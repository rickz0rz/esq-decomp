#include "esq_types.h"

#define MODE_NEWFILE 1006

extern void *NEWGRID2_ErrorLogEntryPtr;
extern u16 FLIB_LogEntryByteCount;
extern u8 CLOCK_FileEofMarkerCtrlZ;
extern const char Global_STR_DF0_ERR_LOG[];

s32 SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const void *path, s32 mode) __attribute__((noinline));
void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(s32 handle, const void *src, s32 len) __attribute__((noinline));
s32 SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(s32 handle) __attribute__((noinline));

s32 PARSEINI_WriteErrorLogEntry(void) __attribute__((noinline, used));

s32 PARSEINI_WriteErrorLogEntry(void)
{
    s32 handle;

    if (NEWGRID2_ErrorLogEntryPtr == 0) {
        return -1;
    }

    handle = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(Global_STR_DF0_ERR_LOG, MODE_NEWFILE);
    if (handle == 0) {
        return -1;
    }

    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(
        handle,
        NEWGRID2_ErrorLogEntryPtr,
        (s32)(u16)FLIB_LogEntryByteCount);
    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, &CLOCK_FileEofMarkerCtrlZ, 1);

    return SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(handle);
}
