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
    LONG pending;

    pending = 0;
    if ((UWORD)(CTASKS_IffTaskState - 4) == 0) {
        pending = CTASKS_PendingLogoBrushDescriptor;
    } else if ((UWORD)(CTASKS_IffTaskState - 5) == 0) {
        pending = CTASKS_PendingGAdsBrushDescriptor;
    } else if ((UWORD)(CTASKS_IffTaskState - 6) == 0 || CTASKS_IffTaskState == 11) {
        pending = CTASKS_PendingIffBrushDescriptor;
    }

    while (BRUSH_LoadInProgressFlag != 0) {
    }

    GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult((void *)pending);

    if ((UWORD)(CTASKS_IffTaskState - 4) == 0) {
        CTASKS_PendingLogoBrushDescriptor = 0;
    } else if ((UWORD)(CTASKS_IffTaskState - 5) == 0) {
        CTASKS_PendingGAdsBrushDescriptor = 0;
    } else if ((UWORD)(CTASKS_IffTaskState - 6) == 0) {
        CTASKS_PendingIffBrushDescriptor = 0;
    }

    _LVOForbid();

    CTASKS_IffTaskDoneFlag = 1;
    CTASKS_IffTaskState = 0;
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CTASKS_C_1, 127, (void *)Global_REF_LIST_IFF_TASK_PROC, 14);
}
