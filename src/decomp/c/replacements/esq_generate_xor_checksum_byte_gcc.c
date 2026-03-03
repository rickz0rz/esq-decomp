#include <stdint.h>

extern uint8_t ESQIFF_RecordChecksumByte;
extern uint8_t ESQIFF_UseCachedChecksumFlag;

int32_t ESQ_GenerateXorChecksumByte(uint8_t seed, const uint8_t *src, int32_t length) {
    uint8_t checksum = ESQIFF_RecordChecksumByte;

    if (ESQIFF_UseCachedChecksumFlag != 0) {
        return (int32_t)checksum;
    }

    checksum ^= 0xFFu;
    {
        int16_t count = (int16_t)length;
        count = (int16_t)(count - 1);
        while (count >= 0) {
            checksum ^= *src++;
            count = (int16_t)(count - 1);
        }
    }

    return (int32_t)checksum;
}
