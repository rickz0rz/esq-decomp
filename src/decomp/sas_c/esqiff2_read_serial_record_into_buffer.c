typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);

LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, WORD record_mode, WORD extension_count)
{
    const UWORD RECORD_MAX = 0x2328;
    const UBYTE CH_NUL = 0;
    const UBYTE TOKEN_EXT_RECORD = 20;
    const UBYTE TOKEN_COPY_NEXT = 18;
    const WORD MODE_PLAIN = 0;
    const WORD MODE_EXTENDED = 1;
    const UWORD MIN_BREAK_INDEX = 1;
    const UWORD COPY_NEXT_LIMIT = 0x12e;
    const LONG RESULT_FAIL = 0;
    WORD d4 = 0;
    WORD local_0x12_counter = 0;

    for (;;) {
        if ((unsigned short)d4 >= RECORD_MAX) {
            break;
        }

        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[(unsigned short)d4] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();

        if (dst[(unsigned short)d4] == CH_NUL) {
            if (record_mode == MODE_PLAIN) {
                break;
            }
            if ((unsigned short)d4 > MIN_BREAK_INDEX) {
                break;
            }
        }

        if (dst[(unsigned short)d4] == TOKEN_EXT_RECORD && record_mode == MODE_EXTENDED) {
            WORD d5 = 0;
            d4 = (WORD)(d4 + 1);
            while ((unsigned short)d5 < (unsigned short)extension_count) {
                WORD index;
                ESQFUNC_WaitForClockChangeAndServiceUi();
                index = d4;
                d4 = (WORD)(d4 + 1);
                dst[(unsigned short)index] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
                d5 = (WORD)(d5 + 1);
            }
            continue;
        }

        if (dst[(unsigned short)d4] == TOKEN_COPY_NEXT && record_mode == MODE_EXTENDED) {
            WORD index;
            d4 = (WORD)(d4 + 1);
            ESQFUNC_WaitForClockChangeAndServiceUi();
            index = d4;
            d4 = (WORD)(d4 + 1);
            dst[(unsigned short)index] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
            local_0x12_counter = (WORD)(local_0x12_counter + 1);
            if ((unsigned short)local_0x12_counter >= COPY_NEXT_LIMIT) {
                return RESULT_FAIL;
            }
            continue;
        }

        d4 = (WORD)(d4 + 1);
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    return (LONG)(unsigned short)d4;
}
