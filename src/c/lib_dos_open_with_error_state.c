/* RESTORES: DOS_OpenWithErrorState
 * MODULE:   modules/submodules/unknown20.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Opens a file through dos.library and records the failure
 * state in the near-data globals. Returns the file handle, or -1.
 *
 * IT POLLS THE SIGNAL CALLBACK FIRST, and only if one is installed. That is a
 * break-check hook: `TST.L Global_SignalCallbackPtr(A4)` then a call, before any
 * work. Moving it after the open would let a Ctrl-C arrive one file too late.
 *
 * IT RETURNS -1 ON FAILURE, NOT ZERO, even though Open() itself returns zero.
 * The error path also stores IoErr() into Global_DosIoErr and 2 into
 * Global_AppErrorCode. A caller that only tests for zero would read a failure as
 * a valid handle.
 *
 * THE NEAR-DATA GLOBALS ARE ORDINARY GLOBALS reached through
 * src/c/esq-neardata.h -- see lib_handle_get_entry_by_index.c for the whole
 * story. Global_DosLibrary lands on _DOSBase, which is the same base
 * esq-dos.h uses, so the library call is written the ordinary way.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     CLR.L Global_DosIoErr(A4)      16-bit displacement off A4
 *   got:     an absolute reference through the enclosing array
 *   summary: DATA=FAR addresses every global absolutely. Same address, 2 bytes
 *            more per site.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"
#include "esq-neardata.h"

extern void SIGNAL_PollAndDispatch(void);

long DOS_OpenWithErrorState(char *name, long mode)
{
    long fh;

    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Global_DosIoErr_A4 = 0;

    fh = (long)Open((STRPTR)name, mode);
    if (fh == 0) {
        Global_DosIoErr_A4 = IoErr();
        Global_AppErrorCode_A4 = 2;
        return -1;
    }

    return fh;
}
