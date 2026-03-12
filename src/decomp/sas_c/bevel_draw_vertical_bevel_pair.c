typedef long LONG;

enum {
    RASTPORT_AOLPEN_OFFSET = 30,
    RASTPORT_FLAGS1_OFFSET = 33,
    RASTPORT_LINPAT_OFFSET = 34,
    BEVEL_LINE_PATTERN_SOLID = -1,
    BEVEL_STYLE_PEN = 15,
    BEVEL_DRAW_MODE_FLAG = 1
};

void _LVOSetDrMd(void);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    LONG rastPortAddr;

    _LVOSetDrMd();
    _LVOSetAPen();
    *(short *)((LONG)rastPort + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
    *(unsigned char *)((LONG)rastPort + RASTPORT_FLAGS1_OFFSET) |= BEVEL_DRAW_MODE_FLAG;
    *(unsigned char *)((LONG)rastPort + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

    _LVOMove();
    _LVODraw();

    leftX++;
    _LVOMove();
    _LVODraw();

    leftX++;
    _LVOMove();
    _LVODraw();

    leftX++;
    _LVOMove();
    _LVODraw();

    _LVOSetAPen();
    rastPortAddr = (LONG)rastPort;
    *(short *)(rastPortAddr + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
    *(unsigned char *)(rastPortAddr + RASTPORT_FLAGS1_OFFSET) =
        *(unsigned char *)(rastPortAddr + RASTPORT_FLAGS1_OFFSET) | BEVEL_DRAW_MODE_FLAG;
    *(unsigned char *)(rastPortAddr + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

    _LVOMove();
    _LVODraw();

    rightX--;
    _LVOMove();
    _LVODraw();

    rightX--;
    _LVOMove();
    _LVODraw();

    rightX--;
    _LVOMove();
    _LVODraw();
}
