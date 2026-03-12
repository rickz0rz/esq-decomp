typedef signed long LONG;
typedef short WORD;

extern void *NEWGRID2_ErrorLogEntryPtr;
extern WORD FLIB_LogEntryByteCount;
extern const char CLOCK_FileEofMarkerCtrlZ[];
extern const char Global_STR_DF0_ERR_LOG[];

extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG DISKIO_WriteBufferedBytes(LONG fileHandle, const void *buffer, LONG byteCount);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);

LONG PARSEINI_WriteErrorLogEntry(void)
{
    LONG fileHandle;

    if (NEWGRID2_ErrorLogEntryPtr == (void *)0) {
        return -1L;
    }

    fileHandle = DISKIO_OpenFileWithBuffer(Global_STR_DF0_ERR_LOG, 1006L);
    if (fileHandle == 0) {
        return -1L;
    }

    DISKIO_WriteBufferedBytes(
        fileHandle,
        NEWGRID2_ErrorLogEntryPtr,
        (LONG)FLIB_LogEntryByteCount);
    DISKIO_WriteBufferedBytes(
        fileHandle,
        (void *)CLOCK_FileEofMarkerCtrlZ,
        1L);

    return DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
