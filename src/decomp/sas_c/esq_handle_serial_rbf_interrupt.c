#include <exec/types.h>
typedef struct SerialIntCtx {
    UBYTE pad_00[24];
    WORD serial_word_24;
    UBYTE pad_1A[130];
    WORD intreq_write_156;
} SerialIntCtx;

extern WORD Global_WORD_H_VALUE;
extern WORD Global_WORD_T_VALUE;
extern WORD Global_WORD_MAX_VALUE;
extern WORD ESQ_SerialRbfErrorCount;
extern WORD ESQ_SerialRbfFillLevel;
extern WORD ESQPARS2_ReadModeFlags;
extern LONG SCRIPT_SerialReadModeOverflowCount;

LONG ESQ_HandleSerialRbfInterrupt(SerialIntCtx *ctx, UBYTE *rbfBase)
{
    const UWORD RBF_WRAP = 0xFA00;
    const UWORD RBF_OVERFLOW_WATERMARK = 0xDAC0;
    const WORD READMODE_RBF_OVERFLOW = 0x0102;
    const WORD INTREQ_RBF = 0x0800;
    const LONG COUNTER_STEP = 1;
    const LONG RESULT_OK = 0;
    UWORD head;
    WORD serialWord;
    WORD fill;

    head = (UWORD)Global_WORD_H_VALUE;
    rbfBase[head] = (UBYTE)ctx->serial_word_24;
    serialWord = ctx->serial_word_24;

    if (serialWord < 0) {
        ESQ_SerialRbfErrorCount = (WORD)(ESQ_SerialRbfErrorCount + COUNTER_STEP);
    }

    head = (UWORD)(head + COUNTER_STEP);
    if (head == RBF_WRAP) {
        head = RESULT_OK;
    }
    Global_WORD_H_VALUE = (WORD)head;

    fill = (WORD)((WORD)head - Global_WORD_T_VALUE);
    if (fill < 0) {
        fill = (WORD)(fill + (WORD)RBF_WRAP);
    }

    ESQ_SerialRbfFillLevel = fill;
    if (fill >= Global_WORD_MAX_VALUE) {
        Global_WORD_MAX_VALUE = fill;
    }

    if ((UWORD)fill >= RBF_OVERFLOW_WATERMARK && ESQPARS2_ReadModeFlags != READMODE_RBF_OVERFLOW) {
        ESQPARS2_ReadModeFlags = READMODE_RBF_OVERFLOW;
        SCRIPT_SerialReadModeOverflowCount += COUNTER_STEP;
    }

    ctx->intreq_write_156 = INTREQ_RBF;
    return RESULT_OK;
}
