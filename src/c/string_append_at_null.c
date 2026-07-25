/* RESTORES: _STRING_AppendAtNull
 * MODULE:   modules/submodules/unknown6.s
 * STATUS:   library
 *
 * Appends src to the end of dst and returns dst; i.e. strcat().
 *
 * Called from 111 sites across disptext/textdisp/wdisp/newgrid/displib, which
 * makes it the best visual canary in the program: if it is wrong, on-screen
 * text garbles immediately and unmistakably.
 *
 * SASC-MISMATCH: library-routine-not-reproducible
 *   ref:     226f0008 206f0004 2008 4a18 66fc 5388 10d9 66fc 4e75  (22 bytes)
 *   got:     2f0a 226f000c 206f0008 2448 ... 245f 4e75             (32 bytes,
 *            with OPTIMIZE; 42 bytes without)
 *   summary: This is not application code. The original 22 bytes appear
 *            verbatim in SAS/C 6.51's sc.lib, scnb.lib, scs.lib and scsnb.lib,
 *            i.e. it is the library's own strcat, compiled from SAS's library
 *            sources with their build settings. Hand-written C is not expected
 *            to reproduce it and does not.
 *   tried:   default, OPTIMIZE, OPTIMIZE OPTSIZE, OPTIMIZE OPTTIME; while/for
 *            scan loops and do/while copy loops.
 *   retest:  do NOT chase this with more C. The correct fix is to link the
 *            routine from sc.lib. Kept as C only because it is the highest-signal
 *            canary available. See "Library code is not application code" in
 *            AGENTS.md -- the same applies to most of modules/submodules/.
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
