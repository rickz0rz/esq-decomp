/* RESTORES: NEWGRID_DrawTopBorderLine
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e73000227900006ba870072c79000028584eaefeaa227900006ba870002200243c000002b776014eaefece4cdf000c4e75
 *   got:     48e730022279000000002c790000000070074eaefeaa22790000000070002200243c000002b776014eaefece4cdf400c4e75
 *   summary: The OS call itself now matches exactly -- SAS/C's #pragma libcall emits the same MOVEA.L base,A6 / JSR _LVOxxx(A6) the original uses, with identical LVO offsets. The remaining gap is A6 handling: SAS/C treats A6 as callee-saved and adds it to the MOVEM save/restore masks (48e73002 / 4cdf400c) where the original treats A6 as scratch and does not save it (48e73000 / 4cdf000c), and it orders the base load before the argument setup. Not an option: CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it. This is now a single narrow code-generator difference rather than an unknown, and it affects every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <proto/graphics.h>
extern struct RastPort *NEWGRID_HeaderRastPortPtr;
void NEWGRID_DrawTopBorderLine(void)
{
    SetAPen(NEWGRID_HeaderRastPortPtr, 7);
    RectFill(NEWGRID_HeaderRastPortPtr, 0, 0, 695, 1);
}
