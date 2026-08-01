/* RESTORES: _STRING_AppendAtNull
 * MODULE:   modules/submodules/unknown6.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Appends `src` to the end of `dst` and returns `dst`. It is
 * strcat, and the original is strcat's own two-loop shape: scan `dst` to its
 * NUL, then copy `src` including the terminator.
 *
 * WRITTEN AS strcat ON PURPOSE. AGENTS.md records that strlen, strcmp and strcpy
 * inline to the original's scan loops under 6.51 with no library call involved,
 * and strcat is the same family. Writing the loops by hand would emit the same
 * work in a different order for no gain.
 *
 * IT RETURNS `dst`, and the original captures it into D0 BEFORE walking the
 * pointer -- `MOVE.L A0,D0` is the third instruction. strcat returns dst too, so
 * the value is the same, but do not be tempted to return the end of the string:
 * a caller that chains appends would then skip the copy it just made.
 */
#include <string.h>

char *STRING_AppendAtNull(char *dst, char *src)
{
    strcat(dst, src);
    return dst;
}
