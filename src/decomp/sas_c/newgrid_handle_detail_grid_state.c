typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    char shortText[18];
    char channelText[1];
} NEWGRID_Entry;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern LONG NEWGRID_DetailGridStateLatch;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern UBYTE GCOMMAND_MplexDetailLayoutFlag;
extern LONG GCOMMAND_MplexDetailInitialLineIndex;
extern const char NEWGRID_ChannelRowFmt[];

extern LONG NEWGRID_UpdatePresetEntry(char **entryOut, char **auxOut, WORD rowIndex, LONG keyIndex);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(char *rastPort, char *entry, char *aux, LONG row, LONG mode, LONG enabled, LONG bevel);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG lineIndex);
extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, const char *arg0, const char *arg1);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *text);
extern LONG NEWGRID_DrawGridFrameVariant2(char *ctx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);

LONG NEWGRID_HandleDetailGridState(char *ctx, LONG keyIndex, WORD rowIndex)
{
    NEWGRID_Entry *entry;
    char *aux;
    NEWGRID_Context *ctxView;
    LONG nextState;
    char channelRow[58];

    entry = 0;
    aux = 0;

    if (ctx == 0) {
        NEWGRID_DetailGridStateLatch = 4;
        return NEWGRID_DetailGridStateLatch;
    }

    ctxView = (NEWGRID_Context *)ctx;
    if (NEWGRID_DetailGridStateLatch == 4) {
        rowIndex = (WORD)NEWGRID_UpdatePresetEntry((char **)&entry, &aux, rowIndex, keyIndex);
        if (entry == 0 || aux == 0) {
            return NEWGRID_DetailGridStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_MplexDetailLayoutPen);

        if (GCOMMAND_MplexDetailLayoutFlag == (UBYTE)'N') {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (char *)entry, aux, (LONG)rowIndex, 2, 1, 4);
        } else {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (char *)entry, aux, (LONG)rowIndex, 3, 1, 4);
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(GCOMMAND_MplexDetailInitialLineIndex);
        PARSEINI_JMPTBL_WDISP_SPrintf(channelRow, NEWGRID_ChannelRowFmt, entry->channelText, entry->shortText);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(ctxView->rastPort, channelRow);

        if (NEWGRID_DrawGridFrameVariant2(ctx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }

        NEWGRID_DetailGridStateLatch = nextState;
        ctxView->selectedState = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        return NEWGRID_DetailGridStateLatch;
    }

    if (NEWGRID_DetailGridStateLatch == 5) {
        if (NEWGRID_DrawGridFrameVariant2(ctx) != 0) {
            nextState = 4;
        } else {
            nextState = 5;
        }
        ctxView->selectedState = -1;
        NEWGRID_DetailGridStateLatch = nextState;
        return NEWGRID_DetailGridStateLatch;
    }

    NEWGRID_DetailGridStateLatch = 4;
    return NEWGRID_DetailGridStateLatch;
}
