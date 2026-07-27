/* RESTORES: ED_InitRastport2Pens
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     4e55fffc2079000086fe41e8000a2b48fffc224870002c79000028584eaefe9e226dfffc70014eaefeaa700eb0b90000a3026614226dfffc70014eaefe9e226dfffc70024eaefea44e5d4e75
 *   got:     48e70006207900000000d0fc000a2a48224d2c790000000070004eaefe9e224d70014eaefeaa700eb0b9000000006610224d70014eaefe9e224d70024eaefea44cdf60004e75
 *   summary: Uses #pragma libcall so the OS call encoding matches; the residual includes A6 in the MOVEM masks. See the os-library-call section of docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"
extern char *WDISP_DisplayContextBase;
extern long  ED_Rastport2PenModeSelector;
#define RP2OFF 10          /* Offset_RastPort2_FromDisplayContextBase + 2 */
void ED_InitRastport2Pens(void)
{
    struct RastPort *rp = (struct RastPort *)(WDISP_DisplayContextBase + RP2OFF);

    SetDrMd(rp, 0);
    SetAPen(rp, 1);
    if (ED_Rastport2PenModeSelector == 14) {
        SetDrMd(rp, 1);
        SetBPen(rp, 2);
    }
}
