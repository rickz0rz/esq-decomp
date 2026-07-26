/* RESTORES: NEWGRID_DrawTopBorderLine
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: os-library-call
 *   ref:     48e73000227900006ba870072c79000028584eaefeaa227900006ba870002200243c000002b776014eaefece4cdf000c4e75
 *   got:     487800072f39000000006100000048780001487802b770002f002f002f3900000000610000004fef001c4e75
 *   summary: The original calls an AmigaOS library function through an explicit base register (MOVEA.L base,A6 / JSR _LVOxxx(A6)). Reproducing that from C requires the SAS/C #pragma libcall machinery and the matching library base; plain extern calls will not match. Recorded rather than guessed at.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *NEWGRID_HeaderRastPortPtr;
extern void SetAPen(void *rp, long pen);
extern void RectFill(void *rp, long x1, long y1, long x2, long y2);
void NEWGRID_DrawTopBorderLine(void)
{
    SetAPen(NEWGRID_HeaderRastPortPtr, 7);
    RectFill(NEWGRID_HeaderRastPortPtr, 0, 0, 695, 1);
}
