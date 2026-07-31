/* RESTORES: CLEANUP_TestEntryFlagYAndBit1
 * MODULE:   modules/groups/a/e/cleanup4.s
 * STATUS:   behavioural
 *
 * Asks whether an entry's animation field holds 'Y' at a given index and bit 1
 * of the flag byte at +40 is set.
 *
 * The literal 89 in the original is the character 'Y' (MOVEQ #89,D0 then
 * CMP.B against the field). It is written as 'Y' here because that is what it
 * means; the emitted byte is the same.
 *
 * The index guard is a signed long range test, 0 through 5 inclusive
 * (TST.L / BMI, then MOVEQ #5 / CMP.L / BGT), and the mode parameter is a word
 * at 14(A5) widened with EXT.L, so it is a signed short.
 *
 * The field pointer is stored to a frame local and reloaded to index through
 * it -- the reserved-A5 spill class.
 *
 * 94 ref vs 84 got. The PEA 7, the EXT.L widening of the mode, the three
 * argument pushes, the LEA 12(A7),A7 cleanup, the MOVEQ #89 and the indexed
 * CMP.B all match in kind and size.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2b40fffc ... 206dfffc b0306800 ... 4e5d
 *            LINK / MOVE.L D0,-4(A5) / MOVEA.L -4(A5),A0 / CMP.B 0(A0,D6.L),D0
 *   got:     ... 2640 ... b0336800
 *            MOVEA.L D0,A3 / CMP.B 0(A3,D6.L),D0
 *   summary: the original parks the returned field pointer in a frame slot and
 *            loads it back to index through; 6.51 keeps it in an address
 *            register. 6 bytes of frame plus 4 for the store/reload pair.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct CleanupEntry {
    char          pad0[40];
    unsigned char flags40;      /* +40 */
};

extern char *COI_GetAnimFieldPointerByMode(struct CleanupEntry *e, long mode,
                                           long which);

long CLEANUP_TestEntryFlagYAndBit1(struct CleanupEntry *e, short mode, long idx)
{
    char *field;
    long  r;

    field = COI_GetAnimFieldPointerByMode(e, (long)mode, 7L);

    if (field != 0 && idx >= 0 && idx <= 5 && field[idx] == 'Y'
        && (e->flags40 & 2))
        r = 1;
    else
        r = 0;

    return r;
}
