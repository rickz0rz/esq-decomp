typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UWORD ESQPARS2_BannerColorBaseValue;
extern UBYTE ESQ_BannerColorClampValueA;
extern UBYTE ESQ_BannerColorClampValueB;
extern UBYTE ESQ_BannerColorClampWaitRowA;
extern UBYTE ESQ_BannerColorClampWaitRowB;

void ESQSHARED4_SetBannerColorBaseAndLimit(UWORD value)
{
    ESQPARS2_BannerColorBaseValue = value;
    ESQ_BannerColorClampValueA = (UBYTE)value;
    ESQ_BannerColorClampValueB = (UBYTE)value;
    ESQ_BannerColorClampWaitRowA = 0xD9;
    ESQ_BannerColorClampWaitRowB = 0xD9;
}
