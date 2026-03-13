typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

#define ESQIFF_BRUSH_HEIGHT_OFFSET 178
#define ESQIFF_BRUSH_PLANE_DEPTH_OFFSET 184
#define ESQIFF_BRUSH_FLAGS196_OFFSET 196
#define ESQIFF_BRUSH_FLAGS198_OFFSET 198
#define ESQIFF_BRUSH_FLAGS199_OFFSET 199
#define ESQIFF_BRUSH_ACCUMULATOR_ROWS_OFFSET 200
#define ESQIFF_BRUSH_PALETTE_BYTES_OFFSET 0xE8
#define ESQIFF_BRUSH_PALETTE_MODE_OFFSET 328
#define ESQIFF_DISPLAY_RASTPORT_OFFSET (-458)
#define ESQIFF_ACCUMULATOR_ROW_SIZE 8
#define ESQIFF_ACCUMULATOR_ROW_COUNT 4
#define ESQIFF_ACCUMULATOR_COPPER_LIMIT 32
#define ESQIFF_ACCUMULATOR_VALUE_LIMIT 0x4000
#define ESQIFF_TRANSITION_BASE 20
#define ESQIFF_TRANSITION_CLAMP 120
#define ESQIFF_TRANSITION_CHAR_BIAS 22
#define ESQIFF_BANNER_TRANSITION_MS 1000
#define ESQIFF_DISPLAY_MODE_FULL 4
#define ESQIFF_DISPLAY_MODE_WIDE 5
#define ESQIFF_DISPLAY_MODE_COMPACT 6
#define ESQIFF_DISPLAY_MODE_FALLBACK 7
#define ESQIFF_BRUSH_FLAGS196_REQUIRE_MASK 0x8004
#define ESQIFF_BRUSH_FLAGS199_DOUBLE_WIDTH_BIT 2
#define ESQIFF_BRUSH_FLAGS198_COMPACT_BIT 7
#define ESQIFF_BRUSH_FLAGS199_WIDE_BIT 2
#define ESQIFF_FORCED_DSTY_TALL 20
#define ESQIFF_FORCED_DSTY_SHORT 10
#define ESQIFF_MISSING_RETRY_GADS 1
#define ESQIFF_MISSING_RETRY_LOGO 2

typedef struct ESQIFF_DisplayContext {
    UBYTE pad0[2];
    UWORD width;
    UWORD height;
    UBYTE rastPortTail[1];
} ESQIFF_DisplayContext;

extern LONG AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG WDISP_DisplayContextBase;
extern void *ESQIFF_GAdsBrushListHead;
extern void *ESQIFF_LogoBrushListHead;
extern WORD SCRIPT_BannerTransitionActive;
extern WORD WDISP_AccumulatorCaptureActive;
extern WORD WDISP_AccumulatorFlushPending;
extern UBYTE WDISP_AccumulatorRowTable[];
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE WDISP_AccumulatorRow0_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow0_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow0_Value;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow1_Value;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow2_Value;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow3_Value;
extern WORD ACCUMULATOR_Row0_CaptureValue;
extern WORD ACCUMULATOR_Row1_CaptureValue;
extern WORD ACCUMULATOR_Row2_CaptureValue;
extern WORD ACCUMULATOR_Row3_CaptureValue;
extern WORD ACCUMULATOR_Row0_Sum;
extern WORD ACCUMULATOR_Row0_SaturateFlag;
extern WORD ACCUMULATOR_Row1_Sum;
extern WORD ACCUMULATOR_Row1_SaturateFlag;
extern WORD ACCUMULATOR_Row2_Sum;
extern WORD ACCUMULATOR_Row2_SaturateFlag;
extern WORD ACCUMULATOR_Row3_Sum;
extern WORD ACCUMULATOR_Row3_SaturateFlag;
extern LONG ESQFUNC_MissingAssetRetryMask;

extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern LONG ESQIFF_JMPTBL_MATH_DivS32(LONG dividend, LONG divisor);
extern WORD ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);
extern void *ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG arg1, LONG arg2);
extern LONG ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRastPort,
    LONG forcedDstY);
