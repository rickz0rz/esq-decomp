typedef long LONG;

typedef struct DateTimePair {
    void *in_ptr;   /* +0 */
    void *out_ptr;  /* +4 */
} DateTimePair;

enum {
    DATETIME_SAVE_PREFIX_LEN = 4
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
    LONG fileHandle;

    if (pair == (DateTimePair *)0) {
        return 0;
    }
    if (pair->in_ptr == (void *)0) {
        return 0;
    }
    if (pair->out_ptr == (void *)0) {
        return 0;
    }

    fileHandle = DISKIO_OpenFileWithBuffer(DST_DefaultDatPathPtr, MODE_NEWFILE);
    if (fileHandle == 0) {
        return 0;
    }

    (void)DISKIO_WriteBufferedBytes(fileHandle, DST_STR_G2_COLON, DATETIME_SAVE_PREFIX_LEN);
    (void)DATETIME_FormatPairToStream(fileHandle, (DateTimePair *)pair->out_ptr);

    (void)DISKIO_WriteBufferedBytes(fileHandle, DST_STR_G3_COLON, DATETIME_SAVE_PREFIX_LEN);
    (void)DATETIME_FormatPairToStream(fileHandle, (DateTimePair *)pair->in_ptr);

    (void)DISKIO_CloseBufferedFileAndFlush(fileHandle);
    return 1;
}
