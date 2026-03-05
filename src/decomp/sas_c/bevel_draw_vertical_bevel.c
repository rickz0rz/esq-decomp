typedef long LONG;

extern LONG Global_REF_GRAPHICS_LIBRARY;

void _LVOSetDrMd(void);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawVerticalBevel(void *rastPort, LONG x, LONG y, LONG height)
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

        y++;
        height--;
    }
}
