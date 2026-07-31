/* RESTORES: GCOMMAND_InitPresetTableFromPalette
 * MODULE:   modules/groups/a/u/gcommand3b_p0.s
 * STATUS:   behavioural
 *
 * Seeds sixteen preset rows from the packed seed table, sixteen entries each.
 *
 * The destination is TWO arrays sharing one base, and reading it any other way
 * gets the layout wrong. The count is written at A3 + i*2, so the first 32
 * bytes are sixteen shorts; the row data is written at A3 + i*128 + j*2 + 32
 * (ASL.L #7 for the row, plus the fixed 32), so sixteen rows of 128 bytes
 * follow the counts. The struct below says exactly that.
 *
 * The SOURCE stride is 62, not 128: the seed table is sixteen rows of 31
 * shorts, and the row offset goes through the 32-bit multiply helper because
 * 62 is not a shift.
 *
 * The inner bound RE-READS the count from memory on every iteration rather
 * than using the 16 it just stored, so the loop is written against
 * t->count[i] rather than against a constant.
 *
 * NOTE ON THE REFERENCE LENGTH. The extract ends at BRA with no epilogue,
 * because the epilogue carries its own label
 * (GCOMMAND_InitPresetTableFromPalette_Return) and refbytes.py extracts label
 * to label. The 98 bytes EXCLUDE the MOVEM/UNLK/RTS that a C restoration always
 * emits -- see AGENTS.md, "A _Return label means the reference bytes stop
 * early".
 *
 * 98 raw ref vs 92 got, so the real comparison is about 104 against 92 once the
 * epilogue is added back. The two-array indexing is confirmed correct by the
 * emitted code: 3bbc00100800 (the count store), ef80 (ASL.L #7 row stride) and
 * 31510020 (the +32 row base) all match the original.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     723e 4eba57ae         MOVEQ #62,D1 / JSR MATH_Mulu32(PC)
 *   got:     2207 eb81 9287 d281   MOVE.L D7,D1 / ASL.L #5,D1 / SUB.L D7,D1 /
 *                                  ADD.L D1,D1
 *   summary: the seed-row offset i * 62 goes to the multiply helper in the
 *            original and is strength-reduced inline by 6.51 -- 62 = (32 - 1)
 *            * 2, which is what the chain computes. Same product, same size
 *            here (8 bytes either way).
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2f400010 ... 202f0010     LINK / spill j*2 / reload
 *   got:     (no frame, the value stays in D0)
 *   summary: the original parks the scaled inner index in a frame slot across
 *            the multiply call and reloads it to finish the address; 6.51 has
 *            no frame and keeps it in a register. The frame plus the
 *            store/reload pair is the delta.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct GCommandPresetTable {
    short count[16];            /* +0,  stride 2   */
    short rows[16][64];         /* +32, stride 128 */
};

extern short GCOMMAND_PresetSeedPackedWordTable[][31];

void GCOMMAND_InitPresetTableFromPalette(struct GCommandPresetTable *t)
{
    long i, j;

    for (i = 0; i < 16; i++) {
        t->count[i] = 16;
        for (j = 0; j < t->count[i]; j++)
            t->rows[i][j] = GCOMMAND_PresetSeedPackedWordTable[i][j];
    }
}
