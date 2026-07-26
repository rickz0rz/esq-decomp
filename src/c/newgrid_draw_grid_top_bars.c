/* RESTORES: NEWGRID_DrawGridTopBars
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4878000170062f002f002f3900006ba8618a4fef00104e75
 *   got:     4878000170062f002f002f3900000000610000004fef00104e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *NEWGRID_HeaderRastPortPtr;
extern void  NEWGRID_FillGridRects(void *rp, long a, long b, long c);
void NEWGRID_DrawGridTopBars(void)
{
    NEWGRID_FillGridRects(NEWGRID_HeaderRastPortPtr, 6, 6, 1);
}
