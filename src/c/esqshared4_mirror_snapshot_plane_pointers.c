/* RESTORES: ESQSHARED4_MirrorSnapshotPlanePointers
 * MODULE:   modules/groups/a/q/esqshared4_p3_p0.s   (1 of its 3 blocks)
 * STATUS:   exact
 *
 * BYTE-EXACT, confirmed by `tools/mismatches.py --recheck` on 2026-08-04.
 * The memory-to-memory-move divergence recorded below did NOT happen: 6.51
 * emits the original's six `MOVE.W abs,abs` instructions. The note is kept
 * because it is what was expected and it was wrong, which is worth knowing
 * before predicting the same thing elsewhere.
 *
 * Copies the three banner snapshot destination pointers from the copper-list
 * words into the ESQPARS2 mirrors, one 16-bit half at a time.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04, and that made the reference for
 * its neighbour wrong. refbytes.py extracts label to label, so
 * ESQSHARED4_TickCopperAndBannerTransitions read as 388 bytes when it is 234 --
 * it had absorbed this block and the one after it. Adding both labels is
 * byte-neutral and test-hash.sh confirms it. This is the case AGENTS.md
 * describes under "not every function has a label"; the tell was a restoration
 * measuring 152 bytes short with no structural disagreement.
 *
 * IT IS DEAD. Nothing reaches it. It sits after TickCopperAndBannerTransitions'
 * RTS, so it cannot be entered by fall-through either, and now that it has a
 * name a grep finds no BSR, JSR, jump-table thunk or C call anywhere in
 * src/modules, src/data or src/c. The name is OURS, chosen from what the block
 * does; the original has none.
 *
 * EACH POINTER IS TWO SEPARATE WORDS AND NOT A LONG. The high and low halves
 * live in non-adjacent copper words, because a copper MOVE carries 16 bits of
 * data. That is why the copy is six word moves and not three long ones, and it
 * is the same split that esqshared4_program_display_window_and_copper.c
 * documents for the pointer patches.
 *
 * SASC-MISMATCH: memory-to-memory-move
 *   ref:     33f9<src>0000<dst>  MOVE.W abs,abs -- one instruction per half
 *   got:     a load into a register and a store, two instructions per half
 *   summary: the 68000 can move memory to memory in one instruction and SAS/C
 *            6.51 does not emit it. Six halves, so the cost is six extra
 *            instructions.
 *   scope:   every restoration that copies one global to another.
 *   retest:  a compiler that emits MOVE.W abs,abs.
 */
extern unsigned short ESQ_BannerSnapshotPlane0DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane0DstPtrHiWord;
extern unsigned short ESQ_BannerSnapshotPlane1DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane1DstPtrHiWord;
extern unsigned short ESQ_BannerSnapshotPlane2DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane2DstPtrHiWord;

extern unsigned short ESQPARS2_BannerSnapshotPlane0DstPtrLo;
extern unsigned short ESQPARS2_BannerSnapshotPlane0DstPtr;
extern unsigned short ESQPARS2_BannerSnapshotPlane1DstPtrLo;
extern unsigned short ESQPARS2_BannerSnapshotPlane1DstPtr;
extern unsigned short ESQPARS2_BannerSnapshotPlane2DstPtrLo;
extern unsigned short ESQPARS2_BannerSnapshotPlane2DstPtr;

void ESQSHARED4_MirrorSnapshotPlanePointers(void)
{
    ESQPARS2_BannerSnapshotPlane0DstPtrLo = ESQ_BannerSnapshotPlane0DstPtrLoWord;
    ESQPARS2_BannerSnapshotPlane0DstPtr   = ESQ_BannerSnapshotPlane0DstPtrHiWord;
    ESQPARS2_BannerSnapshotPlane1DstPtrLo = ESQ_BannerSnapshotPlane1DstPtrLoWord;
    ESQPARS2_BannerSnapshotPlane1DstPtr   = ESQ_BannerSnapshotPlane1DstPtrHiWord;
    ESQPARS2_BannerSnapshotPlane2DstPtrLo = ESQ_BannerSnapshotPlane2DstPtrLoWord;
    ESQPARS2_BannerSnapshotPlane2DstPtr   = ESQ_BannerSnapshotPlane2DstPtrHiWord;
}
