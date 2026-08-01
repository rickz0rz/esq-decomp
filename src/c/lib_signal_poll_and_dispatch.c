/* RESTORES: _SIGNAL_PollAndDispatch
 * MODULE:   modules/submodules/unknown38.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the break check. It samples the Ctrl-C and Ctrl-D signal
 * bits, and if either is pending it calls the installed break handler. If that
 * handler says stop, the program is torn down.
 *
 * `SetSignal(0, 0x3000)` READS the signals without setting any -- a zero
 * newSignals with a 0x3000 mask returns the old state and leaves it alone. Bits
 * 12 and 13 are SIGBREAKB_CTRL_C and CTRL_D.
 *
 * IT DOES NOT CLEAR THE SIGNAL. The bits stay pending, so a handler that returns
 * zero is asked again on the next call. That is deliberate: the check is meant to
 * fire repeatedly until something acts on it.
 *
 * A NON-ZERO HANDLER RESULT IS FATAL. The pointer is cleared FIRST -- so the
 * teardown path cannot re-enter this function through its own I/O -- and then
 * HANDLE_CloseAllAndReturnWithCode(20) closes every handle and leaves the
 * program. It does not return, which is why nothing follows it here.
 *
 * THE HANDLER TAKES NO ARGUMENTS: the original is a bare `JSR (A0)`.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVEA.L Global_SignalCallbackPtr(A4),A0
 *   got:     an absolute read through the enclosing array, then an indirect call
 *   summary: DATA=FAR addresses every global absolutely.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-exec.h"
#include "esq-neardata.h"

extern void HANDLE_CloseAllAndReturnWithCode(long code);

void SIGNAL_PollAndDispatch(void)
{
    long pending;

    pending = SetSignal(0L, 0x3000L) & 0x3000L;
    if (pending == 0)
        return;

    if (Global_SignalCallbackPtr_A4 == 0)
        return;

    if ((*(long (**)(void))Global_SignalCallbackPtr_A4_ADDR)() != 0) {
        Global_SignalCallbackPtr_A4 = 0;
        HANDLE_CloseAllAndReturnWithCode(20);
    }
}
