/* RESTORES: _DOS_CloseWithSignalCheck
 * MODULE:   modules/submodules/unknown22_dos_closewithsignalcheck.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Closes a DOS file handle, polling the break check first.
 *
 * IT ALWAYS RETURNS 0, whatever Close() said. `MOVEQ #0,D0` is the last thing
 * before the epilogue, so a failed close is indistinguishable from a good one
 * and Global_DosIoErr is NOT set. Callers that want the failure have to ask DOS
 * themselves. HANDLE_CloseByIndex tests Global_DosIoErr after calling this, and
 * therefore sees whatever the LAST DOS call left there rather than anything about
 * the close -- that is the original's behaviour and is left alone.
 *
 * THE MODULE WAS SPLIT TO REACH THIS FUNCTION. modules/submodules/unknown22.s
 * also holds __CXD22 and __CXD33, the divide helpers SAS/C emits calls to, which
 * cannot be written in C at all -- they return the quotient in D0 AND the
 * remainder in D1. See the PROVEN BLOCKER section in AGENTS.md. Splitting the
 * module leaves those two in assembly and lets the other three functions out.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVEA.L Global_DosLibrary(A4),A6
 *   got:     the absolute DOSBase esq-dos.h uses -- the same variable, since the
 *            A4 displacement resolves onto _DOSBase.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"
#include "esq-neardata.h"

extern void SIGNAL_PollAndDispatch(void);

long DOS_CloseWithSignalCheck(long fh)
{
    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Close((BPTR)fh);

    return 0;               /* always, whatever Close() said */
}
