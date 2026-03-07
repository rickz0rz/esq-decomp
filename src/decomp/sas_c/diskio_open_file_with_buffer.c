typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;

struct DiskIoBufferState {
    void *BufferPtr;
    LONG BufferSize;
    LONG Remaining;
    WORD SavedF45;
};

struct DiskIoBufferControl {
    void *BufferBase;
    LONG ErrorFlag;
};

extern struct DiskIoBufferState DISKIO_BufferState;
extern struct DiskIoBufferControl DISKIO_BufferControl;
extern LONG DISKIO_OpenCount;
extern WORD ESQPARS2_ReadModeFlags;
extern const char Global_STR_DISKIO_C_1[];

extern void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, ULONG size, ULONG flags);

LONG DISKIO_OpenFileWithBuffer(const char *filePath, LONG accessMode)
{
    const LONG HANDLE_INVALID = 0;
    const LONG OPENCOUNT_STEP = 1;
    const WORD READMODE_STREAMING = 0x100;
    const LONG ALLOC_LINE = 286;
    const ULONG MEMF_PUBLIC = 1;
    LONG handle;

    handle = HANDLE_INVALID;
    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

    if (DISKIO_OpenCount != HANDLE_INVALID) {
        return handle;
    }

    DISKIO_BufferControl.ErrorFlag = 0;
    handle = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(filePath, accessMode);
    if (handle != HANDLE_INVALID) {
        if (DISKIO_OpenCount == HANDLE_INVALID) {
            DISKIO_BufferState.SavedF45 = ESQPARS2_ReadModeFlags;
        }

        DISKIO_OpenCount += OPENCOUNT_STEP;
        ESQPARS2_ReadModeFlags = READMODE_STREAMING;

        DISKIO_BufferControl.BufferBase = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_DISKIO_C_1,
            ALLOC_LINE,
            (ULONG)DISKIO_BufferState.BufferSize,
            MEMF_PUBLIC);
        DISKIO_BufferState.Remaining = DISKIO_BufferState.BufferSize;
        DISKIO_BufferState.BufferPtr = DISKIO_BufferControl.BufferBase;
    }

    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
    return handle;
}
