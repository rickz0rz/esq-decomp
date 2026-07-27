/* RESTORES: DISKIO_WriteBufferedBytes
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * 166 bytes in the original, 200 emitted, 10 differing regions.
 *
 * Reproduces: the four guards that all return 0, the byte-at-a-time copy into the
 * buffer, the inner loop that stops on either the buffer filling or the request
 * being satisfied, the flush that writes the whole buffer and latches the error
 * flag on a short write, the reset of pointer and remaining count after a
 * successful flush, and the UI tick serviced at three separate points.
 *
 * IMPORTANT CAVEAT about struct layouts in this project, discovered here.
 *
 * This file was first written with DISKIO_BufferState laid out wrongly -- an
 * invented pad field putting BufferSize at +8 instead of +4. Correcting it
 * produced BYTE-IDENTICAL output, because DATA=FAR makes every global field
 * access an absolute long that carries a relocation, and tools/cdiff.sh masks
 * relocated fields by definition. So a wrong struct layout is INVISIBLE to the
 * byte comparison.
 *
 * That means struct offsets in a `behavioural` file are not verified by anything.
 * They only get tested if the file is promoted to `exact` and linked, where a
 * wrong offset would silently read the wrong global. Anyone promoting a
 * struct-using restoration must re-derive the offsets from the assembly first --
 * a green cdiff is not evidence they are right.
 *
 * The offsets used here are taken directly from the listing: BufferPtr at
 * DISKIO_BufferState+0 (0x8068), BufferSize at +4 (0x806C), Remaining at +8
 * (0x8070), and the saved flags word at +12 (0x8074).
 *
 * SASC-MISMATCH: unattributed-loop-expansion
 *   summary: The +34 is NOT itemised. The original's inner loop stores the
 *            advanced buffer pointer TWICE per iteration (MOVE.L A0,BufferPtr at
 *            two points, with nothing between them that could have changed it) --
 *            a redundancy no C produces. Beyond that the loop nesting differs in
 *            ways this file does not account for. Recorded as a known-unknown;
 *            do not promote without closing it.
 */
#include "esq-dos.h"

struct DiskIoBufferControl { void *BufferBase; long ErrorFlag; };
struct DiskIoBufferState   { char *BufferPtr; long BufferSize; long Remaining; short SavedF45; };

extern void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void);
extern struct DiskIoBufferControl DISKIO_BufferControl;
extern struct DiskIoBufferState   DISKIO_BufferState;

long DISKIO_WriteBufferedBytes(BPTR fh, char *src, long len)
{
    register long remaining;
    register long result;
    register long total;

    result = len;
    total  = len;
    remaining = len;

    if (src == 0)                              return 0;
    if (len == 0)                              return 0;
    if (DISKIO_BufferControl.ErrorFlag == 1)   return 0;
    if (fh == 0)                               return 0;

    do {
        GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

        do {
            *DISKIO_BufferState.BufferPtr++ = *src++;
            DISKIO_BufferState.Remaining--;
            remaining--;
        } while (DISKIO_BufferState.Remaining != 0 && remaining != 0);

        GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();

        if (DISKIO_BufferState.Remaining == 0) {
            result = Write(fh, DISKIO_BufferControl.BufferBase,
                           DISKIO_BufferState.BufferSize);
            if (result != DISKIO_BufferState.BufferSize) {
                DISKIO_BufferControl.ErrorFlag = 1;
                return result;
            }
            result = total;
            DISKIO_BufferState.BufferPtr = DISKIO_BufferControl.BufferBase;
            DISKIO_BufferState.Remaining = DISKIO_BufferState.BufferSize;
            GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning();
        }
    } while (remaining != 0);

    return result;
}
