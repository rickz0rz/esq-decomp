typedef unsigned char UBYTE;
typedef short WORD;
typedef long LONG;

extern LONG GCOMMAND_PpvSelectionWindowMinutes;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG CONFIG_TimeWindowMinutes;
extern UBYTE COI_FMT_WRAP_CHAR_STRING_CHAR[];
extern UBYTE COI_STR_SINGLE_SPACE[];

LONG COI_TestEntryWithinTimeWindow(void *entry, void *ctx, LONG slot, LONG window, LONG tolerance);
LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);
LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, LONG slot, LONG mode);
void CLEANUP_UpdateEntryFlagBytes(void *entry, LONG slot);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, LONG a, LONG b, LONG c);
LONG GROUP_AI_JMPTBL_STRING_AppendAtNull(UBYTE *dst, const UBYTE *src);

void COI_FormatEntryDisplayText(void *entry, void *ctx, WORD slot, UBYTE *out_buf, LONG mode_marker)
{
    UBYTE *parts[5];
    LONG window;
    LONG tolerance;
    LONG slot_l;
    LONG i;
    UBYTE wrap_buf[20];
    UBYTE *wrap_ptr;

    if (mode_marker == -1) {
        window = GCOMMAND_PpvSelectionWindowMinutes;
        tolerance = GCOMMAND_PpvSelectionToleranceMinutes;
    } else {
        window = 1440;
        tolerance = CONFIG_TimeWindowMinutes;
    }

    slot_l = (LONG)slot;

    if (COI_TestEntryWithinTimeWindow(entry, ctx, slot_l, window, tolerance) == 0) {
        return;
    }

    parts[0] = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, slot_l, 1);

    if (mode_marker == -1) {
        parts[1] = (UBYTE *)0;
        parts[2] = (UBYTE *)0;
        parts[3] = (UBYTE *)0;
        mode_marker = 3;
    } else {
        parts[1] = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, slot_l, 3);
        parts[2] = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, slot_l, 4);
        parts[3] = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, slot_l, 2);
    }
    parts[4] = (UBYTE *)0;

    if (CLEANUP_TestEntryFlagYAndBit1(entry, slot_l, mode_marker) != 0) {
        UBYTE *wrap_field;

        wrap_field = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, slot_l, 6);
        GROUP_AE_JMPTBL_WDISP_SPrintf(wrap_buf, COI_FMT_WRAP_CHAR_STRING_CHAR, 19, (LONG)wrap_field, 20);
        wrap_ptr = wrap_buf;
        CLEANUP_UpdateEntryFlagBytes(entry, slot_l);
    } else {
        wrap_ptr = (UBYTE *)0;
    }

    i = 0;
    while (i < 5) {
        UBYTE *p;

        p = parts[i];
        if (p != (UBYTE *)0 && p[0] != 0) {
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out_buf, COI_STR_SINGLE_SPACE);
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out_buf, p);
        }
        i += 1;
    }

    (void)wrap_ptr;
}
