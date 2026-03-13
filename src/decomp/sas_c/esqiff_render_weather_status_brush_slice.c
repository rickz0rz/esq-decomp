typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

#define WEATHER_SLICE_MAX_WIDTH 30
#define WEATHER_SLICE_LEFT_PAD 42
#define WEATHER_SLICE_FULL_WIDTH 696
#define WEATHER_SLICE_VALIDATE_CODE 16
#define WEATHER_SLICE_VALIDATE_ENABLE 89

#define BRUSH_MODE_OFFSET 32
#define BRUSH_INNER_WIDTH_OFFSET 176
#define BRUSH_TOTAL_WIDTH_OFFSET 178

#define CTX_SLICE_HALF_WIDTH_OFFSET 52
#define CTX_RASTPORT_OFFSET 60

extern WORD ESQIFF_WeatherSliceRemainingWidth;
extern WORD ESQIFF_WeatherSliceSourceOffset;
extern UBYTE ESQIFF_WeatherSliceValidateGateFlag;
extern WORD ESQFUNC_WeatherSliceWidthInitGate;
extern UBYTE CONFIG_NewgridSelectionCode16EnabledFlag;

extern LONG ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRp,
    LONG forcedDstY
);
extern void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code);

static LONG half_toward_zero(LONG value)
{
    if (value < 0) {
        value += 1;
    }
    return value >> 1;
}

LONG ESQIFF_RenderWeatherStatusBrushSlice(char *ctx, UBYTE *brush)
{
    LONG sliceWidth;
    LONG leftX;
    LONG rightX;
    char *rastPort;

    if (brush == (UBYTE *)0) {
        ESQIFF_WeatherSliceRemainingWidth = 0;
        return (LONG)ESQIFF_WeatherSliceRemainingWidth;
    }

    if (ESQIFF_WeatherSliceRemainingWidth <= 0 || ESQFUNC_WeatherSliceWidthInitGate != 0) {
        ESQFUNC_WeatherSliceWidthInitGate = 0;
        ESQIFF_WeatherSliceValidateGateFlag = 1;
        ESQIFF_WeatherSliceSourceOffset = 0;
        ESQIFF_WeatherSliceRemainingWidth = *(WORD *)(brush + BRUSH_TOTAL_WIDTH_OFFSET);
    }

    sliceWidth = (LONG)ESQIFF_WeatherSliceRemainingWidth;
    if (sliceWidth >= WEATHER_SLICE_MAX_WIDTH) {
        sliceWidth = WEATHER_SLICE_MAX_WIDTH;
    }

    rastPort = ctx + CTX_RASTPORT_OFFSET;

    if (*(UBYTE *)(brush + BRUSH_MODE_OFFSET) == 9) {
        leftX = WEATHER_SLICE_LEFT_PAD;
        rightX = (LONG)(*(WORD *)(brush + BRUSH_INNER_WIDTH_OFFSET)) + WEATHER_SLICE_LEFT_PAD;

        ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
            brush,
            leftX,
            0,
            rightX,
            sliceWidth,
            rastPort,
            (LONG)ESQIFF_WeatherSliceSourceOffset
        );

        leftX = WEATHER_SLICE_FULL_WIDTH - (LONG)(*(WORD *)(brush + BRUSH_INNER_WIDTH_OFFSET));
        leftX -= 1;
        rightX = (LONG)(*(WORD *)(brush + BRUSH_INNER_WIDTH_OFFSET)) + leftX;

        ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
            brush,
            leftX,
            0,
            rightX,
            sliceWidth,
            rastPort,
            (LONG)ESQIFF_WeatherSliceSourceOffset
        );
    } else {
        leftX = half_toward_zero(
            WEATHER_SLICE_FULL_WIDTH - (LONG)(*(WORD *)(brush + BRUSH_INNER_WIDTH_OFFSET))
        );
        leftX -= 1;
        rightX = (LONG)(*(WORD *)(brush + BRUSH_INNER_WIDTH_OFFSET)) + leftX;

        ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
            brush,
            leftX,
            0,
            rightX,
            sliceWidth,
            rastPort,
            (LONG)ESQIFF_WeatherSliceSourceOffset
        );

        if (*(UBYTE *)(brush + BRUSH_MODE_OFFSET) == 11 &&
            ESQIFF_WeatherSliceValidateGateFlag == 1 &&
            CONFIG_NewgridSelectionCode16EnabledFlag == WEATHER_SLICE_VALIDATE_ENABLE) {
            ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(ctx, WEATHER_SLICE_VALIDATE_CODE);
            ESQIFF_WeatherSliceValidateGateFlag = 0;
        }
    }

    ESQIFF_WeatherSliceRemainingWidth -= (WORD)sliceWidth;
    ESQIFF_WeatherSliceSourceOffset += (WORD)sliceWidth;
    *(WORD *)(ctx + CTX_SLICE_HALF_WIDTH_OFFSET) = (WORD)half_toward_zero(sliceWidth);

    return (LONG)ESQIFF_WeatherSliceRemainingWidth;
}
