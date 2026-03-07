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
    const LONG PANEL_MODE_EDIT_AD = 6;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_COMPLEMENT = 1;
    const LONG PEN_TEXT = 1;
    const LONG PEN_HILITE = 6;
    const LONG X_LEFT = 40;
    const LONG X_RIGHT = 640;
    const LONG Y_TOP = 68;
    const LONG Y_BOTTOM = 98;
    const LONG Y_MSG = 330;
    const LONG X_ADMAX = 340;
    const LONG X_HELP = 370;
    const LONG Y_MSG2 = 360;
    const LONG Y_MSG3 = 390;
    const LONG Y_PROMPT = 90;
    const LONG DEC_WIDTH_2 = 2;
    const LONG CURSOR_START = 12;
    const LONG PROMPT_BUF_LEN = 14;
    const UBYTE SPACE_CHAR = 0x20;
    const LONG NIBBLE_HI = 2;
    const LONG NIBBLE_LO = 1;
    LONG i;

    ED_DrawHelpPanels(PANEL_MODE_EDIT_AD);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG, X_LEFT, Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN);

    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth((char *)ED_EditBufferScratch, ED_MaxAdNumber, DEC_WIDTH_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG, X_ADMAX, (char *)ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG, X_HELP, Global_STR_LEFT_PARENTHESIS_THEN);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG2, X_LEFT, Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG3, X_LEFT, Global_STR_SINGLE_SPACE_4);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_HILITE);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, X_LEFT, Y_TOP, X_RIGHT, Y_BOTTOM);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_PROMPT, X_LEFT, Global_STR_AD_NUMBER_QUESTIONMARK);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);

    ED_EditCursorOffset = CURSOR_START;

    for (i = 0; i < PROMPT_BUF_LEN; ++i) {
        ED_EditBufferScratch[i] = SPACE_CHAR;
        ED_EditBufferLive[i] = (UBYTE)GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(NIBBLE_HI, NIBBLE_LO);
    }

    ED_AdNumberPromptStateBlock = 0;
    ED_RedrawCursorChar();
}
