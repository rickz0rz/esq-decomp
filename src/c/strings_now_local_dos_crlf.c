/* RESTORES: (nothing -- see strings_now_local_main_a.c for the pattern)
 * MODULE:   modules/submodules/unknown2b_p1_p0.s
 * STATUS:   behavioural
 *
 * DELIBERATELY EMPTY. The module holds `DOS_STR_CRLF`, a CR/LF pair in the
 * CODE section reached by address. Its only reader is
 * STREAM_BufferedPutcOrFlush, which now writes the two bytes into a stack
 * local, so the symbol has no reader and the module has nothing to contribute
 * to the maximum-C build.
 *
 * The assembly module stays, because `src/Prevue.asm` is what the byte-exact
 * build assembles. See strings_now_local_main_a.c for the full note on why the
 * string cannot simply be defined in C.
 */
