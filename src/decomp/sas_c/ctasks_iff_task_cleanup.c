typedef unsigned short UWORD;
typedef long LONG;

extern UWORD CTASKS_IffTaskState;
extern UWORD CTASKS_IffTaskDoneFlag;
extern LONG CTASKS_PendingLogoBrushDescriptor;
extern LONG CTASKS_PendingGAdsBrushDescriptor;
extern LONG CTASKS_PendingIffBrushDescriptor;
extern LONG BRUSH_LoadInProgressFlag;
extern LONG Global_REF_LIST_IFF_TASK_PROC;
extern char Global_STR_CTASKS_C_1[];

void GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(void *desc);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
void _LVOForbid(void);

void CTASKS_IFFTaskCleanup(void)
{
    const LONG PENDING_NONE = 0;
    const UWORD TASKSTATE_LOGO = 4;
    const UWORD TASKSTATE_GADS = 5;
    const UWORD TASKSTATE_IFF = 6;
    const UWORD TASKSTATE_WEATHER = 11;
    const UWORD FLAG_DONE = 1;
    const UWORD FLAG_CLEAR = 0;
    const LONG TASKPROC_FREE_LINE = 127;
    const LONG TASKPROC_STRUCT_SIZE = 14;
    LONG pending;

    pending = PENDING_NONE;
    if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_LOGO) == 0) {
        pending = CTASKS_PendingLogoBrushDescriptor;
    } else if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_GADS) == 0) {
        pending = CTASKS_PendingGAdsBrushDescriptor;
    } else if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_IFF) == 0 || CTASKS_IffTaskState == TASKSTATE_WEATHER) {
        pending = CTASKS_PendingIffBrushDescriptor;
    }

    while (BRUSH_LoadInProgressFlag != 0) {
    }

    GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult((void *)pending);

    if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_LOGO) == 0) {
        CTASKS_PendingLogoBrushDescriptor = PENDING_NONE;
    } else if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_GADS) == 0) {
        CTASKS_PendingGAdsBrushDescriptor = PENDING_NONE;
    } else if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_IFF) == 0) {
        CTASKS_PendingIffBrushDescriptor = PENDING_NONE;
    }

    _LVOForbid();

    CTASKS_IffTaskDoneFlag = FLAG_DONE;
    CTASKS_IffTaskState = FLAG_CLEAR;
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CTASKS_C_1,
        TASKPROC_FREE_LINE,
        (void *)Global_REF_LIST_IFF_TASK_PROC,
        TASKPROC_STRUCT_SIZE);
}
