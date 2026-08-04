/* RESTORES: _ESQIFF2_ValidateFieldIndexAndLength
 * MODULE:   modules/groups/a/o/esqiff2_p1_p1.s
 * STATUS:   behavioural
 *
 * Bounds-checks a group-record parser field. The field index must be 3 or
 * less. Field 1 allows up to 10 characters and every other field allows up
 * to 7. Returns 1 when both bounds hold and 0 otherwise.
 *
 * Both parameters are `short` in ORDINARY 4-byte slots. The original reads
 * `MOVE.W 14(A7),D7` and `MOVE.W 18(A7),D6`, which is the low word of the slot
 * at 12 and the low word of the slot at 16. So the callers push longs and this
 * file must NOT be compiled with SHORTINT -- that would shrink the slot and
 * read the second argument two bytes early.
 *
 * SIZE: the reference reads 50 bytes because the epilogue carries its own
 * `_Return` label. Add the 4-byte `MOVEM.L (A7)+,D6-D7` / `RTS` for a true
 * reference of 54 against 56 emitted. Both bounds tests, both early returns,
 * every branch displacement and the whole tail reproduce in sequence.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     3e2f000e 3c2f0012     MOVE.W 14(A7),D7 / MOVE.W 18(A7),D6
 *   got:     3c2f0012 3e2f000e     the same two loads, D6 first
 *   summary: the original emits prologue parameter loads in DESCENDING register
 *            order and 6.51 emits ascending. Same registers, same offsets, same
 *            total size, opposite order.
 *   tried:   nothing source-level reaches it -- the order is the code
 *            generator's, not the source's.
 *   scope:   every multi-parameter function. See docs/compiler-version.md.
 *   retest:  a compiler that emits D7 before D6.
 *
 * SASC-MISMATCH: compare-against-one-idiom
 *   ref:     7001 be40             MOVEQ #1,D0 / CMP.W D0,D7
 *   got:     2007 5340             MOVE.L D7,D0 / SUBQ.W #1,D0
 *   summary: testing `field == 1`. The original materialises 1 and compares.
 *            6.51 copies the value and subtracts 1 to set the flags. Same test,
 *            same branch, same 4 bytes.
 *   tried:   `field == 1` and `field != 1` with the arms swapped. Both give the
 *            subtract form.
 *   scope:   2 bytes here, and it costs nothing.
 *   retest:  a compiler that emits the compare rather than the subtract.
 */

long ESQIFF2_ValidateFieldIndexAndLength(short field, short length)
{
    if (field > 3)
        return 0;

    if (field == 1) {
        if (length > 10)
            return 0;
    } else if (length > 7) {
        return 0;
    }

    return 1;
}
