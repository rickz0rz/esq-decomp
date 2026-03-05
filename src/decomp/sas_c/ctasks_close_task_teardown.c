typedef unsigned short UWORD;
typedef long LONG;

extern LONG CTASKS_CloseTaskFileHandle;
extern UWORD CTASKS_CloseTaskCompletionFlag;
extern LONG Global_REF_LIST_CLOSE_TASK_PROC;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern LONG Global_REF_DOS_LIBRARY_2;
extern LONG AbsExecBase;
extern char Global_STR_CTASKS_C_3[];

LONG GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
void _LVOClose(void);
void _LVOForbid(void);

void CTASKS_CloseTaskTeardown(void)
{
    if (CTASKS_CloseTaskFileHandle != 0) {
        _LVOClose();
        CTASKS_CloseTaskFileHandle = 0;
    }

    _LVOForbid();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CTASKS_C_3, 194, (void *)Global_REF_LIST_CLOSE_TASK_PROC, 14);
    CTASKS_CloseTaskCompletionFlag = 1;
}
