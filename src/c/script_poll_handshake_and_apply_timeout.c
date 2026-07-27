/* RESTORES: SCRIPT_PollHandshakeAndApplyTimeout
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-vs-saved-register
 *   ref:     4a790000a3546734610000544a00672c30390000bf082200524133c10000bf087014b2406516700033c00000a82433fc00240000a2e033c00000bf084e75
 *   got:     2f074a79000000006732610000004a00672a3039000000003e00524733c7000000007014be40651442790000000033fc0024000000004279000000002e1f4e75
 *   summary: 62 bytes against 64. The original keeps the tick counter in scratch
 *            D1 and so needs no prologue at all; SAS/C promotes it to D7 and pays
 *            for a MOVE.L D7,-(A7) / MOVE.L (A7)+,D7 pair. Every instruction in
 *            between is the same operation on a different register.
 *   tried:   SHORTINT, plain and register locals, direct read-modify-write of the
 *            global instead of a local.
 *   scope:   short-lived locals in leaf functions.
 *   retest:  a compiler that prefers scratch registers for a value that does not
 *            live across a call will emit the original's shape.
 */
extern short SCRIPT_CtrlInterfaceEnabledFlag;
extern unsigned short SCRIPT_CtrlLineAssertedTicks;
extern short ESQIFF_ExternalAssetFlags;
extern short LADFUNC_EntryCount;
extern char SCRIPT_ReadHandshakeBit5Mask(void);
void SCRIPT_PollHandshakeAndApplyTimeout(void)
{
    unsigned short ticks;
    if (!SCRIPT_CtrlInterfaceEnabledFlag) return;
    if (!SCRIPT_ReadHandshakeBit5Mask()) return;
    ticks = SCRIPT_CtrlLineAssertedTicks + 1;
    SCRIPT_CtrlLineAssertedTicks = ticks;
    if (ticks < 20) return;
    ESQIFF_ExternalAssetFlags = 0;
    LADFUNC_EntryCount = 0x24;
    SCRIPT_CtrlLineAssertedTicks = 0;
}
