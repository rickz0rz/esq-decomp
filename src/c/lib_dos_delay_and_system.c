/* RESTORES: DOS_Delay
 * MODULE:   modules/submodules/unknown40_dos_delay.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a thin wrapper on dos.library's Delay.
 *
 * IT DOES NOT POLL THE BREAK CHECK. Every other DOS wrapper in this layer calls
 * SIGNAL_PollAndDispatch first; this one does not, so a Ctrl-C during a long
 * Delay is not noticed until the next read or write. That asymmetry is in the
 * original and is reproduced.
 *
 * THE SIGNATURE IS CONFIRMED against an existing restoration rather than read off
 * the stack offsets: src/c/cleanup_shutdown_system.c already declares
 * `GROUP_MAIN_B_JMPTBL_DOS_Delay(long ticks)`. Checking a declaration or a caller
 * before writing one of these is now the habit -- MEMORY_AllocateMemory was
 * given two arguments when it takes four, and only the emulator caught it.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVEA.L Global_REF_DOS_LIBRARY_2,A6
 *   got:     the absolute DOSBase esq-dos.h uses -- the same variable.
 *   scope:   every library wrapper in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"

void DOS_Delay(long ticks)
{
    Delay(ticks);
}
