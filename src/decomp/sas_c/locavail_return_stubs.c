#include <exec/types.h>
typedef struct LOCAVAIL_NodeRecord {
    UBYTE flag0;
    UBYTE pad1;
    WORD duration2;
    UWORD payloadSize4;
    UBYTE *payload6;
} LOCAVAIL_NodeRecord;

typedef struct LOCAVAIL_FilterState {
    UBYTE mode0;
    UBYTE pad1;
    LONG nodeCount2;
    UBYTE pad6[14];
    LOCAVAIL_NodeRecord *nodeTable20;
} LOCAVAIL_FilterState;

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
    LOCAVAIL_FilterState *state;
    LOCAVAIL_NodeRecord *node;

    duration = 0;
    state = (LOCAVAIL_FilterState *)statePtr;

    if (state != (LOCAVAIL_FilterState *)0 && index >= 0 && index < state->nodeCount2) {
        node = state->nodeTable20 + index;
        duration = (LONG)node->duration2;
    }

    return duration;
}
