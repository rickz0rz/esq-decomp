typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern char WDISP_StatusListMatchPattern[];

void ESQPROTO_CopyLabelToGlobal(const char *in)
{
    char local[16];
    UWORD i = 0;

    for (;;) {
        char c = *in++;
        local[i] = c;
        if (c == 0x12 || i >= 10) {
            break;
        }
        i++;
    }

    local[i] = 0;

    {
        const char *src = local;
        char *dst = WDISP_StatusListMatchPattern;
        while ((*dst++ = *src++) != 0) {
        }
    }
}
