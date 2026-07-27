/* RESTORES: _ESQ_TryRomWriteTest
 * MODULE:   modules/groups/a/a/app3_esqtryromwritetest.s
 * STATUS:   exact
 *
 * Reports the ROM write test as having succeeded, unconditionally. Four bytes:
 * MOVEQ #1 and RTS.
 *
 * The module comment calls it "attempts a ROM write-test sequence"; it does not.
 * Whatever it once did was removed and the stub left behind, and its one caller
 * (ESQ_SupervisorColdReboot) therefore always takes the success path. Restoring
 * it as `return 1` is faithful to the shipped program, not to the description.
 */

long ESQ_TryRomWriteTest(void)
{
    return 1;
}
