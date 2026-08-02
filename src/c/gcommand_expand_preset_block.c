/* RESTORES: _GCOMMAND_ExpandPresetBlock
 * MODULE:   modules/groups/a/u/gcommand3b_p0_gcommand_expandpresetblock.s
 * STATUS:   behavioural
 *
 * Packs THREE BYTES INTO ONE 12-BIT COLOUR and installs it, for preset entries
 * 4 through 7. Each entry is a 3-byte record and each byte contributes its LOW
 * NIBBLE: byte 0 at shift 8, byte 1 at shift 4, byte 2 at shift 0. That is the
 * Amiga colour-register layout, so the three bytes are red, green and blue.
 *
 * IT STARTS AT ENTRY 4, NOT 0. Entries 0 to 3 are set elsewhere; this routine
 * only expands the second half of the block.
 *
 * THE MASK IS APPLIED AFTER THE SHIFT, WHICH IS WHY A BYTE ABOVE 15 CANNOT
 * CORRUPT ITS NEIGHBOURS. `ASL.L D0,D2` then `AND.L (15 << D0),D2` keeps each
 * contribution inside its own nibble. Masking to 15 first would be equivalent
 * and is not what the original does, so the order is kept.
 *
 * THE ACCUMULATOR IS A WORD. `MOVEQ #0,D0 / MOVE.W D5,D0` re-reads only the low
 * 16 bits on every round, so a carry out of bit 15 is discarded rather than
 * kept. Declaring it `long` would preserve a carry the original throws away.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern void GCOMMAND_SetPresetEntry(long index, long line);

void GCOMMAND_ExpandPresetBlock(unsigned char *block)
{
    long entry;

    for (entry = 4; entry < 8; entry++) {
        unsigned short packed = 0;
        long part;

        for (part = 0; part < 3; part++) {
            long shift = (2 - part) * 4;

            packed = (unsigned short)
                (packed + ((((long)block[entry * 3 + part]) << shift)
                           & (15L << shift)));
        }
        GCOMMAND_SetPresetEntry(entry, (long)packed);
    }
}
