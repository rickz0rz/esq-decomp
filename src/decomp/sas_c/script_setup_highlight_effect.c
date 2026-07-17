extern void *Global_REF_GRAPHICS_LIBRARY;
#include <exec/types.h>

extern LONG WDISP_DisplayContextBase;
extern WORD WDISP_AccumulatorCaptureActive;
extern WORD WDISP_AccumulatorFlushPending;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern UBYTE CLEANUP_AlignedInsetNibbleSecondary;

extern void TLIBA3_ClearViewModeRastPort(LONG mode, LONG unused);
extern void *TLIBA3_BuildDisplayContextForViewMode(LONG mode, LONG a, LONG b);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern LONG MATH_DivS32(LONG a, LONG b);
extern WORD SCRIPT_BeginBannerCharTransition(LONG x, LONG y);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG n);
extern void SCRIPT_DrawInsetTextWithFrame(char *rastport, BYTE textPenOverride, BYTE framePen, const char *text);
extern LONG _LVOTextLength(void *base, char *rastport, const char *text, LONG len);
extern void _LVOSetDrMd(void *base, char *rastport, LONG mode);
extern void _LVOSetAPen(void *base, char *rastport, LONG pen);
extern void _LVOMove(void *base, char *rastport, LONG x, LONG y);
extern void _LVOText(void *base, char *rastport, const char *text, LONG len);

typedef struct SCRIPT_DisplayContext {
    UWORD flags0;
    UWORD left2;
    UWORD height4;
    UBYTE rastPort[1];
} SCRIPT_DisplayContext;

static LONG len_local(const char *s)
{
    LONG n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_SetupHighlightEffect(char *text)
{
    SCRIPT_DisplayContext *context;
    char *rastPort;
    LONG left;
    LONG height;
    LONG div;
    char prefix[129];
    LONG prefixLen = 0;
    const char *prefixCursor;
    char sourceTerminator;
    const char *cursor;
    const char *chunkStart;
    LONG chunkLen;
    LONG textWidth;
    LONG x;
    LONG y;

    TLIBA3_ClearViewModeRastPort(4, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    ESQ_SetCopperEffect_OnEnableHighlight();

    context = (SCRIPT_DisplayContext *)WDISP_DisplayContextBase;
    left = (LONG)context->left2;
    height = (LONG)context->height4;
    ESQIFF_RunCopperDropTransition();
    ESQIFF_RestoreBasePaletteTriples();

    div = MATH_DivS32(height, ((context->flags0 & 4U) != 0) ? 2 : 1);
    SCRIPT_BeginBannerCharTransition(div + 22, 500);

    if (text == 0 || *text == '\0') {
        ESQIFF_RunCopperRiseTransition();
        return;
    }

    rastPort = (char *)context->rastPort;
    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    prefixCursor = text;
    while (*prefixCursor != '\0') {
        UBYTE c;

        if (prefixLen >= 128) {
            break;
        }

        c = (UBYTE)*prefixCursor;
        if (c >= 32) {
            prefix[prefixLen] = (char)c;
            prefixLen++;
        }
        prefixCursor++;
    }

    if (*prefixCursor != '\0') {
        sourceTerminator = '\0';
        *(char *)prefixCursor = sourceTerminator;
    }

    prefix[prefixLen] = '\0';

    textWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, prefix, prefixLen);
    if (CLOCK_AlignedInsetRenderGateFlag != 0 &&
        CLEANUP_AlignedInsetNibblePrimary != 0xFF) {
        textWidth += 8;
    }

    x = left - textWidth;
    if (x < 0) {
        x++;
    }
    x >>= 1;
    y = height - 26;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, x, y);

    cursor = text;
    chunkStart = cursor;
    chunkLen = 0;
    while (*cursor != '\0') {
        UBYTE c = (UBYTE)*cursor;
        if (c == 19 || c == 20 || c == 24 || c == 25) {
            if (chunkLen > 0 && c != 20) {
                _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, chunkStart, chunkLen);
            }
            if (c == 24 || c == 25) {
                _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, (c == 24) ? 1 : 3);
                cursor++;
                chunkStart = cursor;
                chunkLen = 0;
                continue;
            }
            if (c == 20) {
                STRING_CopyPadNul(prefix, chunkStart, chunkLen);
                prefix[chunkLen] = '\0';
                SCRIPT_DrawInsetTextWithFrame(
                    rastPort,
                    (BYTE)CLEANUP_AlignedInsetNibblePrimary,
                    (BYTE)CLEANUP_AlignedInsetNibbleSecondary,
                    prefix);
                CLOCK_AlignedInsetRenderGateFlag = 0;
            }
            cursor++;
            chunkStart = cursor;
            chunkLen = 0;
            continue;
        }
        if (c >= 32) {
            chunkLen++;
        }
        cursor++;
    }
    if (chunkLen > 0) {
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, chunkStart, chunkLen);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    ESQIFF_RunCopperRiseTransition();
}
