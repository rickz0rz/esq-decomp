typedef signed long LONG;

extern LONG LOCAVAIL_FilterClassId;
extern LONG LOCAVAIL_FilterStep;

typedef struct LOCAVAIL_FilterState {
    char pad0[8];
    LONG selectedNodeIndex;
    LONG selectedPayloadIndex;
} LOCAVAIL_FilterState;

void LOCAVAIL_ResetFilterCursorState(void *statePtr)
{
    LOCAVAIL_FilterState *state;

    state = (LOCAVAIL_FilterState *)statePtr;
    state->selectedNodeIndex = -1;
    state->selectedPayloadIndex = -1;
    LOCAVAIL_FilterClassId = -1;
    LOCAVAIL_FilterStep = 0;
}
