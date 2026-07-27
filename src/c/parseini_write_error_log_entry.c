/* RESTORES: PARSEINI_WriteErrorLogEntry
 * MODULE:   modules/groups/b/a/parseini3.s
 * STATUS:   behavioural
 *
 * Dumps the accumulated error-log buffer to DF0:ERR.LOG, terminated with a
 * Ctrl-Z end-of-file marker so the file reads cleanly on a PC. Returns -1 if
 * there is nothing to log or the file will not open, 0 on success.
 *
 * 92 bytes in the original, 96 emitted -- 94 of code plus one alignment NOP, so
 * +2 real, and that +2 is a single ordering difference.
 *
 * SASC-MISMATCH: alloc-result-store-order
 *   ref:     JSR / ADDQ.W #8,A7 / MOVE.L D0,D7
 *   got:     BSR / MOVE.L D0,D7 / ADDQ.W #8,A7
 *   summary: The original pops the argument frame before storing the result. Same
 *            habit as esq_format_disk_error_message.c, restored alongside this
 *            one; it costs +2 here and nothing there, which depends only on
 *            whether the pop and the store end up adjacent.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */

extern long SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(long fh, char *p, long len);
extern void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(long fh);

extern char *NEWGRID2_ErrorLogEntryPtr;
extern short FLIB_LogEntryByteCount;
extern char Global_STR_DF0_ERR_LOG[];
extern char CLOCK_FileEofMarkerCtrlZ[];

long PARSEINI_WriteErrorLogEntry(void)
{
    long fh;

    if (NEWGRID2_ErrorLogEntryPtr == 0)
        return -1;

    fh = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(Global_STR_DF0_ERR_LOG, 1006L);
    if (fh == 0)
        return -1;

    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, NEWGRID2_ErrorLogEntryPtr,
                                            (long)FLIB_LogEntryByteCount);
    SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, CLOCK_FileEofMarkerCtrlZ, 1L);
    SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fh);
    return 0;
}
