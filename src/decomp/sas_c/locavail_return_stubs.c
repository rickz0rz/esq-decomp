typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void LOCAVAIL_ParseFilterStateFromBuffer_Return(void) {}
void LOCAVAIL_MapFilterTokenCharToClass_Return(void) {}
void LOCAVAIL_ComputeFilterOffsetForEntry_Return(void) {}
void LOCAVAIL_SaveAvailabilityDataFile_Return(void) {}
void LOCAVAIL_LoadAvailabilityDataFile_Return(void) {}
void LOCAVAIL_UpdateFilterStateMachine_Return(void) {}

LONG LOCAVAIL_GetNodeDurationByIndex(void *statePtr, LONG index)
{
    LONG duration;
    UBYTE *state;
    UBYTE *node;

    duration = 0;
    state = (UBYTE *)statePtr;

    if (state != (UBYTE *)0 && index >= 0 && index < *(LONG *)(state + 2)) {
        node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(index, 10);
        duration = (LONG)*(WORD *)(node + 2);
    }

    return duration;
}
