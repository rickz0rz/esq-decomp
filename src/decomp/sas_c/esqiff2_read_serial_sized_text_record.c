typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s);

WORD ESQIFF2_ReadSerialSizedTextRecord(char *dst, LONG payload_size)
{
    register LONG trailer_len;
    register WORD write_pos;
    register LONG payload_read;
    WORD index;

    if (payload_size <= 0) {
        return 0;
    }

    if (payload_size >= 0x2328L) {
        return 0;
    }

    write_pos = 0;
    payload_read = 0;
    while (payload_read < payload_size && (UWORD)write_pos < (UWORD)0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        index = write_pos;
        write_pos = (WORD)(write_pos + 1);
        dst[(UWORD)index] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        payload_read = payload_read + 1;
    }

    dst[(UWORD)write_pos] = '\0';
    trailer_len = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(dst);
    dst[(UWORD)write_pos] = ' ';
    payload_read = 0;

    for (;;) {
        if ((LONG)(UWORD)write_pos <= 0) {
            break;
        }
        index = (WORD)(write_pos - 1);
        if (dst[(UWORD)index] == '\0') {
            break;
        }
        if (payload_read >= trailer_len) {
            break;
        }
        if ((UWORD)write_pos >= (UWORD)0x2328) {
            break;
        }
        ESQFUNC_WaitForClockChangeAndServiceUi();
        index = write_pos;
        write_pos = (WORD)(write_pos + 1);
        dst[(UWORD)index] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        payload_read = payload_read + 1;
    }

    if ((LONG)(UWORD)write_pos <= 0 ||
        dst[(LONG)(UWORD)write_pos - 1] != '\0' ||
        payload_read != trailer_len) {
        write_pos = 0;
        dst[0] = '\0';
    } else {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    }

    return write_pos;
}
