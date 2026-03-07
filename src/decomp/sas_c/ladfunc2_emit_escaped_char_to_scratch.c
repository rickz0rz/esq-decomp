typedef signed long LONG;
typedef unsigned char UBYTE;

extern const char LADFUNC_FMT_ControlCharCaretEscape[];
extern const char LADFUNC_FMT_ReplacementQuoteChar[];
extern const char LADFUNC_FMT_ReplacementCommaChar[];
extern const char LADFUNC_FMT_HexEscapeByte[];
extern const char LADFUNC_FMT_LiteralChar[];

extern void GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

void LADFUNC2_EmitEscapedCharToScratch(LONG ch)
{
    const UBYTE ASCII_CONTROL_MAX = 32;
    const LONG ASCII_CARET_OFFSET = 64;
    const UBYTE ESCAPE_QUOTE_TOKEN = 168;
    const UBYTE ESCAPE_COMMA_TOKEN = 169;
    const UBYTE ASCII_QUOTE = 34;
    const UBYTE ASCII_COMMA = 44;
    const UBYTE ASCII_PRINTABLE_MAX = 126;
    UBYTE c;

    c = (UBYTE)ch;

    if (c < ASCII_CONTROL_MAX) {
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ControlCharCaretEscape,
            (LONG)c + ASCII_CARET_OFFSET);
        return;
    }

    if (c == ESCAPE_QUOTE_TOKEN) {
        c = ASCII_QUOTE;
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementQuoteChar,
            (LONG)c);
        return;
    }

    if (c == ESCAPE_COMMA_TOKEN) {
        c = ASCII_COMMA;
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementCommaChar,
            (LONG)c);
        return;
    }

    if (c > ASCII_PRINTABLE_MAX) {
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_HexEscapeByte,
            (LONG)c);
        return;
    }

    GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        LADFUNC_FMT_LiteralChar,
        (LONG)c);
}
