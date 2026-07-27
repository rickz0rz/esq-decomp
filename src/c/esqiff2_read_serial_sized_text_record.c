/* RESTORES: ESQIFF2_ReadSerialSizedTextRecord
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * 196 bytes in the original, 176 emitted, 7 differing regions.
 *
 * Companion to esqiff2_read_serial_record_into_buffer.c -- the length-prefixed
 * variant. Reproduces: the size validation against 0 and 0x2328, the fixed-count
 * first read, the NUL written at the end of that block so the count can be parsed
 * out of it in place, the space written back over that NUL before the second read
 * begins, the trailer loop bounded three ways (a NUL in the preceding byte, the
 * parsed count, and the absolute buffer cap), and the completion test that
 * requires BOTH the NUL terminator and an exact count match before the checksum
 * byte is consumed.
 *
 * The NUL-then-space dance is the detail to preserve: the parse is done in place
 * on the live buffer, and the byte it overwrites is restored to a space rather
 * than to whatever was there. A reconstruction that parsed into a copy would be
 * equivalent for the parse but would leave a different byte in the record.
 *
 * On failure the function resets the position to zero AND writes a NUL at the
 * head of the buffer, so a caller that ignores the return value still sees an
 * empty record rather than a partial one.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class; the whole -20.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the seven cross-unit calls.
 */
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern char ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern long ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern char ESQIFF_RecordChecksumByte;

long ESQIFF2_ReadSerialSizedTextRecord(char *buf, long size)
{
    register long count;
    register short pos;
    register long want;

    if (size <= 0)
        return 0;
    if (size >= 0x2328)
        return 0;

    count = 0;
    pos = 0;
    while (count < size && count < 0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        buf[pos] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        count++;
        pos++;
    }

    buf[pos] = 0;
    want = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(buf);
    buf[pos] = ' ';

    count = 0;
    while (buf[pos - 1] && count < want && (unsigned short)pos < 0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        buf[pos] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        count++;
        pos++;
    }

    if (buf[pos - 1] == 0 && count == want) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    } else {
        pos = 0;
        buf[0] = 0;
    }

    return pos;
}
