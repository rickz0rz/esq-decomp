#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

extern char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write[];
extern char P_TYPE_STR_CURDAY_COLON_WriteSection[];
extern char P_TYPE_STR_NXTDAY_COLON_WriteSection[];
extern char P_TYPE_STR_NO_DATA[];
extern char P_TYPE_FMT_PCT_03D_PCT_02D[];
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

void *SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, s32 mode) __attribute__((noinline));
void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(void *handle, const void *buf, s32 len) __attribute__((noinline));
void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void *handle) __attribute__((noinline));
s32 PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...) __attribute__((noinline));

static s32 p_type_strlen_local(const char *s)
{
    const char *p = s;
    while (*p != '\0') {
        ++p;
    }
    return (s32)(p - s);
}

void P_TYPE_WritePromoIdDataFile(void) __attribute__((noinline, used));

void P_TYPE_WritePromoIdDataFile(void)
{
    char line_buf[120];
    void *handle = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write, 1006);
    s32 slot;

    if (handle == (void *)0) {
        return;
    }

    for (slot = 0; slot < 2; ++slot) {
        PTypeEntry *entry;
        s32 i;

        {
            const char *section = (slot == 0) ? P_TYPE_STR_CURDAY_COLON_WriteSection : P_TYPE_STR_NXTDAY_COLON_WriteSection;
            char *d = line_buf;
            while ((*d++ = *section++) != '\0') {
            }
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, line_buf, p_type_strlen_local(line_buf));
        }

        entry = (slot == 0) ? P_TYPE_PrimaryGroupListPtr : P_TYPE_SecondaryGroupListPtr;
        if (entry == (PTypeEntry *)0 || entry->len <= 0) {
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, P_TYPE_STR_NO_DATA, 9);
            continue;
        }

        PARSEINI_JMPTBL_WDISP_SPrintf(line_buf, P_TYPE_FMT_PCT_03D_PCT_02D, (s32)entry->type_byte, entry->len);
        SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, line_buf, p_type_strlen_local(line_buf));

        for (i = 0; i < entry->len; ++i) {
            line_buf[i] = (char)entry->payload[i];
        }
        line_buf[i++] = '\n';
        line_buf[i] = '\0';
        SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(handle, line_buf, p_type_strlen_local(line_buf));
    }

    SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(handle);
}
