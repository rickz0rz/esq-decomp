/* RESTORES: GCOMMAND_LoadPPV3Template
 * MODULE:   modules/groups/a/s/gcommand_p1.s
 * STATUS:   behavioural
 *
 * Loads the PPV template, preferring the PPV3 file and falling back to the
 * older PPV one -- and DELETING the fallback file once it has been read.
 *
 * The two files carry DIFFERENT header sizes: 56 bytes for PPV3 and 52 for the
 * fallback. That size is both the CopyMem length and the amount the work-buffer
 * pointer is advanced past, so getting it wrong shifts every string that
 * follows.
 *
 * The delete happens on the FALLBACK path only, and it also sets the flag that
 * makes the function chain into GCOMMAND_LoadPPVTemplate at the end. So reading
 * the old file is a one-shot migration.
 *
 * If NEITHER file loads, the size stays 0 and the function returns without
 * touching anything -- but it still returns 1.
 *
 * The two template strings are separated by finding character 18 in the buffer
 * and TERMINATING there: CLR.B (A0)+ writes the terminator and steps past it in
 * one instruction, so the second string starts at the byte after. The split
 * only happens if the character is found AND is non-zero.
 *
 * Both template pointers are cleared before the split, so a buffer with no
 * separator leaves them null rather than stale.
 *
 * A HEADER OMISSION COMPILED CLEAN AND WAS WRONG. The first version included
 * only esq-exec.h, so DeleteFile had no prototype and SAS/C emitted an ORDINARY
 * EXTERNAL CALL with the path pushed on the stack (4879.../61000000/584f)
 * instead of the DOS library call the original makes (41f9 LEA path,A0 / 2208
 * MOVE.L A0,D1 / 2c79 base / 4eaeffb8). It compiled without an error and would
 * have failed to link, or worse, linked against something else. Adding
 * esq-dos.h restores the library call. Check that every OS function you call
 * has its header, not just the ones that need the volatile base.
 *
 * 252 ref vs 240 got. Both load calls with their ADDQ.L #1 sentinel tests, the
 * MOVEQ #56 and MOVEQ #52 header sizes, the DeleteFile library call, the
 * CopyMem, the ADD.L advance of the work buffer, the PEA 18 separator search,
 * the CLR.B (A0)+ split, both replace calls, the PEA 993 line number and the
 * ADDQ.L #1 free length all match in kind and size.
 *
 * SASC-MISMATCH: pointer-zeroing-and-frame
 *   ref:     91c8 23c8....aa44 23c8....aa40    SUBA.L A0,A0 / two MOVE.L A0
 *   got:     42b9........ 42b9........         two CLR.L
 *   summary: the original zeroes an address register and stores it to both
 *            template pointers -- the chained pointer-assignment idiom -- where
 *            6.51 emits an independent CLR.L at each. That plus the frame class
 *            is the 12 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "Constant materialisation"
 *            and "The A3/A5 divergence has a single root cause".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include "esq-dos.h"

extern long  GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(char *path);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern void  GCOMMAND_LoadPPVTemplate(void);

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char  GCOMMAND_DigitalPpvEnabledFlag[];
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern char *GCOMMAND_PPVListingsTemplatePtr;
extern char  GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad[];
extern char  GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad[];
extern char  GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete[];
extern char  Global_STR_GCOMMAND_C_3[];

long GCOMMAND_LoadPPV3Template(void)
{
    char *buf;
    char *split;
    long  headerSize = 0;
    long  usedFallback = 0;
    long  len;

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad)
        != -1) {
        headerSize = 56;

    } else if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(
                   GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad)
               != -1) {
        headerSize = 52;
        DeleteFile(GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete);
        usedFallback = 1;
    }

    if (headerSize == 0)
        return 1;

    buf = Global_PTR_WORK_BUFFER;
    len = Global_REF_LONG_FILE_SCRATCH;

    CopyMem(buf, GCOMMAND_DigitalPpvEnabledFlag, headerSize);

    GCOMMAND_PPVListingsTemplatePtr = 0;
    GCOMMAND_PPVPeriodTemplatePtr   = 0;

    Global_PTR_WORK_BUFFER += headerSize;

    split = GROUP_AS_JMPTBL_STR_FindCharPtr(Global_PTR_WORK_BUFFER, 18L);
    if (split != 0 && *split != 0) {
        *split++ = 0;

        GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
            Global_PTR_WORK_BUFFER, GCOMMAND_PPVPeriodTemplatePtr);

        GCOMMAND_PPVListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
            split, GCOMMAND_PPVListingsTemplatePtr);
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_GCOMMAND_C_3, 993L, buf,
                                           len + 1);

    if (usedFallback)
        GCOMMAND_LoadPPVTemplate();

    return 1;
}
