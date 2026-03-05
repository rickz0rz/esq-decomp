typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef signed long LONG;

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
    UWORD head;
    WORD serialWord;
    WORD fill;

    head = (UWORD)Global_WORD_H_VALUE;
    rbfBase[head] = (UBYTE)ctx->serial_word_24;
    serialWord = ctx->serial_word_24;

    if (((UWORD)serialWord & (UWORD)0x8000) != 0) {
        ESQ_SerialRbfErrorCount = (WORD)(ESQ_SerialRbfErrorCount + 1);
    }

    head = (UWORD)(head + 1);
    if (head == (UWORD)0xFA00) {
        head = 0;
    }
    Global_WORD_H_VALUE = (WORD)head;

    fill = (WORD)((WORD)head - Global_WORD_T_VALUE);
    if (fill < 0) {
        fill = (WORD)(fill + (WORD)0xFA00);
    }

    ESQ_SerialRbfFillLevel = fill;
    if (fill >= Global_WORD_MAX_VALUE) {
        Global_WORD_MAX_VALUE = fill;
    }

    if (fill >= (WORD)0xDAC0 && ESQPARS2_ReadModeFlags != (WORD)0x0102) {
        ESQPARS2_ReadModeFlags = (WORD)0x0102;
        SCRIPT_SerialReadModeOverflowCount += 1;
    }

    ctx->intreq_write_156 = (WORD)0x0800;
    return 0;
}
