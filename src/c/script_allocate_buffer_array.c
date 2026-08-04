/* RESTORES: SCRIPT_AllocateBufferArray
 * MODULE:   modules/groups/b/a/script.s
 * STATUS:   behavioural
 *
 * Fills an array of pointers with `count` freshly allocated buffers of `size`
 * bytes each.
 *
 * Both scalar parameters are read as WORDS at slot+2 (3e2f0022, 3c2f0026), so
 * they are shorts, and both are EXT.L-widened before use, so they are signed.
 * The loop bound is a signed word compare (CMP.W D6,D5 / BGE), which is the
 * counter's own width.
 *
 * The allocation size is passed widened to a long; the tracking allocator's
 * own source-line argument is the literal 394.
 *
 * The index scaling (EXT.L / ASL.L #2) is computed BEFORE the call and parked
 * in a frame local (MOVE.L D0,32(A7)), then reloaded afterwards to index the
 * store. That is the reserved-A5 spill class, not something the source asks
 * for.
 *
 * 86 ref vs 84 got, and everything that carries meaning matches: the MEMF word
 * 0x00010001, the PEA 394, the LEA 16(A7),A7 cleanup, the reload of the scaled
 * index through 16(A7) and the indexed store 0(An,D1.L).
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fffc ... 4e5d       LINK.W A5,#-4 / UNLK          (6 bytes)
 *   got:     594f ... 584f           SUBQ.W #4,A7 / ADDQ.W #4,A7   (4 bytes)
 *   summary: the frame class; 2 bytes, and the whole delta.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2005 48c0 e580          MOVE.L D5,D0 / EXT.L D0 / ASL.L #2,D0
 *   got:     48c5 2005 e580          EXT.L D5 / MOVE.L D5,D0 / ASL.L #2,D0
 *   summary: the original copies the counter and widens the copy; 6.51 widens
 *            the counter register in place and then copies. Same three
 *            instructions, same total size, reordered. Widening in place is
 *            harmless because the counter is a short: the bump and the bound
 *            test are both word operations (ADDQ.W #1,D5 / CMP.W D6,D5) and
 *            neither reads the high half.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/memory.h>

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern char  Global_STR_SCRIPT_C_1[];

void SCRIPT_AllocateBufferArray(void **arr, short size, short count)
{
    short i;

    for (i = 0; i < count; i++)
        arr[i] = MEMORY_AllocateMemory(
            Global_STR_SCRIPT_C_1, 394L, (long)size, MEMF_PUBLIC | MEMF_CLEAR);
}
