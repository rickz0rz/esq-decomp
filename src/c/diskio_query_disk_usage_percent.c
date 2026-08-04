/* RESTORES: DISKIO_QueryDiskUsagePercentAndSetBufferSize
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * 168 bytes in the original, 176 emitted (2 of them alignment padding), and
 * casm.py itemises the whole +8.
 *
 * THIS FUNCTION RESET THE AMIGA and was found by bisecting the maximum-C build.
 * It is the worked example for the stale-A6 class: SAS/C cached DOSBase in A6
 * across the MEMORY_AllocateMemory call, which returns with A6 = ExecBase, so
 * `JSR _LVOInfo(A6)` entered exec at the dos offset. Including "esq-dos.h"
 * instead of <proto/dos.h> makes the base volatile and forces the reload -- the
 * emitted code now has the original's three `MOVEA.L <DOSBase>,A6`, one per
 * library call, matching exactly. See esq-libbase.md.
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
 * SASC-MISMATCH: cross-unit-call-width
 *   ref:     4eba18f4                   JSR (d16,PC)
 *   got:     4eb900000000               JSR abs.L
 *   summary: CODE=FAR, mandatory for the maximum-C link. 4 sites x +2 = +8,
 *            which is the entire delta. The usual cross-unit class.
 *   scope:   every extern call in every restoration built with CODE=FAR.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4 ... 4e5d          LINK.W A5,#-12 / UNLK A5
 *   got:     (none)                     A5/A6 added to the MOVEM mask instead
 *   summary: the original spills `info` to -8(A5); SAS/C keeps it in A3 and so
 *            builds no frame. Nets -6 across prologue and epilogue.
 *
 * SASC-MISMATCH: early-return-block-ordering
 *   ref:     677c                       BEQ.S to the shared epilogue
 *   got:     6606 2006 60000086         BNE.S over an inline `return pct`
 *   summary: the original folds the failed-Lock return into the common exit;
 *            SAS/C emits the return inline and branches past it. +6.
 *
 * The register-argument helpers are declared with __asm register parameters,
 * which is what lets pure C call them at all: MATH_Mulu32/MATH_DivS32 take D0/D1
 * and return D0, and `*`/`/` would instead route through SAS/C's own __CXM33 /
 * __CXD33. That reproduces the original's `MOVEQ #100,D1` / JSR pair verbatim.
 */
#include <exec/memory.h>
#include <dos/dos.h>
#include "esq-dos.h"

struct DiskIoBufferState { char *BufferPtr; long BufferSize; long Remaining; short SavedF45; };

extern void *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern long __asm MATH_Mulu32(register __d0 long a, register __d1 long b);
extern long __asm MATH_DivS32(register __d0 long a, register __d1 long b);
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

    info = MEMORY_AllocateMemory(Global_STR_DISKIO_C_5, 567,
                                                 (long)sizeof(struct InfoData),
                                                 MEMF_CLEAR);
    if (info) {
        if (Info((BPTR)lock, info)) {
            pct = MATH_DivS32(
                  MATH_Mulu32((long)info->id_NumBlocksUsed, 100L),
                  (long)info->id_NumBlocks);
            DISKIO_BufferState.BufferSize = info->id_BytesPerBlock * 2;
        }
        MEMORY_DeallocateMemory(Global_STR_DISKIO_C_6, 574, info,
                                                (long)sizeof(struct InfoData));
    }

    UnLock((BPTR)lock);
    return pct;
}
