#include <stdint.h>

extern int16_t CTRL_HPreviousSample;
extern uint8_t CTRL_BUFFER[];

int32_t ESQ_CaptureCtrlBit4StreamBufferByte(void) {
    int16_t idx = CTRL_HPreviousSample;
    int32_t value = CTRL_BUFFER[(uint16_t)idx];

    idx += 1;
    if (idx == 0x01F4) {
        idx = 0;
    }
    CTRL_HPreviousSample = idx;

    return value;
}

