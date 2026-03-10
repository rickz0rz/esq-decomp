typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern LONG Global_REF_BOOL_IS_LINE_OR_PAGE;
extern LONG Global_REF_BOOL_IS_TEXT_OR_CURSOR;

extern LONG ED_BlockOffset;
extern LONG ED_TextLimit;
extern LONG ED_AdDisplayResetFlag;
extern LONG ED_EditCursorOffset;
extern LONG ED_ViewportOffset;
extern UBYTE ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];

extern const char Global_STR_EDITING_AD_NUMBER_FORMATTED_2[];

extern LONG GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(LONG adIndex, UBYTE *scratch, UBYTE *live);
extern LONG GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(LONG hi, LONG lo);
extern void ED_RedrawAllRows(void);
extern void ED_DrawCurrentColorIndicator(UBYTE colorValue);
extern void ED_RedrawCursorChar(void);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(LONG isLineMode);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(LONG isTextMode);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_LoadCurrentAdIntoBuffers(void)
{
    char editingAdLabel[44];
    LONG adIndex;
    LONG textLen;
    LONG i;
    UBYTE packedAttr;
    LONG topY;

    adIndex = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER - 1;
    GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(adIndex, ED_EditBufferScratch, ED_EditBufferLive);

    textLen = 0;
    while (ED_EditBufferScratch[textLen] != 0) {
        ++textLen;
    }

    if (textLen < ED_BlockOffset) {
        packedAttr = (UBYTE)GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(2, 1);
        for (i = textLen; i < ED_BlockOffset; ++i) {
            ED_EditBufferScratch[i] = 0x20;
            ED_EditBufferLive[i] = packedAttr;
        }
    }

    ED_EditBufferScratch[ED_BlockOffset] = 0;

    ED_AdDisplayResetFlag = 1;
    ED_RedrawAllRows();

    ED_EditCursorOffset = 0;
    ED_ViewportOffset = 0;

    Global_REF_BOOL_IS_LINE_OR_PAGE = 0;
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(0);

    Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(1);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);

    topY = 302 - ESQIFF_JMPTBL_MATH_Mulu32(8 - ED_TextLimit, 30);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, topY, 640, 308);

    ED_DrawCurrentColorIndicator(ED_EditBufferLive[0]);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        editingAdLabel,
        Global_STR_EDITING_AD_NUMBER_FORMATTED_2,
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 300, 190, editingAdLabel);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);

    ED_RedrawCursorChar();
}
