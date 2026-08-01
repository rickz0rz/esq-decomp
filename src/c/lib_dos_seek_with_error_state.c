/* RESTORES: _DOS_SeekWithErrorState
 * MODULE:   modules/submodules/unknown18.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Seeks a DOS file handle and returns the NEW position,
 * translating between C's whence values and AmigaDOS's.
 *
 * THE MODE IS C's, NOT THE OS's, AND IT IS BIASED BY ONE. The caller passes 0, 1
 * or 2 -- set, current, end -- and the original passes `mode - OFFSET_END` to
 * Seek(), which turns them into OFFSET_BEGINNING (-1), OFFSET_CURRENT (0) and
 * OFFSET_END (1). Passing the caller's value straight through would seek to the
 * wrong origin every time.
 *
 * Seek() RETURNS THE OLD POSITION, so each mode has to work the new one out:
 *
 *   mode 0  the new position IS the offset asked for
 *   mode 1  old + offset
 *   mode 2  a SECOND Seek(fh, 0, OFFSET_CURRENT), which returns the position
 *           the first seek left, because arithmetic cannot know the file length
 *
 * ANYTHING ELSE RETURNS THE MODE ITSELF. `TST.L D0 / BNE .return` falls out with
 * the mode still in D0. That is almost certainly not deliberate in the original,
 * but it is what it does, and a caller passing 3 gets 3 back rather than an
 * error.
 *
 * THE ERROR PATH DOES NOT STOP THE MODE ADJUSTMENT. A failed seek sets
 * Global_DosIoErr and error code 22 and then falls into the same arithmetic, so
 * mode 1 returns -1 + offset rather than -1. The caller is expected to test
 * Global_DosIoErr, which is what DOS_SeekByIndex does.
 *
 * THE SECOND SEEK IS NOT ERROR-CHECKED.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     CLR.L Global_DosIoErr(A4)   16-bit displacement off A4
 *   got:     an absolute reference through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"
#include "esq-neardata.h"

extern void SIGNAL_PollAndDispatch(void);

#define OFFSET_CURRENT  0
#define OFFSET_END      1

long DOS_SeekWithErrorState(long fh, long pos, long mode)
{
    long old;

    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Global_DosIoErr_A4 = 0;

    old = Seek((BPTR)fh, pos, mode - OFFSET_END);
    if (old == -1) {
        Global_DosIoErr_A4 = IoErr();
        Global_AppErrorCode_A4 = 22;
    }

    if (mode == 2)
        return Seek((BPTR)fh, 0, OFFSET_CURRENT);
    if (mode == 1)
        return old + pos;
    if (mode != 0)
        return mode;            /* the fall-out path -- see above */

    return pos;
}
