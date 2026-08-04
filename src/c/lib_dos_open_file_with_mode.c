/* RESTORES: _DOS_OpenFileWithMode
 * MODULE:   modules/submodules/unknown2b.s   (1 of its 9 labels)
 * STATUS:   behavioural
 *
 * ESQ's wrapper over dos.library Open. Two arguments, both passed straight
 * through: the path in D1 and the mode in D2, which is Open's own convention.
 *
 * Unlike the two graphics wrappers in the same module, this one takes NO
 * file-and-line debug pair. It reads its arguments from the first two stack
 * slots. The three wrappers do not share a convention, so read each one.
 *
 * The result is returned as it comes back from Open, in D0. Callers treat it as
 * a BPTR file handle, and `esq_check_topaz_font_guard.c` declares it that way
 * while other callers use `long`. Both are the same 32 bits.
 *
 * `esq-dos.h`, so the library base is volatile and reloaded. The original loads
 * it once here, but there is only one call so the two forms agree -- and there
 * is deliberately no `esq-dos-leaf.h` in this project. See AGENTS.md.
 *
 * NOT LINKED YET, for the same reason as `lib_graphics_raster.c`: `unknown2b.s`
 * holds nine labels and a C file replaces a whole module. It is written now so
 * `jmptbl_to_c.py` can read the signature and unblock the two jump tables that
 * forward here.
 */
#include "esq-dos.h"

long DOS_OpenFileWithMode(char *path, long mode)
{
    return (long)Open(path, mode);
}
