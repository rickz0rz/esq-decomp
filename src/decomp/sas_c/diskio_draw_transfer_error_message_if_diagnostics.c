typedef signed long LONG;
typedef signed short WORD;

enum {
    DISKIO_DIAG_INACTIVE = 0,
    DISKIO_REASON_INDEX_OFFSET = 1,
    DISKIO_ERROR_TEXT_X = 40,
    DISKIO_ERROR_TEXT_Y = 240,
    DISKIO_ERROR_TEXT_PEN = 4,
    DISKIO_DEFAULT_TEXT_PEN = 1
};

extern WORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char *CTASKS_TerminationReasonPtrTable[];

extern void _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern void DISPLIB_DisplayTextAtPosition(void *rastPort, LONG x, LONG y, const char *text);

void DISKIO_DrawTransferErrorMessageIfDiagnostics(LONG reasonCode)
{
    if (ED_DiagnosticsScreenActive == DISKIO_DIAG_INACTIVE) {
        return;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DISKIO_ERROR_TEXT_PEN);
    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        DISKIO_ERROR_TEXT_X,
        DISKIO_ERROR_TEXT_Y,
        CTASKS_TerminationReasonPtrTable[reasonCode - DISKIO_REASON_INDEX_OFFSET]);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DISKIO_DEFAULT_TEXT_PEN);
}
