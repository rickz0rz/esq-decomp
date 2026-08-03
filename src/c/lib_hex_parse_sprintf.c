/* RESTORES: FORMAT_U32ToHexString, _PARSE_ReadSignedLong,
 *           _PARSE_ReadSignedLong_NoBranch, UNKNOWN10_PrintfPutcToBuffer,
 *           _WDISP_SPrintf
 * MODULE:   modules/submodules/unknown10.s
 * STATUS:   behavioural
 *
 * SAS/C library code: unsigned hex formatting, strtol, and sprintf.
 *
 * FORMAT_U32ToHexString BUILDS ITS DIGITS IN THE CALLER'S ARGUMENT SLOTS.
 * `LEA 4(A7),A1` then `MOVE.B ...,(A1)+` writes over the two four-byte argument
 * slots on the stack -- exactly eight bytes, which is exactly the eight hex
 * digits of a 32-bit value. Both arguments have already been loaded into D0 and
 * A0 by then, so nothing is lost. It is reproduced with a local buffer: the
 * trick saves a frame and cannot be expressed in C, and nothing observes where
 * the scratch lived.
 *
 * IT RETURNS THE DIGIT COUNT, not the buffer length, and a zero value still
 * emits one '0' because the loop is a do-while.
 *
 * THE HEX TABLE IS LOWERCASE and is reached PC-relative from inside the
 * function, with no XDEF -- it is private to it. It lives in the CODE section,
 * and that is why this restoration computes the digit instead of reading a
 * table. See the mismatch entry below.
 *
 * SASC-MISMATCH: hex-table-lands-in-data
 *   ref:     the 16 digits sit in CODE, reached PC-relative from the loop
 *   got:     a `static char[16]` is emitted into the DATA section
 *   summary: SAS/C 6.51 places every initialised static in `data`, so writing
 *            the original's table added 16 bytes to the DATA hunk. On the CODE
 *            side padding is inert, but DATA growth moves every symbol after
 *            the insertion point, and this object links BEFORE the converted
 *            data modules -- so all 55,820 bytes of real data shifted by 16.
 *            The digit is therefore computed: `d < 10 ? '0'+d : 'a'+d-10`.
 *            Measured: table form CODE 320 / DATA 16, computed form
 *            CODE 332 / DATA 0. It costs 12 inert CODE bytes and returns the
 *            DATA hunk to its reference size.
 *   tried:   `static const char[16]` -- 6.51 still emits it into DATA
 *            (CODE 320 / DATA 16, unchanged).
 *   scope:   any restoration holding an initialised static. This is the only
 *            one so far. tools/data_offset_audit.py and the hunk1 size in
 *            build-split.sh are what catch the next.
 *   retest:  a compiler that pools a function-private constant into CODE, or
 *            an option that does. Then restore the table and the lookup.
 *
 * _PARSE_ReadSignedLong AND _PARSE_ReadSignedLong_NoBranch ARE THE SAME FUNCTION,
 * assembled twice. A diff of the two bodies shows only the label names: one
 * branches into the module's shared exported labels, the other into local copies,
 * which is what the "NoBranch" name records. One C body serves both.
 *
 * THE SIGN IS RE-READ FROM THE START OF THE STRING, not remembered. After the
 * digits are consumed the original does `CMPI.B #'-',(A1)` against the ORIGINAL
 * pointer. A leading '+' is skipped and never negates.
 *
 * IT RETURNS THE NUMBER OF CHARACTERS CONSUMED and delivers the value through an
 * out-parameter. The count is `(cursor - 1) - start`, so it excludes the
 * character that stopped the scan -- and a string with no digits at all returns
 * 0 or 1 depending on whether a sign was skipped, with the out-parameter zero.
 *
 * THE DIGIT ACCUMULATE IS `(v*4 + v)*2 + d`, which is v*10 + d. Written as `*10`
 * because that is what it computes; on a 68000 SAS/C reduces a constant multiply
 * to shifts and adds anyway.
 *
 * THE DIGIT TEST IS A SIGNED BYTE TEST after subtracting '0', so anything below
 * '0' -- including a NUL -- ends the scan through the `< 0` arm rather than the
 * `> 9` one.
 *
 * _WDISP_SPrintf IS sprintf AND IT TERMINATES THROUGH THE GLOBAL. It reads
 * Global_PrintfBufferPtr back after formatting and stores the NUL there, rather
 * than tracking the end itself, because the callback is what advanced it.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     ADDQ.L #1,Global_PrintfByteCount(A4)
 *   got:     an absolute reference through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include <stdarg.h>
#include "esq-neardata.h"

extern void WDISP_FormatWithCallback(long (*put)(long ch), char *fmt, void *args);

long FORMAT_U32ToHexString(char *buf, unsigned long value)
{
    char tmp[12];
    long n = 0;

    do {
        /* Computed, not looked up. See hex-table-lands-in-data below. */
        long d = (long)(value & 15);
        tmp[n++] = (char)(d < 10 ? '0' + d : 'a' + d - 10);
        value >>= 4;
    } while (value != 0);

    {
        long digits = n;
        while (n > 0)
            *buf++ = tmp[--n];
        *buf = 0;
        return digits;
    }
}

static long parse_signed_long(char *s, long *out)
{
    char *start = s;
    long value = 0;

    if (*s == '+' || *s == '-')
        s++;

    for (;;) {
        long d = (long)(char)(*s++ - '0');   /* signed: NUL ends via `< 0` */

        if (d < 0 || d > 9)
            break;
        value = value * 10 + d;
    }

    if (*start == '-')                      /* re-read, not remembered */
        value = -value;

    *out = value;
    return (long)((s - 1) - start);
}

long PARSE_ReadSignedLong(char *s, long *out)
{
    return parse_signed_long(s, out);
}

/* Assembled twice in the original; a diff shows only the label names differ. */
long PARSE_ReadSignedLong_NoBranch(char *s, long *out)
{
    return parse_signed_long(s, out);
}

long UNKNOWN10_PrintfPutcToBuffer(long ch)
{
    char *p = (char *)Global_PrintfBufferPtr_A4;

    Global_PrintfByteCount_A4++;
    *p++ = (char)ch;
    Global_PrintfBufferPtr_A4 = (long)p;

    return ch;
}

long WDISP_SPrintf(char *buf, char *fmt, ...)
{
    va_list ap;

    Global_PrintfByteCount_A4 = 0;
    Global_PrintfBufferPtr_A4 = (long)buf;

    va_start(ap, fmt);
    WDISP_FormatWithCallback(UNKNOWN10_PrintfPutcToBuffer, fmt, (void *)ap);
    va_end(ap);

    *(char *)Global_PrintfBufferPtr_A4 = 0;  /* terminated through the global */

    return Global_PrintfByteCount_A4;
}
