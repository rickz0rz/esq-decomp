typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);

WORD ESQIFF2_ReadSerialSizedTextRecord(char *dst, LONG payload_size)
{
    LONG payload_read;
    WORD write_pos;
    LONG trailer_len;
    LONG trailer_read;

    if (payload_size <= 0 || payload_size >= 0x2328L) {
        return 0;
    }

    payload_read = 0;
    write_pos = 0;
    while (payload_read < payload_size && write_pos < (WORD)0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[write_pos++] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        payload_read++;
    }

    dst[write_pos] = '\0';
    trailer_len = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(dst);
    dst[write_pos] = ' ';
    trailer_read = 0;

    while (write_pos > 0 && dst[write_pos - 1] != '\0' && trailer_read < trailer_len && write_pos < (WORD)0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[write_pos++] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        trailer_read++;
    }

    if (!(write_pos > 0 && dst[write_pos - 1] == '\0' && trailer_read == trailer_len)) {
        write_pos = 0;
        dst[0] = '\0';
    } else {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    }

    return write_pos;
}
