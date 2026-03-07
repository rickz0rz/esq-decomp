typedef unsigned char UBYTE;
typedef signed short WORD;

extern UBYTE WDISP_StatusListMatchPattern[];

void ESQPROTO_CopyLabelToGlobal(const UBYTE *src)
{
    UBYTE tmp[12];
    WORD i = 0;

    while (1) {
        UBYTE ch = *src++;
        tmp[i] = ch;
        if (ch == 0x12) {
            break;
        }
        if (i >= 10) {
            break;
        }
        ++i;
    }

    tmp[i] = 0;

    i = 0;
    do {
        WDISP_StatusListMatchPattern[i] = tmp[i];
    } while (tmp[i++] != 0);
}
