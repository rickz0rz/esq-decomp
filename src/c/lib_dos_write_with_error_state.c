/* RESTORES: _DOS_WriteWithErrorState
 * MODULE:   modules/submodules/unknown17.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Writes through a DOS file handle and records the failure
 * state in the near-data globals. It is the exact twin of the other direction --
 * the two modules differ only in which dos.library call they make.
 *
 * IT POLLS THE SIGNAL CALLBACK FIRST, and only when one is installed. That is
 * the break check, and it runs before any I/O.
 *
 * -1 IS THE ONLY FAILURE VALUE. The original compares the result against -1
 * exactly (`MOVEQ #-1,D0 / CMP.L D0,D5`) and reads IoErr only then, so a SHORT
 * write is not an error here: it returns the count and leaves Global_DosIoErr
 * zero. A caller wanting short-write detection has to compare against the
 * length it asked for.
 *
 * THE RESULT IS RETURNED UNCHANGED, including the -1, after the globals are set.
 * The caller distinguishes success from failure by the value, or by
 * Global_DosIoErr, and the two agree.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     CLR.L Global_DosIoErr(A4)   16-bit displacement off A4
 *   got:     an absolute reference through the enclosing array
 *   summary: DATA=FAR addresses every global absolutely.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"
#include "esq-neardata.h"

extern void SIGNAL_PollAndDispatch(void);

long DOS_WriteWithErrorState(long fh, char *buf, long len)
{
    long n;

    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Global_DosIoErr_A4 = 0;

    n = Write((BPTR)fh, (APTR)buf, len);
    if (n == -1) {
        Global_DosIoErr_A4 = IoErr();
        Global_AppErrorCode_A4 = 5;
    }

    return n;
}
