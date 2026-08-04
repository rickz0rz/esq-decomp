/* RESTORES: _GRAPHICS_AllocRaster
 * MODULE:   modules/submodules/unknown2b_graphics_allocraster.s
 * STATUS:   behavioural
 *
 * ESQ's wrapper over graphics.library AllocRaster.
 *
 * THE FIRST TWO ARGUMENTS ARE DEBUG INFORMATION AND THE FUNCTION IGNORES THEM.
 * That is not obvious from the body, which reads its real arguments from the
 * THIRD and FOURTH stack slots and never touches the first two. The caller
 * settles it:
 *
 *     MOVE.L  D1,-(A7)              ; Height
 *     PEA     696.W                 ; Width
 *     PEA     79.W                  ; Line Number
 *     PEA     _Global_STR_ESQDISP_C ; Calling File
 *
 * so the shape is (file, line, ...), the same debug pair MEMORY_AllocateMemory
 * takes. CHECK A CALLER before writing a signature for a wrapper that skips
 * stack slots -- guessing from the body reads every argument two slots early,
 * and no byte check would see it. DOS_OpenFileWithMode, from the same module,
 * takes no such pair, so the wrappers do not share a convention.
 *
 * `esq-graphics-leaf.h`, not `esq-graphics.h`. This makes exactly ONE library
 * call and no ESQ call, so it is in the `no-calls` bucket where a cached
 * library base is safe, and the original loads the base once. `a6_audit.py`
 * machine-checks that precondition -- if it ever flags this file, switch it back
 * rather than silencing the audit.
 */
#include "esq-graphics-leaf.h"

long GRAPHICS_AllocRaster(char *who, long line, long width, long height)
{
    return (long)AllocRaster((unsigned long)width, (unsigned long)height);
}
