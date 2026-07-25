/* RESTORES: ESQSHARED4_SnapshotDisplayBufferBases
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: pointer-vs-direct-move
 *   ref:     2f0943f9000086be23d100005e4043f9000086c223d100005e4443f9000086c623d100005e48225f4e75
 *   got:     23f9000000000000000023f9000000000000000023f900000000000000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2;
extern long ESQPARS2_SnapshotLivePlane0Base, ESQPARS2_SnapshotLivePlane1Base, ESQPARS2_SnapshotLivePlane2Base;
void ESQSHARED4_SnapshotDisplayBufferBases(void)
{
    ESQPARS2_SnapshotLivePlane0Base = ESQSHARED_LivePlaneBase0;
    ESQPARS2_SnapshotLivePlane1Base = ESQSHARED_LivePlaneBase1;
    ESQPARS2_SnapshotLivePlane2Base = ESQSHARED_LivePlaneBase2;
}
