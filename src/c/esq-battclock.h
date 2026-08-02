/* proto/battclock.h with a VOLATILE resource base.  Include this, never
 * <proto/battclock.h>.  See esq-libbase.md in this directory for why.
 *
 * The base is _BattClockBase, which src/data/esq.s labels beside
 * _Global_REF_BATTCLOCK_RESOURCE. battclock is a RESOURCE rather than a library,
 * but the call convention is the same: base in A6, offset from the LVO.
 */
#ifndef ESQ_BATTCLOCK_H
#define ESQ_BATTCLOCK_H
#include <exec/types.h>
extern struct Library * volatile BattClockBase;
#include <clib/battclock_protos.h>
#include <pragmas/battclock_pragmas.h>
#endif
