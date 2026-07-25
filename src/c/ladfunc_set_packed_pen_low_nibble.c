/* RESTORES: LADFUNC_SetPackedPenLowNibble
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * Replaces the low nibble of a packed pen byte. 38 bytes both ways and every
 * instruction matches -- only the two parameter loads are emitted in the
 * opposite order, exactly as in LADFUNC_ComposePackedPenByte.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     ... 1e2f0013 (D7 <- arg1) 1c2f0017 (D6 <- arg2) ...
 *   got:     ... 1c2f0017 (D6 <- arg2) 1e2f0013 (D7 <- arg1) ...
 *   summary: The original emits prologue parameter loads in declaration order,
 *            SAS/C 6.51 in ascending register order. Note the shared constant:
 *            both build 240 as MOVEQ #120 + ADD.L, since MOVEQ cannot reach it.
 *   tried:   both operand orders of `|`, with and without named locals.
 *   retest:  should match unchanged on a compiler that emits parameter loads in
 *            declaration order. Same root cause as
 *            [ladfunc_compose_packed_pen_byte.c].
 */
long LADFUNC_SetPackedPenLowNibble(unsigned char packed, unsigned char low)
{
    return ((long)packed & 240) | ((long)low & 15);
}
