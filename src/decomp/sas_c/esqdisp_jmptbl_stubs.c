#include <exec/types.h>
extern void NEWGRID_ProcessGridMessages(void);
extern void *GRAPHICS_AllocRaster(LONG width, LONG height);

void ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(void){NEWGRID_ProcessGridMessages();}
void *ESQDISP_JMPTBL_GRAPHICS_AllocRaster(const char *tag, LONG line, LONG width, LONG height)
{
    return GRAPHICS_AllocRaster(width, height);
}
