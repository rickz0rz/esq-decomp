typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;

extern UBYTE ESQPARS_DefaultEntryCodeString[];

void ESQSHARED_InitEntryDefaults(UBYTE *entry)
{
    UBYTE *dst;
    UBYTE *src;

    entry[40] = 2;
    entry[41] = (UBYTE)(BYTE)-1;
    entry[42] = (UBYTE)(BYTE)-1;

    dst = &entry[43];
    src = ESQPARS_DefaultEntryCodeString;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    *(UWORD *)(entry + 46) = 3;
}
