#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

extern u8 TEXTDISP_PrimaryGroupCode;
extern u8 TEXTDISP_SecondaryGroupCode;
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

void SCRIPT3_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, s32 count) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *src) __attribute__((noinline));
void P_TYPE_FreeEntry(PTypeEntry *entry) __attribute__((noinline));
PTypeEntry *P_TYPE_AllocateEntry(u8 type_byte, s32 len, const u8 *src) __attribute__((noinline));

s32 P_TYPE_ParseAndStoreTypeRecord(const char *src) __attribute__((noinline, used));

s32 P_TYPE_ParseAndStoreTypeRecord(const char *src)
{
    char parse_buf[4];
    u8 group_code;
    s32 parsed_len;
    s32 payload_len;
    s32 slot = 2;
    s32 result = 0;
    PTypeEntry **slot_ptr;

    SCRIPT3_JMPTBL_STRING_CopyPadNul(parse_buf, src, 3);
    parse_buf[3] = '\0';
    group_code = (u8)SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parse_buf);
    src += 3;

    SCRIPT3_JMPTBL_STRING_CopyPadNul(parse_buf, src, 2);
    parse_buf[2] = '\0';
    parsed_len = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parse_buf);
    src += 2;

    if (group_code == TEXTDISP_PrimaryGroupCode) {
        slot = 0;
    } else if (group_code == TEXTDISP_SecondaryGroupCode) {
        slot = 1;
    }

    if (slot == 2) {
        return 0;
    }

    slot_ptr = (slot == 0) ? &P_TYPE_PrimaryGroupListPtr : &P_TYPE_SecondaryGroupListPtr;
    P_TYPE_FreeEntry(*slot_ptr);

    payload_len = (s16)parsed_len;
    *slot_ptr = P_TYPE_AllocateEntry(group_code, payload_len, (const u8 *)src);
    result = 1;

    return result;
}
