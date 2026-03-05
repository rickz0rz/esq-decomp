typedef long LONG;

void BEVEL_DrawVerticalBevelPair(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawHorizontalBevel(void *rastPort, LONG leftX, LONG rightX, LONG y, LONG bottomY);

void BEVEL_DrawBevelFrameWithTop(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawHorizontalBevel(rastPort, leftX, topY, rightX, bottomY);
}
