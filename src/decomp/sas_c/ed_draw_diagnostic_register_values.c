typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern LONG ED_TempCopyOffset;
extern char ED_EditBufferScratch[];
extern UBYTE GCOMMAND_PresetFallbackValue0[];
extern UBYTE GCOMMAND_PresetFallbackValue1[];
extern UBYTE GCOMMAND_PresetFallbackValue2[];

extern const char Global_STR_REGISTER[];
extern const char Global_STR_R_EQUALS[];
extern const char Global_STR_G_EQUALS[];
extern const char Global_STR_B_EQUALS[];

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern LONG GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(char *dst, LONG value, LONG width);

static LONG ED_DiagPaletteIndex3(void)
{
    LONG idx = ED_TempCopyOffset;
    return (idx << 2) - idx;
}

void ED_DrawDiagnosticRegisterValues(void)
{
    const LONG DRAWMODE_COMPLEMENT = 1;
    const LONG PEN_TEXT = 1;
    const LONG DEC_WIDTH_2 = 2;
    const LONG ROW_REG = 240;
    const LONG ROW_RGB = 270;
    const LONG COL_LEFT = 40;
    const LONG COL_REG_VALUE = 190;
    const LONG COL_R_LABEL = 40;
    const LONG COL_R_VALUE = 85;
    const LONG COL_G_LABEL = 135;
    const LONG COL_G_VALUE = 180;
    const LONG COL_B_LABEL = 230;
    const LONG COL_B_VALUE = 275;
    LONG idx3;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_REG, COL_LEFT, Global_STR_REGISTER);

    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, ED_TempCopyOffset, DEC_WIDTH_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_REG, COL_REG_VALUE, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_R_LABEL, Global_STR_R_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue0[idx3], DEC_WIDTH_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_R_VALUE, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_G_LABEL, Global_STR_G_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue1[idx3], DEC_WIDTH_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_G_VALUE, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_B_LABEL, Global_STR_B_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue2[idx3], DEC_WIDTH_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW_RGB, COL_B_VALUE, ED_EditBufferScratch);
}
