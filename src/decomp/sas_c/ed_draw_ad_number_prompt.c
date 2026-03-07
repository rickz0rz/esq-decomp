typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern LONG ED_MaxAdNumber;
extern LONG ED_EditCursorOffset;
extern UBYTE ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];
extern UBYTE ED_AdNumberPromptStateBlock;

extern const char Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN[];
extern const char Global_STR_LEFT_PARENTHESIS_THEN[];
extern const char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2[];
extern const char Global_STR_SINGLE_SPACE_4[];
extern const char Global_STR_AD_NUMBER_QUESTIONMARK[];

extern void ED_DrawHelpPanels(LONG panelMode);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern LONG GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(char *dst, LONG value, LONG width);
extern LONG GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(LONG hi, LONG lo);
extern void ED_RedrawCursorChar(void);

void ED_DrawAdNumberPrompt(void)
{
    LONG i;

    ED_DrawHelpPanels(6);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN);

    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth((char *)ED_EditBufferScratch, ED_MaxAdNumber, 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 340, (char *)ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 370, Global_STR_LEFT_PARENTHESIS_THEN);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 360, 40, Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 390, 40, Global_STR_SINGLE_SPACE_4);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 68, 640, 98);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_AD_NUMBER_QUESTIONMARK);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    ED_EditCursorOffset = 12;

    for (i = 0; i < 14; ++i) {
        ED_EditBufferScratch[i] = 0x20;
        ED_EditBufferLive[i] = (UBYTE)GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(2, 1);
    }

    ED_AdNumberPromptStateBlock = 0;
    ED_RedrawCursorChar();
}
