typedef long LONG;

typedef struct DateTimePair {
    void *in_ptr;   /* +0 */
    void *out_ptr;  /* +4 */
} DateTimePair;

enum {
    DATETIME_SAVE_PREFIX_LEN = 4,
    DATETIME_SAVE_FAILED = 0,
    DATETIME_SAVE_SUCCESS = 1
};

extern LONG MODE_NEWFILE;
extern const char *DST_DefaultDatPathPtr;
extern const char *DST_STR_G2_COLON;
extern const char *DST_STR_G3_COLON;

extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG DISKIO_WriteBufferedBytes(LONG fileHandle, const void *src, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);
extern LONG DATETIME_FormatPairToStream(LONG fileHandle, DateTimePair *pair);

LONG DATETIME_SavePairToFile(DateTimePair *pair)
{
    const LONG FILEHANDLE_INVALID = 0;
    LONG outputFileHandle;

    if (pair == (DateTimePair *)0) {
        return DATETIME_SAVE_FAILED;
    }
    if (pair->in_ptr == (void *)0) {
        return DATETIME_SAVE_FAILED;
    }
    if (pair->out_ptr == (void *)0) {
        return DATETIME_SAVE_FAILED;
    }

    outputFileHandle = DISKIO_OpenFileWithBuffer(DST_DefaultDatPathPtr, MODE_NEWFILE);
    if (outputFileHandle == FILEHANDLE_INVALID) {
        return DATETIME_SAVE_FAILED;
    }

    (void)DISKIO_WriteBufferedBytes(outputFileHandle, DST_STR_G2_COLON, DATETIME_SAVE_PREFIX_LEN);
    (void)DATETIME_FormatPairToStream(outputFileHandle, (DateTimePair *)pair->out_ptr);

    (void)DISKIO_WriteBufferedBytes(outputFileHandle, DST_STR_G3_COLON, DATETIME_SAVE_PREFIX_LEN);
    (void)DATETIME_FormatPairToStream(outputFileHandle, (DateTimePair *)pair->in_ptr);

    (void)DISKIO_CloseBufferedFileAndFlush(outputFileHandle);
    return DATETIME_SAVE_SUCCESS;
}
