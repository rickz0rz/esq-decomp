#include <exec/types.h>
extern void *WDISP_DisplayContextBase;
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
extern LONG _LVOTextLength(char *rastport, const char *text, LONG len);
extern void _LVOSetDrMd(char *rastport, LONG mode);
extern void _LVOSetAPen(char *rastport, LONG pen);
extern void _LVOMove(char *rastport, LONG x, LONG y);
extern void _LVOText(char *rastport, const char *text, LONG len);

typedef struct SCRIPT_DisplayContext {
    unsigned short flags0;
    unsigned short rastWord2;
    unsigned short width4;
    UBYTE rastPortTail[1];
} SCRIPT_DisplayContext;

static LONG len_local(const char *s)
{
    LONG n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_SetupHighlightEffect(const char *text)
{
    SCRIPT_DisplayContext *context;
    LONG widthSlot;
    LONG div;
    char prefix[128];
    LONG prefixLen = 0;
    char *rp;
    const char *cursor;
    const char *chunkStart;
    LONG chunkLen;

    TLIBA3_ClearViewModeRastPort(4, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    ESQ_SetCopperEffect_OnEnableHighlight();

    context = (SCRIPT_DisplayContext *)WDISP_DisplayContextBase;
    widthSlot = (LONG)context->width4;
    ESQIFF_RunCopperDropTransition();
    ESQIFF_RestoreBasePaletteTriples();

    div = MATH_DivS32(widthSlot, ((context->flags0 & (1 << 2)) != 0) ? 2 : 1);
    SCRIPT_BeginBannerCharTransition((WORD)(div + 22), 500);

    if (text == 0 || *text == '\0') {
        ESQIFF_RunCopperRiseTransition();
        return;
    }

    rp = (char *)&context->rastWord2;
    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    while (text[prefixLen] != '\0' && prefixLen < 128) {
        UBYTE c = (UBYTE)text[prefixLen];
        if (c >= 32) {
            prefix[prefixLen] = (char)c;
        }
        prefixLen++;
    }
    if (prefixLen > 0) {
        prefix[prefixLen] = '\0';
    } else {
        prefix[0] = '\0';
    }

    (void)_LVOTextLength(rp, prefix, len_local(prefix));
    _LVOSetDrMd(rp, 0);
    _LVOSetAPen(rp, 1);
    _LVOMove(rp, 0, widthSlot - 26);

    cursor = text;
    chunkStart = cursor;
    chunkLen = 0;
    while (*cursor != '\0') {
        UBYTE c = (UBYTE)*cursor;
        if (c == 19 || c == 20 || c == 24 || c == 25) {
            if (chunkLen > 0) {
                _LVOText(rp, chunkStart, chunkLen);
            }
            if (c == 24 || c == 25) {
                _LVOSetAPen(rp, (c == 24) ? 1 : 3);
                cursor++;
                chunkStart = cursor;
                chunkLen = 0;
                continue;
            }
            if (c == 20) {
                STRING_CopyPadNul(prefix, chunkStart, chunkLen);
                prefix[chunkLen] = '\0';
                SCRIPT_DrawInsetTextWithFrame(rp, (BYTE)CLEANUP_AlignedInsetNibblePrimary, (BYTE)CLEANUP_AlignedInsetNibbleSecondary, prefix);
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
        _LVOText(rp, chunkStart, chunkLen);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    ESQIFF_RunCopperRiseTransition();
}
