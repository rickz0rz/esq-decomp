#include <exec/types.h>

extern const char LADFUNC_FMT_ControlCharCaretEscape[];
extern const char LADFUNC_FMT_ReplacementQuoteChar[];
extern const char LADFUNC_FMT_ReplacementCommaChar[];
extern const char LADFUNC_FMT_HexEscapeByte[];
extern const char LADFUNC_FMT_LiteralChar[];

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

void LADFUNC2_EmitEscapedCharToScratch(LONG ch)
{
    UBYTE c;

    c = (UBYTE)ch;

    if (c < 32) {
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ControlCharCaretEscape,
            (LONG)c + 64);
        return;
    }

    if (c == 168) {
        c = 34;
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementQuoteChar,
            (LONG)c);
        return;
    }

    if (c == (UBYTE)~86) {
        c = 44;
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementCommaChar,
            (LONG)c);
        return;
    }

    if (c > 126) {
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_HexEscapeByte,
            (LONG)c);
        return;
    }

    FORMAT_RawDoFmtWithScratchBuffer(
        LADFUNC_FMT_LiteralChar,
        (LONG)c);
}
