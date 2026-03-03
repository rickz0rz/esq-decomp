#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

extern char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load[];
extern char P_TYPE_STR_CURDAY_COLON_LoadSection[];
extern char P_TYPE_STR_NXTDAY_COLON_LoadSection[];
extern char P_TYPE_STR_TYPES_COLON[];
extern u8 WDISP_CharClassTable[];
extern u8 TEXTDISP_PrimaryGroupCode;
extern u8 TEXTDISP_SecondaryGroupCode;
extern u8 *Global_PTR_WORK_BUFFER;
extern s32 Global_REF_LONG_FILE_SCRATCH;
extern u8 Global_STR_P_TYPE_C_6;
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

s32 PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path) __attribute__((noinline));
char *P_TYPE_JMPTBL_STRING_FindSubstring(const char *haystack, const char *needle) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *src) __attribute__((noinline));
PTypeEntry *P_TYPE_AllocateEntry(u8 type_byte, s32 len, const u8 *src) __attribute__((noinline));
void P_TYPE_FreeEntry(PTypeEntry *entry) __attribute__((noinline));
void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tag_name, s32 width, void *ptr, s32 size) __attribute__((noinline));

static s32 p_type_strlen_local2(const char *s)
{
    const char *p = s;
    while (*p != '\0') {
        ++p;
    }
    return (s32)(p - s);
}

s32 P_TYPE_LoadPromoIdDataFile(void) __attribute__((noinline, used));

s32 P_TYPE_LoadPromoIdDataFile(void)
{
    u8 *work;
    s32 scratch_len;
    s32 section;

    if (PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load) == -1) {
        return 1;
    }

    work = Global_PTR_WORK_BUFFER;
    scratch_len = Global_REF_LONG_FILE_SCRATCH;

    for (section = 0; section < 2; ++section) {
        const char *section_header = (section == 0) ? P_TYPE_STR_CURDAY_COLON_LoadSection : P_TYPE_STR_NXTDAY_COLON_LoadSection;
        char *cursor = P_TYPE_JMPTBL_STRING_FindSubstring((const char *)work, section_header);
        s32 slot = 2;

        if (cursor == (char *)0) {
            continue;
        }

        cursor += p_type_strlen_local2(section_header);
        while ((WDISP_CharClassTable[(u8)*cursor] & (1 << 3)) != 0) {
            ++cursor;
        }

        {
            s32 parsed_group = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(cursor);
            if ((u8)parsed_group == TEXTDISP_PrimaryGroupCode) {
                slot = 0;
            } else if ((u8)parsed_group == TEXTDISP_SecondaryGroupCode) {
                slot = 1;
            } else {
                slot = 2;
            }

            if (slot != 2) {
                s32 payload_len;
                PTypeEntry *new_entry = (PTypeEntry *)0;
                PTypeEntry **slot_ptr = (slot == 0) ? &P_TYPE_PrimaryGroupListPtr : &P_TYPE_SecondaryGroupListPtr;

                while ((WDISP_CharClassTable[(u8)*cursor] & (1 << 2)) != 0) {
                    ++cursor;
                }
                while ((WDISP_CharClassTable[(u8)*cursor] & (1 << 3)) != 0) {
                    ++cursor;
                }

                payload_len = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(cursor);
                if (payload_len > 0) {
                    char *types = P_TYPE_JMPTBL_STRING_FindSubstring(cursor, P_TYPE_STR_TYPES_COLON);
                    if (types != (char *)0) {
                        u8 saved;

                        types += 7;
                        saved = (u8)types[payload_len];
                        types[payload_len] = '\0';
                        new_entry = P_TYPE_AllocateEntry((u8)parsed_group, payload_len, (const u8 *)types);
                        types[payload_len] = (char)saved;
                    }
                }

                P_TYPE_FreeEntry(*slot_ptr);
                *slot_ptr = new_entry;
            }
        }
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_6, 406, work, scratch_len + 1);
    return 1;
}
