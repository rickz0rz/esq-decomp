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
    UBYTE c;

    c = (UBYTE)ch;

    if (c < 32) {
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ControlCharCaretEscape,
            (LONG)c + 64);
        return;
    }

    if (c == (UBYTE)168) {
        c = 34;
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementQuoteChar,
            (LONG)c);
        return;
    }

    if (c == (UBYTE)169) {
        c = 44;
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementCommaChar,
            (LONG)c);
        return;
    }

    if (c > 126) {
        GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_HexEscapeByte,
            (LONG)c);
        return;
    }

    GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        LADFUNC_FMT_LiteralChar,
        (LONG)c);
}
