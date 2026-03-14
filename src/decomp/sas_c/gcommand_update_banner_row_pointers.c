#include <exec/types.h>
extern LONG GCOMMAND_BannerRowIndexPrevious;
extern LONG GCOMMAND_BannerRowIndexCurrent;

void GCOMMAND_UpdateBannerRowPointers(UWORD *table)
{
    LONG prev = GCOMMAND_BannerRowIndexPrevious;
    LONG curr = GCOMMAND_BannerRowIndexCurrent;
    UBYTE *base = (UBYTE *)table;
    UWORD prevHi;
    UWORD prevLo;

    if (curr == prev) {
        return;
    }

    {
        UBYTE *p = base + (prev << 5) + 772;
        prevHi = (UWORD)(((ULONG)p >> 16) & 0xFFFF);
        prevLo = (UWORD)((ULONG)p & 0xFFFF);
    }

    {
        UBYTE *tail = base + 3916;
        LONG off = (curr << 5);
        *(UWORD *)(base + off + 0x2FA) = (UWORD)(((ULONG)tail >> 16) & 0xFFFF);
        *(UWORD *)(base + off + 0x2FE) = (UWORD)((ULONG)tail & 0xFFFF);
    }

    if (prev == 97) {
        UBYTE *tailPrev = base + 3876;
        LONG off = (prev << 5);
        *(UWORD *)(base + off + 0x2FA) = (UWORD)(((ULONG)tailPrev >> 16) & 0xFFFF);
        *(UWORD *)(base + off + 0x2FE) = (UWORD)((ULONG)tailPrev & 0xFFFF);
    } else {
        LONG off = (prev << 5);
        *(UWORD *)(base + off + 0x2FA) = prevHi;
        *(UWORD *)(base + off + 0x2FE) = prevLo;
    }
}
