typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern const char WDISP_StatusListMatchPattern[];
extern UWORD CLOCK_CurrentDayOfYear;
extern UWORD CLOCK_CurrentYearValue;
extern UBYTE TLIBA1_DayEntryModeCounter;
extern UBYTE WDISP_StatusDayEntry0[];

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern LONG UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(LONG day, LONG year);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG max_len);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *in);
extern ULONG MATH_Mulu32(ULONG a, ULONG b);

typedef struct UNKNOWN_StatusListHeader {
    UBYTE dayMode0;
    UBYTE marker1;
} UNKNOWN_StatusListHeader;

typedef struct UNKNOWN_StatusEntry {
    LONG dayKey0;
    LONG flag1;
    LONG value2;
    LONG value3;
    LONG inactive4;
} UNKNOWN_StatusEntry;

static void copy_label_0x12(const char **pp, char *dst)
{
    const char TOKEN_RECORD_END = 0x12;
    const ULONG LABEL_SCAN_LIMIT = 10u;
    ULONG i = 0;

    for (;;) {
        char c = *(*pp)++;
        dst[i] = c;
        if (c == TOKEN_RECORD_END || i >= LABEL_SCAN_LIMIT) {
            break;
        }
        i++;
    }

    dst[i] = 0;
}

static UNKNOWN_StatusEntry *status_entry_ptr(ULONG index)
{
    ULONG off = MATH_Mulu32(index, 20u);
    return (UNKNOWN_StatusEntry *)(WDISP_StatusDayEntry0 + off);
}

LONG UNKNOWN_ParseListAndUpdateEntries(const char *in)
{
    const ULONG STATUS_ENTRY_COUNT = 4u;
    const LONG STATUS_ENTRY_MAX_INDEX = 3;
    const LONG STATUS_ENTRY_NOT_FOUND = -1;
    const UWORD NEXT_DAY_INCREMENT = 1u;
    const UBYTE RECORD_MARKER_PLUS = '+';
    const UBYTE RECORD_MARKER_NONE = 0;
    const UBYTE FIELD_UNKNOWN_MARKER = '?';
    const LONG FIELD_UNKNOWN_VALUE = -999;
    const ULONG KEY_FIELD_LEN = 3u;
    const ULONG FLAG_FIELD_LEN = 1u;
    const ULONG VALUE_FIELD_LEN = 3u;
    const UNKNOWN_StatusListHeader *header;
    const char *p = in;
    char list_name[16];
    char field_buf[8];
    ULONG i;
    UBYTE marker;

    copy_label_0x12(&p, list_name);
    if (list_name[0] == 0) {
        return 0;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(WDISP_StatusListMatchPattern, list_name) != 0) {
        return 0;
    }

    for (i = 0; i < STATUS_ENTRY_COUNT; ++i) {
        UNKNOWN_StatusEntry *entry = status_entry_ptr(i);
        LONG day = (LONG)((UWORD)(CLOCK_CurrentDayOfYear + (UWORD)i + NEXT_DAY_INCREMENT));
        LONG year = (LONG)CLOCK_CurrentYearValue;

        entry->inactive4 = 1;
        entry->dayKey0 = UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(day, year);
    }

    header = (const UNKNOWN_StatusListHeader *)p;
    TLIBA1_DayEntryModeCounter = header->dayMode0;
    marker = header->marker1;
    p += sizeof(UNKNOWN_StatusListHeader);

    while (marker == RECORD_MARKER_PLUS) {
        LONG key;
        LONG found = STATUS_ENTRY_NOT_FOUND;
        LONG idx;

        STRING_CopyPadNul(field_buf, p, KEY_FIELD_LEN);
        field_buf[3] = 0;
        key = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
        p += KEY_FIELD_LEN;

        for (idx = 0; idx <= (LONG)STATUS_ENTRY_COUNT; ++idx) {
            UNKNOWN_StatusEntry *entry = status_entry_ptr((ULONG)idx);
            if (entry->dayKey0 == key) {
                found = idx;
                break;
            }
        }

        if (found < 0 || found > STATUS_ENTRY_MAX_INDEX) {
            marker = RECORD_MARKER_NONE;
        }

        if (marker == RECORD_MARKER_PLUS) {
            UNKNOWN_StatusEntry *entry = status_entry_ptr((ULONG)found);

            entry->inactive4 = 0;

            STRING_CopyPadNul(field_buf, p, FLAG_FIELD_LEN);
            field_buf[1] = 0;
            if (field_buf[0] == FIELD_UNKNOWN_MARKER) {
                entry->flag1 = 1;
            } else {
                entry->flag1 = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += FLAG_FIELD_LEN;
            STRING_CopyPadNul(field_buf, p, VALUE_FIELD_LEN);
            field_buf[3] = 0;
            if (field_buf[0] == FIELD_UNKNOWN_MARKER) {
                entry->value2 = FIELD_UNKNOWN_VALUE;
            } else {
                entry->value2 = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += VALUE_FIELD_LEN;
            STRING_CopyPadNul(field_buf, p, VALUE_FIELD_LEN);
            field_buf[3] = 0;
            if (field_buf[0] == FIELD_UNKNOWN_MARKER) {
                entry->value3 = FIELD_UNKNOWN_VALUE;
            } else {
                entry->value3 = PARSE_ReadSignedLongSkipClass3_Alt(field_buf);
            }

            p += VALUE_FIELD_LEN;
            marker = *p++;
        } else {
            p += 7;
            marker = *p++;
        }
    }

    return 0;
}
