/* RESTORES: GCOMMAND_LoadDefaultTable
 * MODULE:   modules/groups/a/s/gcommand.s
 * STATUS:   behavioural
 *
 * Loads the niche default table: reads the file into the work buffer, copies
 * the first 32 bytes over the niche state, takes the remainder as the listings
 * template, and frees the buffer.
 *
 * IT RETURNS 1 ON BOTH PATHS, and this is not a transcription slip. The load
 * failure test is ADDQ.L #1,D0 / BEQ with a displacement of 0x5E, which lands
 * on the MOVEQ #1,D0 at 0x1A8C6 -- the same success constant the normal path
 * falls into. So a failed load skips all the work and still answers 1. The C
 * below reproduces that by guarding the body rather than returning early, and
 * it is flagged here because a reader who assumes 0-on-failure will
 * misunderstand every caller.
 *
 * The 32-byte copy goes through exec CopyMem in this direction, where the
 * sibling gcommand_load_command_file.c uses a struct assignment for the same 32
 * bytes on the way out. Both are reproduced as the original has them.
 *
 * Global_PTR_WORK_BUFFER is ADVANCED by 32 past the header before the listings
 * string is taken, and the ORIGINAL buffer address is kept separately for the
 * free -- so the pointer that is freed is not the pointer that is read.
 *
 * The template pointer is cleared to 0 before the replace call, which is what
 * makes the call a fresh install rather than a swap.
 *
 * 124 ref vs 120 got. The CopyMem with its MOVEQ #32 length, the
 * ADD.L D0,work-buffer advance, the ReplaceOwnedString call, the PEA 335 line
 * number, the ADDQ.L #1 length and the LEA 20(A7),A7 cleanup all match exactly,
 * as does the MOVEQ #1 that both paths return.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     91c8 23c80000a9dc     SUBA.L A0,A0 / MOVE.L A0,template
 *   got:     42b900000000          CLR.L template
 *   summary: the original clears an address register and stores it; 6.51 emits
 *            CLR.L on the global directly. Same store, 2 bytes cheaper. Note
 *            the original then PUSHES that same zeroed A0 as the call argument
 *            (2f08) where 6.51 pushes a fresh CLR.L -(A7) (42a7) -- the two
 *            uses of the zero are shared in the original and not in 6.51.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2b48fff8 ... 2f2dfff8 ... 4e5d
 *   got:     ... 2f0d               the buffer pointer stays in an address register
 *   summary: the frame plus the spill and reload of the original work-buffer
 *            address across the CopyMem and the replace call.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include <string.h>

extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char  GCOMMAND_DigitalNicheEnabledFlag[];
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;
extern char  GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable[];
extern char  Global_STR_GCOMMAND_C_1[];

long GCOMMAND_LoadDefaultTable(void)
{
    char *buf;
    long  len;

    if (DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable) != -1) {

        buf = Global_PTR_WORK_BUFFER;
        len = Global_REF_LONG_FILE_SCRATCH;

        CopyMem(buf, GCOMMAND_DigitalNicheEnabledFlag, 32L);
        Global_PTR_WORK_BUFFER += 32;

        GCOMMAND_DigitalNicheListingsTemplatePtr = 0;
        GCOMMAND_DigitalNicheListingsTemplatePtr =
            ESQPARS_ReplaceOwnedString(Global_PTR_WORK_BUFFER, 0);

        MEMORY_DeallocateMemory(Global_STR_GCOMMAND_C_1, 335L,
                                               buf, len + 1);
    }
    return 1;
}
