typedef signed long LONG;
typedef signed short WORD;

extern LONG WDISP_DisplayContextBase;
extern WORD WDISP_AccumulatorFlushPending;

extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern void ESQIFF_RestoreBasePaletteTriples(void);

void TEXTDISP_InitRastAndResetFlag(void)
{
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode((LONG)4, (LONG)0, (LONG)3);
    ESQIFF_RestoreBasePaletteTriples();
    WDISP_AccumulatorFlushPending = (WORD)0;
}
