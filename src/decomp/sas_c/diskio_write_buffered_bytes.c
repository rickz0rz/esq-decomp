typedef signed long LONG;
typedef unsigned char UBYTE;

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

extern void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG _LVOWrite(void *dosBase, LONG fileHandle, const void *buffer, LONG length);

LONG DISKIO_WriteBufferedBytes(LONG handle, const UBYTE *src, LONG len)
{
    LONG result;
    LONG requested;

    result = len;
    requested = len;

    if (src == 0 || len == 0 || DISKIO_BufferControl.ErrorFlag == 1 || handle == 0) {
        return 0;
    }

    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

    for (;;) {
        while (len != 0 && DISKIO_BufferState.Remaining != 0) {
            UBYTE *dst;

            dst = DISKIO_BufferState.BufferPtr;
            *dst++ = *src++;
            DISKIO_BufferState.BufferPtr = dst;
            DISKIO_BufferState.Remaining--;
            len--;
        }

        GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

        if (DISKIO_BufferState.Remaining == 0) {
            LONG wrote;

            wrote = _LVOWrite(
                Global_REF_DOS_LIBRARY_2,
                handle,
                DISKIO_BufferControl.BufferBase,
                DISKIO_BufferState.BufferSize);
            result = wrote;

            if (wrote != DISKIO_BufferState.BufferSize) {
                DISKIO_BufferControl.ErrorFlag = 1;
                break;
            }

            result = requested;
            DISKIO_BufferState.BufferPtr = DISKIO_BufferControl.BufferBase;
            DISKIO_BufferState.Remaining = DISKIO_BufferState.BufferSize;
            GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
        }

        if (len == 0) {
            break;
        }
    }

    return result;
}
