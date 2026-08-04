/* RESTORES: NEWGRID_GetEntryStateCode
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0_p0.s
 * STATUS:   behavioural
 *
 * Returns a small state code for a grid entry at a 1-based slot: 0 when the
 * slot's bit is clear, otherwise 1, 2 or 3 depending on the pointer at
 * 56 + slot*4 and bit 7 of the byte at 7 + slot.
 *
 * The guards are all on the SLOT, and their widths matter: the slot is a word
 * at 30(A7), tested with TST.W / BLE (so it must be at least 1) and with
 * MOVEQ #49 / CMP.W / BGE (so it must be at most 48).
 *
 * The bit-test helper is called with the address of the entry's bitmap at +28
 * and the widened slot, and its result is tested with ADDQ.L #1 / BEQ -- so the
 * "bit clear" answer is -1, not 0. Writing `== 0` there would invert the whole
 * function.
 *
 * 98 ref vs 100 got. The four guards, the helper call and its ADDQ.L #1 test,
 * the ASL.L #2 slot scaling, the TST.L 56(An,Dn.L) and the BTST #7 all match in
 * kind and size.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70330 266f0014 246f0018 3e2f001e   D6-D7/A2-A3, ascending slots
 *   got:     48e70314 3e2f001e 266f0018 2a6f0014   D6-D7/A3/A5, slot loaded first
 *   summary: different register set and the documented descending-versus-
 *            ascending parameter load order.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause" and "Parameter and case layout".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2007 48c0 e580      MOVE.L D7,D0 / EXT.L D0 / ASL.L #2,D0
 *   got:     48c7 2007 e580      EXT.L D7 / MOVE.L D7,D0 / ASL.L #2,D0
 *   summary: the original copies the slot and widens the copy; 6.51 widens in
 *            place then copies. Same three instructions, same size, reordered.
 *            Same item as script_allocate_buffer_array.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     6708 083200077007 6704 7c03 6006 7c02 6002 7c01
 *   got:     6604 7c01 600e 08330007700767047c03 6002 7c02
 *   summary: 6.51 emits the three result arms in a different order and inverts
 *            one test to suit. Same three constants, same conditions; only
 *            which falls through. The documented case-body-layout class, and
 *            the +2.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#ifndef NEWGRIDSTATEENTRY_DEFINED
#define NEWGRIDSTATEENTRY_DEFINED
struct NewGridStateEntry {
    char pad0[28];
    char bits[1];               /* +28 */
};
#endif

#ifndef NEWGRIDSTATECTX_DEFINED
#define NEWGRIDSTATECTX_DEFINED
struct NewGridStateCtx {
    char  pad0[7];
    unsigned char flags[1];     /* +7, indexed by slot */
    char  pad8[48];
    void *slots[1];             /* +56, indexed by slot */
};
#endif

extern long ESQ_TestBit1Based(char *bits, long slot);

long NEWGRID_GetEntryStateCode(struct NewGridStateEntry *e,
                               struct NewGridStateCtx *ctx, short slot)
{
    long r = 0;

    if (e != 0 && ctx != 0 && slot > 0 && slot < 49) {
        if (ESQ_TestBit1Based(e->bits, (long)slot) == -1)
            r = 0;
        else if (ctx->slots[slot] == 0)
            r = 1;
        else if (ctx->flags[slot] & 0x80)
            r = 3;
        else
            r = 2;
    }
    return r;
}
