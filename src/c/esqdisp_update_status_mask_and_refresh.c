/* RESTORES: _ESQDISP_UpdateStatusMaskAndRefresh
 * MODULE:   modules/groups/a/n/esqdisp_p1_p0_esqdisp_updatestatusmaskandrefresh.s
 * STATUS:   behavioural
 *
 * Sets or clears `bits` in the status-indicator mask, and REDRAWS ONLY IF THE
 * MASK ACTUALLY CHANGED. The saved-and-compared value is the point of the
 * routine: setting a bit that is already set draws nothing.
 *
 * THE MASK IS CLAMPED TO 12 BITS AFTER THE UPDATE, NOT BEFORE. So a caller that
 * sets bit 12 or higher changes nothing and triggers no redraw, because the
 * clamp removes the bit before the comparison sees it.
 *
 * SASC-MISMATCH: dead-initial-store
 *   ref:     70ff  MOVEQ #-1,D5   then immediately overwritten by the load
 *   got:     the load alone
 *   summary: the original initialises the saved copy to -1 and overwrites it on
 *            the next instruction without reading it. SAS/C drops the dead
 *            store. Two bytes, no semantic difference -- the value cannot be
 *            observed. AGENTS.md records that a dead test can be kept alive with
 *            a zero LOCAL, but that trick keeps a BRANCH; there is no branch
 *            here to keep, so there is nothing to preserve.
 *   scope:   this site.
 *   retest:  a compiler that does not eliminate a dead store.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern long ESQDISP_StatusIndicatorMask;
extern void ESQDISP_ApplyStatusMaskToIndicators(long mask);

void ESQDISP_UpdateStatusMaskAndRefresh(long bits, long set)
{
    long previous = ESQDISP_StatusIndicatorMask;

    if (set)
        ESQDISP_StatusIndicatorMask |= bits;
    else
        ESQDISP_StatusIndicatorMask &= ~bits;

    ESQDISP_StatusIndicatorMask &= 0xfff;

    if (ESQDISP_StatusIndicatorMask != previous)
        ESQDISP_ApplyStatusMaskToIndicators(ESQDISP_StatusIndicatorMask);
}
