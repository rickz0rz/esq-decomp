typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(LONG oldPtr, LONG newPtr);

void SCRIPT_ResetCtrlContext(void *ctx)
{
    UBYTE *p;
    LONG i;

    p = (UBYTE *)ctx;

    p[436] = 0;
    p[437] = 120;
    p[438] = 0;
    p[439] = 0;

    *(LONG *)(p + 440) = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(*(LONG *)(p + 440), 0);

    p[226] = 0;
    p[26] = 0;
    *(UWORD *)(p + 6) = 0;
    *(UWORD *)(p + 4) = 0;
    *(UWORD *)(p + 10) = 0;
    *(UWORD *)(p + 12) = 0;
    *(UWORD *)(p + 14) = 0;
    *(LONG *)(p + 16) = 0;
    *(LONG *)(p + 20) = 0;
    *(UWORD *)(p + 24) = 0;
    *(UWORD *)(p + 426) = 1;

    for (i = 0; i < 4; i++) {
        p[428 + i] = 0;
        p[0x1b0 + i] = 0;
    }
}
