/* RESTORES: DISKIO_CloseBufferedFileAndFlush
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * 178 bytes in the original, 184 emitted, 9 differing regions.
 *
 * Reproduces: the null-handle early return that still services the UI tick first,
 * the pending-byte calculation as BufferSize minus Remaining, the conditional
 * flush Write, the close-task handoff, the poll loop that services the UI tick on
 * both sides of a five-tick Delay until the completion flag is set, the buffer
 * deallocation, and the open-count decrement whose reaching zero (with the UI
 * idle) restores the saved read-mode flags.
 *
 * The UI tick is serviced SIX times in this function, including once before the
 * null check and once immediately after the deallocation. That density is the
 * point of the routine -- it is the blocking close path, and every pause is an
 * opportunity to keep the display alive. Collapsing the redundant-looking calls
 * would compile and would make the display stutter on close.
 *
 * ARTIFACT not reproduced: the original emits CMP.L D3,D0 immediately after the
 * Write and then discards the result -- no branch follows. Something in the
 * original source compared the byte count against the request and did nothing
 * with the answer. There is no C that produces a dead comparison here, and
 * writing one deliberately would be worse than the six-byte difference.
 *
 * NOTE the struct layout was corrected after the fact. It originally omitted the
 * leading BufferPtr field, putting every subsequent offset four bytes low. The
 * emitted bytes did not change -- see the caveat in
 * diskio_write_buffered_bytes.c: DATA=FAR plus relocation masking makes struct
 * layout invisible to the diff. Offsets here are now taken from the listing:
 * BufferPtr +0 (0x8068), BufferSize +4, Remaining +8, SavedF45 +12.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the ten cross-unit calls -- unusually many for
 *            a function this size, which is most of the 9 regions.
 */
#include <proto/dos.h>

struct DiskIoBufferControl { void *BufferBase; long ErrorFlag; };
struct DiskIoBufferState   { char *BufferPtr; long BufferSize; long Remaining; short SavedF45; };

extern void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void);
extern void CTASKS_StartCloseTaskProcess(long fh);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern struct DiskIoBufferControl DISKIO_BufferControl;
extern struct DiskIoBufferState   DISKIO_BufferState;
extern short CTASKS_CloseTaskCompletionFlag;
extern long  DISKIO_OpenCount;
extern short Global_UIBusyFlag;
extern short ESQPARS2_ReadModeFlags;
extern char  Global_STR_DISKIO_C_2[];

void DISKIO_CloseBufferedFileAndFlush(BPTR fh)
{
    register long pending;

    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
    if (fh == 0)
        return;

    DISKIO_BufferControl.ErrorFlag = 0;
    pending = DISKIO_BufferState.BufferSize - DISKIO_BufferState.Remaining;
    if (pending)
        Write(fh, DISKIO_BufferControl.BufferBase, pending);

    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
    CTASKS_StartCloseTaskProcess(fh);

    do {
        GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
        Delay(5L);
        GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
    } while (CTASKS_CloseTaskCompletionFlag == 0);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_2, 353,
                                            DISKIO_BufferControl.BufferBase,
                                            DISKIO_BufferState.BufferSize);
    GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

    if (DISKIO_OpenCount > 0)
        DISKIO_OpenCount--;
    if (DISKIO_OpenCount == 0 && Global_UIBusyFlag == 0)
        ESQPARS2_ReadModeFlags = DISKIO_BufferState.SavedF45;
}
