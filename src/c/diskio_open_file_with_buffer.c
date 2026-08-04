/* RESTORES: DISKIO_OpenFileWithBuffer
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * Opens a file and attaches the shared write buffer to it, refusing if a file
 * is already open.
 *
 * The UI tick runs TWICE -- once before the open-count guard and once on the
 * way out of every path, including the failed open. Both are part of the
 * contract, not bookkeeping.
 *
 * DISKIO_OpenCount is tested TWICE, and the second test is not redundant even
 * though the first returns on non-zero: DOS_OpenFileWithMode sits between them
 * and the compiler cannot assume the global survives it. The C below re-reads
 * it for the same reason.
 *
 * The buffer allocation takes MEMF_PUBLIC ONLY -- the flag word is a PEA 1.W,
 * not the 0x00010001 pair used elsewhere in this file's neighbours.
 *
 * The struct layouts are the ones diskio_write_buffered_bytes.c derived from
 * the listing: BufferPtr at +0, BufferSize at +4, Remaining at +8 and the saved
 * flags word at +12 of DISKIO_BufferState.
 *
 * 142 ref vs 148 got. The two open-count guards, the memory-to-memory flags
 * save (33f9), the ADDQ.L #1, the MOVE.W #$100, the PEA 1 MEMF word, the
 * PEA 286 line number, the LEA 16(A7),A7 cleanup and both UI ticks match in
 * kind and size. The 6 bytes are the A3/A5 allocation class and the
 * store-ordering class, both settled -- docs/compiler-version.md, "The A3/A5
 * divergence has a single root cause".
 */
#include <exec/memory.h>
#include "esq-dos.h"

struct DiskIoBufferControl { void *BufferBase; long ErrorFlag; };
struct DiskIoBufferState   { char *BufferPtr; long BufferSize; long Remaining;
                             short SavedF45; };

extern void  ESQFUNC_ServiceUiTickIfRunning(void);
extern BPTR  DOS_OpenFileWithMode(char *path, long mode);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);

extern struct DiskIoBufferControl DISKIO_BufferControl;
extern struct DiskIoBufferState   DISKIO_BufferState;
extern long  DISKIO_OpenCount;
extern short ESQPARS2_ReadModeFlags;
extern char  Global_STR_DISKIO_C_1[];

BPTR DISKIO_OpenFileWithBuffer(char *path, long mode)
{
    BPTR  fh = 0;
    char *buf;

    ESQFUNC_ServiceUiTickIfRunning();

    if (DISKIO_OpenCount != 0)
        return fh;

    DISKIO_BufferControl.ErrorFlag = 0;

    fh = DOS_OpenFileWithMode(path, mode);

    if (fh != 0) {
        if (DISKIO_OpenCount == 0)
            DISKIO_BufferState.SavedF45 = ESQPARS2_ReadModeFlags;

        DISKIO_OpenCount++;
        ESQPARS2_ReadModeFlags = 0x100;

        buf = (char *)MEMORY_AllocateMemory(
            Global_STR_DISKIO_C_1, 286L, DISKIO_BufferState.BufferSize,
            MEMF_PUBLIC);

        DISKIO_BufferState.Remaining      = DISKIO_BufferState.BufferSize;
        DISKIO_BufferState.BufferPtr      = buf;
        DISKIO_BufferControl.BufferBase   = buf;
    }

    ESQFUNC_ServiceUiTickIfRunning();
    return fh;
}
