/* RESTORES: GCOMMAND_DumpGradientTable
 * MODULE:   modules/groups/a/u/gcommand3b_p0.s   (its only block)
 * STATUS:   behavioural
 *
 * A diagnostic dump of one gradient table: a header line naming it, then for
 * each of 16 colours a "COLOR n m" line followed by m value lines.
 *
 * IT CARRIED NO LABEL UNTIL 2026-08-04, and the module before it in
 * src/Prevue.asm ends in RTS, so nothing reaches it by name or by fall-through.
 * Adding the label is byte-neutral; test-hash.sh and build-split.sh pass across
 * the change. The name is OURS, chosen from what the block does.
 *
 * THE TABLE HAS TWO SHAPES AT ONCE, and reading only one of them gets it wrong.
 * The COUNT for colour n is a word at `n * 2` from the table base -- a flat
 * array of 16 counts. The VALUES for colour n are words at `n * 128 + m * 2 +
 * 32` -- a 128-byte stride with a 32-byte header. So the count array and the
 * value blocks overlap in the same object, and the counts live inside what the
 * stride would call colour 0's header.
 *
 * THE STRIDE IS WRITTEN AS A SHIFT because the original does `ASL.L #7,D0`, not
 * a multiply. AGENTS.md records that writing `* 128` instead makes SAS/C widen
 * the whole computation through SWAP/CLR.W/SWAP and spill an argument.
 *
 * THE OUTER BOUND IS 16 AND THE INNER BOUND IS THE COUNT ITSELF, re-read from
 * the table on every inner iteration rather than hoisted. That is the
 * original's shape: `MOVE.W 0(A2,D0.L),D1 / EXT.L D1 / CMP.L D1,D6` sits inside
 * the inner loop, so a count the format call somehow changed would be seen.
 * Hoisting it would be better C and different code.
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     the first two format calls share one 12-byte block, popped once
 *            with `LEA 12(A7),A7`
 *   got:     each call builds and pops its own block
 *   summary: same arguments reach both callees. Several sites in the program.
 *   scope:   program-wide; esqproto_parse.c records the same item.
 *   retest:  a compiler that defers argument-stack cleanup across calls.
 */
extern char GCOMMAND_FMT_PCT_S_COLON[];
extern char GCOMMAND_STR_GRADIENT[];
extern char GCOMMAND_FMT_COLOR_PCT_D_PCT_D[];
extern char GCOMMAND_FMT_PCT_D_PCT_03X[];
extern char GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE[];

extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

void GCOMMAND_DumpGradientTable(char *name, char *table)
{
    long colour;
    long slot;

    FORMAT_RawDoFmtWithScratchBuffer(GCOMMAND_FMT_PCT_S_COLON, name);
    FORMAT_RawDoFmtWithScratchBuffer(GCOMMAND_STR_GRADIENT);

    for (colour = 0; colour < 16; colour++) {
        FORMAT_RawDoFmtWithScratchBuffer(
            GCOMMAND_FMT_COLOR_PCT_D_PCT_D, colour,
            (long)*(short *)(table + colour * 2));

        for (slot = 0; slot < (long)*(short *)(table + colour * 2); slot++) {
            FORMAT_RawDoFmtWithScratchBuffer(
                GCOMMAND_FMT_PCT_D_PCT_03X, slot,
                (long)*(unsigned short *)(table + (colour << 7) + slot * 2 + 32));
        }
    }

    FORMAT_RawDoFmtWithScratchBuffer(
        GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE);
}
