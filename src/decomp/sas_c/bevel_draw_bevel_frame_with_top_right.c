typedef long LONG;

void BEVEL_DrawBeveledFrame(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawHorizontalBevel(void *rastPort, LONG leftX, LONG rightX, LONG y, LONG bottomY);

void BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawBeveledFrame(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawHorizontalBevel(rastPort, leftX, topY, rightX, bottomY);
}
