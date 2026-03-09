typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG LOCAVAIL_FilterClassId;
extern LONG LOCAVAIL_FilterStep;

void LOCAVAIL_ResetFilterCursorState(void *statePtr)
{
    UBYTE *state;

    state = (UBYTE *)statePtr;
    *(LONG *)(state + 8) = -1;
    *(LONG *)(state + 12) = -1;
    LOCAVAIL_FilterClassId = -1;
    LOCAVAIL_FilterStep = 0;
}
