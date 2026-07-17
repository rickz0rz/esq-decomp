#include <graphics/rastport.h>

extern UBYTE ESQDISP_StatusIndicatorDeferredApplyFlag;
extern LONG ESQDISP_StatusIndicatorColorCache[];
extern struct RastPort *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern struct BitMap Global_REF_696_400_BITMAP;  /* a STRUCT, not a pointer (wdisp.s) */

extern LONG _LVOReadPixel(void);
extern void _LVOSetAPen(void);
extern void _LVORectFill(void);

void ESQDISP_SetStatusIndicatorColorSlot(LONG color, LONG slot)
{
    LONG y;
    struct RastPort *rp;
    UBYTE savedPen;
    void *savedBitMap;

    if (slot != 0 && slot != 1) {
        return;
    }

    if (ESQDISP_StatusIndicatorDeferredApplyFlag != 0) {
        if (color == -1) {
            return;
        }
        ESQDISP_StatusIndicatorColorCache[slot] = color;
        return;
    }

    if (color == -1) {
        color = ESQDISP_StatusIndicatorColorCache[slot];
        ESQDISP_StatusIndicatorColorCache[slot] = -1;
    }

    if (ESQDISP_StatusIndicatorColorCache[slot] == color) {
        return;
    }

    ESQDISP_StatusIndicatorColorCache[slot] = color;

    y = (slot == 1) ? 40 : 57;

    rp = Global_REF_RASTPORT_1;
    savedPen = rp->FgPen;
    savedBitMap = rp->BitMap;
    rp->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;

    if (color == 7 || color == 6) {
        color = _LVOReadPixel(Global_REF_GRAPHICS_LIBRARY, rp, 655, 55);
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, color);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0x28F, y, 0x295, y + 4);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, (LONG)savedPen);

    rp->BitMap = savedBitMap;
}
