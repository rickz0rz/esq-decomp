extern short DST_PrimaryCountdown;
extern short CLOCK_DaySlotIndex;
extern long DATETIME_BuildFromBaseDay(void *base_day, void *out_struct, short slot_base, long countdown);

enum {
    DATETIME_GLOBALS_SLOT_BASE = 54
};

long DATETIME_BuildFromGlobals(void *out_struct)
{
    long secondsResult;

    secondsResult = DATETIME_BuildFromBaseDay(
        &CLOCK_DaySlotIndex,
        out_struct,
        DATETIME_GLOBALS_SLOT_BASE,
        (long)DST_PrimaryCountdown
    );
    return secondsResult;
}
