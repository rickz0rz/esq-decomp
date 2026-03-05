typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE NEWGRID_WrapWordSpacer;
extern UBYTE NEWGRID_WrapReturnSpacer;
extern UBYTE Global_STR_SINGLE_SPACE;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);
extern UBYTE *NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(UBYTE *src, UBYTE *dst, LONG limit, UBYTE *delims);
extern LONG _LVOTextLength(void *rastport, UBYTE *text, LONG len);
extern void _LVOMove(void *rastport, LONG x, LONG y);
extern void _LVOText(void *rastport, UBYTE *text, LONG len);

UBYTE *NEWGRID_DrawWrappedText(void *rastport, LONG x, LONG y, LONG max_width, UBYTE *text, LONG draw_enable)
{
    UBYTE word_buf[50];
    LONG drawn_width;
    LONG trim_len;
    UBYTE *next;
    UBYTE *word_start;
    LONG space_w;

    drawn_width = 0;
    trim_len = 0;
    next = (UBYTE *)0;
    word_start = (UBYTE *)0;

    if (text != (UBYTE *)0) {
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(text);
    }

    word_start = next;
    space_w = _LVOTextLength(rastport, &Global_STR_SINGLE_SPACE, 1);
    _LVOMove(rastport, x, y);

    while (next != (UBYTE *)0) {
        LONG word_len;
        LONG word_w;
        LONG rem_w;
        UBYTE *scan;

        next = NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(next, word_buf, 50, &NEWGRID_WrapWordSpacer);
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(next);

        if (word_buf[0] == 0) {
            return (UBYTE *)0;
        }

        scan = word_buf;
        while (*scan != 0) {
            ++scan;
        }
        word_len = (LONG)(scan - word_buf);
        word_w = _LVOTextLength(rastport, word_buf, word_len);
        rem_w = max_width - drawn_width;

        if (word_w > rem_w) {
            if (word_w <= max_width) {
                return word_start;
            }

            trim_len = word_len - 1;
            while (trim_len > 0) {
                LONG trim_w = _LVOTextLength(rastport, word_buf, trim_len);
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
