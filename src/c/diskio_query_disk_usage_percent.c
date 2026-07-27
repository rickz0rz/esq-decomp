/* RESTORES: DISKIO_QueryDiskUsagePercentAndSetBufferSize
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * 168 bytes in the original, 160 emitted, 5 differing regions.
 *
 * Reproduces: the shared Lock, the zero-percent early return when it fails, the
 * MEMF_CLEAR InfoData allocation, the guarded Info() call, the usage percentage
 * as NumBlocksUsed * 100 / NumBlocks, the buffer size set to twice the disk's
 * BytesPerBlock, and the deallocation nested inside the allocation check while
 * the UnLock sits outside it -- so a failed allocation still releases the lock.
 *
 * The exec/dos struct offsets decode as standard InfoData: NumBlocks at +12,
 * NumBlocksUsed at +16, BytesPerBlock at +20, total size 36. Using the real
 * <dos/dos.h> struct rather than hand-written offsets means these are checked by
 * the compiler rather than by me -- which, given the struct-offset caveat in
 * diskio_write_buffered_bytes.c, is the preferable option whenever a system
 * header defines the layout.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     7264 4eba18dc              MOVEQ #100,D1 / JSR MATH_Mulu32
 *   got:     e581 9280 e781 d280 e581   inline shift/subtract chain for x100
 *   summary: 32-bit multiply, so the original calls the helper -- consistent with
 *            the width rule established in coi_compute_entry_time_delta_minutes.c.
 *            This is where most of the -8 comes from.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     (none)                     MOVEM only
 */
#include <exec/memory.h>
#include <dos/dos.h>
#include <proto/dos.h>

struct DiskIoBufferState { char *BufferPtr; long BufferSize; long Remaining; short SavedF45; };

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern long  GROUP_AG_JMPTBL_MATH_Mulu32(long a, long b);
extern long  GROUP_AG_JMPTBL_MATH_DivS32(long a, long b);
extern struct DiskIoBufferState DISKIO_BufferState;
extern char Global_STR_DISKIO_C_5[];
extern char Global_STR_DISKIO_C_6[];

long DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *path)
{
    struct InfoData *info;
    register long lock;
    register long pct;

    pct = 0;

    lock = (long)Lock(path, -2L);
    if (lock == 0)
        return pct;

    info = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DISKIO_C_5, 567,
                                                 (long)sizeof(struct InfoData),
                                                 MEMF_CLEAR);
    if (info) {
        if (Info((BPTR)lock, info)) {
            pct = info->id_NumBlocksUsed * 100 / info->id_NumBlocks;
            DISKIO_BufferState.BufferSize = info->id_BytesPerBlock * 2;
        }
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_6, 574, info,
                                                (long)sizeof(struct InfoData));
    }

    UnLock((BPTR)lock);
    return pct;
}
