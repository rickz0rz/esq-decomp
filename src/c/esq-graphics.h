/* proto/graphics.h with a VOLATILE library base.  Include this, never
 * <proto/graphics.h>.  See esq-libbase.md in this directory for why.
 */
#ifndef ESQ_GRAPHICS_H
#define ESQ_GRAPHICS_H
#include <exec/types.h>
extern struct GfxBase * volatile GfxBase;
#include <clib/graphics_protos.h>
#include <pragmas/graphics_pragmas.h>
#endif
