/* proto/dos.h with a VOLATILE library base.  Include this, never
 * <proto/dos.h>.  See esq-libbase.md in this directory for why.
 */
#ifndef ESQ_DOS_H
#define ESQ_DOS_H
#include <exec/types.h>
extern struct DosLibrary * volatile DOSBase;
#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>
#endif
