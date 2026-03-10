typedef signed long LONG;
typedef short WORD;

extern void *NEWGRID2_ErrorLogEntryPtr;
extern WORD FLIB_LogEntryByteCount;
extern const char CLOCK_FileEofMarkerCtrlZ[];
extern const char Global_STR_DF0_ERR_LOG[];

extern LONG SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(LONG fileHandle, void *buffer, LONG byteCount);
extern LONG SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);

LONG PARSEINI_WriteErrorLogEntry(void)
{
    LONG fileHandle;

    if (NEWGRID2_ErrorLogEntryPtr == (void *)0) {
        return -1L;
    }

    fileHandle = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(Global_STR_DF0_ERR_LOG, 1006L);
    if (fileHandle == 0) {
        return -1L;
    }

    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(
        fileHandle,
        NEWGRID2_ErrorLogEntryPtr,
        (LONG)FLIB_LogEntryByteCount);
    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(
        fileHandle,
        (void *)CLOCK_FileEofMarkerCtrlZ,
        1L);

    return SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
