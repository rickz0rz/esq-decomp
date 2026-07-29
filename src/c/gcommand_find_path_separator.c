/* RESTORES: GCOMMAND_FindPathSeparator
 * MODULE:   modules/groups/a/t/gcommand2.s
 * STATUS:   behavioural
 *
 * Returns a pointer to the character after the last ':' or '/' in a path.
 * With no separator, and with an empty string, it returns the start.
 *
 * The backward walk stops on a count test (n == 1) instead of on a pointer
 * compare against the start. That is what the original does, and it keeps the
 * length in D7 as a live loop counter.
 *
 * The strlen inlines to the original's own scan loop, byte for byte:
 * MOVEA.L A3,A0 / TST.B (A0)+ / BNE / SUBQ.L #1,A0 / SUBA.L A3,A0.
 *
 * 80 bytes against 96, and tools/casm.py attributes ALL 16 to the one
 * divergence below.
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff8 ... 2b48fffc / 206dfffc   LINK A5,#-8; cursor in -4(A5)
 *   got:     48e70314 ... 264d                  no frame; cursor in A3
 *   summary: the original keeps the walking cursor in a stack slot and reloads
 *            it on every use. SAS/C 6.51 keeps it in an address register and
 *            needs no frame at all, which removes the LINK/UNLK pair and every
 *            spill around the loop.
 *   tried:   nothing source-side. The variable is an ordinary local whose
 *            address is never taken, so no legal C form asks for the spill.
 *   scope:   program-wide. The same class is recorded in
 *            diskio_consume_cstring_from_work_buffer.c,
 *            diskio_consume_line_from_work_buffer.c and
 *            gcommand_apply_highlight_flag.c.
 *   retest:  a compiler that spills a local pointer instead of allocating it to
 *            an address register. Re-run tools/mismatches.py --recheck.
 */
#include <string.h>

char *GCOMMAND_FindPathSeparator(char *path)
{
    char *p;
    long n;
    char c;

    n = strlen(path);
    if (n == 0)
        p = path;
    else {
        p = path + n - 1;
        for (;;) {
            c = *p;
            if (c == ':' || c == '/') {
                p++;
                break;
            }
            if (n == 1) {
                p = path;
                break;
            }
            p--;
            n--;
        }
    }
    return p;
}
