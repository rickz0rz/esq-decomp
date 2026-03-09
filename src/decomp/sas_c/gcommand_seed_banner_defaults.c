typedef unsigned char UBYTE;
typedef signed short WORD;

extern void GCOMMAND_BuildBannerTables(UBYTE arg0, WORD arg1, UBYTE arg2);

typedef struct GCOMMAND_CopperHeader {
    UBYTE head0;
    UBYTE head1;
    WORD terminator2;
} GCOMMAND_CopperHeader;

typedef struct GCOMMAND_BannerCopperList {
    GCOMMAND_CopperHeader start;
    UBYTE pad4[3912];
    GCOMMAND_CopperHeader end;
} GCOMMAND_BannerCopperList;

extern GCOMMAND_BannerCopperList ESQ_CopperListBannerA;
extern GCOMMAND_BannerCopperList ESQ_CopperListBannerB;

void GCOMMAND_SeedBannerDefaults(void)
{
    GCOMMAND_BuildBannerTables(32, (WORD)0xFFFE, 1);

    ESQ_CopperListBannerA.start.head0 = (UBYTE)31;
    ESQ_CopperListBannerA.start.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerA.start.terminator2 = (WORD)0xFFFE;
    ESQ_CopperListBannerA.end.head0 = (UBYTE)0xF8;
    ESQ_CopperListBannerA.end.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerA.end.terminator2 = (WORD)0xFFFE;

    ESQ_CopperListBannerB.start.head0 = (UBYTE)31;
    ESQ_CopperListBannerB.start.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerB.start.terminator2 = (WORD)0xFFFE;
    ESQ_CopperListBannerB.end.head0 = (UBYTE)0xF8;
    ESQ_CopperListBannerB.end.head1 = (UBYTE)0xD9;
    ESQ_CopperListBannerB.end.terminator2 = (WORD)0xFFFE;
}
