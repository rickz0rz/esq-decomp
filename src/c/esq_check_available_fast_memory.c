/* RESTORES: ESQ_CheckAvailableFastMemory
 * MODULE:   modules/groups/_main/b/b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     72022c7800044eaeff280c80000927c06c0833fc0001000029684e75
 *   got:     2f0e72022c7800044eaeff280c80000927c0640833fc0001000000002c5f4e75
 *   summary: Uses #pragma libcall via the proto headers, so the OS call encoding matches; the residual difference is A6 being added to the MOVEM masks. See the os-library-call section of docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
extern short HAS_REQUESTED_FAST_MEMORY;
void ESQ_CheckAvailableFastMemory(void)
{
    if (AvailMem(2) < 600000L)
        HAS_REQUESTED_FAST_MEMORY = 1;
}
