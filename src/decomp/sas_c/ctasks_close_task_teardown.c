#include <exec/types.h>
extern LONG CTASKS_CloseTaskFileHandle;
extern UWORD CTASKS_CloseTaskCompletionFlag;
extern LONG Global_REF_LIST_CLOSE_TASK_PROC;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern LONG Global_REF_DOS_LIBRARY_2;
extern LONG AbsExecBase;
extern const char Global_STR_CTASKS_C_3[];

LONG GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
void _LVOClose(void);
void _LVOForbid(void);

void CTASKS_CloseTaskTeardown(void)
{
    const LONG DEALLOC_LINE = 194;
    const LONG PROC_LIST_BYTES = 14;
    const UWORD TASK_DONE = 1;

    if (CTASKS_CloseTaskFileHandle != 0) {
        _LVOClose();
        CTASKS_CloseTaskFileHandle = 0;
    }

    _LVOForbid();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CTASKS_C_3,
        DEALLOC_LINE,
        (void *)Global_REF_LIST_CLOSE_TASK_PROC,
        PROC_LIST_BYTES);
    CTASKS_CloseTaskCompletionFlag = TASK_DONE;
}
