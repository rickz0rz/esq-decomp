/* RESTORES: NEWGRID_TestEntrySelectable
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * Decides whether an entry can be selected in one of two modes.
 *
 * The control flow is easier to get wrong than it looks, so it is read off the
 * branch targets rather than the instruction order:
 *
 *   mode not 0 and not 1        -> return 0 immediately
 *   entry null, context null,
 *     or bit 7 of +40 clear     -> 0
 *   mode 0 and bit 2 of +27 set -> 1
 *   mode 1 and the bit test
 *     helper returns non-zero   -> 1
 *   otherwise                   -> 0
 *
 * Note the mode-0 arm FALLS THROUGH into the mode-1 test when its bit is
 * clear, and the mode-1 compare then rejects it. That is why the second
 * `mode == 1` test exists at all and why it is not redundant.
 *
 * 90 ref vs 96 got. Both BTST operands (#7 of +40, #2 of +27), the mode guard
 * pair (MOVEQ #1 / CMP.L / BNE), the helper call with its ADDQ.W #4 cleanup and
 * the TST.L on its result all match in kind and size.
 *
 * SASC-MISMATCH: result-assigned-per-arm
 *   ref:     7201 6002 7200 2c01     MOVEQ #1,D1 / BRA / MOVEQ #0,D1 / MOVE.L D1,D6
 *   got:     7c01 6002 7c00          MOVEQ #1,D6 / BRA / MOVEQ #0,D6
 *   summary: the original funnels every arm through D1 and copies to the result
 *            register once; 6.51 writes the result register directly from each
 *            arm, which removes the copy but repeats the MOVEQ at more sites.
 *            Net +6 here because 6.51 also splits the combined guard into
 *            separate early exits (200d 670c 200b 6708 rather than the
 *            original's fall-through chain).
 *   tried:   assigning through an explicit long temporary before the return,
 *            which is exactly what fixed the same shape in
 *            textdisp_should_open_editor_for_entry.c (64 -> 66 against 66).
 *            Here it does reintroduce the funnel copy (2c05, MOVE.L D5,D6) but
 *            the function grows 96 -> 100 against the original's 90, because
 *            6.51 then needs a fifth saved register. REJECTED: it buys the one
 *            instruction and loses more elsewhere. The trick is worth trying on
 *            any 1/0 result and is not automatic.
 *   scope:   any function returning a 1/0 built in branches.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70330 266f0014 246f0018 2e2f001c   D6-D7/A2-A3
 *   got:     48e70314 2e2f001c 266f0018 2a6f0014   D6-D7/A3/A5, reversed order
 *   summary: different register set and the documented parameter load order.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause" and "Parameter and case layout".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
struct NewGridSelectEntry {
    char          pad0[27];
    unsigned char flags27;      /* +27 */
    char          pad28[12];
    unsigned char flags40;      /* +40 */
};

extern long NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(struct NewGridSelectEntry *e);

long NEWGRID_TestEntrySelectable(struct NewGridSelectEntry *e, void *ctx,
                                 long mode)
{
    long r = 0;

    if (mode == 0 || mode == 1) {
        if (e == 0 || ctx == 0 || !(e->flags40 & 0x80))
            r = 0;
        else if (mode == 0 && (e->flags27 & 4))
            r = 1;
        else if (mode == 1 && NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(e) != 0)
            r = 1;
        else
            r = 0;
    }
    return r;
}
