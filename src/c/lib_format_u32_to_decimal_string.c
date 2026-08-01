/* RESTORES: FORMAT_U32ToDecimalString
 * MODULE:   modules/submodules/unknown8.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Writes `value` into `buf` as unsigned decimal, terminates
 * it, and returns the number of DIGITS -- not the buffer length including the
 * NUL.
 *
 * THE DIGITS ARE BUILT BACKWARDS INTO A STACK BUFFER and then copied forward.
 * The original opens `LINK.W A5,#-12` for twelve bytes, which is exactly enough
 * for the ten digits of 4294967295 with two to spare, and the loop is a
 * do-while: a value of zero still emits one '0'.
 *
 * SASC-MISMATCH: division-helper
 *   ref:     MOVEQ #10,D1 / JSR MATH_DivU32(PC)   quotient in D0, remainder D1
 *   got:     `/` and `%`, which 6.51 routes through its own __CXD33
 *   summary: the original calls the program's own MATH_DivU32, which returns
 *            both halves of the division in one call. C has no way to ask for
 *            that, so `/` and `%` are written and the compiler emits its helper
 *            twice per digit. __CXD33 is defined in
 *            modules/submodules/unknown22.s and is exported, so this links.
 *            Same digits, same order, same return value.
 *   scope:   this function and FORMAT_U32ToOctalString beside it.
 *   retest:  a compiler that keeps the remainder from a division it just did.
 */
long FORMAT_U32ToDecimalString(char *buf, unsigned long value)
{
    char tmp[12];
    long n = 0;

    do {
        tmp[n++] = (char)('0' + (value % 10));
        value /= 10;
    } while (value != 0);

    {
        long digits = n;
        while (n > 0)
            *buf++ = tmp[--n];
        *buf = 0;
        return digits;
    }
}
