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

extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, ULONG size, ULONG flags);

LONG DISKIO_OpenFileWithBuffer(const char *filePath, LONG accessMode)
{
    const LONG ALLOC_LINE = 286;
    const ULONG MEMF_PUBLIC = 1;
    LONG handle;

    handle = 0;
    ESQFUNC_ServiceUiTickIfRunning();

    if (DISKIO_OpenCount != 0) {
        return handle;
    }

    DISKIO_BufferControl.ErrorFlag = 0;
    handle = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(filePath, accessMode);
    if (handle != 0) {
        if (DISKIO_OpenCount == 0) {
            DISKIO_BufferState.SavedF45 = ESQPARS2_ReadModeFlags;
        }

        DISKIO_OpenCount += 1;
        ESQPARS2_ReadModeFlags = 0x100;

        DISKIO_BufferControl.BufferBase = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_DISKIO_C_1,
            ALLOC_LINE,
            (ULONG)DISKIO_BufferState.BufferSize,
            MEMF_PUBLIC);
        DISKIO_BufferState.Remaining = DISKIO_BufferState.BufferSize;
        DISKIO_BufferState.BufferPtr = DISKIO_BufferControl.BufferBase;
    }

    ESQFUNC_ServiceUiTickIfRunning();
    return handle;
}
