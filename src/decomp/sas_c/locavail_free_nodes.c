#include <exec/types.h>
typedef struct LOCAVAIL_NodeRecord {
    UBYTE flag0;
    UBYTE pad1;
    UWORD word2;
    UWORD payloadSize4;
    void *payload6;
} LOCAVAIL_NodeRecord;

typedef struct LOCAVAIL_FilterState {
    UBYTE mode0;
    UBYTE pad1;
    LONG nodeCount2;
    UBYTE modeChar6;
    UBYTE pad7;
    LONG field8;
    LONG field12;
    ULONG *sharedRef16;
    LOCAVAIL_NodeRecord *nodeTable20;
} LOCAVAIL_FilterState;

extern const char Global_STR_LOCAVAIL_C_1[];
extern const char Global_STR_LOCAVAIL_C_2[];
extern const char Global_STR_LOCAVAIL_C_3[];
extern LONG GROUP_AY_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void LOCAVAIL_FreeNodeRecord(void *node)
{
    LOCAVAIL_NodeRecord *nodeView = (LOCAVAIL_NodeRecord *)node;

    nodeView->flag0 = 0;
    nodeView->word2 = 0;
    nodeView->payloadSize4 = 0;
    nodeView->payload6 = (void *)0;
}

void LOCAVAIL_FreeNodeAtPointer(void *node)
{
    LOCAVAIL_NodeRecord *nodeView = (LOCAVAIL_NodeRecord *)node;

    if (nodeView != (LOCAVAIL_NodeRecord *)0) {
        void *buf = nodeView->payload6;
        if (buf != (void *)0) {
            WORD size = (WORD)nodeView->payloadSize4;
            if (size > 0) {
                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_1,
                    106,
                    buf,
                    (LONG)size
                );
            }
        }
        LOCAVAIL_FreeNodeRecord(node);
    }
}

void LOCAVAIL_ResetFilterStateStruct(void *state)
{
    LOCAVAIL_FilterState *stateView = (LOCAVAIL_FilterState *)state;

    stateView->mode0 = 0;
    stateView->nodeCount2 = 0;
    stateView->sharedRef16 = (ULONG *)0;
    stateView->nodeTable20 = (LOCAVAIL_NodeRecord *)0;
    stateView->modeChar6 = 'F';
    stateView->field8 = -1;
    stateView->field12 = -1;
}

void LOCAVAIL_FreeResourceChain(void *state)
{
    LOCAVAIL_FilterState *stateView = (LOCAVAIL_FilterState *)state;

    if (stateView != (LOCAVAIL_FilterState *)0) {
        ULONG *sharedRef = stateView->sharedRef16;
        if (sharedRef != (ULONG *)0) {
            if ((LONG)(*sharedRef) > 0) {
                *sharedRef -= 1;
            }

            if (stateView->nodeTable20 != (LOCAVAIL_NodeRecord *)0 &&
                stateView->nodeCount2 > 0 &&
                *sharedRef == 0) {
                LONG i = 0;

                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_2,
                    159,
                    sharedRef,
                    4
                );

                while (i < stateView->nodeCount2) {
                    LOCAVAIL_FreeNodeAtPointer(stateView->nodeTable20 + i);
                    i += 1;
                }

                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_3,
                    164,
                    stateView->nodeTable20,
                    GROUP_AY_JMPTBL_MATH_Mulu32(stateView->nodeCount2, 10)
                );
            }
        }

        LOCAVAIL_ResetFilterStateStruct(state);
    }
}
