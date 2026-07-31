/* RESTORES: TEXTDISP_BuildEntryDetailLine
 * MODULE:   modules/groups/b/a/textdisp_p2.s
 * STATUS:   behavioural
 *
 * Assembles the one-line description shown for a selected entry, out of four
 * pieces appended in order: a short name, the programme title, the time, and
 * the channel number. Each piece is built in a shared 512-byte work buffer and
 * appended to the record's own output field, so the buffer is reused four
 * times.
 *
 * THE CHARACTER-CLASS BIT 3 MEANS "SKIP ME" and it is tested at FIVE separate
 * points -- leading control bytes on the short name, on the title, on the time
 * segment, the run after a separator, and the backtrack after truncation. Two
 * of those loops run FORWARD and one runs BACKWARD, and the backward one has no
 * lower bound: it walks off the front of the buffer if the buffer begins with a
 * class-3 character. That is the original's.
 *
 * THREE SEPARATORS ARE TRIED IN ORDER -- " at ", " vs. " and " vs " -- and only
 * the first that matches is used. The match is case-folded. Finding one
 * replaces the separator's first character with 0x18 and then scans forward to
 * the next class-3 character and writes another 0x18, bracketing the second
 * half of the title.
 *
 * THE TRUNCATION SEARCH STARTS WHERE THE BRACKET ENDED, not at the buffer. When
 * a separator was found the '(' search begins at the second 0x18; when none was
 * found it begins at the buffer. The original expresses that by leaving the
 * pointer in A0 across two different paths, which is easy to miss -- reading it
 * as "always search the whole buffer" truncates titles that contain a
 * parenthesis before the separator.
 *
 * THE TITLE IS SKIPPED BY LENGTH, NOT MATCHED. If the entry text is at least as
 * long as the record's title, the title's length is added to the pointer --
 * without checking that the text actually starts with the title. A shorter text
 * is used whole.
 *
 * THE CHANNEL NUMBER IS COPIED WITH SPACES REMOVED from the entry's name field
 * at +1, into the same work buffer the time segment just used. The terminator
 * is written at the compacted length, so the previous contents past that point
 * survive but are unreachable.
 *
 * THE OUTPUT FIELD IS THE RECORD'S OWN at +220, cleared at the start, and every
 * piece is appended to it. The final trim is to 284 pixels.
 *
 * 714 ref vs 714 got, 26 differing regions.
 *
 * THE SIZE AGREEMENT IS COINCIDENCE, per AGENTS.md rule 1, and is recorded as
 * such: 26 differing regions over 714 bytes means the two streams diverge
 * throughout, and the totals happening to land equal says nothing on its own.
 * What is evidence: the three-part validity guard, both pointer lookups, the
 * short-name build, all five class-3 scans including the unbounded backward
 * one, the title-length skip with its length comparison, the SPrintf, all three
 * case-folded separator searches in order, both 0x18 writes, the '(' search
 * from the bracket rather than the buffer, the truncation backtrack, the time
 * format call, the space-removing channel copy and the 284-pixel trim all match
 * in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fdE4 ... 2b48fffc   LINK.W A5,#-540 / MOVE.L A0,-4(A5)
 *   got:     the same slots addressed from A7
 *   summary: the frame class. With a 512-byte work buffer dominating the frame,
 *            most accesses are displacements either way, and the residual
 *            differences are in which of the four pointers each compiler keeps
 *            live across the calls. They cancel to zero here.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct TdRec {
    char  pad0[10];
    char  title[200];                   /* +10  */
    long  mode;                         /* +210 */
    long  index;                        /* +214 */
    short slot;                         /* +218 */
    char  out[4];                       /* +220 */
};

struct TdEntry2 {
    char pad0;
    char name[51];                      /* +1 */
};

struct TdAux2 {
    char  pad0[56];
    char *slots[50];                    /* +56 */
};

extern void  TEXTDISP_ResetSelectionState(struct TdRec *rec);
extern struct TdAux2 *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(long i,
                                                                     long m);
extern struct TdEntry2 *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long i,
                                                                    long m);
