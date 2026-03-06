extern short DST_PrimaryCountdown;
extern short CLOCK_DaySlotIndex;
extern long DATETIME_BuildFromBaseDay(void *base_day, void *out_struct, short slot_base, long countdown);

long DATETIME_BuildFromGlobals(void *out_struct)
{
    long result;

    result = DATETIME_BuildFromBaseDay(&CLOCK_DaySlotIndex, out_struct, 54, (long)DST_PrimaryCountdown);
    return result;
}
