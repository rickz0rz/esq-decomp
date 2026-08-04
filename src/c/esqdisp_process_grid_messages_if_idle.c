/* RESTORES: ESQDISP_ProcessGridMessagesIfIdle
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     4a790000295e66144a790000a2dc660c4ab90000a2d066044eba02be4e75
 *   got:     3039000000006614303900000000660c4ab9000000006604610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short ESQDISP_GridMessagePumpBlockFlag;
extern short Global_UIBusyFlag;
extern long  NEWGRID_MessagePumpSuspendFlag;
extern void  NEWGRID_ProcessGridMessages(void);
void ESQDISP_ProcessGridMessagesIfIdle(void)
{
    if (ESQDISP_GridMessagePumpBlockFlag != 0)
        return;
    if (Global_UIBusyFlag != 0)
        return;
    if (NEWGRID_MessagePumpSuspendFlag != 0)
        return;
    NEWGRID_ProcessGridMessages();
}
