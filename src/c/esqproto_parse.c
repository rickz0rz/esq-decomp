/* RESTORES: _ESQPROTO_VerifyChecksumAndParseRecord,
 *           _ESQPROTO_VerifyChecksumAndParseList,
 *           _ESQPROTO_ParseDigitLabelAndDisplay,
 *           _ESQPROTO_CopyLabelToGlobal
 * MODULE:   modules/submodules/unknown.s   (4 of its 12 labels)
 * STATUS:   behavioural
 *
 * The RBF protocol handlers. Despite living in `submodules/`, these are ESQ's
 * OWN code, not SAS/C runtime -- they read the serial record buffer, verify its
 * checksum and drive the weather status display. The `unknown*.s` naming says
 * where the disassembly put them, not who wrote them.
 *
 * The two Verify functions are the same routine over a different parser:
 * Record calls UNKNOWN_ParseRecordAndUpdateDisplay, List calls
 * UNKNOWN_ParseListAndUpdateEntries. Everything else about them is identical,
 * down to the instruction.
 *
 * THE COMMAND BYTE ARRIVES AS THE LOW BYTE OF A LONG SLOT. The original reads
 * `MOVE.B 11(A7),D7`, and 11 is 8 plus 3 -- the low byte of the four-byte slot
 * at 8(A7) on a big-endian machine. The parameter is therefore declared `long`,
 * matching the externs the rest of the tree already uses, and narrowed where the
 * value is used. Declaring it `char` would also read byte 3 and would work, but
 * it would disagree with every existing declaration.
 *
 * The checksum comparison is UNSIGNED. The original zero-extends with
 * `MOVEQ #0,D1` before `MOVE.B _ESQIFF_RecordChecksumByte,D1`, so the byte is
 * cast through `unsigned char` here. `ESQIFF_RecordChecksumByte` is declared
 * plain `char` everywhere else and SAS/C's plain char is signed, so dropping the
 * cast would compare a negative number against a positive checksum and reject
 * every record with the high bit set.
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     the read call's three-long block is kept, its top slot overwritten
 *            with the length, two more longs pushed, and all 20 bytes popped at
 *            once with `LEA 20(A7),A7`
 *   got:     each call builds and pops its own block
 *   summary: same arguments reach both callees. The original saves the pops by
 *            letting the blocks overlap.
 *   scope:   several call-pair sites in the program.
 *   retest:  a compiler that defers argument-stack cleanup across calls.
 *
 * NOT LINKED YET. `unknown.s` holds twelve labels -- these four, two parser
 * entry points and six jump-table thunks -- and a C file replaces a whole
 * module. These are written now because `jmptbl_to_c.py` reads their signatures,
 * which unblocks `modules/groups/a/o/esqpars_p1.s` and its 27 thunks.
 */
#include <string.h>
#include <graphics/rastport.h>

extern short  ESQIFF_ParseAttemptCount;
extern short  ESQIFF_RecordLength;
extern char  *ESQIFF_RecordBufferPtr;
extern char   ESQIFF_RecordChecksumByte;
extern short  DATACErrs;

extern short  WDISP_WeatherStatusDigitChar;
extern char   WDISP_WeatherStatusLabelBuffer[];
extern char  *WDISP_WeatherStatusTextPtr;
extern char   WDISP_StatusListMatchPattern[];
extern short  ED_DiagnosticsScreenActive;
extern struct RastPort *Global_REF_RASTPORT_1;

extern short ESQIFF2_ReadSerialRecordIntoBuffer(char *buf, long mode, long extra);
extern long  ESQ_GenerateXorChecksumByte(long seed, char *buf, long len);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);
extern void  DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                           char *text);
extern void  UNKNOWN_ParseRecordAndUpdateDisplay(char *buf);
extern void  UNKNOWN_ParseListAndUpdateEntries(char *buf);

/* Copy a label out of the record and NUL-terminate it.
 *
 * The terminator is 18 (0x12), and the loop STORES it before noticing, then
 * overwrites it with the NUL -- which is why the store comes before both tests.
 * At most eleven bytes are consumed: index 0 through 10 inclusive.
 *
 * Returns the source pointer ADVANCED past everything it read, because
 * ESQPROTO_ParseDigitLabelAndDisplay carries on from there. The original keeps
 * that cursor in A3 across the whole function. */
static char *copy_label(char *src, char *dst)
{
    char  buf[13];
    short i;
    char  c;

    i = 0;
    for (;;) {
        c = *src++;
        buf[i] = c;
        if (c == 18)
            break;
        if (i >= 10)
            break;
        i++;
    }
    buf[i] = 0;

    strcpy(dst, buf);
    return src;
}

/* Read a record, check it, and hand it to `parse` when the checksum agrees.
 * Both public Verify functions are this routine; only `parse` differs. */
static void verify_and_parse(long cmd, void (*parse)(char *))
{
    long len;
    long sum;

    ESQIFF_ParseAttemptCount++;

    ESQIFF_RecordLength = ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr,
                                                             0L, 0L);
    len = (long)(unsigned short)ESQIFF_RecordLength;
    sum = ESQ_GenerateXorChecksumByte((long)(unsigned char)cmd,
                                      ESQIFF_RecordBufferPtr, len);

    if (sum == (long)(unsigned char)ESQIFF_RecordChecksumByte)
        (*parse)(ESQIFF_RecordBufferPtr);
    else
        DATACErrs++;
}

void ESQPROTO_VerifyChecksumAndParseRecord(long cmd)
{
    verify_and_parse(cmd, UNKNOWN_ParseRecordAndUpdateDisplay);
}

void ESQPROTO_VerifyChecksumAndParseList(long cmd)
{
    verify_and_parse(cmd, UNKNOWN_ParseListAndUpdateEntries);
}

void ESQPROTO_CopyLabelToGlobal(char *src)
{
    copy_label(src, WDISP_StatusListMatchPattern);
}

void ESQPROTO_ParseDigitLabelAndDisplay(char *src)
{
    long digit;

    digit = (long)(unsigned char)*src++;
    WDISP_WeatherStatusDigitChar = (short)digit;
    if (digit < 48 || digit > 57)
        WDISP_WeatherStatusDigitChar = 48;

    src = copy_label(src, WDISP_WeatherStatusLabelBuffer);

    WDISP_WeatherStatusTextPtr = ESQPARS_ReplaceOwnedString(src,
                                                           WDISP_WeatherStatusTextPtr);

    if (ED_DiagnosticsScreenActive != 0)
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 0L, 172L,
                                      WDISP_WeatherStatusTextPtr);
}
