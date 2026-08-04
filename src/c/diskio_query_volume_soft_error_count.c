/* RESTORES: DISKIO_QueryVolumeSoftErrorCount
 * MODULE:   modules/groups/a/g/diskio_p4.s
 * STATUS:   behavioural
 *
 * Locks a volume, asks DOS for its InfoData, and returns id_NumSoftErrors --
 * the FIRST longword of the structure, which is what MOVE.L (A0),D7 reads.
 *
 * The lock mode is -2, ACCESS_READ. The InfoData block is 36 bytes and is
 * allocated through the tracking allocator with MEMF_CLEAR only, not
 * MEMF_PUBLIC -- the flag word is 0x00010000, so reproducing it as
 * MEMF_PUBLIC|MEMF_CLEAR would be wrong.
 *
 * The cleanup path is exact and worth reading: a failed ALLOCATION skips
 * straight to the UnLock, while a failed INFO still frees the block. Both exits
 * unlock. Getting either wrong leaks a lock, which on a real Amiga eventually
 * wedges the drive.
 *
 * The volatile DOS header is required and is the textbook case for it: the
 * tracking allocator is ESQ assembly that returns with A6 pointing at ExecBase,
 * so the DOS base must reload before Info. The original does exactly that --
 * three separate MOVEA.L Global_REF_DOS_LIBRARY_2,A6 for the three DOS calls.
 * See src/c/esq-libbase.md, which uses this shape as its example.
 *
 * 138 ref vs 132 got. All three DOS LVO offsets (ffac Lock, ff8e Info,
 * ffa6 UnLock), the MOVEQ #-2 lock mode, the MEMF_CLEAR word 0x00010000, both
 * PEA 36 sizes, both line numbers (593, 599) and both LEA 16(A7),A7 cleanups
 * match exactly -- and so does the three-times reload of the DOS base, which is
 * the whole reason the volatile header is right here.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff4 ... 2b40fff8 ... 4e5d
 *            LINK.W A5,#-12 / MOVE.L D0,-8(A5) / UNLK
 *   got:     2640                 MOVEA.L D0,A3
 *   summary: the original spills the InfoData pointer to a frame slot; 6.51
 *            keeps it in an address register. The frame plus the store is the
 *            6 bytes. Note the original ALSO holds the same pointer in D2 for
 *            the Info call, so the spill is redundant even there.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/memory.h>
#include "esq-dos.h"

extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern char  Global_STR_DISKIO_C_7[];
extern char  Global_STR_DISKIO_C_8[];

long DISKIO_QueryVolumeSoftErrorCount(char *name)
{
    BPTR lock;
    struct InfoData *info;
    long  errors = 0;

    lock = Lock(name, -2L);
    if (lock == 0)
        return errors;

    info = (struct InfoData *)MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_7, 593L, 36L, MEMF_CLEAR);

    if (info != 0) {
        if (Info(lock, info))
            errors = info->id_NumSoftErrors;

        MEMORY_DeallocateMemory(Global_STR_DISKIO_C_8, 599L,
                                                info, 36L);
    }

    UnLock(lock);
    return errors;
}
