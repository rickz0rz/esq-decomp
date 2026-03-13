typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    LONG len;
    UBYTE *payload;
} PTypeEntry;

extern const char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load[];
extern const char P_TYPE_STR_CURDAY_COLON_LoadSection[];
extern const char P_TYPE_STR_NXTDAY_COLON_LoadSection[];
extern const char P_TYPE_STR_TYPES_COLON[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern char *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern const char Global_STR_P_TYPE_C_6[];
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

extern LONG PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern char *STRING_FindSubstring(char *haystack, char *needle);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *src);
extern PTypeEntry *P_TYPE_AllocateEntry(UBYTE type_byte, LONG len, const UBYTE *src);
extern void P_TYPE_FreeEntry(PTypeEntry *entry);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *tag_name, LONG width, void *ptr, LONG size);

static LONG p_type_strlen_local(const char *s)
{
    const char *p = s;
    while (*p != '\0') {
        ++p;
    }
    return (LONG)(p - s);
}

LONG P_TYPE_LoadPromoIdDataFile(void)
{
    char *work;
    LONG scratch_len;
    LONG section;

    if (PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load) == -1) {
        return 1;
    }

    work = Global_PTR_WORK_BUFFER;
    scratch_len = Global_REF_LONG_FILE_SCRATCH;

    for (section = 0; section < 2; ++section) {
        const char *section_header = (section == 0) ? P_TYPE_STR_CURDAY_COLON_LoadSection : P_TYPE_STR_NXTDAY_COLON_LoadSection;
        char *cursor = STRING_FindSubstring(work, (char *)section_header);
        LONG slot = 2;

        if (!cursor) {
            continue;
        }

        cursor += p_type_strlen_local(section_header);
        while ((WDISP_CharClassTable[(UBYTE)*cursor] & (1 << 3)) != 0) {
            ++cursor;
        }

        {
            LONG parsed_group = PARSE_ReadSignedLongSkipClass3_Alt(cursor);
            if ((UBYTE)parsed_group == TEXTDISP_PrimaryGroupCode) {
                slot = 0;
            } else if ((UBYTE)parsed_group == TEXTDISP_SecondaryGroupCode) {
                slot = 1;
            } else {
                slot = 2;
            }

            if (slot != 2) {
                LONG payload_len;
                PTypeEntry *new_entry = (PTypeEntry *)0;
                PTypeEntry **slot_ptr = (slot == 0) ? &P_TYPE_PrimaryGroupListPtr : &P_TYPE_SecondaryGroupListPtr;

                while ((WDISP_CharClassTable[(UBYTE)*cursor] & (1 << 2)) != 0) {
                    ++cursor;
                }
                while ((WDISP_CharClassTable[(UBYTE)*cursor] & (1 << 3)) != 0) {
                    ++cursor;
                }

                payload_len = PARSE_ReadSignedLongSkipClass3_Alt(cursor);
                if (payload_len > 0) {
                    char *types = STRING_FindSubstring(cursor, (char *)P_TYPE_STR_TYPES_COLON);
                    if (types) {
                        UBYTE saved;

                        types += 7;
                        saved = (UBYTE)types[payload_len];
                        types[payload_len] = '\0';
                        new_entry = P_TYPE_AllocateEntry((UBYTE)parsed_group, payload_len, (const UBYTE *)types);
                        types[payload_len] = (char)saved;
                    }
                }

                P_TYPE_FreeEntry(*slot_ptr);
                *slot_ptr = new_entry;
            }
        }
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_6, 406, work, scratch_len + 1);
    return 1;
}
