typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD WDISP_AccumulatorFlushPending;
extern LONG WDISP_DisplayContextBase;
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE WDISP_PaletteTriplesGBase[];
extern UBYTE WDISP_PaletteTriplesBBase[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern LONG _LVOSetRast(void *gfxBase, void *rastPort, LONG pen);

typedef struct TEXTDISP_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} TEXTDISP_DisplayContext;

void TEXTDISP_SetRastForMode(WORD modeIndex)
{
    TEXTDISP_DisplayContext *context;

    WDISP_AccumulatorFlushPending = 0;
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();

    if (modeIndex == 0) {
        WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);
        return;
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(7, 0, 4);

    WDISP_PaletteTriplesRBase[0] = WDISP_PaletteTriplesRBase[(LONG)modeIndex * 3];
    WDISP_PaletteTriplesGBase[0] = WDISP_PaletteTriplesGBase[(LONG)modeIndex * 3];
    WDISP_PaletteTriplesBBase[0] = WDISP_PaletteTriplesBBase[(LONG)modeIndex * 3];
    context = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;

    _LVOSetRast(
        Global_REF_GRAPHICS_LIBRARY,
        (void *)context->rastPort,
        (LONG)modeIndex);
}
