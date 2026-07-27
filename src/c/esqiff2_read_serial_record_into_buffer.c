/* RESTORES: ESQIFF2_ReadSerialRecordIntoBuffer
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * 224 bytes in the original, 236 emitted, only FIVE differing regions.
 *
 * A serial receive loop with two escape sequences. Reproduces: the 0x2328 record
 * cap, the UI-service call before every single byte read, the NUL handling that
 * ends the record immediately in mode 0 but only past offset 1 in mode 1, the
 * 0x14 escape that copies a caller-sized extension block inline, the 0x12 escape
 * that copies exactly one following byte and counts toward a 0x12e escape budget
 * whose exhaustion returns 0, and the trailing checksum byte read into a global
 * after the loop with the byte count returned.
 *
 * EVERY comparison here is unsigned -- the record cap (BCC), the offset-past-1
 * test (BHI), the extension length (BCC) and the escape budget (BCS). Declaring
 * the counters `unsigned short` is load-bearing: with signed counters the
 * compiler emits BGE/BGT and the escape budget stops behaving the same once the
 * count passes 0x7fff. That is not reachable given the 0x2328 cap, but the
 * emitted code differs regardless.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     514f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. The escape counter is the only frame local and
 *            SAS/C keeps it in a register, but it then spends more reloading the
 *            buffer index around each call -- which is why this comes out larger
 *            despite dropping the frame.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the eight cross-unit calls.
 */
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern char ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern char ESQIFF_RecordChecksumByte;

short ESQIFF2_ReadSerialRecordIntoBuffer(char *buf, short mode, unsigned short extLen)
{
    register unsigned short i;
    register unsigned short j;
    unsigned short escCount;

    i = 0;
    escCount = 0;

    while (i < 0x2328) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        buf[i] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();

        if (buf[i] == 0) {
            if (mode == 0)
                break;
            if (i > 1)
                break;
        }

        if (buf[i] == 20 && mode == 1) {
            i++;
            for (j = 0; j < extLen; j++) {
                ESQFUNC_WaitForClockChangeAndServiceUi();
                buf[i++] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
            }
            continue;
        }

        if (buf[i] == 18 && mode == 1) {
            i++;
            ESQFUNC_WaitForClockChangeAndServiceUi();
            buf[i++] = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
            escCount++;
            if (escCount < 0x12e)
                continue;
            return 0;
        }

        i++;
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    return i;
}
