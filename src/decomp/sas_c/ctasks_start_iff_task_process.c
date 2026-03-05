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
    LONG task;
    LONG list_ptr;
    LONG seg_bptr;

    do {
        _LVOForbid();
        task = _LVOFindTask();
        _LVOPermit();
    } while (task != 0);

    CTASKS_IffTaskDoneFlag = 0;
    if ((UWORD)(CTASKS_IffTaskState - 6) != 0) {
        if (ESQIFF_AssetSourceSelect != 0) {
            CTASKS_IffTaskState = 4;
        } else {
            CTASKS_IffTaskState = 5;
        }
    }

    list_ptr = (LONG)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_CTASKS_C_2, 159, 14, 0x10001UL);
    Global_REF_LIST_IFF_TASK_PROC = list_ptr;

    *(LONG *)(list_ptr + 0) = 14;
    *(LONG *)(list_ptr + 10) = (LONG)CTASKS_IFFTaskCleanup;
    *(UWORD *)(list_ptr + 8) = 20217;

    seg_bptr = (list_ptr + 4) >> 2;
    CTASKS_IffTaskSegListBPTR = seg_bptr;

    CTASKS_IffTaskProcPtr = _LVOCreateProc();
}
