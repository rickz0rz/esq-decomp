#include <exec/types.h>
typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    LONG len;
    UBYTE *payload;
} PTypeEntry;

extern const char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write[];
extern const char P_TYPE_STR_CURDAY_COLON_WriteSection[];
extern const char P_TYPE_STR_NXTDAY_COLON_WriteSection[];
extern const char P_TYPE_STR_NO_DATA[];
extern const char P_TYPE_FMT_PCT_03D_PCT_02D[];
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

extern LONG SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buf, LONG len);
extern LONG SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle);
extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);

void P_TYPE_WritePromoIdDataFile(void)
{
    char lineBuf[120];
    LONG handle;
    LONG slot;

    handle = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write, 1006);
    if (handle == 0) {
        return;
    }

    {
        const char *src = P_TYPE_STR_CURDAY_COLON_WriteSection;
        char *dst = lineBuf;
        while ((*dst++ = *src++) != '\0') {
        }
    }

    slot = 0;
    while (slot != 2) {
        PTypeEntry *entry;
        char *start;
        char *scan;
        LONG i;

        entry = (slot == 0) ? P_TYPE_PrimaryGroupListPtr : P_TYPE_SecondaryGroupListPtr;

        start = lineBuf;
        scan = start;
        while (*scan++ != '\0') {
        }
        SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, start, (LONG)((scan - start) - 1));

        if (entry && entry->len > 0) {
            PARSEINI_JMPTBL_WDISP_SPrintf(lineBuf, P_TYPE_FMT_PCT_03D_PCT_02D, (LONG)entry->type_byte, entry->len);

            start = lineBuf;
            scan = start;
            while (*scan++ != '\0') {
            }
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, start, (LONG)((scan - start) - 1));

            i = 0;
            while (i < entry->len) {
                lineBuf[i] = (char)entry->payload[i];
                ++i;
            }
            lineBuf[i++] = '\n';
            lineBuf[i] = '\0';

            start = lineBuf;
            scan = start;
            while (*scan++ != '\0') {
            }
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, start, (LONG)((scan - start) - 1));
        } else {
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, P_TYPE_STR_NO_DATA, 9);
        }

        if (slot == 0) {
            slot = 1;
            {
                const char *src = P_TYPE_STR_NXTDAY_COLON_WriteSection;
                char *dst = lineBuf;
                while ((*dst++ = *src++) != '\0') {
                }
            }
        } else {
            slot = 2;
        }
    }

    SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(handle);
}
