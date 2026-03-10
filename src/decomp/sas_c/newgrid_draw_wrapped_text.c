typedef signed long LONG;
typedef unsigned char UBYTE;

extern const char NEWGRID_WrapWordSpacer[];
extern const char NEWGRID_WrapReturnSpacer[];
extern const char Global_STR_SINGLE_SPACE[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);
extern char *NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(char *src, char *dst, LONG limit, const char *delims);
extern LONG _LVOTextLength(char *rastport, const char *text, LONG len);
extern void _LVOMove(char *rastport, LONG x, LONG y);
extern void _LVOText(char *rastport, const char *text, LONG len);

char *NEWGRID_DrawWrappedText(char *rastport, LONG x, LONG y, LONG max_width, char *text, LONG draw_enable)
{
    char word_buf[50];
    LONG drawn_width;
    LONG trim_len;
    char *next;
    char *word_start;
    LONG space_w;

    drawn_width = 0;
    trim_len = 0;
    next = (char *)0;
    word_start = (char *)0;

    if (text != (char *)0) {
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(text);
    }

    word_start = next;
    space_w = _LVOTextLength(rastport, Global_STR_SINGLE_SPACE, 1);
    _LVOMove(rastport, x, y);

    while (next != (char *)0) {
        LONG word_len;
        LONG word_w;
        LONG rem_w;
        char *scan;

        next = NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(next, word_buf, 50, NEWGRID_WrapWordSpacer);
        next = NEWGRID2_JMPTBL_STR_SkipClass3Chars(next);

        if (word_buf[0] == 0) {
            return (char *)0;
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
            _LVOText(rastport, NEWGRID_WrapReturnSpacer, 1);
        }

        drawn_width += space_w;
    }

    return next;
}
