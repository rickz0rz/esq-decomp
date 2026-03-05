typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

extern UWORD CTASKS_CloseTaskCompletionFlag;
extern LONG CTASKS_CloseTaskFileHandle;
extern LONG Global_REF_LIST_CLOSE_TASK_PROC;
extern LONG CTASKS_CloseTaskSegListBPTR;
extern LONG CTASKS_CloseTaskProcPtr;
extern LONG Global_REF_DOS_LIBRARY_2;
extern char Global_STR_CTASKS_C_4[];
extern char Global_STR_CLOSE_TASK[];

void CTASKS_CloseTaskTeardown(void);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG _LVOCreateProc(void);

void CTASKS_StartCloseTaskProcess(LONG file_handle)
{
    LONG list_ptr;
    LONG seg_bptr;

    CTASKS_CloseTaskCompletionFlag = 0;
    CTASKS_CloseTaskFileHandle = file_handle;

    list_ptr = (LONG)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_CTASKS_C_4, 203, 14, 0x10001UL);
    Global_REF_LIST_CLOSE_TASK_PROC = list_ptr;

    *(LONG *)(list_ptr + 0) = 14;
    *(LONG *)(list_ptr + 10) = (LONG)CTASKS_CloseTaskTeardown;
    *(UWORD *)(list_ptr + 8) = 20217;

    seg_bptr = (list_ptr + 4) >> 2;
    CTASKS_CloseTaskSegListBPTR = seg_bptr;

    CTASKS_CloseTaskProcPtr = _LVOCreateProc();
}
