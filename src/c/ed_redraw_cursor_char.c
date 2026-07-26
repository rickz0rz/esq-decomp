/* RESTORES: ED_RedrawCursorChar
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     22790000870270052c79000028584eaefe9e6100001622790000870270012c79000028584eaefe9e4e75
 *   got:     2f0e2279000000002c790000000070054eaefe9e6100000022790000000070014eaefe9e2c5f4e75
 *   summary: The OS call itself now matches exactly -- SAS/C's #pragma libcall emits the same MOVEA.L base,A6 / JSR _LVOxxx(A6) the original uses, with identical LVO offsets. The remaining gap is A6 handling: SAS/C treats A6 as callee-saved and adds it to the MOVEM save/restore masks (48e73002 / 4cdf400c) where the original treats A6 as scratch and does not save it (48e73000 / 4cdf000c), and it orders the base load before the argument setup. Not an option: CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it. This is now a single narrow code-generator difference rather than an unknown, and it affects every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <proto/graphics.h>
extern struct RastPort *Global_REF_RASTPORT_1;
extern void ED_DrawCursorChar(void);
void ED_RedrawCursorChar(void)
{
    SetDrMd(Global_REF_RASTPORT_1, 5);
    ED_DrawCursorChar();
    SetDrMd(Global_REF_RASTPORT_1, 1);
}
