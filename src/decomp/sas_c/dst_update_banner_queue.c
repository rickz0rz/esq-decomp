typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern UBYTE ESQ_SecondarySlotModeFlagChar;
extern WORD DST_PrimaryCountdown;
extern WORD DST_SecondaryCountdown;
extern UBYTE CLOCK_DaySlotIndex[];

extern WORD DATETIME_UpdateSelectionField(void *entry);
extern void DST_AddTimeOffset(void *clock_state, LONG a, LONG b);
extern void *DST_AllocateBannerStruct(void *banner);
extern void DST_RefreshBannerBuffer(void);
extern void DST_WriteRtcFromGlobals(void);

LONG DST_UpdateBannerQueue(void *pair)
{
    const LONG PTR_NULL = 0;
    const LONG SLOT0_OFFSET = 0;
    const LONG SLOT1_OFFSET = 4;
    const LONG SLOT_COUNTDOWN_OFFSET = 16;
    const LONG COUNTDOWN_ACTIVE = 1;
    const LONG STEP_FORWARD = 1;
    const LONG STEP_BACKWARD = -1;
    const LONG OFFSET_ZERO = 0;
    const UBYTE SECONDARY_MODE_ENABLED = 89;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    UBYTE *p = (UBYTE *)pair;
    LONG changed = FLAG_FALSE;

    if (p == (UBYTE *)PTR_NULL) {
        return FLAG_FALSE;
    }

    if (*(void **)(p + SLOT0_OFFSET) != (void *)PTR_NULL) {
        UBYTE *slot0 = (UBYTE *)*(void **)(p + SLOT0_OFFSET);
        *(WORD *)(slot0 + SLOT_COUNTDOWN_OFFSET) = DST_PrimaryCountdown;

        if (DATETIME_UpdateSelectionField(slot0) != 0) {
            LONG step = (*(WORD *)(slot0 + SLOT_COUNTDOWN_OFFSET) != FLAG_FALSE) ? STEP_FORWARD : STEP_BACKWARD;
            DST_AddTimeOffset(CLOCK_DaySlotIndex, step, OFFSET_ZERO);
            DST_PrimaryCountdown = *(WORD *)(slot0 + SLOT_COUNTDOWN_OFFSET);
            DST_WriteRtcFromGlobals();
            changed = FLAG_TRUE;
        }
    } else {
        if ((WORD)(DST_PrimaryCountdown - COUNTDOWN_ACTIVE) == FLAG_FALSE) {
            DST_AddTimeOffset(CLOCK_DaySlotIndex, STEP_BACKWARD, OFFSET_ZERO);
            DST_PrimaryCountdown = FLAG_FALSE;
            changed = FLAG_TRUE;
        }
    }

    if (ESQ_SecondarySlotModeFlagChar == SECONDARY_MODE_ENABLED) {
        if (*(void **)(p + SLOT1_OFFSET) != (void *)PTR_NULL) {
            UBYTE *slot1 = (UBYTE *)*(void **)(p + SLOT1_OFFSET);
            *(WORD *)(slot1 + SLOT_COUNTDOWN_OFFSET) = DST_SecondaryCountdown;

            if (DATETIME_UpdateSelectionField(slot1) != 0) {
                DST_SecondaryCountdown = *(WORD *)(slot1 + SLOT_COUNTDOWN_OFFSET);
                changed = FLAG_TRUE;
            }
        } else if ((WORD)(DST_SecondaryCountdown - COUNTDOWN_ACTIVE) == FLAG_FALSE) {
            DST_SecondaryCountdown = FLAG_FALSE;
            changed = FLAG_TRUE;
        }
    } else if ((WORD)(DST_SecondaryCountdown - COUNTDOWN_ACTIVE) == FLAG_FALSE) {
        *(void **)(p + SLOT1_OFFSET) = DST_AllocateBannerStruct(*(void **)(p + SLOT1_OFFSET));
        DST_SecondaryCountdown = FLAG_FALSE;
        changed = FLAG_TRUE;
    }

    if (changed != FLAG_FALSE) {
        DST_RefreshBannerBuffer();
    }

    return changed;
}
