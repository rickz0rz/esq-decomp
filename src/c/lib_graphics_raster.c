/* RESTORES: _GRAPHICS_AllocRaster, _GRAPHICS_FreeRaster
 * MODULE:   modules/submodules/unknown2b.s   (2 of its 9 labels)
 * STATUS:   behavioural
 *
 * ESQ's two wrappers over graphics.library AllocRaster and FreeRaster.
 *
 * THE FIRST TWO ARGUMENTS ARE DEBUG INFORMATION AND THE FUNCTIONS IGNORE THEM.
 * That is not obvious from the body, which reads its real arguments from
 * `16(A5)` and `20(A5)` -- the THIRD and FOURTH stack slots -- and never touches
 * the first two at all. Read from the body alone this looks like a two-argument
 * function with a strange frame. The caller settles it:
 *
 *     MOVE.L  D1,-(A7)              ; Height
 *     PEA     696.W                 ; Width
 *     PEA     79.W                  ; Line Number
 *     PEA     _Global_STR_ESQDISP_C ; Calling File
 *     JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)
 *
 * So the shape is (file, line, width, height), the same file-and-line debug pair
 * `MEMORY_AllocateMemory` takes. **Check a CALLER before writing a signature for
 * a wrapper that skips stack slots** -- guessing the arity from the body would
 * have produced a function that reads its arguments two slots early, and no byte
 * check would have seen it.
 *
 * `esq-graphics-leaf.h`, not `esq-graphics.h`. Each function makes exactly ONE
 * library call and no ESQ call, so it is in the `no-calls` bucket where a cached
 * library base is safe. The original loads the base once per function, which the
 * leaf header reproduces; the volatile header would add a reload the original
 * does not have. `tools/a6_audit.py` machine-checks the precondition -- if it
 * ever flags this file, switch it back rather than silencing the audit.
 *
 * NOT LINKED YET. `unknown2b.s` holds nine labels and a C file replaces a whole
 * module, so this cannot enter a manifest until the SAS/C stdio routines beside
 * it are also written. It is written now because `jmptbl_to_c.py` reads the
 * signature from here, which unblocks the jump tables that forward to these two.
 */
#include "esq-graphics-leaf.h"

long GRAPHICS_AllocRaster(char *who, long line, long width, long height)
{
    return (long)AllocRaster((unsigned long)width, (unsigned long)height);
}

void GRAPHICS_FreeRaster(char *who, long line, void *p, long width, long height)
{
    FreeRaster((PLANEPTR)p, (unsigned long)width, (unsigned long)height);
}
