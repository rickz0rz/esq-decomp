#include <exec/types.h>
extern void CLEANUP_DrawClockFormatList(LONG startIndex);

void NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList(LONG startIndex)
{
    CLEANUP_DrawClockFormatList(startIndex);
}
