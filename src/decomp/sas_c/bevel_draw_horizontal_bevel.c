typedef long LONG;

void _LVOSetDrMd(void);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawHorizontalBevel(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    LONG i;

    _LVOSetDrMd();
    _LVOSetAPen();

    for (i = 0; i < 4; i++) {
        *(short *)((LONG)rastPort + 34) = -1;
        *(unsigned char *)((LONG)rastPort + 33) |= 1;
        *(unsigned char *)((LONG)rastPort + 30) = 15;

        _LVOMove();
        _LVODraw();

        topY--;
        rightX++;
    }

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
}
