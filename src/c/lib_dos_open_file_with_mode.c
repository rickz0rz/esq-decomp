/* RESTORES: _DOS_OpenFileWithMode
 * MODULE:   modules/submodules/unknown2b_dos_openfilewithmode.s
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
 * SPLIT OUT OF unknown2b.s, which held nine labels including the SAS/C stdio
 * routines. `tools/split_module.py` cut this onto its own `;!======` boundary,
 * byte-neutral, so it links while the stdio group stays in assembly.
 */
#include "esq-dos.h"

long DOS_OpenFileWithMode(char *path, long mode)
{
    return (long)Open(path, mode);
}
