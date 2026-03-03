#include <stdint.h>

extern int16_t Global_WORD_T_VALUE;
extern int16_t Global_WORD_H_VALUE;
extern int16_t ESQPARS2_ReadModeFlags;
extern uint8_t *Global_REF_INTB_RBF_64K_BUFFER;

int32_t ESQ_ReadSerialRbfByte(void) {
    int16_t tail = Global_WORD_T_VALUE;
    int32_t value = Global_REF_INTB_RBF_64K_BUFFER[(uint16_t)tail];
    uint16_t fill;

    tail += 1;
    if (tail == (int16_t)0xFA00) {
        tail = 0;
    }
    Global_WORD_T_VALUE = tail;

    fill = (uint16_t)((uint16_t)Global_WORD_H_VALUE - (uint16_t)tail);
    if ((int16_t)fill < 0) {
        fill = (uint16_t)(fill + 0xFA00U);
    }

    if (ESQPARS2_ReadModeFlags == (int16_t)0x0102 && fill < 0xBB80U) {
        ESQPARS2_ReadModeFlags = 0;
    }

    return value;
}

