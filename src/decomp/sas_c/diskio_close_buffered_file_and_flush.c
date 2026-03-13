typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;

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
extern void *Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_DISKIO_C_2[];
extern LONG DISKIO_OpenCount;
extern WORD CTASKS_CloseTaskCompletionFlag;
extern WORD Global_UIBusyFlag;
extern WORD ESQPARS2_ReadModeFlags;

extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG _LVOWrite(void *dosBase, LONG fileHandle, const void *buffer, LONG length);
extern LONG _LVODelay(void *dosBase, LONG ticks);
extern void CTASKS_StartCloseTaskProcess(LONG fileHandle);
extern void MEMORY_DeallocateMemory(void *ptr, ULONG size);

LONG DISKIO_CloseBufferedFileAndFlush(LONG fileHandle)
{
    LONG openCountBeforeClose;

    ESQFUNC_ServiceUiTickIfRunning();

    if (fileHandle != 0) {
        LONG bytesPending;

        DISKIO_BufferControl.ErrorFlag = 0;
        bytesPending = DISKIO_BufferState.BufferSize - DISKIO_BufferState.Remaining;
        if (bytesPending != 0) {
            _LVOWrite(
                Global_REF_DOS_LIBRARY_2,
                fileHandle,
                DISKIO_BufferControl.BufferBase,
                bytesPending);
        }

        ESQFUNC_ServiceUiTickIfRunning();
        CTASKS_StartCloseTaskProcess(fileHandle);

        while (CTASKS_CloseTaskCompletionFlag == 0) {
            ESQFUNC_ServiceUiTickIfRunning();
            _LVODelay(Global_REF_DOS_LIBRARY_2, 5);
            ESQFUNC_ServiceUiTickIfRunning();
        }

        MEMORY_DeallocateMemory(
            DISKIO_BufferControl.BufferBase,
            (ULONG)DISKIO_BufferState.BufferSize);
        ESQFUNC_ServiceUiTickIfRunning();
    }

    openCountBeforeClose = DISKIO_OpenCount;
    if (openCountBeforeClose > 0) {
        DISKIO_OpenCount -= 1;
    }

    if (DISKIO_OpenCount == 0 && Global_UIBusyFlag == 0) {
        ESQPARS2_ReadModeFlags = DISKIO_BufferState.SavedF45;
    }

    return openCountBeforeClose;
}
