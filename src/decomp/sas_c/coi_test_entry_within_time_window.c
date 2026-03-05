typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

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

    result = 1;
    delta_minutes = 0;
    offset_minutes = 0;
    sub_entry = (UBYTE *)0;
    anim = (UBYTE *)0;

    if (entry == (UBYTE *)0 || time_ctx == (void *)0 || slot <= 0) {
        result = 0;
        return result;
    }

    if (slot < 49) {
        offset_minutes = GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset((LONG)entry[0], time_ctx, (LONG)slot);
    } else {
        offset_minutes = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)slot - (LONG)CLOCK_HalfHourSlotIndex, 30);
    }

    if ((entry[27] & 16) != 0) {
        LONG i;
        LONG count;
        UBYTE **table;

        anim = *(UBYTE **)(entry + 48);
        if (anim != (UBYTE *)0) {
            count = (LONG)*(WORD *)(anim + 36);
            i = 0;
            while (i < count) {
                table = *(UBYTE ***)(anim + 38);
                sub_entry = table[i];
                if (*(WORD *)sub_entry == slot) {
                    break;
                }
                sub_entry = (UBYTE *)0;
                i += 1;
            }

            if (sub_entry != (UBYTE *)0) {
                delta_minutes = *(LONG *)(sub_entry + 26);
            } else {
                delta_minutes = *(LONG *)(anim + 32);
            }

            if (delta_minutes == -1) {
                delta_minutes = fallback_delta;
            }
        } else {
            delta_minutes = fallback_delta;
        }
    } else {
        delta_minutes = COI_ComputeEntryTimeDeltaMinutes(entry, (LONG)slot) - offset_minutes;
    }

    if (delta_minutes < 0 || offset_minutes > max_offset || offset_minutes < -delta_minutes) {
        result = 0;
    }

    return result;
}
