typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern ULONG ESQSHARED4_InterleaveCopyBaseOffset;
extern ULONG ESQSHARED4_InterleaveCopyTailOffsetCurrent;

void ESQSHARED4_CopyInterleavedRowWordsFromOffset(UBYTE *base)
{
    UBYTE *a1;
    UBYTE *a2;
    int i;

    a1 = base + ESQSHARED4_InterleaveCopyBaseOffset;
    a2 = a1 + 0x20;

    for (i = 0; i < 16; i++) {
        *((UWORD *)(a1 + 6)) = *((UWORD *)(a2 + 6));
        *((UWORD *)(a1 + 10)) = *((UWORD *)(a2 + 10));
        *((UWORD *)(a1 + 14)) = *((UWORD *)(a2 + 14));
        a1 += 0x20;
        a2 += 0x20;
    }

    a2 = base + ESQSHARED4_InterleaveCopyTailOffsetCurrent;
    *((UWORD *)(a1 + 6)) = *((UWORD *)(a2 + 6));
    *((UWORD *)(a1 + 10)) = *((UWORD *)(a2 + 10));
    *((UWORD *)(a1 + 14)) = *((UWORD *)(a2 + 14));
}
