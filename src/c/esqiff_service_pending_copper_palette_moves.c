/* RESTORES: ESQIFF_ServicePendingCopperPaletteMoves
 * MODULE:   modules/groups/a/n/esqiffbb.s
 * STATUS:   behavioural
 *
 * Services one pending copper-palette move per accumulator row. A row acts only
 * when its saturate flag reads exactly 1 and it has move flags set; the flag is
 * then cleared, and bit 1 of the move flags picks the direction.
 *
 * The four rows are written out longhand rather than as a loop over arrays. That
 * is what the original does -- the row globals are eight separate symbols with no
 * usable stride between the saturate flags (0x11C, 0x11E, 0x120, 0x122) and the
 * move flags (0xA84A, 0xA852, 0xA85A, 0xA862), so there is no array to index and
 * the original emits four straight-line copies of the same 80 bytes.
 *
 * The sixth __saveds function found.
 *
 * 372 bytes in the original, 372 emitted, and EXACTLY EIGHT differing hunks --
 * every one of them the same four bytes, `4eba` against `6100`, at the eight
 * cross-unit calls. Nothing else in the function differs at all: not the frame,
 * not the flag tests, not the BTST, not the byte-to-long widenings, not the
 * argument pushes.
 *
 * That makes this the sharpest call-encoding probe in the project, ahead of
 * esqiff_handle_brush_ini_reload_hotkey.c, which is 128 bytes with eight call
 * regions and a ninth region of argument-pop ordering. Here there is no ninth.
 *
 *     tools/cmatch.sh src/c/esqiff_service_pending_copper_palette_moves.c \
 *                     ESQIFF_ServicePendingCopperPaletteMoves
 *
 * A compiler that emits JSR (d16,PC) for a call to an extern takes this function
 * byte-exact on the first compile with no source change. A compiler that emits
 * BSR.W differs in exactly 32 bytes out of 372. There is no third outcome and
 * nothing to interpret.
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     4eba098a 4eba0956 4eba0930 4eba08fc 4eba08d6 4eba08a2 4eba087c 4eba0848
 *   got:     61000000 x8
 *   summary: The whole difference. Both encodings are four bytes with a 16-bit
 *            PC-relative displacement; the original used JSR (d16,PC) for a callee
 *            in another translation unit. See docs/compiler-version.md.
 */
#include <proto/exec.h>

extern void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(long start, long end);
extern void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(long start, long end);

extern short ACCUMULATOR_Row0_SaturateFlag;
extern short WDISP_AccumulatorRow0_MoveFlags;
extern unsigned char WDISP_AccumulatorRow0_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow0_CopperIndexEnd;
extern short ACCUMULATOR_Row1_SaturateFlag;
extern short WDISP_AccumulatorRow1_MoveFlags;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexEnd;
extern short ACCUMULATOR_Row2_SaturateFlag;
extern short WDISP_AccumulatorRow2_MoveFlags;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexEnd;
extern short ACCUMULATOR_Row3_SaturateFlag;
extern short WDISP_AccumulatorRow3_MoveFlags;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexEnd;

void __saveds ESQIFF_ServicePendingCopperPaletteMoves(void)
{
    if (ACCUMULATOR_Row0_SaturateFlag == 1 && WDISP_AccumulatorRow0_MoveFlags) {
        ACCUMULATOR_Row0_SaturateFlag = 0;
        if (WDISP_AccumulatorRow0_MoveFlags & 2)
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(
                (long)WDISP_AccumulatorRow0_CopperIndexStart,
                (long)WDISP_AccumulatorRow0_CopperIndexEnd);
        else
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(
                (long)WDISP_AccumulatorRow0_CopperIndexStart,
                (long)WDISP_AccumulatorRow0_CopperIndexEnd);
    }

    if (ACCUMULATOR_Row1_SaturateFlag == 1 && WDISP_AccumulatorRow1_MoveFlags) {
        ACCUMULATOR_Row1_SaturateFlag = 0;
        if (WDISP_AccumulatorRow1_MoveFlags & 2)
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(
                (long)WDISP_AccumulatorRow1_CopperIndexStart,
                (long)WDISP_AccumulatorRow1_CopperIndexEnd);
        else
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(
                (long)WDISP_AccumulatorRow1_CopperIndexStart,
                (long)WDISP_AccumulatorRow1_CopperIndexEnd);
    }

    if (ACCUMULATOR_Row2_SaturateFlag == 1 && WDISP_AccumulatorRow2_MoveFlags) {
        ACCUMULATOR_Row2_SaturateFlag = 0;
        if (WDISP_AccumulatorRow2_MoveFlags & 2)
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(
                (long)WDISP_AccumulatorRow2_CopperIndexStart,
                (long)WDISP_AccumulatorRow2_CopperIndexEnd);
        else
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(
                (long)WDISP_AccumulatorRow2_CopperIndexStart,
                (long)WDISP_AccumulatorRow2_CopperIndexEnd);
    }

    if (ACCUMULATOR_Row3_SaturateFlag == 1 && WDISP_AccumulatorRow3_MoveFlags) {
        ACCUMULATOR_Row3_SaturateFlag = 0;
        if (WDISP_AccumulatorRow3_MoveFlags & 2)
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(
                (long)WDISP_AccumulatorRow3_CopperIndexStart,
                (long)WDISP_AccumulatorRow3_CopperIndexEnd);
        else
            ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(
                (long)WDISP_AccumulatorRow3_CopperIndexStart,
                (long)WDISP_AccumulatorRow3_CopperIndexEnd);
    }
}
