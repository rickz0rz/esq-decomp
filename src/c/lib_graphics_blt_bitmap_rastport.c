/* RESTORES: GRAPHICS_BltBitMapRastPort
 * MODULE:   modules/submodules/unknown39.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a thin wrapper on graphics.library's BltBitMapRastPort.
 * It loads the library base, moves nine arguments off the stack into the
 * registers the call wants, and calls.
 *
 * THE ORIGINAL READS THE BASE FROM A4 NEAR-DATA
 * (`MOVEA.L Global_GraphicsLibraryBase_A4(A4),A6`), which a DATA=FAR build has
 * no access to. `esq-graphics.h` reaches the same library through the absolute
 * `GfxBase` that src/data/esq.s labels, which is what every other restored
 * graphics caller in this program already does.
 *
 * esq-graphics.h, NOT esq-graphics-leaf.h. The leaf header exists for a function
 * whose every call is a library call and it would be correct here on that test
 * -- there is exactly one call and it is a library call. The volatile header is
 * used anyway because this is a LIBRARY wrapper reached from arbitrary places,
 * and a reload before a single call costs 2 bytes once. Read the a6_audit note
 * in AGENTS.md before changing it.
 *
 * SASC-MISMATCH: argument-shuffle
 *   ref:     MOVEM.L 32(A7),D0-D1 and MOVEM.L 44(A7),D2-D6, two instructions
 *            moving seven arguments
 *   got:     one move per argument
 *   summary: the original loads consecutive stack arguments into consecutive
 *            registers with MOVEM, which C cannot express. Same nine values
 *            arrive in the same nine registers.
 *   scope:   every register-heavy library wrapper in submodules/.
 *   retest:  a compiler that coalesces argument loads into MOVEM.
 */
#include "esq-graphics.h"

void GRAPHICS_BltBitMapRastPort(struct BitMap *srcBitMap, long xSrc, long ySrc,
                                struct RastPort *destRP, long xDest, long yDest,
                                long xSize, long ySize, unsigned long minterm)
{
    BltBitMapRastPort(srcBitMap, xSrc, ySrc, destRP, xDest, yDest,
                      xSize, ySize, minterm);
}
