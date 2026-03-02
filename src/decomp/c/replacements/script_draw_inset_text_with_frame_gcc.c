#include "esq_types.h"

extern void *Global_REF_GRAPHICS_LIBRARY;

s32 _LVOTextLength(void *rastport, const char *text, s32 len) __attribute__((noinline));
void _LVOText(void *rastport, const char *text, s32 len) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(void *rastport, s32 frame_pen, s32 width, s32 depth) __attribute__((noinline));

static s32 cstrlen_local(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_DrawInsetTextWithFrame(void *rastport, s8 text_pen_override, s8 frame_pen, const char *text) __attribute__((noinline, used));

void SCRIPT_DrawInsetTextWithFrame(void *rastport, s8 text_pen_override, s8 frame_pen, const char *text)
{
    s32 text_len;
    s32 saved_pen = 0;
    u8 *rp = (u8 *)rastport;

    if (text == 0 || *text == '\0') {
        return;
    }

    if ((s32)frame_pen != -1) {
        *(u16 *)(rp + 36) = (u16)(*(u16 *)(rp + 36) + 4);
        text_len = cstrlen_local(text);
        TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(
            rastport,
            (s32)frame_pen,
            _LVOTextLength(rastport, text, text_len),
            (s32)*(u16 *)(rp + 58));
    }

    if ((s32)text_pen_override != -1) {
        saved_pen = (s32)rp[25];
        _LVOSetAPen(rastport, (s32)text_pen_override);
    }

    text_len = cstrlen_local(text);
    _LVOText(rastport, text, text_len);

    if ((s32)text_pen_override != -1) {
        _LVOSetAPen(rastport, saved_pen);
    }

    if ((s32)frame_pen != -1) {
        *(u16 *)(rp + 38) = (u16)(*(u16 *)(rp + 38) - 2);
        *(u16 *)(rp + 36) = (u16)(*(u16 *)(rp + 36) + 4);
    }
}
