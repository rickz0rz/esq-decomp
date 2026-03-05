extern short CLOCK_MinuteTrigger30MinusBase;
extern short CLOCK_MinuteTrigger60MinusBase;
extern short CLOCK_MinuteTriggerBaseOffsetPlus30;
extern short CLOCK_MinuteTriggerBaseOffset;

void ESQ_SeedMinuteEventThresholds(long base_minute, long base_offset)
{
    CLOCK_MinuteTrigger60MinusBase = (short)(60 - (short)base_minute);
    CLOCK_MinuteTrigger30MinusBase = (short)(30 - (short)base_minute);
    CLOCK_MinuteTriggerBaseOffset = (short)base_offset;
    CLOCK_MinuteTriggerBaseOffsetPlus30 = (short)((short)base_offset + 30);
}
