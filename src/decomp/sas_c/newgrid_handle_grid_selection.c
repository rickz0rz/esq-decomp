typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry NEWGRID_Entry;

struct NEWGRID_Entry {
    UBYTE pad0[1];
};

extern LONG NEWGRID_GridSelectionWorkflowState;
extern LONG NEWGRID_GridSelectionEntryIndex;
extern LONG NEWGRID_GridSelectionColumnAdjust;
extern UBYTE CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode32EnabledFlag;
extern const NEWGRID_Entry *TEXTDISP_PrimaryEntryPtrTable[];

extern LONG NEWGRID_ShouldOpenEditor(const NEWGRID_Entry *entry);
extern LONG NEWGRID_UpdateGridState(char *ctx, LONG keyIndex, WORD rowIndex);
extern LONG NEWGRID_ProcessGridEntries(char *ctx, LONG keyIndex, UWORD rowIndex);
extern LONG NEWGRID_FindNextFlaggedEntry(LONG mode, LONG startIndex);
extern void NEWGRID_ValidateSelectionCode(char *ctx, LONG code);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(char *ctx);

LONG NEWGRID_HandleGridSelection(char *ctx, WORD rowIndex)
{
    LONG scannedThisStep;
    const NEWGRID_Entry *entry;
    LONG state;

    scannedThisStep = 0;

    if (ctx == 0) {
        if (NEWGRID_GridSelectionWorkflowState == 5) {
            entry = TEXTDISP_PrimaryEntryPtrTable[NEWGRID_GridSelectionEntryIndex];
            if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                NEWGRID_UpdateGridState(ctx, 0, 0);
            } else {
                NEWGRID_ProcessGridEntries(ctx, 0, 0);
            }
        }
        NEWGRID_GridSelectionWorkflowState = 0;
        NEWGRID_GridSelectionEntryIndex = 0;
        return NEWGRID_GridSelectionWorkflowState;
    }

    state = NEWGRID_GridSelectionWorkflowState;
    if (state == 0) {
        NEWGRID_GridSelectionColumnAdjust = 0;
        NEWGRID_GridSelectionWorkflowState = 3;
    }

    if (NEWGRID_GridSelectionWorkflowState == 3 || NEWGRID_GridSelectionWorkflowState == 4) {
        NEWGRID_GridSelectionEntryIndex = NEWGRID_FindNextFlaggedEntry(
            NEWGRID_GridSelectionWorkflowState,
            NEWGRID_GridSelectionEntryIndex
        );
        scannedThisStep = 1;
    } else if (NEWGRID_GridSelectionWorkflowState != 5) {
        NEWGRID_GridSelectionWorkflowState = 0;
        return NEWGRID_GridSelectionWorkflowState;
    }

    if (NEWGRID_GridSelectionEntryIndex == -1) {
        NEWGRID_GridSelectionWorkflowState = 0;
        return NEWGRID_GridSelectionWorkflowState;
    }

    entry = TEXTDISP_PrimaryEntryPtrTable[NEWGRID_GridSelectionEntryIndex];
    if (NEWGRID_ShouldOpenEditor(entry) != 0) {
        NEWGRID_GridSelectionWorkflowState = NEWGRID_UpdateGridState(
            ctx,
            NEWGRID_GridSelectionEntryIndex,
            rowIndex
        );
    } else {
        NEWGRID_GridSelectionWorkflowState = NEWGRID_ProcessGridEntries(
            ctx,
            NEWGRID_GridSelectionEntryIndex,
            rowIndex
        );

        if (scannedThisStep != 0 &&
            NEWGRID_GridSelectionColumnAdjust < 1 &&
            NEWGRID_GridSelectionWorkflowState == 5 &&
            CONFIG_NewgridSelectionCode48_49EnabledFlag == (UBYTE)89) {
            NEWGRID_ValidateSelectionCode(ctx, 48);
            NEWGRID_GridSelectionColumnAdjust = NEWGRID_GetGridModeIndex();
        }
    }

    if (CONFIG_NewgridSelectionCode32EnabledFlag == (UBYTE)89 &&
        scannedThisStep != 0 &&
        NEWGRID_GridSelectionColumnAdjust < 1) {
        NEWGRID_ValidateSelectionCode(ctx, 32);
        NEWGRID_GridSelectionColumnAdjust = NEWGRID_GetGridModeIndex();
    }

    if (NEWGRID_GridSelectionColumnAdjust > 0) {
        NEWGRID_GridSelectionColumnAdjust -= NEWGRID_ComputeColumnIndex(ctx);
    }

    return NEWGRID_GridSelectionWorkflowState;
}
