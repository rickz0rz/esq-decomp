/* RESTORES: NEWGRID_TestEntryState
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0_p0.s
 * STATUS:   behavioural
 *
 * Asks whether an entry is in one of four states, choosing the group and
 * normalising the slot key first.
 *
 * THE GROUP CHOICE IS NOT A RANGE TEST. A key ABOVE 48 uses group 2, a key of
 * exactly 1 ALSO uses group 2, and everything in between uses group 1. The two
 * tests are separate (BGT then BNE) and the second falls through into the
 * group-2 arm.
 *
 * The key is then wound back into 1..48 by repeated subtraction, and only on
 * the group-2 path -- the group-1 path never normalises, because a key that
 * reached it was already in range.
 *
 * The mode dispatch is a chained subtract, and modes 2 and 3 SHARE an arm.
 *
 * Mode 1 matches state 1 OR state 3, and reading that off the bytes matters:
 * the CMP.L against 1 does not modify D0, so the following SUBQ.L #3 still
 * operates on the state, not on a difference. Mode 0 matches state 0 and the
 * shared 2/3 arm matches state 3, both through the SEQ/NEG.B booleanize.
 *
 * 236 ref vs 216 got. The group choice, the normalise loop
 * (7030 b840 6f.. 04440030 60f4), all four pointer calls, the state call, the
 * mode chain and all three booleanize arms (57c0 4400) match in kind and size.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff0 ... 2b40fffc / 2b40fff8 / 2b40fff0 ... 4e5d
 *            LINK / three results spilled to frame slots and reloaded
 *   got:     514f ... 2a40 / 2640 / 2f40001c
 *            SUBQ.W #8,A7, two kept in address registers
 *   summary: the original parks the entry pointer, the aux pointer AND the
 *            state in frame slots and reads them all back; 6.51 keeps the two
 *            pointers in registers and spills only the state. The frame plus
 *            the saved stores and reloads is the 20 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(long index,
                                                           long mode);
extern void *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(long index,
                                                              long mode);
/* The callee takes two TYPED pointers and a `short` slot. `void *, void *, long`
 * compiled alone and clashed as soon as this file was merged into one unit with
 * newgrid_get_entry_state_code.c. Separately compiled the linker checks no types,
 * so the disagreement was invisible. Forward declarations keep each struct
 * defined only in the file that owns it. The slot still occupies a 4-byte stack
 * slot either way -- only SHORTINT would change that, and it is off here.
 *
 * The guards make the pair order-independent inside a merged unit. SAS/C 6.51
 * accepts a forward declaration followed by the definition and REJECTS the
 * reverse -- "item already declared" -- so an unguarded tag declaration here
 * would compile or not depending on which file the merge happened to put
 * first. */
#ifndef NEWGRIDSTATEENTRY_DEFINED
struct NewGridStateEntry;
#endif
#ifndef NEWGRIDSTATECTX_DEFINED
struct NewGridStateCtx;
#endif
extern long  NEWGRID_GetEntryStateCode(struct NewGridStateEntry *entry,
                                       struct NewGridStateCtx *aux, short slot);

long NEWGRID_TestEntryState(long mode, long primaryIndex, long secondaryIndex,
                            short key)
{
    void *entry;
    void *aux;
    long  state;
    long  result = 0;

    if (key > 48 || key == 1) {
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(secondaryIndex, 2L);
        aux   = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(secondaryIndex,
                                                                 2L);
        while (key > 48)
            key -= 48;
    } else {
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(primaryIndex, 1L);
        aux   = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(primaryIndex,
                                                                 1L);
    }

    state = NEWGRID_GetEntryStateCode((struct NewGridStateEntry *)entry,
                                      (struct NewGridStateCtx *)aux, key);

    switch (mode) {
    case 0:
        result = (state == 0) ? 1 : 0;
        break;
    case 1:
        result = (state == 1 || state == 3) ? 1 : 0;
        break;
    case 2:
    case 3:
        result = (state == 3) ? 1 : 0;
        break;
    }

    return result;
}
