/* RESTORES: ESQDISP_ApplyStatusMaskToIndicators
 * MODULE:   modules/groups/a/n/esqdisp_p1_p0.s
 * STATUS:   behavioural
 *
 * Turns a status bitmask into two indicator colour slots -- one for the primary
 * indicator (first argument 1) and one for the secondary (first argument 0).
 *
 * A mask of -1 is the "unknown" case and is tested SEPARATELY for each half,
 * with the two halves giving different results: the primary gets colour -1 and
 * the secondary gets colour -1 as well, but by different paths, and the
 * secondary returns immediately afterwards rather than falling through.
 *
 * The primary half reads bits 4 and 5:
 *   bit 4 set, bit 5 set    -> 4
 *   bit 4 set, bit 5 clear  -> 2
 *   bit 4 clear             -> 7
 *
 * The secondary half is a four-level cascade on bits 8, 0, 2 and 1:
 *   bit 8            -> 4
 *   bit 0 and bit 2  -> 4
 *   bit 0 and bit 1  -> 2
 *   bit 0 alone      -> 1
 *   bit 2 (no bit 0) -> 3
 *   bit 1 (no bit 0, no bit 2) -> 3
 *   none of them     -> 7
 *
 * Note bits 2 and 1 give the SAME colour 3 when bit 0 is clear, but they are
 * two separate arms in the original and are kept apart here for that reason.
 *
 * 240 ref vs 244 got. All eleven calls are at the same offsets with the same
 * colour constants and the same ADDQ.W #8 cleanups, and every BTST operand
 * (bits 4, 5, 8, 0, 2, 1) matches -- including the two separate bit-2 and bit-1
 * arms that both yield 3, and the bit-4/bit-5 pair which is VERBATIM:
 *
 *     ref  08070004 6726 08070005 6710 48780001 48780004
 *     got  08070004 6726 08070005 6710 48780001 48780004
 *
 * EVERY ARM IS AN if/else, AND THAT IS MEASURED. Writing the bit-5 arm as a
 * conditional expression instead -- `(mask & 0x20) ? 4L : 2L` -- makes 6.51
 * booleanize it (56c0 7202 9200 9200: SNE, then 2 minus 0xFF twice gives 4)
 * and the function drops to 232 bytes. That is EIGHT BYTES UNDER the original
 * and it matches nothing: the original branches and pushes two immediates.
 * The if/else form is 4 bytes over and reproduces the branch exactly, so it is
 * the one kept. AGENTS.md rule 1 in its usual shape -- the smaller output was
 * the less faithful one.
 */
extern void ESQDISP_SetStatusIndicatorColorSlot(long colour, long which);

void ESQDISP_ApplyStatusMaskToIndicators(long mask)
{
    if (mask == -1)
        ESQDISP_SetStatusIndicatorColorSlot(-1L, 1L);
    else if (mask & 0x10) {
        if (mask & 0x20)
            ESQDISP_SetStatusIndicatorColorSlot(4L, 1L);
        else
            ESQDISP_SetStatusIndicatorColorSlot(2L, 1L);
    }
    else
        ESQDISP_SetStatusIndicatorColorSlot(7L, 1L);

    if (mask == -1) {
        ESQDISP_SetStatusIndicatorColorSlot(-1L, 0L);
        return;
    }

    if (mask & 0x100)
        ESQDISP_SetStatusIndicatorColorSlot(4L, 0L);
    else if (mask & 1) {
        if (mask & 4)
            ESQDISP_SetStatusIndicatorColorSlot(4L, 0L);
        else if (mask & 2)
            ESQDISP_SetStatusIndicatorColorSlot(2L, 0L);
        else
            ESQDISP_SetStatusIndicatorColorSlot(1L, 0L);
    } else if (mask & 4)
        ESQDISP_SetStatusIndicatorColorSlot(3L, 0L);
    else if (mask & 2)
        ESQDISP_SetStatusIndicatorColorSlot(3L, 0L);
    else
        ESQDISP_SetStatusIndicatorColorSlot(7L, 0L);
}
