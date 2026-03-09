typedef unsigned char UBYTE;
typedef signed short WORD;

extern char WDISP_StatusListMatchPattern[];

void ESQPROTO_CopyLabelToGlobal(const char *src)
{
    char tmp[12];
    WORD i = 0;

    while (1) {
        char ch = *src++;
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
