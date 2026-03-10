typedef signed long LONG;

extern void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);

void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
}
