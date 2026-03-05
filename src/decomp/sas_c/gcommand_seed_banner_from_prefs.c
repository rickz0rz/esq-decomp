typedef unsigned char UBYTE;
typedef signed short WORD;

extern void GCOMMAND_BuildBannerTables(UBYTE arg0, WORD arg1, UBYTE arg2);
extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];
extern WORD CONFIG_BannerCopperHeadByte;

void GCOMMAND_SeedBannerFromPrefs(void)
{
    GCOMMAND_BuildBannerTables(128, (WORD)0x80FE, 0);

    ESQ_CopperListBannerA[0] = (UBYTE)CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA[1] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerA + 2) = (WORD)0xFFFE;

    ESQ_CopperListBannerB[0] = (UBYTE)CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerB[1] = (UBYTE)0xD9;
    *(WORD *)(ESQ_CopperListBannerB + 2) = (WORD)0xFFFE;
}
