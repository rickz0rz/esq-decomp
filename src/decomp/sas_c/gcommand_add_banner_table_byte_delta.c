typedef signed char BYTE;
typedef unsigned char UBYTE;

void GCOMMAND_AddBannerTableByteDelta(UBYTE *tablePtr, BYTE delta)
{
    tablePtr[0] = (UBYTE)(tablePtr[0] + delta);
}
