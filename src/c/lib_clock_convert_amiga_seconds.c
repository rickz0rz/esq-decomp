/* RESTORES: CLOCK_ConvertAmigaSecondsToClockData
 * MODULE:   modules/submodules/unknown41.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a thin wrapper on utility.library's Amiga2Date, which
 * turns a seconds-since-1978 count into a broken-down ClockData.
 *
 * THE ARGUMENTS ARRIVE TOGETHER. The original reads them with one
 * `MOVEM.L 8(A7),D0/A0`, which loads D0 from +8 and A0 from +12 -- the seconds
 * and the destination, in that order. A single MOVEM is not expressible in C and
 * does not need to be; the same two values reach the same two registers.
 *
 * THE BASE IS _UtilityBase, which src/data/esq.s now labels beside
 * _Global_REF_UTILITY_LIBRARY. Adding the label is byte-neutral -- both gates
 * stay green -- and it is the same arrangement _GfxBase and _DOSBase already
 * use. Without it the SAS/C pragma has no symbol to load.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     MOVEA.L _Global_REF_UTILITY_LIBRARY,A6 with A6 saved and restored
 *   got:     the same load through the volatile esq-utility.h base
 *   summary: the same variable by a different name. The volatile declaration
 *            costs nothing here, because there is one call.
 *   scope:   program-wide. See src/c/esq-libbase.md.
 *   retest:  not a compiler question; it is the header contract.
 */
#include "esq-utility.h"

void CLOCK_ConvertAmigaSecondsToClockData(unsigned long seconds, void *clockData)
{
    Amiga2Date(seconds, (struct ClockData *)clockData);
}
