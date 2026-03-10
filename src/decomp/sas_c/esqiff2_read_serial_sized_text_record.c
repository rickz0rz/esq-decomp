typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQIFF_RecordChecksumByte;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s);

WORD ESQIFF2_ReadSerialSizedTextRecord(char *dst, LONG payload_size)
{
    const LONG RECORD_MAX_LEN = 0x2328L;
    const WORD RECORD_MAX_LEN_W = (WORD)0x2328;
    const LONG ZERO = 0;
    const WORD ZERO_W = (WORD)0;
    const char CH_NUL = '\0';
    const char CH_SPACE = ' ';
    LONG payload_read;
    WORD write_pos;
    LONG trailer_len;
    LONG trailer_read;

    if (payload_size <= ZERO || payload_size >= RECORD_MAX_LEN) {
        return ZERO_W;
    }

    payload_read = ZERO;
    write_pos = ZERO_W;
    while (payload_read < payload_size && write_pos < RECORD_MAX_LEN_W) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[write_pos++] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        payload_read++;
    }

    dst[write_pos] = CH_NUL;
    trailer_len = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(dst);
    dst[write_pos] = CH_SPACE;
    trailer_read = ZERO;

    while (write_pos > ZERO &&
           dst[write_pos - 1] != CH_NUL &&
           trailer_read < trailer_len &&
           write_pos < RECORD_MAX_LEN_W) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        dst[write_pos++] = (char)ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        trailer_read++;
    }

    if (!(write_pos > ZERO && dst[write_pos - 1] == CH_NUL && trailer_read == trailer_len)) {
        write_pos = ZERO_W;
        dst[ZERO] = CH_NUL;
    } else {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    }

    return write_pos;
}
