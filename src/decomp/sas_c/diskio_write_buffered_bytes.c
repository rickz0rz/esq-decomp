typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    DISKIO_RESULT_ZERO = 0,
    DISKIO_ERROR_FLAG_SET = 1,
    DISKIO_HANDLE_INVALID = 0
};

struct DiskIoBufferState {
    UBYTE *BufferPtr;
    LONG BufferSize;
    LONG Remaining;
    short SavedF45;
};

struct DiskIoBufferControl {
    UBYTE *BufferBase;
    LONG ErrorFlag;
};

extern struct DiskIoBufferState DISKIO_BufferState;
extern struct DiskIoBufferControl DISKIO_BufferControl;
extern void *Global_REF_DOS_LIBRARY_2;

extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG _LVOWrite(void *dosBase, LONG fileHandle, const void *buffer, LONG length);

LONG DISKIO_WriteBufferedBytes(LONG handle, const UBYTE *src, LONG len)
{
    const UBYTE *DISKIO_PTR_NULL = (const UBYTE *)0;
    LONG writeResult;
    LONG requested;

    writeResult = len;
    requested = len;

    if (src == DISKIO_PTR_NULL ||
        len == DISKIO_RESULT_ZERO ||
        DISKIO_BufferControl.ErrorFlag == DISKIO_ERROR_FLAG_SET ||
        handle == DISKIO_HANDLE_INVALID) {
        return DISKIO_RESULT_ZERO;
    }

    ESQFUNC_ServiceUiTickIfRunning();

    for (;;) {
        while (len != 0 && DISKIO_BufferState.Remaining != 0) {
            UBYTE *dst;

            dst = DISKIO_BufferState.BufferPtr;
            *dst++ = *src++;
            DISKIO_BufferState.BufferPtr = dst;
            DISKIO_BufferState.Remaining--;
            len--;
        }

        ESQFUNC_ServiceUiTickIfRunning();

        if (DISKIO_BufferState.Remaining == 0) {
            LONG wrote;

            wrote = _LVOWrite(
                Global_REF_DOS_LIBRARY_2,
                handle,
                DISKIO_BufferControl.BufferBase,
                DISKIO_BufferState.BufferSize);
            writeResult = wrote;

            if (wrote != DISKIO_BufferState.BufferSize) {
                DISKIO_BufferControl.ErrorFlag = DISKIO_ERROR_FLAG_SET;
                break;
            }

            writeResult = requested;
            DISKIO_BufferState.BufferPtr = DISKIO_BufferControl.BufferBase;
            DISKIO_BufferState.Remaining = DISKIO_BufferState.BufferSize;
            ESQFUNC_ServiceUiTickIfRunning();
        }

        if (len == DISKIO_RESULT_ZERO) {
            break;
        }
    }

    return writeResult;
}
