#include "esq_types.h"

extern void *WDISP_DisplayContextBase;
extern s16 WDISP_AccumulatorCaptureActive;
extern s16 WDISP_AccumulatorFlushPending;
extern u8 CLOCK_AlignedInsetRenderGateFlag;
extern u8 CLEANUP_AlignedInsetNibblePrimary;
extern u8 CLEANUP_AlignedInsetNibbleSecondary;

void TLIBA3_ClearViewModeRastPort(s32 mode, s32 unused) __attribute__((noinline));
void *TLIBA3_BuildDisplayContextForViewMode(s32 mode, s32 a, s32 b) __attribute__((noinline));
void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void) __attribute__((noinline));
void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void) __attribute__((noinline));
void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void) __attribute__((noinline));
void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void) __attribute__((noinline));
s32 MATH_DivS32(s32 a, s32 b) __attribute__((noinline));
void SCRIPT_BeginBannerCharTransition(s32 x, s32 y) __attribute__((noinline));
void STRING_CopyPadNul(char *dst, const char *src, s32 n) __attribute__((noinline));
void SCRIPT_DrawInsetTextWithFrame(void *rastport, s8 text_pen_override, s8 frame_pen, const char *text) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const char *text, s32 len) __attribute__((noinline));
void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVOText(void *rastport, const char *text, s32 len) __attribute__((noinline));

static s32 len_local(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_SetupHighlightEffect(const char *text) __attribute__((noinline, used));

void SCRIPT_SetupHighlightEffect(const char *text)
{
    s32 width_slot;
    s32 div;
    char prefix[128];
    s32 prefix_len = 0;
    void *rp;
    const char *cursor;
    const char *chunk_start;
    s32 chunk_len;

    TLIBA3_ClearViewModeRastPort(4, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();

    width_slot = (s32)(*(u16 *)((u8 *)WDISP_DisplayContextBase + 4));
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();
    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();

    div = MATH_DivS32(width_slot, ((*(u16 *)WDISP_DisplayContextBase) & (1 << 2)) ? 2 : 1);
    SCRIPT_BeginBannerCharTransition((s16)(div + 22), 500);

    if (text == 0 || *text == '\0') {
        TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
        return;
    }

    rp = (u8 *)WDISP_DisplayContextBase + 2;
    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    while (text[prefix_len] != '\0' && prefix_len < 128) {
        u8 c = (u8)text[prefix_len];
        if (c >= 32) {
            prefix[prefix_len] = (char)c;
        }
        prefix_len++;
    }
    if (prefix_len > 0) {
        prefix[prefix_len] = '\0';
    } else {
        prefix[0] = '\0';
    }

    (void)_LVOTextLength(rp, prefix, len_local(prefix));
    if (CLOCK_AlignedInsetRenderGateFlag && CLEANUP_AlignedInsetNibblePrimary != (u8)0xFF) {
        (void)0;
    }
    _LVOSetDrMd(rp, 0);
    _LVOSetAPen(rp, 1);
    _LVOMove(rp, 0, width_slot - 26);

    cursor = text;
    chunk_start = cursor;
    chunk_len = 0;
    while (*cursor != '\0') {
        u8 c = (u8)*cursor;
        if (c == 19 || c == 20 || c == 24 || c == 25) {
            if (chunk_len > 0) {
                _LVOText(rp, chunk_start, chunk_len);
            }
            if (c == 24 || c == 25) {
                _LVOSetAPen(rp, (c == 24) ? 1 : 3);
                cursor++;
                chunk_start = cursor;
                chunk_len = 0;
                continue;
            }
            if (c == 20) {
                STRING_CopyPadNul(prefix, chunk_start, chunk_len);
                prefix[chunk_len] = '\0';
                SCRIPT_DrawInsetTextWithFrame(rp, (s8)CLEANUP_AlignedInsetNibblePrimary, (s8)CLEANUP_AlignedInsetNibbleSecondary, prefix);
                CLOCK_AlignedInsetRenderGateFlag = 0;
            }
            cursor++;
            chunk_start = cursor;
            chunk_len = 0;
            continue;
        }
        if (c >= 32) {
            chunk_len++;
        }
        cursor++;
    }
    if (chunk_len > 0) {
        _LVOText(rp, chunk_start, chunk_len);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
}
