/* RESTORES: PARSEINI_ScanLogoDirectory
 * MODULE:   modules/groups/b/a/parseini_p2_p1.s
 * STATUS:   behavioural
 *
 * Reconciles the logo directory against the configured logo list and DELETES
 * every logo file that is not in the list. It shells out to the DOS `list` and
 * `delete` commands rather than using the file system directly.
 *
 * THIS FUNCTION DELETES FILES, which is worth stating plainly because nothing
 * in its name says so. Any file in DH2:LOGOS whose name does not appear
 * case-insensitively in DF0:LOGO.LST is removed. A failure to open the list
 * leaves `primaryOk` zero, the primary table empty, and therefore NOTHING
 * matches -- so an unreadable list file deletes every logo. The original has no
 * guard against that and this reproduces it.
 *
 * THE TWO LISTS ARE SANITISED DIFFERENTLY. The primary list strips newline,
 * carriage return AND COMMA; the secondary strips only newline and carriage
 * return. So a comma truncates a name in the configured list but not in the
 * directory listing, and a logo whose name contains a comma can never match.
 *
 * The primary list also runs each line through GCOMMAND_FindPathSeparator and
 * stores what that returns -- the basename -- while the secondary stores the
 * raw line. That is what makes a full path in the list comparable to a bare
 * filename from the directory.
 *
 * THE MATCH LOOP DOES NOT STOP AT THE FIRST HIT. It scans the whole primary
 * table and sets the flag repeatedly. Adding a break would be an optimisation
 * the original does not have.
 *
 * BOTH TABLES ARE FREED WITH A RE-MEASURED LENGTH. The size passed to the
 * deallocator is `strlen(entry) + 1`, computed again at free time rather than
 * remembered -- so a string that was modified in place between allocation and
 * free would be freed with the wrong size. Nothing here modifies them.
 *
 * THE LINE BUFFER IS 88 BYTES AND IS READ WITH A 99-BYTE LIMIT. The original's
 * frame puts the buffer at -88(A5), with the two list-state longs and the path
 * pointer BELOW it, so 99 bytes of line data overrun it by 11 into the saved A5
 * and the return address. It is a real latent overflow in the shipped program,
 * reachable from a logo filename longer than 87 characters. The declaration
 * below keeps the original's 88 bytes rather than quietly widening it, because
 * widening it would hide the defect and change the frame.
 *
 * The delete command is built by copying 24 bytes of a template, terminating,
 * and appending the filename -- so the template is not a C string at that
 * point; the terminator is written explicitly at index 24.
 *
 * 816 ref vs 896 got, 26 differing regions. The Execute of the list command,
 * both opens with their mode strings, both read loops with their 100-entry
 * caps, both sanitiser character sets, the basename call on the primary path
 * only, both allocations with their distinct line numbers, the match scan
 * without an early exit, the 24-byte template copy with its explicit
 * terminator, the delete Execute, both free loops and both handle closes match
 * in kind and size.
 *
 * The 80 bytes are spread at 2 to 6 bytes a site with no dominant region --
 * the frame class over a function with two 400-byte tables and a large frame.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fc40 ... 2b48ff9c   LINK.W A5,#-960 / MOVE.L A0,-100(A5)
 *   got:     the same slots addressed from A7
 *   summary: the frame class. With 960 bytes of locals every access is a
 *            displacement either way, so the cost is in how the two index the
 *            tables -- the original keeps a table base in A0 and adds the
 *            scaled index, 6.51 re-forms the address per access.
 *   tried:   the chained-zero form for the table initialisation, per AGENTS.md
 *            -- `primary[i] = secondary[i] = 0` against two statements. It is
 *            size-NEUTRAL here at 896 either way, so the chained form is used
 *            because it is the idiom the original has (`SUBA.L A1,A1` then two
 *            stores), not because it saves anything.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-dos.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern long  PARSEINI_JMPTBL_HANDLE_OpenWithMode(char *path, char *mode);
extern long  PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(char *buf, long limit,
                                                      long handle);
extern char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(char *s);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                 long size, long flags);
extern void  SCRIPT_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                   void *p, long size);
extern long  PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern void  PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern void  PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(long handle);

extern char Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK[];
extern char Global_STR_DELETE_NIL_DH2_LOGOS[];
extern char PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST[];
extern char PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT[];
extern char PARSEINI_STR_RB_LogoListPrimary[];
extern char PARSEINI_STR_RB_LogoListSecondary[];
extern char Global_STR_PARSEINI_C_4[];
extern char Global_STR_PARSEINI_C_5[];
extern char Global_STR_PARSEINI_C_6[];
extern char Global_STR_PARSEINI_C_7[];

void PARSEINI_ScanLogoDirectory(void)
{
    char *primary[100];
    char *secondary[100];
    char  delCmd[40];
    char  line[88];
    char *p;
    long  primaryOk;
    long  secondaryOk;
    long  ph;
    long  sh;
    long  matched;
    long  len;
    long  i;
    long  j;
    long  n;

    secondaryOk = primaryOk = (long)line;

    for (i = 0; i < 100; i++)
        primary[i] = secondary[i] = 0;

    Execute(Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, 0L, 0L);

    ph = PARSEINI_JMPTBL_HANDLE_OpenWithMode(
             PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST,
             PARSEINI_STR_RB_LogoListPrimary);
    if (ph == 0)
        primaryOk = 0;

    sh = PARSEINI_JMPTBL_HANDLE_OpenWithMode(
             PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT,
             PARSEINI_STR_RB_LogoListSecondary);
    if (sh == 0)
        secondaryOk = 0;

    n = 0;
    while (primaryOk != 0 && n < 100) {

        primaryOk = PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(line, 99L, ph);

        len = strlen(line);
        for (j = 0; j < len; j++) {
            if (line[j] == 10 || line[j] == 13 || line[j] == 44)
                line[j] = 0;
        }

        p = PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(line);

        primary[n] = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                         Global_STR_PARSEINI_C_4, 1263L, strlen(p) + 1,
                         MEMF_PUBLIC | MEMF_CLEAR);

        strcpy(primary[n], p);
        n++;
    }

    n = 0;
    while (secondaryOk != 0 && n < 100) {

        secondaryOk = PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(line, 99L, sh);

        len = strlen(line);
        for (j = 0; j < len; j++) {
            if (line[j] == 10 || line[j] == 13)
                line[j] = 0;
        }

        secondary[n] = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                           Global_STR_PARSEINI_C_5, 1287L, strlen(line) + 1,
                           MEMF_PUBLIC | MEMF_CLEAR);

        strcpy(secondary[n], line);
        n++;
    }

    for (i = 0; secondary[i] != 0; i++) {

        matched = 0;

        for (j = 0; primary[j] != 0; j++) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(secondary[i],
                                                     primary[j]) == 0)
                matched = 1;
        }

        if (matched == 0) {
            memcpy(delCmd, Global_STR_DELETE_NIL_DH2_LOGOS, 24);
            delCmd[24] = 0;
            PARSEINI_JMPTBL_STRING_AppendAtNull(delCmd, secondary[i]);
            Execute(delCmd, 0L, 0L);
        }

        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_PARSEINI_C_6, 1323L,
                                              secondary[i],
                                              strlen(secondary[i]) + 1);
    }

    for (i = 0; primary[i] != 0; i++)
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_PARSEINI_C_7, 1329L,
                                              primary[i],
                                              strlen(primary[i]) + 1);

    if (ph != 0)
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(ph);

    if (sh != 0)
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(sh);
}
