typedef signed long LONG;
typedef signed short WORD;

extern LONG NEWGRID2_PendingOperationId;
extern LONG NEWGRID2_LastDispatchResult;
extern LONG NEWGRID_GridOperationId;
extern WORD ESQDISP_PendingGridReinitFlag;

extern LONG NEWGRID_HandleGridSelection(void *gridCtx, LONG rowIndex);
extern LONG NEWGRID_ProcessAltEntryState(void *gridCtx, LONG rowIndex, LONG selector);
extern LONG NEWGRID2_HandleGridState(void *gridCtx, WORD rowIndex, LONG modeSel);
extern LONG NEWGRID_ProcessSecondaryState(void *gridCtx, LONG rowIndex);
extern LONG NEWGRID_ProcessScheduleState(void *gridCtx, LONG rowIndex, LONG selector);
extern LONG NEWGRID_ProcessShowtimesWorkflow(void *gridCtx, LONG rowIndex, LONG selector);

LONG NEWGRID2_DispatchGridOperation(LONG operationId, void *gridCtx, WORD rowIndex, WORD selector)
{
    LONG op = operationId;

    if (op == 0) {
        gridCtx = 0;
        op = NEWGRID2_PendingOperationId;
        NEWGRID2_PendingOperationId = 0;
    } else {
        NEWGRID2_PendingOperationId = op;
    }

    if (ESQDISP_PendingGridReinitFlag != 0) {
        ESQDISP_PendingGridReinitFlag = 0;
        gridCtx = 0;
    }

    NEWGRID_GridOperationId = op;
    if (op < 1 || op >= 8) {
        NEWGRID_GridOperationId = 0;
    } else {
        switch (op) {
            case 1:
                NEWGRID2_LastDispatchResult = NEWGRID_HandleGridSelection(gridCtx, (LONG)rowIndex);
                break;
            case 2:
                NEWGRID2_LastDispatchResult = NEWGRID_ProcessAltEntryState(gridCtx, (LONG)rowIndex, (LONG)selector);
                break;
            case 3:
                NEWGRID2_LastDispatchResult = NEWGRID2_HandleGridState(gridCtx, rowIndex, 0);
                break;
            case 4:
                NEWGRID2_LastDispatchResult = NEWGRID2_HandleGridState(gridCtx, rowIndex, 1);
                break;
            case 5:
                NEWGRID2_LastDispatchResult = NEWGRID_ProcessSecondaryState(gridCtx, (LONG)rowIndex);
                break;
            case 6:
                NEWGRID2_LastDispatchResult = NEWGRID_ProcessScheduleState(gridCtx, (LONG)rowIndex, (LONG)selector);
                break;
            case 7:
                NEWGRID2_LastDispatchResult = NEWGRID_ProcessShowtimesWorkflow(gridCtx, (LONG)rowIndex, (LONG)selector);
                break;
        }
    }

    return (NEWGRID2_LastDispatchResult != 0) ? -1 : 0;
}
