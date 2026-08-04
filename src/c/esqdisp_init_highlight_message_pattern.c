/* RESTORES: _ESQDISP_InitHighlightMessagePattern
 * MODULE:   modules/groups/a/n/esqdisp_p0.s
 * STATUS:   behavioural
 *
 * Seeds four ascending pattern bytes, 4 to 7, into the highlight message
 * structure at offsets 55 to 58.
 *
 * The counter is `long`. The original compares with CMP.L against a register
 * holding 4, and indexes with a long displaced index (55(A3,D7.L)), so the
 * running value is 32 bits. A `short` counter changes both.
 *
 * SIZE: the reference reads 28 bytes because the epilogue carries its own
 * `_ESQDISP_InitHighlightMessagePattern_Return` label and `refbytes.py`
 * extracts label to label. Add the 6-byte `MOVEM.L (A7)+,D7/A3` / `RTS` and the
 * true reference is 34. The emitted stream is 34 plus a 2-byte NOP pad. So the
 * sizes AGREE and the only divergence is the register below.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70110 266f000c ... 1780     MOVEM D7/A3 / MOVEA.L 12(A7),A3 / MOVE.B ...,(A3,D7.L)
 *   got:     48e70104 2a6f000c ... 1b80     the same three instructions on A5
 *   summary: three bytes differ and they are the same two-bit address-register
 *            field each time. Every other byte of the body is identical in
 *            sequence, including the loop bound, the branch displacements and
 *            the index arithmetic. The original reserves A5 as a frame pointer
 *            and takes A3 as its first address register variable.
 *   tried:   nothing. This is the project's central divergence and it is not
 *            option-selectable -- see docs/compiler-version.md.
 *   scope:   program-wide, wherever a pointer local exists.
 *   retest:  a compiler that emits 2f0b rather than 2f0d on the acceptance test.
 */

void ESQDISP_InitHighlightMessagePattern(unsigned char *msg)
{
    long i;

    for (i = 0; i < 4; i++)
        msg[55 + i] = (unsigned char)(i + 4);
}
