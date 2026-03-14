#include <exec/types.h>
extern UBYTE ESQ_CopperListBannerA[];

ULONG GCOMMAND_GetBannerChar(void)
{
    return (ULONG)ESQ_CopperListBannerA[0];
}
