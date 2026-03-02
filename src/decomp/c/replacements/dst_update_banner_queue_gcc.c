#include "esq_types.h"

/*
 * Target 622 GCC trial function.
 * Tick/update primary and secondary banner slots, then refresh staging when changed.
 */
extern u8 ESQ_SecondarySlotModeFlagChar;
extern s16 DST_PrimaryCountdown;
extern s16 DST_SecondaryCountdown;
extern u8 CLOCK_DaySlotIndex[];

s16 DATETIME_UpdateSelectionField(void *entry) __attribute__((noinline));
void DST_AddTimeOffset(void *clock_state, s32 a, s32 b) __attribute__((noinline));
void *DST_AllocateBannerStruct(void *banner) __attribute__((noinline));
void DST_RefreshBannerBuffer(void) __attribute__((noinline));
void DST_WriteRtcFromGlobals(void) __attribute__((noinline));

s32 DST_UpdateBannerQueue(void *pair) __attribute__((noinline, used));

s32 DST_UpdateBannerQueue(void *pair)
{
    u8 *p = (u8 *)pair;
    s32 changed = 0;

    if (p == (u8 *)0) {
        return 0;
    }

    if (*(void **)(p + 0) != (void *)0) {
        u8 *slot0 = (u8 *)*(void **)(p + 0);
        *(s16 *)(slot0 + 16) = DST_PrimaryCountdown;

        if (DATETIME_UpdateSelectionField(slot0) != 0) {
            s32 step = (*(s16 *)(slot0 + 16) != 0) ? 1 : -1;
            DST_AddTimeOffset(CLOCK_DaySlotIndex, step, 0);
            DST_PrimaryCountdown = *(s16 *)(slot0 + 16);
            DST_WriteRtcFromGlobals();
            changed = 1;
        }
    } else {
        if ((s16)(DST_PrimaryCountdown - 1) == 0) {
            DST_AddTimeOffset(CLOCK_DaySlotIndex, -1, 0);
            DST_PrimaryCountdown = 0;
            changed = 1;
        }
    }

    if (ESQ_SecondarySlotModeFlagChar == 89) {
        if (*(void **)(p + 4) != (void *)0) {
            u8 *slot1 = (u8 *)*(void **)(p + 4);
            *(s16 *)(slot1 + 16) = DST_SecondaryCountdown;

            if (DATETIME_UpdateSelectionField(slot1) != 0) {
                DST_SecondaryCountdown = *(s16 *)(slot1 + 16);
                changed = 1;
            }
        } else if ((s16)(DST_SecondaryCountdown - 1) == 0) {
            DST_SecondaryCountdown = 0;
            changed = 1;
        }
    } else if ((s16)(DST_SecondaryCountdown - 1) == 0) {
        *(void **)(p + 4) = DST_AllocateBannerStruct(*(void **)(p + 4));
        DST_SecondaryCountdown = 0;
        changed = 1;
    }

    if (changed != 0) {
        DST_RefreshBannerBuffer();
    }

    return changed;
}
