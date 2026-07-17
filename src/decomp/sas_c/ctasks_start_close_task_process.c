#include <exec/memory.h>
#include <exec/types.h>

#define CTASKS_FLAG_CLEAR 0
#define CTASKS_ALLOC_LINE 203
#define CTASKS_TASKPROC_SIZE 14

#define MEMF_PUBLIC_CLEAR (MEMF_PUBLIC | MEMF_CLEAR)

#define CTASKS_LIST_SIZE_OFFSET 0
#define CTASKS_LIST_TASKENTRY_OFFSET 10
#define CTASKS_LIST_MAGIC_OFFSET 8
#define CTASKS_LIST_MAGIC 20217
#define CTASKS_BPTRLIST_OFFSET 4
#define CTASKS_BPTRLIST_SHIFT 2

extern UWORD CTASKS_CloseTaskCompletionFlag;
extern LONG CTASKS_CloseTaskFileHandle;
extern LONG Global_REF_LIST_CLOSE_TASK_PROC;
extern LONG CTASKS_CloseTaskSegListBPTR;
extern LONG CTASKS_CloseTaskProcPtr;
extern LONG Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_CTASKS_C_4[];
extern const char Global_STR_CLOSE_TASK[];

void CTASKS_CloseTaskTeardown(void);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
/* base-first _LVO ABI. CreateProc(dosBase; D1=name, D2=pri, D3=segListBPTR, D4=stackSize). */
LONG _LVOCreateProc(void *dosBase, const char *name, LONG pri, LONG segListBPTR, LONG stackSize);

void CTASKS_StartCloseTaskProcess(LONG file_handle)
{
    LONG list_ptr;
    LONG seg_bptr;

    CTASKS_CloseTaskCompletionFlag = CTASKS_FLAG_CLEAR;
    CTASKS_CloseTaskFileHandle = file_handle;

    list_ptr = (LONG)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_CTASKS_C_4,
        CTASKS_ALLOC_LINE,
        CTASKS_TASKPROC_SIZE,
        MEMF_PUBLIC_CLEAR);
    Global_REF_LIST_CLOSE_TASK_PROC = list_ptr;

    *(LONG *)(list_ptr + CTASKS_LIST_SIZE_OFFSET) = CTASKS_TASKPROC_SIZE;
    *(LONG *)(list_ptr + CTASKS_LIST_TASKENTRY_OFFSET) = (LONG)CTASKS_CloseTaskTeardown;
    *(UWORD *)(list_ptr + CTASKS_LIST_MAGIC_OFFSET) = CTASKS_LIST_MAGIC;

    seg_bptr = (list_ptr + CTASKS_BPTRLIST_OFFSET) >> CTASKS_BPTRLIST_SHIFT;
    CTASKS_CloseTaskSegListBPTR = seg_bptr;

    CTASKS_CloseTaskProcPtr = _LVOCreateProc(
        Global_REF_DOS_LIBRARY_2, Global_STR_CLOSE_TASK, 0, CTASKS_CloseTaskSegListBPTR, 8192);
}
