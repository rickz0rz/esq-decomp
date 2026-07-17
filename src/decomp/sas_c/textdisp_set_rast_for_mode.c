#include <exec/types.h>

extern WORD WDISP_AccumulatorFlushPending;
extern LONG WDISP_DisplayContextBase;
extern LONG Global_REF_RASTPORT_2;   /* address-only: layout anchor for the display rastport */
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE WDISP_PaletteTriplesGBase[];
extern UBYTE WDISP_PaletteTriplesBBase[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void ESQIFF_RunCopperDropTransition(void);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

/* asm: MOVEA.L WDISP_DisplayContextBase,A0
        ADDA.W #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
   The rastport lives at the symbol-layout delta (Global_REF_RASTPORT_2 is +8 from
   WDISP_DisplayContextBase in the data segment) plus 2 = +10 from the context base,
   NOT +2. A hardcoded +2 makes SetRast read a garbage BitMap pointer -> 8000 0003. */
#define TEXTDISP_RASTPORT \
    ((char *)(WDISP_DisplayContextBase + \
              ((LONG)&Global_REF_RASTPORT_2 - (LONG)&WDISP_DisplayContextBase + 2)))

void TEXTDISP_SetRastForMode(WORD modeIndex)
{
    WDISP_AccumulatorFlushPending = 0;
    ESQIFF_RunCopperDropTransition();

    if (modeIndex == 0) {
        WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);
        return;
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(7, 0, 4);

    WDISP_PaletteTriplesRBase[0] = WDISP_PaletteTriplesRBase[(LONG)modeIndex * 3];
    WDISP_PaletteTriplesGBase[0] = WDISP_PaletteTriplesGBase[(LONG)modeIndex * 3];
    WDISP_PaletteTriplesBBase[0] = WDISP_PaletteTriplesBBase[(LONG)modeIndex * 3];

    _LVOSetRast(
        Global_REF_GRAPHICS_LIBRARY,
        TEXTDISP_RASTPORT,
        (LONG)modeIndex);
}
