typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    COI_RESULT_FALSE = 0,
    COI_SLOT_MIN_VALID = 1,
    COI_SLOT_INVALID = 49,
    COI_SLOT_MINUTES = 30,
    COI_FLAGS_OFFSET = 27,
    COI_FLAG_HAS_ANIM_TABLE = 16,
    COI_ANIM_PTR_OFFSET = 48,
    COI_ANIM_COUNT_OFFSET = 36,
    COI_ANIM_TABLE_OFFSET = 38,
    COI_SUBENTRY_DELTA_OFFSET = 26,
    COI_ANIM_FALLBACK_DELTA_OFFSET = 32,
    COI_DELTA_INVALID = -1
};

extern UWORD CLOCK_HalfHourSlotIndex;

LONG GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(LONG lead_char, const char *time_ctx, LONG slot);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
LONG COI_ComputeEntryTimeDeltaMinutes(const void *entry, LONG slot);

typedef struct COI_SubEntry {
    WORD slotKey0;
    UBYTE pad2[24];
    LONG delta26;
} COI_SubEntry;

typedef struct COI_AnimObject {
    UBYTE pad0[COI_ANIM_COUNT_OFFSET];
    WORD subEntryCount;
    COI_SubEntry **subEntryTable;
    LONG fallbackDelta32;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE leadChar0;
    UBYTE pad1[COI_FLAGS_OFFSET - 1];
    UBYTE flags27;
    UBYTE pad28[COI_ANIM_PTR_OFFSET - 28];
    COI_AnimObject *anim;
} COI_Entry;

LONG COI_TestEntryWithinTimeWindow(const UBYTE *entry, const void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta)
{
    const COI_Entry *entryView;
    LONG result;
    LONG offset_minutes;
    LONG delta_minutes;
    COI_AnimObject *anim;
    COI_SubEntry *sub_entry;

    result = 1;
    delta_minutes = 0;
    offset_minutes = 0;
    sub_entry = 0;
    anim = 0;
    entryView = (const COI_Entry *)entry;

    if (entry == 0 || time_ctx == 0 || slot < COI_SLOT_MIN_VALID) {
        result = COI_RESULT_FALSE;
        return result;
    }

    if (slot < COI_SLOT_INVALID) {
        offset_minutes = GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset((LONG)entryView->leadChar0, time_ctx, (LONG)slot);
    } else {
        offset_minutes = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)slot - (LONG)CLOCK_HalfHourSlotIndex, COI_SLOT_MINUTES);
    }

    if ((entryView->flags27 & COI_FLAG_HAS_ANIM_TABLE) != 0) {
        LONG i;
        LONG count;
        COI_SubEntry **table;

        anim = entryView->anim;
        if (anim != 0) {
            count = (LONG)anim->subEntryCount;
            i = 0;
            while (i < count) {
                table = anim->subEntryTable;
                sub_entry = table[i];
                if (sub_entry->slotKey0 == slot) {
                    break;
                }
                sub_entry = 0;
                i += 1;
            }

            if (sub_entry != 0) {
                delta_minutes = sub_entry->delta26;
            } else {
                delta_minutes = anim->fallbackDelta32;
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
