#include <stdint.h>

extern int16_t CLOCK_MinuteTrigger30MinusBase;
extern int16_t CLOCK_MinuteTrigger60MinusBase;
extern int16_t CLOCK_MinuteTriggerBaseOffsetPlus30;
extern int16_t CLOCK_MinuteTriggerBaseOffset;

void ESQ_SeedMinuteEventThresholds(int32_t base_minute, int32_t base_offset) {
    CLOCK_MinuteTrigger60MinusBase = (int16_t)(60 - (int16_t)base_minute);
    CLOCK_MinuteTrigger30MinusBase = (int16_t)(30 - (int16_t)base_minute);
    CLOCK_MinuteTriggerBaseOffset = (int16_t)base_offset;
    CLOCK_MinuteTriggerBaseOffsetPlus30 = (int16_t)((int16_t)base_offset + 30);
}
