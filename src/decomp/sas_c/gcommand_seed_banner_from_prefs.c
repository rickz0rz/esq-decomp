typedef unsigned char UBYTE;
typedef signed short WORD;

extern void GCOMMAND_BuildBannerTables(UBYTE arg0, WORD arg1, UBYTE arg2);
extern WORD CONFIG_BannerCopperHeadByte;

typedef struct GCOMMAND_CopperHeader {
    UBYTE head0;
    UBYTE head1;
    WORD terminator2;
} GCOMMAND_CopperHeader;

extern GCOMMAND_CopperHeader ESQ_CopperListBannerA;
extern GCOMMAND_CopperHeader ESQ_CopperListBannerB;

void GCOMMAND_SeedBannerFromPrefs(void)
{
    GCOMMAND_BuildBannerTables(128, (WORD)0x80FE, 0);

    ESQ_CopperListBannerA.head0 = (UBYTE)CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerA.terminator2 = (WORD)0xFFFE;

    ESQ_CopperListBannerB.head0 = (UBYTE)CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerB.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerB.terminator2 = (WORD)0xFFFE;
}
