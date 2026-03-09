typedef long LONG;

void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawVerticalBevel(char *rastPort, LONG x, LONG topY, LONG bottomY);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawBeveledFrame(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawVerticalBevel(rastPort, leftX, topY, bottomY);

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
}
