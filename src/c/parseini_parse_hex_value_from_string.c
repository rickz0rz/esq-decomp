/* RESTORES: PARSEINI_ParseHexValueFromString
 * MODULE:   modules/groups/b/a/parseini3.s
 * STATUS:   behavioural
 *
 * 64 bytes against 64, 5 differing regions, all of them register allocation
 * (the original's A3 against SAS/C's A5) plus the call encoding.
 *
 * The shift is its OWN STATEMENT, and that is worth 20 bytes. Written as
 * `value = (value << 4) + ParseHexDigit(...)` SAS/C evaluates the call first,
 * spills the shifted value to a stack slot it has to allocate, and lands at 84.
 * The original shifts D7 in place before the call, which is what the split form
 * emits. Same rule as the `a = b = 0` chain: match the original's ORDER, not
 * just its arithmetic.
 *
 * Reproduces: the accumulate-nibbles loop, stopping at the first character the
 * class table does not mark as a hex digit.
 *
 * The pointer is re-tested for NULL on every iteration even though it can never
 * become NULL inside the loop. That is the original's own dead test, and it is
 * kept for the reason recorded in script_split_and_normalize_search_buffer.c:
 * written any other way the compiler drops the branch and the match is lost.
 *
 * The character is used BOTH ways -- zero-extended to index the class table
 * (MOVEQ #0 / MOVE.B) and sign-extended to pass to ParseHexDigit (EXT.W/EXT.L).
 * Hence the unsigned char pointer plus an explicit (char) cast at the call.
 */
extern unsigned char WDISP_CharClassTable[];
extern long SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(long ch);

long PARSEINI_ParseHexValueFromString(unsigned char *s)
{
    register long value;
    register unsigned char *p;

    value = 0;
    p = s;
    while (p && (WDISP_CharClassTable[*p] & 0x80)) {
        value <<= 4;
        value += SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((long)(char)*p);
        p++;
    }
    return value;
}
