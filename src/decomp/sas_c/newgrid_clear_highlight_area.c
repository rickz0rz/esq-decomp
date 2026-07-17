#include <graphics/rastport.h>

extern void *AbsExecBase;
extern struct RastPort *NEWGRID_MainRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG NEWGRID_RefreshStateFlag;

extern void GCOMMAND_ResetHighlightMessages(void);

/* base-first _LVO ABI. Disable/Enable take exec base; SetAPen/RectFill take gfx
   base. (Disable A6=exec; SetAPen A1=rp,D0=pen; RectFill A1=rp,D0..D3=xMin,yMin,
   xMax,yMax.) */
extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_ClearHighlightArea(void)
{
    _LVODisable(AbsExecBase);
    GCOMMAND_ResetHighlightMessages();
    _LVOEnable(AbsExecBase);

    if (NEWGRID_RefreshStateFlag != 0) {
        return;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, (char *)NEWGRID_MainRastPortPtr, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, (char *)NEWGRID_MainRastPortPtr, 0, 68, 695, 267);
}
