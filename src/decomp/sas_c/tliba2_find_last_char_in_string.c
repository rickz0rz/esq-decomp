typedef unsigned char UBYTE;

char *TLIBA2_FindLastCharInString(char *str, UBYTE targetChar)
{
    char *p;

    if (str == (char *)0) {
        return (char *)0;
    }

    p = str;
    while (*p != 0) {
        ++p;
    }
    if (p == str) {
        return (char *)0;
    }
    --p;

    for (;;) {
        if ((UBYTE)*p == targetChar) {
            return p;
        }
        if (p == str) {
            break;
        }
        --p;
    }

    return (char *)0;
}
