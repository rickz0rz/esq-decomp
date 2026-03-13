typedef signed char BYTE;

extern BYTE LOCAVAIL_PrimaryFilterState;

extern void LOCAVAIL_ResetFilterCursorState(void *statePtr);

void ED1_EnterEscMenu_AfterVersionText(void)
{
    LOCAVAIL_ResetFilterCursorState(&LOCAVAIL_PrimaryFilterState);
}
