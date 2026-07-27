/* RESTORES: BRUSH_LoadColorTextFont
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * 234 bytes in the original, 224 emitted, 10 differing regions.
 *
 * Reproduces: the three failure paths each with their own source-line constant
 * (396 for the alloc, 416 for the oversize check, 431 for the short read) and
 * each deallocating before returning -1, the Read against dos.library with the
 * length compared to the request, the nested unpack loops where the outer steps
 * by three and the inner runs a fixed three times, the high-nibble extraction
 * (ASR.L #4 then AND #15) and the separate output index that advances
 * independently of the input pointer, and the success path returning 1 after a
 * final deallocation.
 *
 * The 96-byte allocation size is Struct_ColorTextFont_Size in the assembly, and
 * the oversize guard compares the requested length against the same constant --
 * so a caller asking for more than one ColorTextFont's worth is rejected rather
 * than overflowing the buffer.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0                   LINK.W A5,#-16
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. The original spills the buffer pointer, the
 *            walking pointer and the inner counter; SAS/C keeps all three in
 *            registers, which is the whole -10.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include <exec/memory.h>
#include "esq-dos.h"

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern char Global_STR_BRUSH_C_1[];
extern char Global_STR_BRUSH_C_2[];
extern char Global_STR_BRUSH_C_3[];
extern char Global_STR_BRUSH_C_4[];

long BRUSH_LoadColorTextFont(BPTR fh, long size, unsigned char *out)
{
    unsigned char *buf;
    unsigned char *p;
    short j;
    register short outIdx;
    register short i;

    buf = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_1, 396, 96,
                                                MEMF_PUBLIC);
    if (buf == 0)
        return -1;

    if (size > 96) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_2, 416, buf, 96);
        return -1;
    }

    if (Read(fh, buf, size) != size) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_3, 431, buf, 96);
        return -1;
    }

    outIdx = 0;
    i = 0;
    p = buf;
    while (i < size) {
        for (j = 0; j < 3; j++) {
            out[outIdx] = (*p++ >> 4) & 15;
            outIdx++;
        }
        i += 3;
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_4, 445, buf, 96);
    return 1;
}
