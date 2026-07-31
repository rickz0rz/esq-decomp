/* RESTORES: _DST_BuildBannerTimeWord
 * MODULE:   modules/groups/a/j/dst2_p1.s
 * STATUS:   behavioural
 *
 * 52 bytes against 52, in FIVE regions, and the regions cancel: -2 for the
 * missing LINK, +2 for the epilogue that replaces it, and three regions that
 * cost nothing. The argument shapes are all confirmed by the callee's own
 * prologue, which reads a word at 10(A5) and a byte at 15(A5).
 *
 * SASC-MISMATCH: no-frame-pointer
 *   ref:     4e55fffc ... 486dfffe ... 302dfffe 4ced00c0fff4 4e5d
 *   got:     594f     ... 486f000e ... 4fef0010 302f000a 4cdf00c0 584f
 *   summary: the original opens LINK.W A5,#-4 and reaches its one local
 *            through A5. SAS/C 6.51 opens SUBQ.W #4,A7 and reaches the same
 *            local through A7, then unwinds with LEA/ADDQ where the original
 *            uses UNLK. Net zero bytes: -2 on the prologue, +2 on the
 *            epilogue. Taking the local's address does not force a frame.
 *   tried:   sc has no frame-pointer option. The full option list has LINK,
 *            LINKerDEFine, LINKerOPTions and LINKerWITH, all of which drive
 *            the linker step, and STacKCHecK/STacKEXTend, which drive the
 *            stack-overflow prologue this project already disables.
 *   scope:   every restoration with a small frame and a call.
 *   retest:  a compiler that emits LINK for a 4-byte frame matches this.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     3e2d000a 1c2d000f      load a, then b
 *   got:     1c2f0017 3e2f0012      load b, then a
 *   summary: same two loads from the same two slots, opposite order, zero
 *            bytes. SAS/C 6.51 emits its parameter loads in reverse
 *            declaration order. script_set_ctrl_context_mode.c records the
 *            same class; nothing in the body can reach it, because the loads
 *            happen in the prologue.
 *   retest:  as above.
 *
 * SASC-MISMATCH: widening-move-width
 *   ref:     2007 48c0      MOVE.L D7,D0 / EXT.L D0
 *   got:     3007 48c0      MOVE.W D7,D0 / EXT.L D0
 *   summary: two bytes either way and the same result in D0. D7 was loaded by
 *            MOVE.W, so its upper half is undefined; EXT.L sign-extends the
 *            low word and discards it in both forms.
 *   retest:  as above.
 */
extern void DST_BuildBannerTimeEntry(long a, long b, short *out, void *unused);

short DST_BuildBannerTimeWord(short a, unsigned char b)
{
    short out;

    DST_BuildBannerTimeEntry((long)a, (long)b, &out, 0L);
    return out;
}
