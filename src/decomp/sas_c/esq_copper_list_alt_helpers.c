typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;

typedef struct ESQ_CopperListHeader {
    UBYTE flag0;
} ESQ_CopperListHeader;

typedef struct ESQ_BannerPaletteSlot {
    UWORD color;
    UWORD pad2;
} ESQ_BannerPaletteSlot;

typedef struct ESQ_BannerPaletteTable {
    ESQ_BannerPaletteSlot slots[8];
} ESQ_BannerPaletteTable;

extern ESQ_CopperListHeader ESQ_CopperListBannerA;
extern ESQ_CopperListHeader ESQ_CopperListBannerB;
extern ESQ_BannerPaletteTable ESQ_BannerPaletteWordsA;
extern ESQ_BannerPaletteTable ESQ_BannerPaletteWordsB;
extern UBYTE WDISP_PaletteTriplesRBase[];

extern UWORD ESQ_DecColorStep(UWORD color);
extern UWORD ESQ_BumpColorTowardTargets(UWORD color, UBYTE *targets);

void ESQ_ClearCopperListFlags(void)
{
    ESQ_CopperListBannerA.flag0 = 0;
    ESQ_CopperListBannerB.flag0 = 0;
}

void ESQ_DecCopperListsAltSkipIndex4(void)
{
    WORD i;

    for (i = 0; i <= 7; ++i) {
        if (i != 1) {
            UWORD value = ESQ_BannerPaletteWordsA.slots[i].color;

            value = ESQ_DecColorStep(value);
            ESQ_BannerPaletteWordsA.slots[i].color = value;
            ESQ_BannerPaletteWordsB.slots[i].color = value;
        }
    }
}

void ESQ_IncCopperListsAltSkipIndex4(void)
{
    UBYTE *targets;
    WORD i;

    targets = WDISP_PaletteTriplesRBase;
    for (i = 0; i <= 7; ++i) {
        if (i != 1) {
            UWORD value = ESQ_BannerPaletteWordsA.slots[i].color;

            value = ESQ_BumpColorTowardTargets(value, targets);
            ESQ_BannerPaletteWordsA.slots[i].color = value;
            ESQ_BannerPaletteWordsB.slots[i].color = value;
        }
        targets += 3;
    }
}
