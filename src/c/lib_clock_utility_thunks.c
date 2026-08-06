/* RESTORES: CLOCK_CheckDateOrSecondsFromEpoch,
 *           CLOCK_SecondsFromEpoch
 * MODULE:   modules/submodules/unknown42.s   (2 of its 16 labels)
 * STATUS:   behavioural
 *
 * The two utility.library date thunks. Each loads ESQ's cached UtilityBase,
 * puts the record pointer in A0 and calls one vector -- CheckDate at -54,
 * Date2Amiga at -60.
 *
 * THE OTHER FOURTEEN LABELS IN THIS MODULE ARE THE PARALLEL-PORT DEBUG PRINTER
 * and are restored in lib_parallel_debug_port.c. They share a module and
 * nothing else; a C file replaces a whole module, so both files had to exist
 * before either could be linked.
 *
 * THE RECORD IS ParseIniRtcRecord, NOT struct ClockData. Both callers in
 * src/c -- parseini_write_rtc_from_globals.c and, until the jump-table thunks
 * were deleted on 2026-08-06, jmptbl_b_a_parseini2_p1.c -- declare it that way,
 * and the field offsets match the ROM's
 * ClockData layout, which is what CheckDate and Date2Amiga expect.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2f0e2c79<base>206f0008 4eaeffca 2c5f4e75   (20)
 *   summary: the original saves A6, loads the base once and calls. The
 *            volatile base in esq-utility.h forces the reload the pragma
 *            already emits, so the shapes agree; what differs is that SAS/C
 *            saves and restores A6 through its own MOVEM rather than a single
 *            MOVE.L, and reaches the base as an absolute under DATA=FAR.
 *   scope:   every restoration that calls a library through a cached base.
 *   retest:  nothing to retest; the reload is the correct behaviour here --
 *            see esq-libbase.md.
 */
#include "esq-utility.h"

#ifndef PARSEINIRTCRECORD_DEFINED
struct ParseIniRtcRecord;
#endif

long CLOCK_CheckDateOrSecondsFromEpoch(struct ParseIniRtcRecord *r)
{
    return CheckDate((struct ClockData *)r);
}

long CLOCK_SecondsFromEpoch(struct ParseIniRtcRecord *r)
{
    return Date2Amiga((struct ClockData *)r);
}
