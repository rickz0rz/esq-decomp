typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    COI_RESULT_FALSE = 0,
    COI_RESULT_TRUE = 1,
    COI_SLOT_MIN_VALID = 1,
    COI_SLOT_INVALID = 49,
    COI_SLOT_MINUTES = 30,
    COI_ANIM_PTR_OFFSET = 48,
    COI_ANIM_COUNT_OFFSET = 36,
    COI_ANIM_TABLE_OFFSET = 38,
    COI_SUBENTRY_DELTA_OFFSET = 26,
    COI_ANIM_FALLBACK_DELTA_OFFSET = 32,
    COI_DELTA_INVALID = -1
};

extern UWORD CLOCK_HalfHourSlotIndex;

LONG GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(LONG lead_char, void *time_ctx, LONG slot);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
LONG COI_ComputeEntryTimeDeltaMinutes(void *entry, LONG slot);

LONG COI_TestEntryWithinTimeWindow(UBYTE *entry, void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta)
{
    LONG result;
    LONG offset_minutes;
    LONG delta_minutes;
    UBYTE *anim;
    UBYTE *sub_entry;

    result = COI_RESULT_TRUE;
    delta_minutes = 0;
    offset_minutes = 0;
    sub_entry = (UBYTE *)0;
    anim = (UBYTE *)0;

    if (entry == (UBYTE *)0 || time_ctx == (void *)0 || slot < COI_SLOT_MIN_VALID) {
        result = COI_RESULT_FALSE;
        return result;
    }

    if (slot < COI_SLOT_INVALID) {
        offset_minutes = GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset((LONG)entry[0], time_ctx, (LONG)slot);
    } else {
        offset_minutes = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)slot - (LONG)CLOCK_HalfHourSlotIndex, COI_SLOT_MINUTES);
    }

    if ((entry[27] & 16) != 0) {
        LONG i;
        LONG count;
        UBYTE **table;

        anim = *(UBYTE **)(entry + COI_ANIM_PTR_OFFSET);
        if (anim != (UBYTE *)0) {
            count = (LONG)*(WORD *)(anim + COI_ANIM_COUNT_OFFSET);
            i = 0;
            while (i < count) {
                table = *(UBYTE ***)(anim + COI_ANIM_TABLE_OFFSET);
                sub_entry = table[i];
                if (*(WORD *)sub_entry == slot) {
                    break;
                }
                sub_entry = (UBYTE *)0;
                i += 1;
            }

            if (sub_entry != (UBYTE *)0) {
                delta_minutes = *(LONG *)(sub_entry + COI_SUBENTRY_DELTA_OFFSET);
            } else {
                delta_minutes = *(LONG *)(anim + COI_ANIM_FALLBACK_DELTA_OFFSET);
            }

            if (delta_minutes == COI_DELTA_INVALID) {
                delta_minutes = fallback_delta;
            }
        } else {
            delta_minutes = fallback_delta;
        }
    } else {
        delta_minutes = COI_ComputeEntryTimeDeltaMinutes(entry, (LONG)slot) - offset_minutes;
    }

    if (delta_minutes < 0 || offset_minutes > max_offset || offset_minutes < -delta_minutes) {
        result = COI_RESULT_FALSE;
    }

    return result;
}
