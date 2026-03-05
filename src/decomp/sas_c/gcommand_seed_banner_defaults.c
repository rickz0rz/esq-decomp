typedef unsigned char UBYTE;
typedef signed short WORD;

extern void GCOMMAND_BuildBannerTables(UBYTE arg0, WORD arg1, UBYTE arg2);
extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

void GCOMMAND_SeedBannerDefaults(void)
{
    GCOMMAND_BuildBannerTables(32, (WORD)0xFFFE, 1);

    ESQ_CopperListBannerA[0] = (UBYTE)31;
    ESQ_CopperListBannerA[1] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerA + 2) = (WORD)0xFFFE;
    ESQ_CopperListBannerA[3916] = (UBYTE)0xF8;
    ESQ_CopperListBannerA[3917] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerA + 3918) = (WORD)0xFFFE;

    ESQ_CopperListBannerB[0] = (UBYTE)31;
    ESQ_CopperListBannerB[1] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerB + 2) = (WORD)0xFFFE;
    ESQ_CopperListBannerB[3916] = (UBYTE)0xF8;
    ESQ_CopperListBannerB[3917] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerB + 3918) = (WORD)0xFFFE;
}
