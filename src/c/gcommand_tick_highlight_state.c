/* RESTORES: GCOMMAND_TickHighlightState
 * MODULE:   modules/groups/a/u/gcommand3b_p3.s
 * STATUS:   behavioural
 *
 * One tick of the banner animation: rebuild if asked, advance the phase, wrap
 * three counters, and service the message queue.
 *
 * All three wraps compare against 98 but do DIFFERENT things:
 *   - the phase resets to 0 and pulls both offsets from their reset values
 *   - the queue slot counts DOWN and wraps to 0x61 when it goes negative
 *   - the row index counts up and resets to 0
 *
 * The row-byte step is 176, reached in the original as MOVEQ #88 / ADD.L D1,D1
 * -- the 2n constant rule -- and the interleave step is a plain 32.
 *
 * The previous-value globals are all written BEFORE their current counterparts
 * change, which is what makes them the previous values.
 *
 * The phase comparison is CMP.L global,D0 with the constant in D0, so it reads
 * "98 minus the phase"; the sense is still equality.
 *
 * 174 ref vs 168 got. Every counter update, both reset-value loads, the
 * MOVEQ #88 / ADD.L D1,D1 step of 176, the MOVEQ #32 step, the memory-to-memory
 * previous-offset copy (23f9), the 0x61 slot wrap and the two 98 comparisons
 * all match in kind and size.
 *
 * SASC-MISMATCH: dead-address-register-load
 *   ref:     48e72008 49f900008000 ... 4cdf1004
 *            A4 is SAVED, loaded with LEA _Global_REF_LONG_FILE_SCRATCH, and
 *            then never read
 *   got:     2f02 ... 241f
 *            no A4 at all
 *   summary: the original spends 10 bytes -- a MOVEM slot and a six-byte LEA --
 *            on an address register the body never uses. It is not addressing
 *            anything: every global here is reached absolutely. This is
 *            unreachable from C, which will not emit a load whose result is
 *            dead, and it is the whole 6-byte delta once the register-saving
 *            difference is netted off.
 *   tried:   nothing. Reproducing it would mean declaring a pointer local that
 *            is initialised and never read, and hoping the allocator both keeps
 *            it and picks A4 -- a wish rather than a source form, and the same
 *            reasoning that rejects the dead-store cases in
 *            textdisp_apply_source_config_all_entries.c.
 *   scope:   unknown; this is the first sighting of a dead ADDRESS-register
 *            load, as opposed to the dead frame STORES seen elsewhere. Worth
 *            watching for in other functions that save A4.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void GCOMMAND_RebuildBannerTablesFromBounds(void);
extern void GCOMMAND_ServiceHighlightMessages(void);

extern short GCOMMAND_BannerRebuildPendingFlag;
extern long  GCOMMAND_BannerPhaseIndexCurrent;
extern long  GCOMMAND_BannerRowByteOffsetCurrent;
extern long  GCOMMAND_BannerRowByteOffsetPrevious;
extern long  GCOMMAND_BannerRowByteOffsetResetValue;
extern long  ESQSHARED4_InterleaveCopyTailOffsetCurrent;
extern long  ESQSHARED4_InterleaveCopyTailOffsetReset;
extern short GCOMMAND_BannerQueueSlotCurrent;
extern short GCOMMAND_BannerQueueSlotPrevious;
extern long  GCOMMAND_BannerRowIndexCurrent;
extern long  GCOMMAND_BannerRowIndexPrevious;

void GCOMMAND_TickHighlightState(void)
{
    if (GCOMMAND_BannerRebuildPendingFlag != 0)
        GCOMMAND_RebuildBannerTablesFromBounds();

    GCOMMAND_BannerPhaseIndexCurrent++;
    GCOMMAND_BannerRowByteOffsetPrevious = GCOMMAND_BannerRowByteOffsetCurrent;

    if (GCOMMAND_BannerPhaseIndexCurrent == 98) {
        GCOMMAND_BannerPhaseIndexCurrent    = 0;
        GCOMMAND_BannerRowByteOffsetCurrent = GCOMMAND_BannerRowByteOffsetResetValue;
        ESQSHARED4_InterleaveCopyTailOffsetCurrent =
            ESQSHARED4_InterleaveCopyTailOffsetReset;
    } else {
        GCOMMAND_BannerRowByteOffsetCurrent        += 176;
        ESQSHARED4_InterleaveCopyTailOffsetCurrent += 32;
    }

    GCOMMAND_BannerQueueSlotPrevious = GCOMMAND_BannerQueueSlotCurrent;
    GCOMMAND_BannerQueueSlotCurrent--;
    if (GCOMMAND_BannerQueueSlotCurrent < 0)
        GCOMMAND_BannerQueueSlotCurrent = 0x61;

    GCOMMAND_BannerRowIndexPrevious = GCOMMAND_BannerRowIndexCurrent;
    GCOMMAND_BannerRowIndexCurrent++;
    if (GCOMMAND_BannerRowIndexCurrent == 98)
        GCOMMAND_BannerRowIndexCurrent = 0;

    GCOMMAND_ServiceHighlightMessages();
}
