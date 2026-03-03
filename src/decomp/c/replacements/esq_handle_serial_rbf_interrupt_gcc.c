#include <stdint.h>

typedef int16_t s16;
typedef uint16_t u16;
typedef uint8_t u8;
typedef int32_t s32;

typedef struct SerialIntCtx {
    uint8_t pad_00[24];
    s16 serial_word_24;
    uint8_t pad_1A[130];
    s16 intreq_write_156;
} SerialIntCtx;

extern s16 Global_WORD_H_VALUE;
extern s16 Global_WORD_T_VALUE;
extern s16 Global_WORD_MAX_VALUE;
extern s16 ESQ_SerialRbfErrorCount;
extern s16 ESQ_SerialRbfFillLevel;
extern s16 ESQPARS2_ReadModeFlags;
extern s32 SCRIPT_SerialReadModeOverflowCount;

s32 ESQ_HandleSerialRbfInterrupt(SerialIntCtx *ctx, u8 *rbf_base) {
    u16 head = (u16)Global_WORD_H_VALUE;
    s16 serial_word;
    s16 fill;

    rbf_base[head] = (u8)ctx->serial_word_24;
    serial_word = ctx->serial_word_24;

    if ((u16)serial_word & 0x8000U) {
        ESQ_SerialRbfErrorCount = (s16)(ESQ_SerialRbfErrorCount + 1);
    }

    head = (u16)(head + 1U);
    if (head == 0xFA00U) {
        head = 0;
    }
    Global_WORD_H_VALUE = (s16)head;

    fill = (s16)((s16)head - Global_WORD_T_VALUE);
    if (fill < 0) {
        fill = (s16)(fill + (s16)0xFA00);
    }

    ESQ_SerialRbfFillLevel = fill;
    if (fill >= Global_WORD_MAX_VALUE) {
        Global_WORD_MAX_VALUE = fill;
    }

    if (fill >= (s16)0xDAC0 && ESQPARS2_ReadModeFlags != (s16)0x0102) {
        ESQPARS2_ReadModeFlags = (s16)0x0102;
        SCRIPT_SerialReadModeOverflowCount += 1;
    }

    ctx->intreq_write_156 = (s16)0x0800;
    return 0;
}

