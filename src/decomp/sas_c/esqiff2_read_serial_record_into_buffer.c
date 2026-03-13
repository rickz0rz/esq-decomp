typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG SCRIPT_ReadNextRbfByte(void);

LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, WORD record_mode, WORD extension_count)
{
    WORD d4 = 0;
    WORD local_0x12_counter = 0;

    for (;;) {
        if ((UWORD)d4 >= (UWORD)0x2328) {
            break;
        }

        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[(UWORD)d4] = (UBYTE)SCRIPT_ReadNextRbfByte();

        if (dst[(UWORD)d4] == 0) {
            if (record_mode == 0) {
                break;
            }
            if ((UWORD)d4 > (UWORD)1) {
                break;
            }
        }

        if (dst[(UWORD)d4] == 20 && record_mode == 1) {
            WORD d5 = 0;
            d4 = (WORD)(d4 + 1);
            while ((UWORD)d5 < (UWORD)extension_count) {
                WORD index;
                ESQFUNC_WaitForClockChangeAndServiceUi();
                index = d4;
                d4 = (WORD)(d4 + 1);
                dst[(UWORD)index] = (UBYTE)SCRIPT_ReadNextRbfByte();
                d5 = (WORD)(d5 + 1);
            }
            continue;
        }

        if (dst[(UWORD)d4] == 18 && record_mode == 1) {
            WORD index;
            d4 = (WORD)(d4 + 1);
            ESQFUNC_WaitForClockChangeAndServiceUi();
            index = d4;
            d4 = (WORD)(d4 + 1);
            dst[(UWORD)index] = (UBYTE)SCRIPT_ReadNextRbfByte();
            local_0x12_counter = (WORD)(local_0x12_counter + 1);
            if ((UWORD)local_0x12_counter >= (UWORD)0x12e) {
                return 0;
            }
            continue;
        }

        d4 = (WORD)(d4 + 1);
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    return (LONG)(UWORD)d4;
}
