typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    UBYTE shortText[18];
    UBYTE channelText[1];
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
extern UBYTE NEWGRID_ChannelRowFmt[];

extern LONG NEWGRID_UpdatePresetEntry(UBYTE **entryOut, UBYTE **auxOut, WORD rowIndex, LONG keyIndex);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(void *rastPort, UBYTE *entry, UBYTE *aux, LONG row, LONG mode, LONG enabled, LONG bevel);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG lineIndex);
extern void PARSEINI_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, const UBYTE *arg0, const UBYTE *arg1);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *rastPort, const UBYTE *text);
extern LONG NEWGRID_DrawGridFrameVariant2(UBYTE *ctx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);

LONG NEWGRID_HandleDetailGridState(UBYTE *ctx, LONG keyIndex, WORD rowIndex)
{
    NEWGRID_Entry *entry;
    UBYTE *aux;
    NEWGRID_Context *ctxView;
    LONG nextState;
    UBYTE channelRow[58];

    entry = 0;
    aux = 0;

    if (ctx == 0) {
        NEWGRID_DetailGridStateLatch = 4;
        return NEWGRID_DetailGridStateLatch;
    }

    ctxView = (NEWGRID_Context *)ctx;
    if (NEWGRID_DetailGridStateLatch == 4) {
        rowIndex = (WORD)NEWGRID_UpdatePresetEntry((UBYTE **)&entry, &aux, rowIndex, keyIndex);
        if (entry == 0 || aux == 0) {
            return NEWGRID_DetailGridStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, GCOMMAND_MplexDetailLayoutPen);

        if (GCOMMAND_MplexDetailLayoutFlag == (UBYTE)'N') {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (UBYTE *)entry, aux, (LONG)rowIndex, 2, 1, 4);
        } else {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (UBYTE *)entry, aux, (LONG)rowIndex, 3, 1, 4);
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
