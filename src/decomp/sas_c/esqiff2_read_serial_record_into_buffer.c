typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);

LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, WORD record_mode, WORD extension_count)
{
    WORD d4 = 0;
    WORD local_0x12_counter = 0;

    for (;;) {
        if ((unsigned short)d4 >= 0x2328) {
            break;
        }

        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[(unsigned short)d4] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();

        if (dst[(unsigned short)d4] == 0) {
            if (record_mode == 0) {
                break;
            }
            if ((unsigned short)d4 > 1) {
                break;
            }
        }

        if (dst[(unsigned short)d4] == 20 && record_mode == 1) {
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

        if (dst[(unsigned short)d4] == 18 && record_mode == 1) {
            WORD index;
            d4 = (WORD)(d4 + 1);
            ESQFUNC_WaitForClockChangeAndServiceUi();
            index = d4;
            d4 = (WORD)(d4 + 1);
            dst[(unsigned short)index] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
            local_0x12_counter = (WORD)(local_0x12_counter + 1);
            if ((unsigned short)local_0x12_counter >= 0x12e) {
                return 0;
            }
            continue;
        }

        d4 = (WORD)(d4 + 1);
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    return (LONG)(unsigned short)d4;
}
