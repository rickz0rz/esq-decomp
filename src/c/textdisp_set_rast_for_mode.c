/* RESTORES: TEXTDISP_SetRastForMode
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * 160 bytes in the original, 172 emitted, 6 differing regions.
 *
 * Reproduces: the flush flag cleared and the copper drop run before anything
 * else, the two-way context build (view mode 3 with zero arguments for mode 0,
 * view mode 7 with a trailing 4 otherwise), the three palette-triple copies that
 * move the selected mode's RGB down into slot 0, and the SetRast on the embedded
 * rastport at +10.
 *
 * The palette copies index at mode*3 into three SEPARATE base symbols one byte
 * apart -- R at 0xA356, G at 0xA357, B at 0xA358 -- so they are interleaved
 * triples addressed through three views of the same array, not three arrays.
 * Writing them as one array of structs would change the addressing.
 *
 * The multiply is MULS, inline, not a helper call -- 16-bit, consistent with the
 * width rule from coi_compute_entry_time_delta_minutes.c. Note it is signed
 * despite the index being non-negative in practice.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls; most of the +12.
 */
#include "esq-graphics.h"

extern void  WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern void *TLIBA3_BuildDisplayContextForViewMode(long a, long b, long c);
extern short WDISP_AccumulatorFlushPending;
extern void *WDISP_DisplayContextBase;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char WDISP_PaletteTriplesGBase[];
extern unsigned char WDISP_PaletteTriplesBBase[];

void TEXTDISP_SetRastForMode(short mode)
{
    WDISP_AccumulatorFlushPending = 0;
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();

    if (mode == 0) {
        WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);
        return;
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(7, 0, 4);

    WDISP_PaletteTriplesRBase[0] = WDISP_PaletteTriplesRBase[mode * 3];
    WDISP_PaletteTriplesGBase[0] = WDISP_PaletteTriplesGBase[mode * 3];
    WDISP_PaletteTriplesBBase[0] = WDISP_PaletteTriplesBBase[mode * 3];

    SetRast((struct RastPort *)((char *)WDISP_DisplayContextBase + 10), (long)mode);
}
