typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

extern UWORD CTASKS_IffTaskDoneFlag;
extern UWORD CTASKS_IffTaskState;
extern UWORD ESQIFF_AssetSourceSelect;
extern LONG Global_REF_LIST_IFF_TASK_PROC;
extern LONG CTASKS_IffTaskSegListBPTR;
extern LONG CTASKS_IffTaskProcPtr;
extern char Global_STR_IFF_TASK_1[];
extern char Global_STR_IFF_TASK_2[];
extern char Global_STR_CTASKS_C_2[];

void CTASKS_IFFTaskCleanup(void);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG _LVOFindTask(void);
void _LVOForbid(void);
void _LVOPermit(void);
LONG _LVOCreateProc(void);

void CTASKS_StartIffTaskProcess(void)
{
    const UWORD FLAG_FALSE = 0;
    const UWORD TASKSTATE_IFF = 6;
    const UWORD TASKSTATE_LOGO = 4;
    const UWORD TASKSTATE_GADS = 5;
    const LONG TASKPROC_ALLOC_LINE = 159;
    const LONG TASKPROC_STRUCT_SIZE = 14;
    const ULONG MEMF_PUBLIC_CLEAR = 0x10001UL;
    const LONG TASKLIST_SIZE_OFFSET = 0;
    const LONG TASKLIST_MAGIC_OFFSET = 8;
    const LONG TASKLIST_ENTRY_OFFSET = 10;
    const UWORD TASKLIST_MAGIC = 20217;
    const LONG TASKLIST_SEG_BPTR_SHIFT = 2;
    const LONG TASKLIST_SEG_BPTR_ADD = 4;
    LONG task;
    LONG list_ptr;
    LONG seg_bptr;

    do {
        _LVOForbid();
        task = _LVOFindTask();
        _LVOPermit();
    } while (task != FLAG_FALSE);

    CTASKS_IffTaskDoneFlag = FLAG_FALSE;
    if ((UWORD)(CTASKS_IffTaskState - TASKSTATE_IFF) != 0) {
        if (ESQIFF_AssetSourceSelect != FLAG_FALSE) {
            CTASKS_IffTaskState = TASKSTATE_LOGO;
        } else {
            CTASKS_IffTaskState = TASKSTATE_GADS;
        }
    }

    list_ptr = (LONG)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_CTASKS_C_2,
        TASKPROC_ALLOC_LINE,
        TASKPROC_STRUCT_SIZE,
        MEMF_PUBLIC_CLEAR);
    Global_REF_LIST_IFF_TASK_PROC = list_ptr;

    *(LONG *)(list_ptr + TASKLIST_SIZE_OFFSET) = TASKPROC_STRUCT_SIZE;
    *(LONG *)(list_ptr + TASKLIST_ENTRY_OFFSET) = (LONG)CTASKS_IFFTaskCleanup;
    *(UWORD *)(list_ptr + TASKLIST_MAGIC_OFFSET) = TASKLIST_MAGIC;

    seg_bptr = (list_ptr + TASKLIST_SEG_BPTR_ADD) >> TASKLIST_SEG_BPTR_SHIFT;
    CTASKS_IffTaskSegListBPTR = seg_bptr;

    CTASKS_IffTaskProcPtr = _LVOCreateProc();
}
