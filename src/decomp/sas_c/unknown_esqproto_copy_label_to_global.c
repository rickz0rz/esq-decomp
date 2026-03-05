typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UBYTE WDISP_StatusListMatchPattern[];

void ESQPROTO_CopyLabelToGlobal(const UBYTE *in)
{
    UBYTE local[16];
    UWORD i = 0;

    for (;;) {
        UBYTE c = *in++;
        local[i] = c;
        if (c == 0x12 || i >= 10) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        const UBYTE *src = local;
        UBYTE *dst = WDISP_StatusListMatchPattern;
        while ((*dst++ = *src++) != 0) {
        }
    }
}
