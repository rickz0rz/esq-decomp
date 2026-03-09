typedef signed long LONG;

typedef struct LOCAVAIL_FilterState {
    char groupCode;
} LOCAVAIL_FilterState;

extern LONG LOCAVAIL_FilterModeFlag;
extern LOCAVAIL_FilterState LOCAVAIL_PrimaryFilterState;

extern void LOCAVAIL_ResetFilterCursorState(void *statePtr);

void LOCAVAIL_SetFilterModeAndResetState(LONG mode)
{
    if (LOCAVAIL_FilterModeFlag == mode) {
        return;
    }

    if (mode == 1 || mode == 0) {
        LOCAVAIL_FilterModeFlag = mode;
        LOCAVAIL_ResetFilterCursorState(&LOCAVAIL_PrimaryFilterState);
    }
}
