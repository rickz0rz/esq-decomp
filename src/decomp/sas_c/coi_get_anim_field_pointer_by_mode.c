typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;
typedef unsigned char UBYTE;

LONG COI_GetAnimFieldPointerByMode(void *entry, UWORD key, UWORD mode)
{
    UBYTE *e;
    UBYTE *anim;
    UBYTE *sub;
    WORD found;
    WORD i;
    LONG out;

    e = (UBYTE *)entry;
    sub = (UBYTE *)0;
    found = 0;

    if (e == (UBYTE *)0 || *(LONG *)(e + 48) == 0) {
        return 0;
    }

    anim = *(UBYTE **)(e + 48);
    i = 0;
    while (i < *(WORD *)(anim + 36)) {
        UBYTE **table;
        UBYTE *cur;

        table = *(UBYTE ***)(anim + 38);
        cur = table[i];
        sub = cur;
        if (*(UWORD *)(cur + 0) == key) {
            found = 1;
            break;
        }
        i += 1;
    }

    switch (mode) {
    case 5:
        out = (LONG)anim;
        break;
    case 0:
        out = *(LONG *)(anim + 4);
        break;
    case 1:
        out = (found != 0) ? *(LONG *)(sub + 2) : *(LONG *)(anim + 8);
        break;
    case 2:
        out = (found != 0) ? *(LONG *)(sub + 6) : *(LONG *)(anim + 12);
        break;
    case 3:
        out = (found != 0) ? *(LONG *)(sub + 10) : *(LONG *)(anim + 16);
        break;
    case 4:
        out = (found != 0) ? *(LONG *)(sub + 14) : *(LONG *)(anim + 20);
        break;
    case 6:
        out = (found != 0) ? *(LONG *)(sub + 18) : *(LONG *)(anim + 24);
        break;
    case 7:
        out = (found != 0) ? *(LONG *)(sub + 22) : *(LONG *)(anim + 28);
        break;
    default:
        out = 0;
        break;
    }

    return out;
}
