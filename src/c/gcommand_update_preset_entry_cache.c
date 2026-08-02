/* RESTORES: _GCOMMAND_UpdatePresetEntryCache
 * MODULE:   modules/groups/a/u/gcommand3b_p1.s
 * STATUS:   behavioural
 *
 * Recomputes the four cached preset increments in a record, from the four
 * source bytes at +55 and the span at +32.
 *
 * A NEGATIVE SPAN MEANS "NOT SET" AND THE CACHE IS LEFT ALONE. `TST.L / BMI`
 * returns without writing anything, so a record whose span has never been
 * computed keeps whatever the cache already held rather than being filled with
 * garbage.
 *
 * THE TWO CURSORS LIVE IN FRAME SLOTS, NOT REGISTERS, because D6, D7 and A3 are
 * already taken by the span, the counter and the record. That is a register
 * pressure artifact of the original and carries no meaning, so the C uses
 * ordinary locals and lets SAS/C place them.
 *
 * THE FOUR SOURCE BYTES ARE AT +55, NOT ADJACENT TO THE CACHE AT +36. There are
 * three bytes of something else between the end of the cache and the start of
 * the bytes, so the two runs cannot be folded into one struct member.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern long GCOMMAND_ComputePresetIncrement(long value, long span);

void GCOMMAND_UpdatePresetEntryCache(unsigned char *rec)
{
    long span = *(long *)(rec + 32);
    long *cache;
    unsigned char *source;
    long i;

    if (span < 0)
        return;

    cache = (long *)(rec + 36);
    source = rec + 55;

    for (i = 0; i < 4; i++) {
        *cache = GCOMMAND_ComputePresetIncrement((long)*source, span);
        cache++;
        source++;
    }
}
