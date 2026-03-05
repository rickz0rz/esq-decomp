typedef long LONG;

void BEVEL_DrawVerticalBevelPair(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawVerticalBevel(void *rastPort, LONG x, LONG topY, LONG bottomY);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawBeveledFrame(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawVerticalBevel(rastPort, leftX, topY, bottomY);

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
}
