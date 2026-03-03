#include <stdint.h>

extern uint8_t ED_StateRingTable[];
extern int32_t ED_StateRingWriteIndex;
extern uint8_t CTRL_SampleEntryScratch[];

void ESQ_StoreCtrlSampleEntry(void) {
    int32_t index = ED_StateRingWriteIndex;
    uint8_t *dst = ED_StateRingTable + ((int16_t)index * 5);
    const uint8_t *src = CTRL_SampleEntryScratch;

    do {
        *dst++ = *src;
    } while (*src++ != 0);

    index += 1;
    if (index >= 20) {
        index = 0;
    }

    ED_StateRingWriteIndex = index;
}
