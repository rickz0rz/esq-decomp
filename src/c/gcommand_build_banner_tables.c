/* RESTORES: GCOMMAND_BuildBannerTables
 * MODULE:   modules/groups/a/u/gcommand3b_p3_p1_p1.s
 * STATUS:   behavioural
 *
 * Rebuilds both banner copper lists from scratch, with the whole thing inside
 * Disable/Enable because the animation tick reads every one of these globals.
 *
 * The counter seeds are not symmetric and each one matters: the queue slot
 * starts at 97 previous / 96 current, and the row index at 84 previous / 85
 * current. The queue pair is derived with one SUBQ.W from a shared MOVEQ #97;
 * the row pair is two separate MOVEQ.
 *
 * The head byte is stamped into the one-byte stack local TWICE -- once before
 * each CopyImageDataToBitmap call. The first call can change it, so the second
 * stamp is not redundant.
 *
 * The two image copies differ in three arguments: the copper list, the byte
 * count (2992 against 3080) and the row offset, which is 88 further on for the
 * second.
 *
 * The width parameter is a word and the flag a byte; both are zero-extended
 * before being passed as longs.
 *
 * 234 ref vs 240 got. Both seven-argument calls with their PEA 2992 / PEA 3080
 * counts, both list and bitmap addresses, the MOVEQ #88 offset step, both
 * head-byte stamps, the MOVE.W #1 and MOVE.W #$100 flag stores and both exec
 * LVO offsets (ff88 Disable, ff82 Enable) match in kind and size.
 *
 * SASC-MISMATCH: shared-constant-vs-separate
 *   ref:     7061 33c0....b2f6 5340 33c0....b2f8
 *            MOVEQ #97 / store / SUBQ.W #1 / store 96
 *   got:     33fc00610000.... 33fc00600000....
 *            two independent MOVE.W immediates
 *   summary: the original derives the queue-slot pair from ONE constant with a
 *            SUBQ; 6.51 materialises 97 and 96 separately. Same two values.
 *            It does the same for the two zero stores at the top, using CLR.L
 *            twice where the original shares a MOVEQ #0.
 *   scope:   program-wide. docs/compiler-version.md, "Constant materialisation".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"

extern void GCOMMAND_ResetPresetWorkTables(void);
extern void GCOMMAND_CopyImageDataToBitmap(void *bitmap, char *list, long count,
                                           long offset, char *head, long width,
                                           long flag);
extern void GCOMMAND_ClearBannerQueue(void);

extern char  Global_REF_696_400_BITMAP[];
extern char  ESQ_CopperListBannerA[];
extern char  ESQ_CopperListBannerB[];
extern long  GCOMMAND_BannerPhaseIndexCurrent;
extern long  GCOMMAND_BannerRowByteOffsetCurrent;
extern long  GCOMMAND_BannerRowByteOffsetPrevious;
extern long  GCOMMAND_BannerRowByteOffsetResetValue;
extern long  ESQSHARED4_InterleaveCopyTailOffsetCurrent;
extern long  ESQSHARED4_InterleaveCopyTailOffsetReset;
extern short GCOMMAND_BannerQueueSlotCurrent;
extern short GCOMMAND_BannerQueueSlotPrevious;
extern long  GCOMMAND_BannerRowIndexCurrent;
extern long  GCOMMAND_BannerRowIndexPrevious;
extern short ED2_HighlightTickEnabledFlag;
extern short ESQPARS2_ReadModeFlags;

void GCOMMAND_BuildBannerTables(char head, short width, unsigned char flag)
{
    char headByte;

    headByte = head;

    Disable();

    GCOMMAND_ResetPresetWorkTables();

    GCOMMAND_BannerPhaseIndexCurrent     = 0;
    GCOMMAND_BannerRowByteOffsetPrevious = 0;
    GCOMMAND_BannerRowByteOffsetCurrent  = GCOMMAND_BannerRowByteOffsetResetValue;
    ESQSHARED4_InterleaveCopyTailOffsetCurrent =
        ESQSHARED4_InterleaveCopyTailOffsetReset;

    GCOMMAND_BannerQueueSlotPrevious = 97;
    GCOMMAND_BannerQueueSlotCurrent  = 96;
    GCOMMAND_BannerRowIndexPrevious  = 84;
    GCOMMAND_BannerRowIndexCurrent   = 85;

    GCOMMAND_CopyImageDataToBitmap(Global_REF_696_400_BITMAP,
                                   ESQ_CopperListBannerA, 2992L,
                                   GCOMMAND_BannerRowByteOffsetCurrent,
                                   &headByte, (long)(unsigned short)width,
                                   (long)flag);

    headByte = head;

    GCOMMAND_CopyImageDataToBitmap(Global_REF_696_400_BITMAP,
                                   ESQ_CopperListBannerB, 3080L,
                                   88 + GCOMMAND_BannerRowByteOffsetCurrent,
                                   &headByte, (long)(unsigned short)width,
                                   (long)flag);

    GCOMMAND_ClearBannerQueue();

    ED2_HighlightTickEnabledFlag = 1;
    ESQPARS2_ReadModeFlags       = 0x100;

    Enable();
}
