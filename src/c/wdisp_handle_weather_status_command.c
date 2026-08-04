/* RESTORES: _WDISP_HandleWeatherStatusCommand
 * MODULE:   modules/groups/b/a/wdisp.s
 * STATUS:   behavioural
 *
 * The entry point for the two weather display commands, 48 and 51. Any other
 * command falls through to TEXTDISP_ResetSelectionAndRefresh and returns.
 *
 * The body is one sequence: clear view mode 4, build a context for it, drop the
 * copper in, build a bare context, draw either the overlay (48) or the summary
 * (51), build view mode 4 again, validate the four accumulator rows, and raise
 * the copper back.
 *
 * Each accumulator row is accepted only when both of its copper indexes are
 * below 32 AND its value is below 0x4000. A row that fails any of the three
 * tests is zeroed. Capture stays on if ANY row survived.
 *
 * READ THIS BEFORE JUDGING THE SIZE. tools/refbytes.py extracts label to label,
 * and the next label in wdisp.s is a long way past this function's RTS: the
 * module holds a block the disassembly marks "Dead code" plus one further
 * unlabelled routine. So the raw reference is 692 bytes and the FUNCTION is
 * 538 -- its epilogue, 4cdf00e4/4e5d/4e75, ends at byte 538 of the extract.
 * Against 538 this file emits 532, six bytes SHORT, which is the closest
 * result in this tranche by a wide margin. Judging it against 692 would have
 * read as a 160-byte shortfall and sent the next reader hunting for missing
 * code that is not missing.
 *
 * SASC-MISMATCH: extract-overruns-the-function
 *   ref:     4cdf00e44e5d4e75           the epilogue, at byte 538 of a 692-byte
 *                                       extract
 *   got:     532 bytes total            the whole function
 *   summary: -6 against the real function over 9 regions. The remaining 154
 *            bytes of the extract are dead code and a following unlabelled
 *            routine, not part of this function.
 *   scope:   any function whose module continues past it without a label. See
 *            AGENTS.md on _Return labels and trailing padding for the same
 *            trap in its other form.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct WDispContext {
    unsigned short f0;
    unsigned short width;           /* 2 */
    unsigned short height;          /* 4 */
};

extern void  TLIBA3_ClearViewModeRastPort(long mode, long flag);
extern struct WDispContext *TLIBA3_BuildDisplayContextForViewMode(long mode,
                                                       long a, long b);
extern void  ESQIFF_RestoreBasePaletteTriples(void);
extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern void  TEXTDISP_ResetSelectionAndRefresh(void);
extern void  WDISP_DrawWeatherStatusOverlay(struct RastPort *rp, long w, long h);
extern void  WDISP_DrawWeatherStatusSummary(struct RastPort *rp, long w, long h);

extern struct WDispContext *WDISP_DisplayContextBase;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

extern unsigned char WDISP_AccumulatorRow0_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow0_CopperIndexEnd;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexEnd;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexEnd;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexEnd;
extern short WDISP_AccumulatorRow0_Value;
extern short WDISP_AccumulatorRow1_Value;
extern short WDISP_AccumulatorRow2_Value;
extern short WDISP_AccumulatorRow3_Value;
extern short ACCUMULATOR_Row0_CaptureValue;
extern short ACCUMULATOR_Row1_CaptureValue;
extern short ACCUMULATOR_Row2_CaptureValue;
extern short ACCUMULATOR_Row3_CaptureValue;
extern short ACCUMULATOR_Row0_Sum;
extern short ACCUMULATOR_Row1_Sum;
extern short ACCUMULATOR_Row2_Sum;
extern short ACCUMULATOR_Row3_Sum;
extern short ACCUMULATOR_Row0_SaturateFlag;
extern short ACCUMULATOR_Row1_SaturateFlag;
extern short ACCUMULATOR_Row2_SaturateFlag;
extern short ACCUMULATOR_Row3_SaturateFlag;
extern short WDISP_AccumulatorCaptureActive;

void WDISP_HandleWeatherStatusCommand(long cmd)
{
    struct RastPort *rp;
    long width, height;

    if (cmd != 48 && cmd != 51) {
        TEXTDISP_ResetSelectionAndRefresh();
        return;
    }

    TLIBA3_ClearViewModeRastPort(4L, 0L);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 4L);
    ESQ_SetCopperEffect_OnEnableHighlight();

    rp = (struct RastPort *)((char *)WDISP_DisplayContextBase + 10);
    height = WDISP_DisplayContextBase->height;
    width  = WDISP_DisplayContextBase->width;

    ESQIFF_RestoreBasePaletteTriples();
    ESQIFF_RunCopperDropTransition();
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3L, 0L, 0L);

    SetDrMd(rp, 0L);
    SetAPen(rp, 1L);
    SetFont(rp, Global_HANDLE_PREVUEC_FONT);

    if (cmd == 48)
        WDISP_DrawWeatherStatusOverlay(rp, width, height);
    else if (cmd == 51)
        WDISP_DrawWeatherStatusSummary(rp, width, height);

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 4L);

    if (WDISP_AccumulatorRow0_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow0_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow0_Value < 0x4000)
        ACCUMULATOR_Row0_CaptureValue = WDISP_AccumulatorRow0_Value;
    else
        ACCUMULATOR_Row0_CaptureValue = 0;

    if (WDISP_AccumulatorRow1_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow1_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow1_Value < 0x4000)
        ACCUMULATOR_Row1_CaptureValue = WDISP_AccumulatorRow1_Value;
    else
        ACCUMULATOR_Row1_CaptureValue = 0;

    if (WDISP_AccumulatorRow2_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow2_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow2_Value < 0x4000)
        ACCUMULATOR_Row2_CaptureValue = WDISP_AccumulatorRow2_Value;
    else
        ACCUMULATOR_Row2_CaptureValue = 0;

    if (WDISP_AccumulatorRow3_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow3_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow3_Value < 0x4000)
        ACCUMULATOR_Row3_CaptureValue = WDISP_AccumulatorRow3_Value;
    else
        ACCUMULATOR_Row3_CaptureValue = 0;

    if (ACCUMULATOR_Row0_CaptureValue || ACCUMULATOR_Row1_CaptureValue ||
        ACCUMULATOR_Row2_CaptureValue || ACCUMULATOR_Row3_CaptureValue)
        WDISP_AccumulatorCaptureActive = 1;
    else
        WDISP_AccumulatorCaptureActive = 0;

    ACCUMULATOR_Row0_Sum = ACCUMULATOR_Row0_SaturateFlag =
    ACCUMULATOR_Row1_Sum = ACCUMULATOR_Row1_SaturateFlag =
    ACCUMULATOR_Row2_Sum = ACCUMULATOR_Row2_SaturateFlag =
    ACCUMULATOR_Row3_Sum = ACCUMULATOR_Row3_SaturateFlag = 0;

    ESQIFF_RunCopperRiseTransition();
}
