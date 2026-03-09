typedef unsigned long ULONG;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char Global_STR_38_SPACES[];

extern void _LVOSetAPen(void *gfxBase, char *rastPort, ULONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, ULONG mode);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, ULONG x, ULONG y, const char *text);

void DISKIO2_DisplayStatusLine(const char *text)
{
    char *rastPort = Global_REF_RASTPORT_1;
    void *gfxBase = Global_REF_GRAPHICS_LIBRARY;

    _LVOSetAPen(gfxBase, rastPort, 1);
    _LVOSetDrMd(gfxBase, rastPort, 1);

    DISPLIB_DisplayTextAtPosition(rastPort, 40, 120, Global_STR_38_SPACES);
    DISPLIB_DisplayTextAtPosition(rastPort, 40, 120, text);
}
