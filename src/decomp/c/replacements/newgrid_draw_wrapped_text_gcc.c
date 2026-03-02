#include "esq_types.h"

extern u8 NEWGRID_WrapWordSpacer;
extern u8 NEWGRID_WrapReturnSpacer;
extern u8 Global_STR_SINGLE_SPACE;
extern void *Global_REF_GRAPHICS_LIBRARY;

u8 *NEWGRID2_JMPTBL_STR_SkipClass3Chars(u8 *s) __attribute__((noinline));
u8 *NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(u8 *src, u8 *dst, s32 limit, const u8 *delims) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVOText(void *rastport, const u8 *text, s32 len) __attribute__((noinline));

u8 *NEWGRID_DrawWrappedText(void *rastport, s32 x, s32 y, s32 max_width, u8 *text, s32 draw_enable) __attribute__((noinline, used));

u8 *NEWGRID_DrawWrappedText(void *rastport, s32 x, s32 y, s32 max_width, u8 *text, s32 draw_enable)
{
    u8 word_buf[50];
    s32 drawn_width = 0;
    s32 trim_len = 0;
    u8 *next = (u8 *)0;
    u8 *word_start = (u8 *)0;
    s32 space_w;

    if (text != (u8 *)0) {
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(text);
    }

    word_start = next;

    space_w = _LVOTextLength(rastport, &Global_STR_SINGLE_SPACE, 1);
    _LVOMove(rastport, x, y);

    while (next != (u8 *)0) {
        s32 word_len;
        s32 word_w;
        s32 rem_w;
        u8 *scan;

        next = NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(next, word_buf, 50, &NEWGRID_WrapWordSpacer);
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(next);

        if (word_buf[0] == 0) {
            return (u8 *)0;
        }

        scan = word_buf;
        while (*scan != 0) {
            ++scan;
        }
        word_len = (s32)(scan - word_buf);
        word_w = _LVOTextLength(rastport, word_buf, word_len);

        rem_w = max_width - drawn_width;
        if (word_w > rem_w) {
            if (word_w <= max_width) {
                return word_start;
            }

            trim_len = word_len - 1;
            while (trim_len > 0) {
                s32 trim_w = _LVOTextLength(rastport, word_buf, trim_len);
                if (trim_w <= rem_w) {
                    break;
                }
                trim_len -= 1;
            }

            if (trim_len > 0 && draw_enable != 0) {
                _LVOText(rastport, word_buf, trim_len);
            }

            return word_start + trim_len;
        }

        if (draw_enable != 0) {
            _LVOText(rastport, word_buf, word_len);
        }

        drawn_width += word_w;
        word_start = next;

        if (*next == 0) {
            continue;
        }

        if (drawn_width + space_w > max_width) {
            return word_start;
        }

        if (draw_enable != 0) {
            _LVOText(rastport, &NEWGRID_WrapReturnSpacer, 1);
        }

        drawn_width += space_w;
    }

    return next;
}
