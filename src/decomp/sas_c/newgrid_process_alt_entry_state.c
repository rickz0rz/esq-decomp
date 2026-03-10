typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_AltEntryWorkflowState;
extern LONG NEWGRID_AltEntryCursor;
extern LONG NEWGRID_AltEntryAttemptCounter;
extern UBYTE CONFIG_NewgridSelectionCode35EnabledFlag;

extern LONG NEWGRID_HandleAltGridState(char *ctx, LONG keyIndex, WORD rowIndex);
extern LONG NEWGRID_FindNextEntryWithMarkers(LONG mode, LONG startIndex, WORD selector);
extern void NEWGRID_DrawEmptyGridMessage(char *ctx, unsigned short slot);
extern void NEWGRID_ValidateSelectionCode(char *ctx, LONG code);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(char *ctx);

LONG NEWGRID_ProcessAltEntryState(char *ctx, WORD rowIndex, WORD selector)
{
    LONG updatedFromScan;
    LONG state;

    updatedFromScan = 0;

    if (ctx == 0) {
        if (NEWGRID_AltEntryWorkflowState == 5) {
            NEWGRID_HandleAltGridState(ctx, 0, 0);
        }
        NEWGRID_AltEntryWorkflowState = 0;
        NEWGRID_AltEntryCursor = 0;
        return NEWGRID_AltEntryWorkflowState;
    }

    state = NEWGRID_AltEntryWorkflowState;
    if (state >= 6) {
        NEWGRID_AltEntryWorkflowState = 0;
        return NEWGRID_AltEntryWorkflowState;
    }

    switch (state) {
        case 0:
            NEWGRID_AltEntryAttemptCounter = 0;
            NEWGRID_AltEntryCursor = NEWGRID_FindNextEntryWithMarkers(
                NEWGRID_AltEntryWorkflowState,
                NEWGRID_AltEntryCursor,
                rowIndex
            );
            if (NEWGRID_AltEntryCursor == -1) {
                return NEWGRID_AltEntryWorkflowState;
            }
            NEWGRID_AltEntryWorkflowState = 1;
            /* fallthrough */
        case 1:
            NEWGRID_DrawEmptyGridMessage(ctx, (unsigned short)rowIndex);
            NEWGRID_AltEntryWorkflowState = 3;
            return NEWGRID_AltEntryWorkflowState;
        case 2:
            NEWGRID_AltEntryWorkflowState = 0;
            return NEWGRID_AltEntryWorkflowState;
        case 3:
        case 4:
            NEWGRID_AltEntryCursor = NEWGRID_FindNextEntryWithMarkers(
                NEWGRID_AltEntryWorkflowState,
                NEWGRID_AltEntryCursor,
                rowIndex
            );
            updatedFromScan = 1;
            /* fallthrough */
        case 5:
            if (NEWGRID_AltEntryCursor == -1) {
                NEWGRID_AltEntryWorkflowState = 0;
                return NEWGRID_AltEntryWorkflowState;
            }

            NEWGRID_AltEntryWorkflowState = NEWGRID_HandleAltGridState(
                ctx,
                NEWGRID_AltEntryCursor,
                rowIndex
            );

            if (CONFIG_NewgridSelectionCode35EnabledFlag != (UBYTE)89) {
                return NEWGRID_AltEntryWorkflowState;
            }

            if (updatedFromScan != 0 && NEWGRID_AltEntryAttemptCounter < 1) {
                NEWGRID_ValidateSelectionCode(ctx, 51);
                NEWGRID_AltEntryAttemptCounter = NEWGRID_GetGridModeIndex();
            }

            NEWGRID_AltEntryAttemptCounter -= NEWGRID_ComputeColumnIndex(ctx);
            return NEWGRID_AltEntryWorkflowState;
        default:
            NEWGRID_AltEntryWorkflowState = 0;
            return NEWGRID_AltEntryWorkflowState;
    }
}
