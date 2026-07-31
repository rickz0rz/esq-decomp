/* diskfont protos with a VOLATILE library base.  Include this, never
 * <proto/diskfont.h>.  See esq-libbase.md in this directory for why.
 *
 * The pragma names the base `DiskfontBase`, so src/data/esq.s carries a
 * `_DiskfontBase` label on Global_REF_DISKFONT_LIBRARY, exactly as it already
 * does for `_GfxBase` and `_DOSBase`.  Adding a label emits no bytes, so both
 * gates stay green.
 */
#ifndef ESQ_DISKFONT_H
#define ESQ_DISKFONT_H
#include <exec/types.h>
extern struct Library * volatile DiskfontBase;
#include <clib/diskfont_protos.h>
#include <pragmas/diskfont_pragmas.h>
#endif
