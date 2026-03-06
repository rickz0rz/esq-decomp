typedef signed char BYTE;

extern BYTE LOCAVAIL_PrimaryFilterState;

extern void ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(void *statePtr);

void ED1_EnterEscMenu_AfterVersionText(void)
{
    ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(&LOCAVAIL_PrimaryFilterState);
}
