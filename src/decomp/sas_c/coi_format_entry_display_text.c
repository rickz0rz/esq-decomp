typedef unsigned char UBYTE;
typedef short WORD;
typedef long LONG;

enum {
    COI_MODE_MARKER_PPV = -1,
    COI_WINDOW_FULL_DAY_MINUTES = 1440,
    COI_FIELD_MODE_TITLE = 1,
    COI_FIELD_MODE_TEXT = 2,
    COI_FIELD_MODE_FLAG3 = 3,
    COI_FIELD_MODE_FLAG4 = 4,
    COI_FIELD_MODE_WRAP = 6,
    COI_PART_COUNT = 5,
    COI_WRAP_PRINTF_WIDTH = 19,
    COI_WRAP_BUF_LEN = 20
};

extern LONG GCOMMAND_PpvSelectionWindowMinutes;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG CONFIG_TimeWindowMinutes;
extern const char COI_FMT_WRAP_CHAR_STRING_CHAR[];
extern const char COI_STR_SINGLE_SPACE[];

LONG COI_TestEntryWithinTimeWindow(const void *entry, const void *ctx, LONG slot, LONG window, LONG tolerance);
const char *COI_GetAnimFieldPointerByMode(const void *entry, LONG slot, LONG mode);
LONG CLEANUP_TestEntryFlagYAndBit1(const void *entry, LONG slot, LONG mode);
void CLEANUP_UpdateEntryFlagBytes(void *entry, LONG slot);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

void COI_FormatEntryDisplayText(void *entry, void *ctx, WORD slot, char *out_buf, LONG mode_marker)
{
    const char *parts[COI_PART_COUNT];
    LONG window;
    LONG tolerance;
    LONG slot_l;
    LONG i;
    char wrap_buf[COI_WRAP_BUF_LEN];
    char *wrap_ptr;

    if (mode_marker == COI_MODE_MARKER_PPV) {
        window = GCOMMAND_PpvSelectionWindowMinutes;
        tolerance = GCOMMAND_PpvSelectionToleranceMinutes;
    } else {
        window = COI_WINDOW_FULL_DAY_MINUTES;
        tolerance = CONFIG_TimeWindowMinutes;
    }

    slot_l = (LONG)slot;

    if (COI_TestEntryWithinTimeWindow(entry, ctx, slot_l, window, tolerance) == 0) {
        return;
    }

    parts[0] = COI_GetAnimFieldPointerByMode(entry, slot_l, COI_FIELD_MODE_TITLE);

    if (mode_marker == COI_MODE_MARKER_PPV) {
        parts[1] = (const char *)0;
        parts[2] = (const char *)0;
        parts[3] = (const char *)0;
        mode_marker = COI_FIELD_MODE_FLAG3;
    } else {
        parts[1] = COI_GetAnimFieldPointerByMode(entry, slot_l, COI_FIELD_MODE_FLAG3);
        parts[2] = COI_GetAnimFieldPointerByMode(entry, slot_l, COI_FIELD_MODE_FLAG4);
        parts[3] = COI_GetAnimFieldPointerByMode(entry, slot_l, COI_FIELD_MODE_TEXT);
    }
    parts[4] = (const char *)0;

    if (CLEANUP_TestEntryFlagYAndBit1(entry, slot_l, mode_marker) != 0) {
        const char *wrap_field;

        wrap_field = COI_GetAnimFieldPointerByMode(entry, slot_l, COI_FIELD_MODE_WRAP);
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            wrap_buf,
            COI_FMT_WRAP_CHAR_STRING_CHAR,
            COI_WRAP_PRINTF_WIDTH,
            (LONG)wrap_field,
            COI_WRAP_BUF_LEN);
        wrap_ptr = wrap_buf;
        CLEANUP_UpdateEntryFlagBytes(entry, slot_l);
    } else {
        wrap_ptr = (char *)0;
    }

    i = 0;
    while (i < COI_PART_COUNT) {
        const char *p;

        p = parts[i];
        if (p != (const char *)0 && p[0] != 0) {
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out_buf, COI_STR_SINGLE_SPACE);
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out_buf, p);
        }
        i += 1;
    }

    (void)wrap_ptr;
}
