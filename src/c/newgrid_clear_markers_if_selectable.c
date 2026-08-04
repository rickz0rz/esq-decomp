/* RESTORES: NEWGRID_ClearMarkersIfSelectable
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * Clears the selection bit on every slot of every selectable entry, across both
 * groups.
 *
 * The two halves are the SAME loop written out twice -- once for group 1 and
 * once for group 2 -- with different count and present-flag globals and a
 * different mode argument. The original does not share them, and neither does
 * this: writing a helper would produce a call the original does not have.
 *
 * The whole thing is skipped when the mode parameter is 1 or less
 * (MOVEQ #1 / CMP.W / BLE), which is tested ONCE before either loop.
 *
 * The inner clear runs slots 1 through 48 -- it starts at 1, not 0, and stops
 * at 49 -- and the bit is 5 of the byte at 7 + slot of the AUX record. Note the
 * clear uses the AUX pointer while the selectable test uses BOTH pointers.
 *
 * Both pointers are parked in frame slots across the selectable call, which is
 * the reserved-A5 spill class.
 *
 * 222 ref vs 212 got. Both loops, both mode arguments, the MOVEQ #1 limit
 * guard, the MOVEQ #49 slot bound, the LEA 24(A7),A7 cleanups and both
 * selectable calls match in kind and size, and the two halves are emitted
 * separately in both -- no shared tail.
 *
 * SASC-MISMATCH: bclr-vs-and
 *   ref:     08b000054807       BCLR #5,7(A0,D4.L)
 *   got:     70df c0334807 17804807
 *                               MOVEQ #-33,D0 / AND.B (A3,D4.L),D0 /
 *                               MOVE.B D0,(A3,D4.L)
 *   summary: the original clears the bit in place with BCLR; 6.51 loads,
 *            masks with ~0x20 and stores back. Same result, and 6.51 is 4
 *            bytes cheaper at each of the two sites because BCLR on an indexed
 *            operand is a long instruction.
 *   tried:   nothing from the source side -- `&= ~0x20` is the only way to
 *            spell it, and SAS/C has no bit-clear intrinsic.
 *   scope:   any single-bit clear on an indexed byte.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridAuxRecord {
    char pad0[7];
    char slots[49];             /* +7, indexed 1..48 */
};

extern void *ESQDISP_GetEntryPointerByMode(long index,
                                                           long mode);
extern struct NewGridAuxRecord *ESQDISP_GetEntryAuxPointerByMode(
    long index, long mode);
extern long NEWGRID_TestEntrySelectable(void *entry, void *aux, long mode);

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern unsigned char  TEXTDISP_PrimaryGroupPresentFlag;
extern unsigned char  TEXTDISP_SecondaryGroupPresentFlag;

void NEWGRID_ClearMarkersIfSelectable(long mode, short limit)
{
    void *entry;
    struct NewGridAuxRecord *aux;
    long i;
    long slot;

    if (limit <= 1)
        return;

    for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount
                && TEXTDISP_PrimaryGroupPresentFlag != 0; i++) {

        entry = ESQDISP_GetEntryPointerByMode(i, 1L);
        aux   = ESQDISP_GetEntryAuxPointerByMode(i, 1L);

        if (NEWGRID_TestEntrySelectable(entry, aux, mode))
            for (slot = 1; slot < 49; slot++)
                aux->slots[slot] &= ~0x20;
    }

    for (i = 0; i < TEXTDISP_SecondaryGroupEntryCount
                && TEXTDISP_SecondaryGroupPresentFlag != 0; i++) {

        entry = ESQDISP_GetEntryPointerByMode(i, 2L);
        aux   = ESQDISP_GetEntryAuxPointerByMode(i, 2L);

        if (NEWGRID_TestEntrySelectable(entry, aux, mode))
            for (slot = 1; slot < 49; slot++)
                aux->slots[slot] &= ~0x20;
    }
}
