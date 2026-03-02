#include "esq_types.h"

extern void *AbsExecBase;
extern void *NEWGRID_MainRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern s32 NEWGRID_RefreshStateFlag;

void _LVODisable(void) __attribute__((noinline));
void _LVOEnable(void) __attribute__((noinline));
void GCOMMAND_ResetHighlightMessages(void) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVORectFill(void *rastport, s32 x_min, s32 y_min, s32 x_max, s32 y_max) __attribute__((noinline));

void NEWGRID_ClearHighlightArea(void) __attribute__((noinline, used));

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
