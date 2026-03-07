typedef long LONG;

enum {
    BEVEL_STROKE_INDEX_START = 0,
    RASTPORT_AOLPEN_OFFSET = 30,
    RASTPORT_FLAGS1_OFFSET = 33,
    RASTPORT_LINPAT_OFFSET = 34,
    BEVEL_LINE_PATTERN_SOLID = -1,
    BEVEL_STYLE_PEN = 15,
    BEVEL_DRAW_MODE_FLAG = 1,
    BEVEL_STROKE_COUNT = 4
};

void _LVOSetDrMd(void);
void _LVOSetAPen(void);
void _LVOMove(void);
void _LVODraw(void);

void BEVEL_DrawHorizontalBevel(void *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    LONG i;

    _LVOSetDrMd();
    _LVOSetAPen();

    for (i = BEVEL_STROKE_INDEX_START; i < BEVEL_STROKE_COUNT; i++) {
        *(short *)((LONG)rastPort + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
        *(unsigned char *)((LONG)rastPort + RASTPORT_FLAGS1_OFFSET) |= BEVEL_DRAW_MODE_FLAG;
        *(unsigned char *)((LONG)rastPort + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

        _LVOMove();
        _LVODraw();

        topY--;
        rightX++;
    }

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
}
