/* proto/intuition.h with a VOLATILE library base.  Include this, never
 * <proto/intuition.h>.  See esq-libbase.md in this directory for why.
 */
#ifndef ESQ_INTUITION_H
#define ESQ_INTUITION_H
#include <exec/types.h>
extern struct IntuitionBase * volatile IntuitionBase;
#include <clib/intuition_protos.h>
#include <pragmas/intuition_pragmas.h>
#endif
