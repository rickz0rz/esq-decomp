/* RESTORES: _ED_DrawBottomHelpBarBackground
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: constant-via-moveq-shift
 *   ref:     243c000002a8                MOVE.L #680,D2
 *   got:     7455e78a                    MOVEQ #85,D2 / ASL.L #3,D2
 *   summary: SAS/C materialises 680 as 85<<3, saving two bytes. The original
 *            loads the immediate directly. Same family as shift-of-one-via-bset:
 *            SAS/C reaches for a shift where the original does not.
 *   tried:   NOOPTPEEP, OPTSIZE, OPTTIME -- the substitution is not a peephole
 *            and no option disables it.
 *   scope:   every large constant with a small odd mantissa.
 *   retest:  SAS/C 6.00 emits 7455e78a too, so this class does NOT bracket 6.00
 *            against 6.51 -- both are more aggressive here than the original.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   summary: 48E73002/4CDF400C vs 48E73000/4CDF000C -- SAS/C adds A6 to the
 *            MOVEM masks and hoists the GfxBase load above the first argument
 *            setup. The original treats A6 as scratch. See the os-library-call
 *            section of docs/compiler-version.md.
 *   scope:   every OS-calling function in the program.
 */
#include "esq-graphics.h"
extern struct RastPort *Global_REF_RASTPORT_1;
void ED_DrawBottomHelpBarBackground(void)
{
    SetAPen(Global_REF_RASTPORT_1, 2L);
    RectFill(Global_REF_RASTPORT_1, 40L, 68L, 680L, 429L);
    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);
}
