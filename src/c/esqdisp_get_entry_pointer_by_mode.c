/* RESTORES: _ESQDISP_GetEntryPointerByMode
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_esqdisp_getentrypointerbymode.s
 * STATUS:   behavioural
 *
 * Index a per-mode entry-pointer table, returning NULL for an unsupported mode
 * or an out-of-range index. Mode 1 selects the primary group, mode 2 the
 * secondary; every rejection path falls to the same exit.
 *
 * 96 bytes against 112, and ALL SIXTEEN are the A5 frame-pointer class below.
 * Everything else reproduces exactly: both mode tests, both signed-negative
 * checks, both zero-extended bounds compares, both index scalings and both
 * table LEAs are instruction-for-instruction identical to the original.
 *
 * Shape notes, each read off the reference:
 *   - the result is a LOCAL cleared on entry (CLR.L -4(A5)) and loaded into D0
 *     once at the shared exit, not a set of early returns. Early returns cost
 *     the shared epilogue.
 *   - the counts are zero-extended (MOVEQ #0,D0 / MOVE.W count,D0) before a
 *     signed long compare, so they are `unsigned short` against a `long` index.
 *   - the index is tested for negative separately (TST.L / BMI) rather than
 *     folded into an unsigned compare, so the index really is signed.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc  LINK.W A5,#-4      got:  (nothing)
 *            42adfffc  CLR.L -4(A5)             9bcd      SUBA.L A5,A5
 *            2b50fffc  MOVE.L (A0),-4(A5)       2a50      MOVEA.L (A0),A5
 *            2250 2b49fffc  via A1              2a50      MOVEA.L (A0),A5
 *            202dfffc 4cdf00c0 4e5d             200d 4cdf20c0
 *   summary: the original reserves A5 as a frame pointer and keeps the result
 *            in the stack slot -4(A5); 6.51 sees a function that needs no
 *            frame, frees A5 and allocates the result to it. Identical
 *            semantics throughout. Fully itemised (tools/casm.py agrees the
 *            attribution sums to the observed delta):
 *              prologue  LINK + CLR.L slot vs MOVEM + SUBA.L      -6
 *              stores    two slot stores vs two MOVEA.L           -6
 *              epilogue  slot reload + UNLK vs register move      -4
 *            The original's odd asymmetry -- MOVE.L (A0),-4(A5) on one path but
 *            MOVEA.L (A0),A1 / MOVE.L A1,-4(A5) on the other -- is an artifact
 *            of the same frame, and disappears here into one instruction twice.
 *   tried:   nothing source-side can reach it, and this is not a source
 *            question: docs/compiler-version.md "The A3/A5 divergence has a
 *            single root cause" records DEBUG=FULL, DEBUG=LINE, DEBUG=SYMBOL,
 *            STKEXT, PROFILE and OPTIMIZE all leaving 6.51 unchanged. Forcing a
 *            frame by taking the local's address would be exactly the kind of
 *            distortion the project forbids.
 *   scope:   whole-program. The original has 364 `LINK.W A5` frames and ZERO
 *            MOVEM masks containing A5; 6.51 hands A5 out as the first address
 *            register variable whenever a function needs no frame.
 *   retest:  a compiler that reserves A5 as the frame pointer. It fixes this
 *            file and its sibling with no source change.
 *
 * PROBE VALUE: `SCRIPT_SaveCtrlContextSnapshot` is the isolated A5 *register*
 * probe at 234 bytes. This pair is the compact probe for the same property in
 * its *frame* form -- 112 bytes, one class, delta fully accounted -- and the two
 * forms are one property, so a candidate compiler should flip all three at once.
 * If it flips one but not the others, the single-root-cause claim is wrong.
 *
 * SIZE NOTE: tools/coverage.py reported the sibling as 228 bytes; it is 112.
 * The extra 116 were two unlabelled `; Unreferenced Code` blocks that the
 * label-to-label extraction ran straight through. Splitting the module fixed it
 * (refbytes.py also stops at a source-file change). Scope was checked rather
 * than assumed: the program contains exactly four such blocks, all four in this
 * one module, and after the split no surveyed function absorbs one. So this was
 * a single mismeasured function, not a systemic error in the target ranking.
 */

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];

void *ESQDISP_GetEntryPointerByMode(long index, long mode)
{
    void *entry = 0;

    if (mode == 1) {
        if (index >= 0 && index < TEXTDISP_PrimaryGroupEntryCount)
            entry = TEXTDISP_PrimaryEntryPtrTable[index];
    } else if (mode == 2) {
        if (index >= 0 && index < TEXTDISP_SecondaryGroupEntryCount)
            entry = TEXTDISP_SecondaryEntryPtrTable[index];
    }

    return entry;
}
