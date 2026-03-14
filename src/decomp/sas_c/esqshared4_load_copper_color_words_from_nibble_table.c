#include <exec/types.h>
extern UWORD ESQ_BannerColorSweepProgramA;
extern UWORD ESQ_BannerColorSweepProgramB;
extern UWORD ESQ_BannerColorSweepProgramA_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramA_TailColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_TailColorWord;

extern UWORD ESQSHARED4_DecodeRgbNibbleTriplet(UBYTE *src);

void ESQSHARED4_LoadCopperColorWordsFromNibbleTable(UBYTE *src, UBYTE *dstA, UBYTE *dstB, UWORD offset)
{
    UWORD i;

    for (i = 0; i <= 7; i++) {
        UWORD color;

        color = ESQSHARED4_DecodeRgbNibbleTriplet(src);
        src += 3;

        if (offset == 4) {
            ESQ_BannerColorSweepProgramA = color;
            ESQ_BannerColorSweepProgramB = color;
            ESQ_BannerColorSweepProgramA_AnchorColorWord = color;
            ESQ_BannerColorSweepProgramB_AnchorColorWord = color;
        } else if (offset == 0x1C) {
            ESQ_BannerColorSweepProgramA_TailColorWord = color;
            ESQ_BannerColorSweepProgramB_TailColorWord = color;
        } else {
            *((UWORD *)(dstA + offset)) = color;
            *((UWORD *)(dstB + offset)) = color;
        }

        offset = (UWORD)(offset + 4);
    }
}
