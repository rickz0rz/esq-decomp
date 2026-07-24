/* STRING_AppendAtNull -- replaces modules/submodules/unknown6.s
 *
 * Appends src to the end of dst and returns dst; i.e. strcat().
 *
 * NOTE: the original 22 bytes are verbatim SAS/C 6.51 library code (the exact
 * sequence appears in sc.lib/scnb.lib/scs.lib/scsnb.lib), compiled from SAS's
 * own library sources. No C we feed to sc reproduces it byte-for-byte, so this
 * is a *behavioural* replacement, not a byte-exact one -- it exists to exercise
 * the mixed C+asm pipeline and to act as a visual canary. The function is
 * called from 111 sites across disptext/textdisp/wdisp/newgrid/displib, so if
 * it is wrong, on-screen text garbles immediately and unmistakably.
 *
 * For a faithful build this function should be linked from sc.lib instead.
 */
char *STRING_AppendAtNull(char *dst, char *src)
{
    char *p = dst;

    while (*p)
        p++;
    while ((*p++ = *src++) != 0)
        ;
    return dst;
}
