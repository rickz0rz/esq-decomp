typedef signed long LONG;

typedef struct NEWGRID_RastPort {
    char unused;
} NEWGRID_RastPort;

extern void *AbsExecBase;
extern NEWGRID_RastPort *NEWGRID_MainRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG NEWGRID_RefreshStateFlag;

extern void _LVODisable(void);
extern void _LVOEnable(void);
extern void GCOMMAND_ResetHighlightMessages(void);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_ClearHighlightArea(void)
{
    (void)AbsExecBase;
    (void)Global_REF_GRAPHICS_LIBRARY;

    _LVODisable();
    GCOMMAND_ResetHighlightMessages();
    _LVOEnable();

    if (NEWGRID_RefreshStateFlag != 0) {
        return;
    }

    _LVOSetAPen(NEWGRID_MainRastPortPtr, 7);
    _LVORectFill(NEWGRID_MainRastPortPtr, 0, 68, 695, 267);
}
