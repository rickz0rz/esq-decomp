typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry NEWGRID_Entry;

struct NEWGRID_Entry {
    UBYTE pad0[1];
};

extern LONG NEWGRID_SecondaryWorkflowState;
extern LONG NEWGRID_SecondarySelectedEntryIndex;
extern LONG NEWGRID_SecondarySelectionHintCounter;
extern NEWGRID_Entry *TEXTDISP_PrimaryEntryPtrTable[];

extern UBYTE GCOMMAND_DigitalNicheEnabledFlag;
extern LONG GCOMMAND_NicheEditorLayoutPen;
extern LONG GCOMMAND_NicheEditorRowPen;
extern UBYTE GCOMMAND_NicheWorkflowMode;
extern UBYTE *GCOMMAND_DigitalNicheListingsTemplatePtr;
extern UBYTE CONFIG_NewgridSelectionCode48_49EnabledFlag;

extern LONG NEWGRID_HandleGridEditorState(UBYTE *ctx, LONG layoutPen, LONG rowPen, UBYTE *sourceText);
extern LONG NEWGRID_UpdateGridState(UBYTE *ctx, LONG keyIndex, WORD rowIndex);
extern LONG NEWGRID_ProcessGridEntries(UBYTE *ctx, LONG keyIndex, WORD rowIndex);
extern LONG NEWGRID_FindNextEntryWithFlags(LONG mode, LONG startIndex);
extern LONG NEWGRID_ShouldOpenEditor(NEWGRID_Entry *entry);
extern void NEWGRID_ValidateSelectionCode(UBYTE *ctx, LONG code);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(UBYTE *ctx);

LONG NEWGRID_ProcessSecondaryState(UBYTE *ctx, WORD rowIndex)
{
    LONG scannedThisStep;
    LONG state;
    NEWGRID_Entry *entry;

    scannedThisStep = 0;

    if (ctx == 0) {
        state = NEWGRID_SecondaryWorkflowState;
        if (state == 2 || state == 7) {
            NEWGRID_HandleGridEditorState(ctx, 0, 0, 0);
        } else if (state == 5) {
            entry = TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SecondarySelectedEntryIndex];
            if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                NEWGRID_UpdateGridState(ctx, 0, 0);
            } else {
                NEWGRID_ProcessGridEntries(ctx, 0, 0);
            }
        }
        NEWGRID_SecondaryWorkflowState = 0;
        NEWGRID_SecondarySelectedEntryIndex = 0;
        return NEWGRID_SecondaryWorkflowState;
    }

    state = NEWGRID_SecondaryWorkflowState;
    if (state >= 8) {
        return NEWGRID_SecondaryWorkflowState;
    }

    switch (state) {
        case 0:
            NEWGRID_SecondarySelectionHintCounter = 0;
            NEWGRID_SecondarySelectedEntryIndex = NEWGRID_FindNextEntryWithFlags(
                NEWGRID_SecondaryWorkflowState,
                NEWGRID_SecondarySelectedEntryIndex
            );
            if (NEWGRID_SecondarySelectedEntryIndex == -1) {
                return NEWGRID_SecondaryWorkflowState;
            }
            NEWGRID_SecondaryWorkflowState = 2;
            /* fallthrough */
        case 2:
            if (GCOMMAND_NicheWorkflowMode == (UBYTE)'B' ||
                GCOMMAND_NicheWorkflowMode == (UBYTE)'F') {
                NEWGRID_SecondaryWorkflowState = NEWGRID_HandleGridEditorState(
                    ctx,
                    GCOMMAND_NicheEditorLayoutPen,
                    GCOMMAND_NicheEditorRowPen,
                    GCOMMAND_DigitalNicheListingsTemplatePtr
                );
                if (NEWGRID_SecondaryWorkflowState == 5) {
                    NEWGRID_SecondaryWorkflowState = 2;
                    return NEWGRID_SecondaryWorkflowState;
                }
                NEWGRID_SecondaryWorkflowState = 3;
                return NEWGRID_SecondaryWorkflowState;
            }
            NEWGRID_SecondaryWorkflowState = 3;
            /* fallthrough */
        case 3:
        case 4:
            NEWGRID_SecondarySelectedEntryIndex = NEWGRID_FindNextEntryWithFlags(
                NEWGRID_SecondaryWorkflowState,
                NEWGRID_SecondarySelectedEntryIndex
            );
            scannedThisStep = 1;
            /* fallthrough */
        case 5:
            if (NEWGRID_SecondarySelectedEntryIndex == -1) {
                NEWGRID_SecondaryWorkflowState = 7;
            } else {
                entry = TEXTDISP_PrimaryEntryPtrTable[NEWGRID_SecondarySelectedEntryIndex];
                if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                    NEWGRID_SecondaryWorkflowState = NEWGRID_UpdateGridState(
                        ctx,
                        NEWGRID_SecondarySelectedEntryIndex,
                        rowIndex
                    );
                } else {
                    NEWGRID_SecondaryWorkflowState = NEWGRID_ProcessGridEntries(
                        ctx,
                        NEWGRID_SecondarySelectedEntryIndex,
                        rowIndex
                    );
                    if (scannedThisStep != 0 &&
                        NEWGRID_SecondarySelectionHintCounter < 1 &&
                        NEWGRID_SecondaryWorkflowState == 5 &&
                        CONFIG_NewgridSelectionCode48_49EnabledFlag == (UBYTE)89) {
                        NEWGRID_ValidateSelectionCode(ctx, 49);
                        NEWGRID_SecondarySelectionHintCounter = NEWGRID_GetGridModeIndex();
                    }
                }

                if (GCOMMAND_DigitalNicheEnabledFlag == (UBYTE)89 &&
                    scannedThisStep != 0 &&
                    NEWGRID_SecondarySelectionHintCounter < 1) {
                    NEWGRID_ValidateSelectionCode(ctx, 33);
                    NEWGRID_SecondarySelectionHintCounter = NEWGRID_GetGridModeIndex();
                }

                if (NEWGRID_SecondarySelectionHintCounter > 0) {
                    NEWGRID_SecondarySelectionHintCounter -= NEWGRID_ComputeColumnIndex(ctx);
                }
                return NEWGRID_SecondaryWorkflowState;
            }
            /* fallthrough */
        case 7:
            if (GCOMMAND_NicheWorkflowMode == (UBYTE)'B' ||
                GCOMMAND_NicheWorkflowMode == (UBYTE)'L') {
                NEWGRID_SecondaryWorkflowState = NEWGRID_HandleGridEditorState(
                    ctx,
                    GCOMMAND_NicheEditorLayoutPen,
                    GCOMMAND_NicheEditorRowPen,
                    GCOMMAND_DigitalNicheListingsTemplatePtr
                );
                if (NEWGRID_SecondaryWorkflowState == 5) {
                    NEWGRID_SecondaryWorkflowState = 7;
                    return NEWGRID_SecondaryWorkflowState;
                }
                NEWGRID_SecondaryWorkflowState = 0;
                return NEWGRID_SecondaryWorkflowState;
            }
            NEWGRID_SecondaryWorkflowState = 0;
            return NEWGRID_SecondaryWorkflowState;
        default:
            return NEWGRID_SecondaryWorkflowState;
    }
}
