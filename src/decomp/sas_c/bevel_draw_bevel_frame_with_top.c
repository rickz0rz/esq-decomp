#include <exec/types.h>

void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawHorizontalBevel(char *rastPort, LONG leftX, LONG rightX, LONG y, LONG bottomY);

void BEVEL_DrawBevelFrameWithTop(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawHorizontalBevel(rastPort, leftX, topY, rightX, bottomY);
}
