/* RESTORES: _GCOMMAND_SetPresetEntry
 * MODULE:   modules/groups/a/u/gcommand3b_p0_gcommand_setpresetentry.s
 * STATUS:   behavioural
 *
 * Stores a preset value into slot `index` of the preset table. Four bounds
 * tests guard the store and any failure returns without writing.
 *
 * The valid index range is 1 to 15, NOT 0 to 15. The original tests
 * `TST.L D7 / BLE`, so index 0 is rejected along with every negative value.
 * Slot 0 exists in the table and this function will not write it.
 *
 * The record stride is 128 BYTES and the value is the first word of the
 * record. That is why this file declares a 128-byte struct rather than the
 * plain `unsigned short[]` the other restorations use. Written as
 * `table[index * 64]` on a word array, SAS/C emits `ASL.L #6` followed by a
 * copy and a double -- 6 extra bytes -- because it scales the element index and
 * then the element size. A 128-byte element gives the original's single
 * `ASL.L #7`.
 *
 * The struct carries its own guard so a future merge with another restoration
 * that declares the same tag still compiles. SAS/C 6.51 accepts a forward tag
 * declaration only BEFORE the definition, so the guard has to be the struct's
 * own -- see AGENTS.md.
 *
 * Both parameters are `long`. The original loads them with MOVE.L and tests
 * them with TST.L and CMPI.L.
 *
 * SIZE: the reference reads 50 bytes because the epilogue carries its own
 * `_Return` label. Add the 4-byte `MOVEM.L (A7)+,D6-D7` / `RTS` for a true
 * reference of 54, against 54 emitted plus a 2-byte NOP pad. THE SIZES AGREE.
 *
 * After the struct change this function differs from the original in ONE class
 * and nothing else. All four bounds tests, every branch displacement, the
 * `ASL.L #7`, the LEA, the ADDA and the store reproduce byte for byte.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     2e2f000c 2c2f0010     MOVE.L 12(A7),D7 / MOVE.L 16(A7),D6
 *   got:     2c2f0010 2e2f000c     the same two loads, D6 first
 *   summary: the original emits prologue parameter loads in DESCENDING register
 *            order and 6.51 emits ascending. Same registers, same offsets, same
 *            size. This is the whole difference in this function.
 *   tried:   swapping the parameter order in the signature is NOT a fix -- it
 *            would change the calling convention and break every assembly
 *            caller.
 *   scope:   every multi-parameter function. See docs/compiler-version.md.
 *   retest:  a compiler that emits D7 before D6. This function then goes exact.
 */
#ifndef GCOMMANDPRESETRECORD_DEFINED
#define GCOMMANDPRESETRECORD_DEFINED
struct GcommandPresetRecord {
    unsigned short value;
    char           rest[126];
};
#endif

extern struct GcommandPresetRecord GCOMMAND_PresetValueTable[];

void GCOMMAND_SetPresetEntry(long index, long value)
{
    if (index <= 0)
        return;
    if (index >= 16)
        return;
    if (value < 0)
        return;
    if (value >= 0x1000)
        return;

    GCOMMAND_PresetValueTable[index].value = (unsigned short)value;
}
