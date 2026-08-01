/* RESTORES: FORMAT_U32ToOctalString
 * MODULE:   modules/submodules/unknown9.s
 * STATUS:   behavioural
 *
 * SAS/C library code, and the octal twin of FORMAT_U32ToDecimalString. Same
 * shape: digits built backwards into a twelve-byte stack buffer, copied forward,
 * terminated, and the DIGIT COUNT returned.
 *
 * NO DIVISION HERE. The original masks with 7 and shifts right by 3
 * (`ANDI.W #7` / `LSR.L #3`), so this one needs no helper at all and the C says
 * the same thing. Writing `% 8` and `/ 8` would let 6.51 reduce them to the same
 * mask and shift, but the explicit form matches the original instruction for
 * instruction and cannot be got wrong by an optimiser setting.
 *
 * A ZERO VALUE STILL EMITS ONE '0', because the loop is a do-while.
 */
long FORMAT_U32ToOctalString(char *buf, unsigned long value)
{
    char tmp[12];
    long n = 0;

    do {
        tmp[n++] = (char)('0' + (value & 7));
        value >>= 3;
    } while (value != 0);

    {
        long digits = n;
        while (n > 0)
            *buf++ = tmp[--n];
        *buf = 0;
        return digits;
    }
}
