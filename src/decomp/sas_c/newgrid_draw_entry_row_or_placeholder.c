typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_EntryPlaceholderModeFlag;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern const char *SCRIPT_PtrNoDataPlaceholder;
extern const char *SCRIPT_PtrOffAirPlaceholder;

extern void NEWGRID_DrawGridEntry(char *gridCtx, char *entryPtr, char *auxPtr, UWORD row, UWORD col, LONG style, LONG mode);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(char *gridCtx, const char *text);

void NEWGRID_DrawEntryRowOrPlaceholder(char *gridCtx, char *entryPtr, LONG rowMeta, WORD row, WORD col, LONG state)
{
    if (state == 2) {
        if (NEWGRID_EntryPlaceholderModeFlag) {
            LONG enabled = 0;
            if (CONFIG_NewgridPlaceholderBevelFlag == (UBYTE)89) {
                enabled = -1;
            }
            NEWGRID_DrawGridEntry(gridCtx, entryPtr, (char *)rowMeta, row, col, enabled, 2);
            return;
        }

        NEWGRID_DrawGridEntry(gridCtx, entryPtr, (char *)rowMeta, row, 3, 1, 2);
        return;
    }

    if (!state) {
        DISPTEXT_LayoutAndAppendToBuffer(gridCtx, SCRIPT_PtrOffAirPlaceholder);
        return;
    }

    DISPTEXT_LayoutAndAppendToBuffer(gridCtx, SCRIPT_PtrNoDataPlaceholder);
}
