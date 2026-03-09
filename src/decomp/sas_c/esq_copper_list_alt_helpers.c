typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;

extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];
extern UWORD ESQ_BannerPaletteWordsA[];
extern UWORD ESQ_BannerPaletteWordsB[];
extern UBYTE WDISP_PaletteTriplesRBase[];

extern UWORD ESQ_DecColorStep(UWORD color);
extern UWORD ESQ_BumpColorTowardTargets(UWORD color, UBYTE *targets);

void ESQ_ClearCopperListFlags(void)
{
    ESQ_CopperListBannerA[0] = 0;
    ESQ_CopperListBannerB[0] = 0;
}

void ESQ_DecCopperListsAltSkipIndex4(void)
{
    WORD off;
    WORD i;

    off = 0;
    for (i = 0; i <= 7; ++i) {
        if (off != 4) {
            UWORD value = *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsA + off);

            value = ESQ_DecColorStep(value);
            *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsA + off) = value;
            *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsB + off) = value;
        }
        off = (WORD)(off + 4);
    }
}

void ESQ_IncCopperListsAltSkipIndex4(void)
{
    UBYTE *targets;
    WORD off;
    WORD i;

    targets = WDISP_PaletteTriplesRBase;
    off = 0;
    for (i = 0; i <= 7; ++i) {
        if (off != 4) {
            UWORD value = *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsA + off);

            value = ESQ_BumpColorTowardTargets(value, targets);
            *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsA + off) = value;
            *(UWORD *)((UBYTE *)ESQ_BannerPaletteWordsB + off) = value;
        }
        off = (WORD)(off + 4);
        targets += 3;
    }
}
