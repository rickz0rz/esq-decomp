/* proto/utility.h with a VOLATILE library base.  Include this, never
 * <proto/utility.h>.  See esq-libbase.md in this directory for why.
 *
 * The base is _UtilityBase, which src/data/esq.s labels beside
 * _Global_REF_UTILITY_LIBRARY -- the same arrangement _GfxBase, _DOSBase,
 * _DiskfontBase and _IntuitionBase already use. A label emits no bytes, so both
 * gates stay green across adding one.
 */
#ifndef ESQ_UTILITY_H
#define ESQ_UTILITY_H
#include <exec/types.h>
extern struct Library * volatile UtilityBase;
#include <clib/utility_protos.h>
#include <pragmas/utility_pragmas.h>
#endif