extern void  TEXTDISP_BuildEntryShortName(struct TdEntry2 *e, char *out);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern char *TEXTDISP_SkipControlCodes(char *s);
extern void  WDISP_SPrintf(char *dst, char *fmt, char *arg);
extern char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(char *hay, char *needle);
extern char *STR_FindCharPtr(char *s, long ch);
extern void  TEXTDISP_FormatEntryTimeForIndex(char *buf, long idx, void *aux);
extern void  TEXTDISP_TrimTextToPixelWidth(char *text, long width);

extern unsigned char WDISP_CharClassTable[];
extern char SCRIPT_AlignedPrefixEmptyF[];
extern char SCRIPT_AlignedPrefixEmptyG[];
extern char SCRIPT_AlignedStringFormat[];
extern char SCRIPT_StrAtSeparator[];
extern char SCRIPT_StrVsDotSeparator[];
extern char SCRIPT_StrVsSeparator[];
extern char Global_STR_ALIGNED_CHANNEL_2[];

void TEXTDISP_BuildEntryDetailLine(struct TdRec *rec)
{
    struct TdAux2   *aux;
    struct TdEntry2 *entry;
    char *titlePtr;
    char *out;
    char *p;
    char *q;
    char  work[512];
    long  titleLen;
    long  i;
    long  j;

    if (rec == 0)
        return;

    if (rec->mode == 3 || rec->index == -1 || rec->slot == -1) {
        TEXTDISP_ResetSelectionState(rec);
        return;
    }

    titlePtr = rec->title;

    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(rec->index,
                                                         rec->mode);
    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(rec->index,
                                                        rec->mode);

    out  = rec->out;
    *out = 0;

    TEXTDISP_BuildEntryShortName(entry, work);

    p = work;
    while ((WDISP_CharClassTable[(long)(unsigned char)*p] & 8)
           || (unsigned char)*p == 24 || (unsigned char)*p == 25)
        p++;

    if (*p != 0) {
        strcpy(out, SCRIPT_AlignedPrefixEmptyF);
        STRING_AppendAtNull(out, p);
    }

    p = TEXTDISP_SkipControlCodes(aux->slots[rec->slot]);

    if (p != 0 && *p != 0) {

        titleLen = strlen(titlePtr);

        if ((long)strlen(p) >= titleLen)
            p += titleLen;

        while (WDISP_CharClassTable[(long)(unsigned char)*p] & 8)
            p++;

        WDISP_SPrintf(work, SCRIPT_AlignedStringFormat, p);

        p = TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(work,
                                                    SCRIPT_StrAtSeparator);
        if (p == 0)
            p = TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(
                    work, SCRIPT_StrVsDotSeparator);
        if (p == 0)
            p = TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(
                    work, SCRIPT_StrVsSeparator);

        if (p != 0) {
            *p = 0x18;
            do {
                p++;
            } while ((WDISP_CharClassTable[(long)(unsigned char)*p] & 8) == 0);
            *p = 0x18;
            q = p;
        } else {
            q = work;
        }

        p = STR_FindCharPtr(q, 40L);

        if (p != 0) {
            do {
                *p = 0;
                p--;
            } while (WDISP_CharClassTable[(long)(unsigned char)*p] & 8);
        }

        STRING_AppendAtNull(out, work);
    }

    TEXTDISP_FormatEntryTimeForIndex(work, (long)rec->slot, aux);

    p = work;
    while (WDISP_CharClassTable[(long)(unsigned char)*p] & 8)
        p++;

    if (*p != 0) {
        STRING_AppendAtNull(out, SCRIPT_AlignedPrefixEmptyG);
        STRING_AppendAtNull(out, p);
    }

    i = 0;
    j = 0;

    while (entry->name[j] != 0) {
        if (entry->name[j] != 32)
            work[i++] = entry->name[j];
        j++;
    }

    work[i] = 0;

    if (work[0] != 0) {
        STRING_AppendAtNull(out, Global_STR_ALIGNED_CHANNEL_2);
        STRING_AppendAtNull(out, work);
    }

    TEXTDISP_TrimTextToPixelWidth(out, 284L);
}
