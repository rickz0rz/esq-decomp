typedef signed long LONG;
typedef signed short WORD;

extern WORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char *CTASKS_TerminationReasonPtrTable[];

extern void _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern void DISPLIB_DisplayTextAtPosition(void *rastPort, LONG x, LONG y, const char *text);

void DISKIO_DrawTransferErrorMessageIfDiagnostics(LONG reasonCode)
{
    if (ED_DiagnosticsScreenActive == 0) {
        return;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 4);
    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        40,
        240,
        CTASKS_TerminationReasonPtrTable[reasonCode - 1]);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