extern ULONG ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(LONG planeIndex);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);

static WORD ESQIFF_CaptureAccumulatorValue(UBYTE start, UBYTE end, WORD value)
{
    if (start < ESQIFF_ACCUMULATOR_COPPER_LIMIT &&
        end < ESQIFF_ACCUMULATOR_COPPER_LIMIT &&
        value < ESQIFF_ACCUMULATOR_VALUE_LIMIT) {
        return value;
    }

    return 0;
}

void ESQIFF_ShowExternalAssetWithCopperFx(WORD refreshMode)
{
    UBYTE *brush;
    LONG transitionDivisor;
    LONG transitionSteps;
    LONG rowIndex;
    LONG buildMode;
    LONG forcedDstY;
    ESQIFF_DisplayContext *displayContext;
    char *rastPort;
    ULONG paletteMode;
    ULONG copyLimit;
    ULONG brushLimit;
    ULONG copyIndex;
    WORD capture3;

    if (refreshMode != 0) {
        brush = (UBYTE *)ESQIFF_GAdsBrushListHead;
    } else {
        brush = (UBYTE *)ESQIFF_LogoBrushListHead;
    }

    if (brush == (UBYTE *)0) {
        if (refreshMode != 0) {
            ESQFUNC_MissingAssetRetryMask |= ESQIFF_MISSING_RETRY_GADS;
        } else {
            ESQFUNC_MissingAssetRetryMask |= ESQIFF_MISSING_RETRY_LOGO;
        }
        return;
    }

    ESQIFF_RunCopperDropTransition();

    transitionSteps =
        ESQIFF_TRANSITION_BASE + (LONG)*(UWORD *)(brush + ESQIFF_BRUSH_HEIGHT_OFFSET);
    if ((brush[ESQIFF_BRUSH_FLAGS199_OFFSET] &
         (UBYTE)(1U << ESQIFF_BRUSH_FLAGS199_DOUBLE_WIDTH_BIT)) != 0) {
        transitionDivisor = 2;
    } else {
        transitionDivisor = 1;
    }

    transitionSteps = ESQIFF_JMPTBL_MATH_DivS32(transitionSteps, transitionDivisor);
    if (transitionSteps > ESQIFF_TRANSITION_CLAMP) {
        transitionSteps = ESQIFF_TRANSITION_CLAMP;
    }

    ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(
        transitionSteps + ESQIFF_TRANSITION_CHAR_BIAS,
        ESQIFF_BANNER_TRANSITION_MS);
    while (SCRIPT_BannerTransitionActive != 0) {
    }

    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;
    rowIndex = 0;
    while (rowIndex < ESQIFF_ACCUMULATOR_ROW_COUNT) {
        LONG rowOffset;

        rowOffset = rowIndex * ESQIFF_ACCUMULATOR_ROW_SIZE;
        _LVOCopyMem(
            (void *)AbsExecBase,
            brush + ESQIFF_BRUSH_ACCUMULATOR_ROWS_OFFSET + rowOffset,
            WDISP_AccumulatorRowTable + rowOffset,
            ESQIFF_ACCUMULATOR_ROW_SIZE);
        rowIndex++;
    }

    WDISP_AccumulatorCaptureActive = 0;
    WDISP_AccumulatorFlushPending = 1;

    if ((*(ULONG *)(brush + ESQIFF_BRUSH_FLAGS196_OFFSET) &
         (ULONG)ESQIFF_BRUSH_FLAGS196_REQUIRE_MASK) ==
        (ULONG)ESQIFF_BRUSH_FLAGS196_REQUIRE_MASK) {
        buildMode = ESQIFF_DISPLAY_MODE_FULL;
        forcedDstY = ESQIFF_FORCED_DSTY_TALL;
    } else if ((brush[ESQIFF_BRUSH_FLAGS198_OFFSET] &
                (UBYTE)(1U << ESQIFF_BRUSH_FLAGS198_COMPACT_BIT)) != 0) {
        buildMode = ESQIFF_DISPLAY_MODE_COMPACT;
        forcedDstY = ESQIFF_FORCED_DSTY_SHORT;
    } else if ((brush[ESQIFF_BRUSH_FLAGS199_OFFSET] &
                (UBYTE)(1U << ESQIFF_BRUSH_FLAGS199_WIDE_BIT)) != 0) {
        buildMode = ESQIFF_DISPLAY_MODE_WIDE;
        forcedDstY = ESQIFF_FORCED_DSTY_TALL;
    } else {
        buildMode = ESQIFF_DISPLAY_MODE_FALLBACK;
        forcedDstY = ESQIFF_FORCED_DSTY_SHORT;
    }

    WDISP_DisplayContextBase = (LONG)ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
        buildMode, 0, (LONG)brush[ESQIFF_BRUSH_PLANE_DEPTH_OFFSET]);
    displayContext = (ESQIFF_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (char *)(WDISP_DisplayContextBase + ESQIFF_DISPLAY_RASTPORT_OFFSET);

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 7);

    ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
        brush,
        0,
        forcedDstY,
        (LONG)displayContext->width - 1,
        (LONG)displayContext->height - 1,
        rastPort,
        0);

    paletteMode = *(ULONG *)(brush + ESQIFF_BRUSH_PALETTE_MODE_OFFSET);
    if (paletteMode == 0 || paletteMode == 1) {
        copyLimit = ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(5) * 3UL;
        brushLimit = ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(
            (LONG)brush[ESQIFF_BRUSH_PLANE_DEPTH_OFFSET]) * 3UL;
        copyIndex = 0;
        while (copyIndex < copyLimit && copyIndex < brushLimit) {
            WDISP_PaletteTriplesRBase[copyIndex] =
                brush[ESQIFF_BRUSH_PALETTE_BYTES_OFFSET + copyIndex];
            copyIndex++;
        }
    }

    ACCUMULATOR_Row0_CaptureValue = ESQIFF_CaptureAccumulatorValue(
        WDISP_AccumulatorRow0_CopperIndexStart,
        WDISP_AccumulatorRow0_CopperIndexEnd,
        WDISP_AccumulatorRow0_Value);
    ACCUMULATOR_Row1_CaptureValue = ESQIFF_CaptureAccumulatorValue(
        WDISP_AccumulatorRow1_CopperIndexStart,
        WDISP_AccumulatorRow1_CopperIndexEnd,
        WDISP_AccumulatorRow1_Value);
    ACCUMULATOR_Row2_CaptureValue = ESQIFF_CaptureAccumulatorValue(
        WDISP_AccumulatorRow2_CopperIndexStart,
        WDISP_AccumulatorRow2_CopperIndexEnd,
        WDISP_AccumulatorRow2_Value);
    capture3 = ESQIFF_CaptureAccumulatorValue(
        WDISP_AccumulatorRow3_CopperIndexStart,
        WDISP_AccumulatorRow3_CopperIndexEnd,
        WDISP_AccumulatorRow3_Value);
    ACCUMULATOR_Row3_CaptureValue = capture3;

    if (ACCUMULATOR_Row0_CaptureValue != 0 ||
        ACCUMULATOR_Row1_CaptureValue != 0 ||
        ACCUMULATOR_Row2_CaptureValue != 0 ||
        capture3 != 0) {
        WDISP_AccumulatorCaptureActive = 1;
    } else {
        WDISP_AccumulatorCaptureActive = 0;
    }

    ACCUMULATOR_Row0_Sum = 0;
    ACCUMULATOR_Row0_SaturateFlag = 0;
    ACCUMULATOR_Row1_Sum = 0;
    ACCUMULATOR_Row1_SaturateFlag = 0;
    ACCUMULATOR_Row2_Sum = 0;
    ACCUMULATOR_Row2_SaturateFlag = 0;
    ACCUMULATOR_Row3_Sum = 0;
    ACCUMULATOR_Row3_SaturateFlag = 0;

    ESQIFF_RunCopperRiseTransition();
}
