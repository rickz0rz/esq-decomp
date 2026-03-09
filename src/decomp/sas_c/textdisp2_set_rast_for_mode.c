typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD WDISP_AccumulatorFlushPending;
extern LONG WDISP_DisplayContextBase;
extern UBYTE WDISP_PaletteTriplesRBase;
extern UBYTE WDISP_PaletteTriplesGBase;
extern UBYTE WDISP_PaletteTriplesBBase;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a, LONG b);
extern LONG _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

typedef struct TEXTDISP_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} TEXTDISP_DisplayContext;

void TEXTDISP_SetRastForMode(UWORD modeIndex)
{
    TEXTDISP_DisplayContext *context;
    LONG idx;

    WDISP_AccumulatorFlushPending = 0;
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();

    if (modeIndex == 0) {
        WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);
        return;
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(7, 0, 4);

    idx = (LONG)(UWORD)modeIndex;
    idx = idx + idx + (LONG)(UWORD)modeIndex;
    WDISP_PaletteTriplesRBase = *(((UBYTE *)&WDISP_PaletteTriplesRBase) + idx);
    WDISP_PaletteTriplesGBase = *(((UBYTE *)&WDISP_PaletteTriplesGBase) + idx);
    WDISP_PaletteTriplesBBase = *(((UBYTE *)&WDISP_PaletteTriplesBBase) + idx);
    context = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;

    _LVOSetRast(
        Global_REF_GRAPHICS_LIBRARY,
        (char *)context->rastPort,
        (LONG)(UWORD)modeIndex
    );
}
