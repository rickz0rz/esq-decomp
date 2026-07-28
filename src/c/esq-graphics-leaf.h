/* graphics protos with a NON-volatile library base, for LEAF functions only.
 *
 * Use `esq-graphics.h` by default. Use this header ONLY in a function whose
 * every call is a library call, and say so in the file's header comment.
 *
 * WHY THIS EXISTS
 *
 * esq-graphics.h declares GfxBase volatile, which forces a base reload before
 * every library call. That is mandatory in general -- ESQ's hand-written
 * assembly clobbers A6 and returns without restoring it, so a cached base after
 * an ESQ call enters the wrong library at the same offset and resets the
 * machine. The full account is in esq-libbase.md.
 *
 * But the hazard is specifically an intervening call to ESQ ASSEMBLY. AmigaOS
 * library functions preserve A6 (only D0/D1/A0/A1 are volatile across a library
 * call), so a base cached across nothing but library calls is safe. The
 * original relies on exactly that: TLIBA3_DrawInnerFrameBorder loads
 * Global_REF_GRAPHICS_LIBRARY once and issues four Move/Draw calls on it.
 *
 * Forcing a reload in those functions is not fidelity, it is our artifact --
 * +6 bytes per call site that the original does not have and never had.
 *
 * WHAT KEEPS THIS HONEST
 *
 * tools/a6_audit.py already draws the line in the right place. Read its `audit`
 * loop: a `jsr d16(a6)` leaves the base live, while a `jsr`/`bsr` to a symbol
 * clears it. So if anyone later adds a call to ESQ assembly in a file that
 * includes THIS header, the next library call is flagged and the audit exits
 * nonzero. The precondition is machine-checked, not a comment.
 *
 * Run it after any C build:
 *     /tmp/.capvenv/bin/python tools/a6_audit.py
 *
 * If a6_audit flags a file that includes this header, the fix is to switch that
 * file back to esq-graphics.h -- NOT to silence the audit.
 *
 * Note this is a per-file choice, not a per-call one: a function that makes both
 * library calls and ESQ calls must use esq-graphics.h and eat the reloads.
 */
#ifndef ESQ_GRAPHICS_LEAF_H
#define ESQ_GRAPHICS_LEAF_H
#include <exec/types.h>
extern struct GfxBase *GfxBase;
#include <clib/graphics_protos.h>
#include <pragmas/graphics_pragmas.h>
#endif
