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
    LONG idx3;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 240, 40, Global_STR_REGISTER);

    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, ED_TempCopyOffset, 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 240, 190, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 40, Global_STR_R_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue0[idx3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 85, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 135, Global_STR_G_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue1[idx3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 180, ED_EditBufferScratch);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 230, Global_STR_B_EQUALS);
    idx3 = ED_DiagPaletteIndex3();
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, (LONG)GCOMMAND_PresetFallbackValue2[idx3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 275, ED_EditBufferScratch);
}
