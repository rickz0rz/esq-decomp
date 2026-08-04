/* RESTORES: ESQFUNC_ServiceGridAlertsAndTick
 * MODULE:   modules/groups/a/n/esqfunc_p2.s   (its only block)
 * STATUS:   behavioural
 *
 * Services the grid message queue, runs any pending alert, and ticks the text
 * display state -- the three things the idle path does once per pass.
 *
 * IT CARRIED NO LABEL UNTIL 2026-08-04, and it is dead: the module before it in
 * src/Prevue.asm ends in RTS, so nothing reaches it by name or by fall-through.
 * Adding the label is byte-neutral. The name is OURS, chosen from what the
 * block does.
 *
 * THE ALERT CALL IS GUARDED AND THE OTHER TWO ARE NOT. CLEANUP_ProcessAlerts
 * runs only when CLEANUP_PendingAlertFlag is non-zero; the grid service and the
 * display tick run unconditionally either side of it.
 *
 * SASC-MISMATCH: tail-call-not-merged
 *   ref:     three JSRs and an RTS, all reached PC-relative
 *   got:     the same three calls under CODE=FAR as JSR abs.L
 *   summary: the call encoding is the manifest's, not this function's -- see
 *            AGENTS.md on ESQ_FARCALLS. Nothing else differs.
 *   scope:   program-wide.
 *   retest:  a byte-exact manifest builds without CODE=FAR and lands on the
 *            original encoding.
 */
extern short CLEANUP_PendingAlertFlag;
extern void  ESQDISP_ProcessGridMessagesIfIdle(void);
extern void  CLEANUP_ProcessAlerts(void);
extern void  TEXTDISP_TickDisplayState(void);

void ESQFUNC_ServiceGridAlertsAndTick(void)
{
    ESQDISP_ProcessGridMessagesIfIdle();
    if (CLEANUP_PendingAlertFlag != 0)
        CLEANUP_ProcessAlerts();
    TEXTDISP_TickDisplayState();
}
