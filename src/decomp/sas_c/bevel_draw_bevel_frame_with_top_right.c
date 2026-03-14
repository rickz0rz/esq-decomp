#include <exec/types.h>

void BEVEL_DrawBeveledFrame(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawHorizontalBevel(char *rastPort, LONG leftX, LONG rightX, LONG y, LONG bottomY);

void BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawBeveledFrame(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawHorizontalBevel(rastPort, leftX, topY, rightX, bottomY);
}
