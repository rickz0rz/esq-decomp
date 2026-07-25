/* RESTORES: LADFUNC_ComposePackedPenByte
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * Packs two nibbles into one pen byte. 36 bytes both ways, and every
 * instruction matches -- only the order of the two parameter loads differs.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     ... 1e2f0013 (D7 <- arg1) 1c2f0017 (D6 <- arg2) ...
 *   got:     ... 1c2f0017 (D6 <- arg2) 1e2f0013 (D7 <- arg1) ...
 *   summary: Both end with the same register assignment and identical
 *            arithmetic; the original emits the prologue loads in parameter
 *            order, SAS/C 6.51 in ascending register order. Reversing the
 *            operands of the `|` swaps which value is computed first but does
 *            not change the load order, so it is not an evaluation-order issue.
 *            Likely the same root cause as register-allocation-order.
 *   tried:   both operand orders of `|`; with and without named locals.
 *   retest:  should match unchanged on a compiler that emits parameter loads in
 *            declaration order.
 */
long LADFUNC_ComposePackedPenByte(unsigned char high, unsigned char low)
{
    return (((long)high & 15) << 4) | ((long)low & 15);
}
