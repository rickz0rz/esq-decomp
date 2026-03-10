typedef unsigned short UWORD;
typedef unsigned long ULONG;

struct AliasPair {
    char *key;
    char *value;
};

extern long DISKIO_OpenFileWithBuffer(const char *path, long mode);
extern long DISKIO_WriteBufferedBytes(long handle, const void *buf, ULONG len);
extern long DISKIO_CloseBufferedFileAndFlush(long handle);

extern const char CTASKS_PATH_QTABLE_INI[];
extern long MODE_NEWFILE;
extern const char DISKIO2_STR_QTABLE[];
extern const char DISKIO2_STR_QTableLineBreakAfterHeader[];
extern const char DISKIO2_STR_QTableEquals[];
extern const char DISKIO2_STR_QTableValueQuoteOpen[];
extern const char DISKIO2_STR_QTableValueQuoteClose[];
extern const char DISKIO2_STR_QTableLineBreakAfterEntry[];

volatile UWORD TEXTDISP_AliasCount;
volatile struct AliasPair *TEXTDISP_AliasPtrTable[256];
volatile long DISKIO2_QTableIniFileHandle;

long DISKIO2_WriteQTableIniFile(void)
{
    UWORD i;

    if (TEXTDISP_AliasCount < 1U) {
        return -1;
    }

    DISKIO2_QTableIniFileHandle = DISKIO_OpenFileWithBuffer(
        CTASKS_PATH_QTABLE_INI,
        MODE_NEWFILE);
    if (DISKIO2_QTableIniFileHandle == 0 || TEXTDISP_AliasCount == 0) {
        return -1;
    }

    {
        const char *scan = DISKIO2_STR_QTABLE;
        while (*scan != 0) {
            scan++;
        }
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            DISKIO2_STR_QTABLE,
            (ULONG)(scan - DISKIO2_STR_QTABLE));
    }
    DISKIO_WriteBufferedBytes(
        DISKIO2_QTableIniFileHandle,
        DISKIO2_STR_QTableLineBreakAfterHeader,
        2);

    for (i = 0; i < TEXTDISP_AliasCount; i++) {
        struct AliasPair *pair = (struct AliasPair *)TEXTDISP_AliasPtrTable[i];
        const char *key;
        const char *value;
        const char *scan;

        if (pair == 0) {
            continue;
        }
        key = pair->key;
        value = pair->value;
        if (key == 0 || value == 0) {
            continue;
        }

        scan = key;
        while (*scan != 0) {
            scan++;
        }
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            key,
            (ULONG)(scan - key));
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            DISKIO2_STR_QTableEquals,
            1);
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            DISKIO2_STR_QTableValueQuoteOpen,
            1);

        scan = value;
        while (*scan != 0) {
            scan++;
        }
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            value,
            (ULONG)(scan - value));
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            DISKIO2_STR_QTableValueQuoteClose,
            1);
        DISKIO_WriteBufferedBytes(
            DISKIO2_QTableIniFileHandle,
            DISKIO2_STR_QTableLineBreakAfterEntry,
            2);
    }

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_QTableIniFileHandle);
    return 0;
}
