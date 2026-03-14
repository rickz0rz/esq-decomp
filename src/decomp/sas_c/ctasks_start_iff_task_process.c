#include <exec/types.h>
#define CTASKS_FLAG_FALSE 0
#define CTASKS_TASKSTATE_LOGO 4
#define CTASKS_TASKSTATE_GADS 5
#define CTASKS_TASKSTATE_IFF 6
#define CTASKS_TASKPROC_ALLOC_LINE 159
#define CTASKS_TASKPROC_STRUCT_SIZE 14
#define CTASKS_MEMF_PUBLIC_CLEAR 0x10001UL
#define CTASKS_TASKLIST_SIZE_OFFSET 0
#define CTASKS_TASKLIST_MAGIC_OFFSET 8
#define CTASKS_TASKLIST_ENTRY_OFFSET 10
#define CTASKS_TASKLIST_MAGIC 20217
#define CTASKS_TASKLIST_SEG_BPTR_SHIFT 2
#define CTASKS_TASKLIST_SEG_BPTR_ADD 4

extern UWORD CTASKS_IffTaskDoneFlag;
extern UWORD CTASKS_IffTaskState;
extern UWORD ESQIFF_AssetSourceSelect;
extern LONG Global_REF_LIST_IFF_TASK_PROC;
extern LONG CTASKS_IffTaskSegListBPTR;
extern LONG CTASKS_IffTaskProcPtr;
extern const char Global_STR_IFF_TASK_1[];
extern const char Global_STR_IFF_TASK_2[];
extern const char Global_STR_CTASKS_C_2[];

void CTASKS_IFFTaskCleanup(void);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG _LVOFindTask(void);
void _LVOForbid(void);
void _LVOPermit(void);
LONG _LVOCreateProc(void);

void CTASKS_StartIffTaskProcess(void)
{
    LONG task;
    LONG list_ptr;
    LONG seg_bptr;

    do {
        _LVOForbid();
        task = _LVOFindTask();
        _LVOPermit();
    } while (task != CTASKS_FLAG_FALSE);

    CTASKS_IffTaskDoneFlag = CTASKS_FLAG_FALSE;
    if ((UWORD)(CTASKS_IffTaskState - CTASKS_TASKSTATE_IFF) != 0) {
        if (ESQIFF_AssetSourceSelect != CTASKS_FLAG_FALSE) {
            CTASKS_IffTaskState = CTASKS_TASKSTATE_LOGO;
        } else {
            CTASKS_IffTaskState = CTASKS_TASKSTATE_GADS;
        }
    }

    list_ptr = (LONG)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_CTASKS_C_2,
        CTASKS_TASKPROC_ALLOC_LINE,
        CTASKS_TASKPROC_STRUCT_SIZE,
        CTASKS_MEMF_PUBLIC_CLEAR);
    Global_REF_LIST_IFF_TASK_PROC = list_ptr;

    *(LONG *)(list_ptr + CTASKS_TASKLIST_SIZE_OFFSET) = CTASKS_TASKPROC_STRUCT_SIZE;
    *(LONG *)(list_ptr + CTASKS_TASKLIST_ENTRY_OFFSET) = (LONG)CTASKS_IFFTaskCleanup;
    *(UWORD *)(list_ptr + CTASKS_TASKLIST_MAGIC_OFFSET) = CTASKS_TASKLIST_MAGIC;

    seg_bptr = (list_ptr + CTASKS_TASKLIST_SEG_BPTR_ADD) >> CTASKS_TASKLIST_SEG_BPTR_SHIFT;
    CTASKS_IffTaskSegListBPTR = seg_bptr;

    CTASKS_IffTaskProcPtr = _LVOCreateProc();
}
