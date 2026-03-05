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
    UBYTE *p = (UBYTE *)pair;
    LONG changed = 0;

    if (p == (UBYTE *)0) {
        return 0;
    }

    if (*(void **)(p + 0) != (void *)0) {
        UBYTE *slot0 = (UBYTE *)*(void **)(p + 0);
        *(WORD *)(slot0 + 16) = DST_PrimaryCountdown;

        if (DATETIME_UpdateSelectionField(slot0) != 0) {
            LONG step = (*(WORD *)(slot0 + 16) != 0) ? 1 : -1;
            DST_AddTimeOffset(CLOCK_DaySlotIndex, step, 0);
            DST_PrimaryCountdown = *(WORD *)(slot0 + 16);
            DST_WriteRtcFromGlobals();
            changed = 1;
        }
    } else {
        if ((WORD)(DST_PrimaryCountdown - 1) == 0) {
            DST_AddTimeOffset(CLOCK_DaySlotIndex, -1, 0);
            DST_PrimaryCountdown = 0;
            changed = 1;
        }
    }

    if (ESQ_SecondarySlotModeFlagChar == 89) {
        if (*(void **)(p + 4) != (void *)0) {
            UBYTE *slot1 = (UBYTE *)*(void **)(p + 4);
            *(WORD *)(slot1 + 16) = DST_SecondaryCountdown;

            if (DATETIME_UpdateSelectionField(slot1) != 0) {
                DST_SecondaryCountdown = *(WORD *)(slot1 + 16);
                changed = 1;
            }
        } else if ((WORD)(DST_SecondaryCountdown - 1) == 0) {
            DST_SecondaryCountdown = 0;
            changed = 1;
        }
    } else if ((WORD)(DST_SecondaryCountdown - 1) == 0) {
        *(void **)(p + 4) = DST_AllocateBannerStruct(*(void **)(p + 4));
        DST_SecondaryCountdown = 0;
        changed = 1;
    }

    if (changed != 0) {
        DST_RefreshBannerBuffer();
    }

    return changed;
}
