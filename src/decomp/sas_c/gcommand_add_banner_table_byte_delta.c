#include <exec/types.h>
void GCOMMAND_AddBannerTableByteDelta(UBYTE *tablePtr, BYTE delta)
{
    tablePtr[0] = (UBYTE)(tablePtr[0] + delta);
}
