typedef signed long LONG;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

extern void GCOMMAND_AddBannerTableByteDelta(UBYTE *tablePtr, BYTE delta);
extern void GCOMMAND_UpdateBannerOffset(BYTE delta);

void GCOMMAND_AdjustBannerCopperOffset(BYTE delta)
{
    if (delta != 0) {
        LONG next = (LONG)ESQ_CopperListBannerA[0] + (LONG)delta;
        if (next >= 130) {
            GCOMMAND_AddBannerTableByteDelta(ESQ_CopperListBannerA, delta);
            GCOMMAND_AddBannerTableByteDelta(ESQ_CopperListBannerB, delta);
            GCOMMAND_UpdateBannerOffset(delta);
        }
    }
}
