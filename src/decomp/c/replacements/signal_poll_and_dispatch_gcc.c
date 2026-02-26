#include "esq_types.h"

/*
 * Target 070 GCC trial function.
 * Poll break signals and dispatch callback; clear callback + close on failure.
 */
extern u32 Global_SignalCallbackPtr;

s32 HANDLE_CloseAllAndReturnWithCode(s32 code);

s32 SIGNAL_PollAndDispatch(void) __attribute__((noinline, used));

s32 SIGNAL_PollAndDispatch(void)
{
    s32 set_signal_result;
    s32 masked_signals;

    {
        register s32 d0_in __asm__("d0") = 0;
        register s32 d1_in __asm__("d1") = 0x3000;
        __asm__ volatile(
            "movea.l AbsExecBase,%%a6\n\t"
            "jsr _LVOSetSignal(%%a6)\n\t"
            : "+r"(d0_in), "+r"(d1_in)
            :
            : "a6", "cc", "memory");
        set_signal_result = d0_in;
    }

    masked_signals = (set_signal_result & 0x3000);
    if (masked_signals != 0 && Global_SignalCallbackPtr != 0) {
        s32 (*callback)(void) = (s32 (*)(void))Global_SignalCallbackPtr;

        if (callback() != 0) {
            Global_SignalCallbackPtr = 0;
            HANDLE_CloseAllAndReturnWithCode(20);
        }
    }

    return set_signal_result;
}
