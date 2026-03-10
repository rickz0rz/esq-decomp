typedef signed long LONG;

extern void BEVEL_DrawBevelFrameWithTop(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);

void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawBevelFrameWithTop(rastPort, leftX, topY, rightX, bottomY);
}
