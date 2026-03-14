#include <exec/types.h>
extern WORD Global_WORD_T_VALUE;
extern WORD Global_WORD_H_VALUE;
extern WORD ESQPARS2_ReadModeFlags;
extern UBYTE *Global_REF_INTB_RBF_64K_BUFFER;

LONG ESQ_ReadSerialRbfByte(void)
{
    WORD tail;
    LONG value;
    UWORD fill;

    tail = Global_WORD_T_VALUE;
    value = (LONG)Global_REF_INTB_RBF_64K_BUFFER[(UWORD)tail];

    tail = (WORD)(tail + 1);
    if (tail == (WORD)0xFA00) {
        tail = 0;
    }
    Global_WORD_T_VALUE = tail;

    fill = (UWORD)((UWORD)Global_WORD_H_VALUE - (UWORD)tail);
    if ((WORD)fill < 0) {
        fill = (UWORD)(fill + (UWORD)0xFA00);
    }

    if (ESQPARS2_ReadModeFlags == (WORD)0x0102 && fill < (UWORD)0xBB80) {
        ESQPARS2_ReadModeFlags = 0;
    }

    return value;
}
