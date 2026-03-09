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

typedef struct DST_BannerStruct {
    UBYTE pad0[16];
    WORD countdown16;
} DST_BannerStruct;

typedef struct DST_BannerPair {
    DST_BannerStruct *primaryBanner;
    DST_BannerStruct *secondaryBanner;
} DST_BannerPair;

LONG DST_UpdateBannerQueue(void *pair)
{
    const LONG PTR_NULL = 0;
    const LONG COUNTDOWN_ACTIVE = 1;
    const LONG STEP_FORWARD = 1;
    const LONG STEP_BACKWARD = -1;
    const LONG OFFSET_ZERO = 0;
    const UBYTE SECONDARY_MODE_ENABLED = 89;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    DST_BannerPair *p = (DST_BannerPair *)pair;
    LONG changed = FLAG_FALSE;

    if (p == (DST_BannerPair *)PTR_NULL) {
        return FLAG_FALSE;
    }

    if (p->primaryBanner != (DST_BannerStruct *)PTR_NULL) {
        DST_BannerStruct *slot0 = p->primaryBanner;
        slot0->countdown16 = DST_PrimaryCountdown;

        if (DATETIME_UpdateSelectionField(slot0) != 0) {
            LONG step = (slot0->countdown16 != FLAG_FALSE) ? STEP_FORWARD : STEP_BACKWARD;
            DST_AddTimeOffset(CLOCK_DaySlotIndex, step, OFFSET_ZERO);
            DST_PrimaryCountdown = slot0->countdown16;
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
        if (p->secondaryBanner != (DST_BannerStruct *)PTR_NULL) {
            DST_BannerStruct *slot1 = p->secondaryBanner;
            slot1->countdown16 = DST_SecondaryCountdown;

            if (DATETIME_UpdateSelectionField(slot1) != 0) {
                DST_SecondaryCountdown = slot1->countdown16;
                changed = FLAG_TRUE;
            }
        } else if ((WORD)(DST_SecondaryCountdown - COUNTDOWN_ACTIVE) == FLAG_FALSE) {
            DST_SecondaryCountdown = FLAG_FALSE;
            changed = FLAG_TRUE;
        }
    } else if ((WORD)(DST_SecondaryCountdown - COUNTDOWN_ACTIVE) == FLAG_FALSE) {
        p->secondaryBanner = (DST_BannerStruct *)DST_AllocateBannerStruct(p->secondaryBanner);
        DST_SecondaryCountdown = FLAG_FALSE;
        changed = FLAG_TRUE;
    }

    if (changed != FLAG_FALSE) {
        DST_RefreshBannerBuffer();
    }

    return changed;
}
