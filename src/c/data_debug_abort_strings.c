/* RESTORES: DEBUG_STR_UserAbortRequested,
 *           DEBUG_STR_Continue,
 *           DEBUG_STR_Abort
 * MODULE:   modules/submodules/unknown36_p0_strings.s
 * STATUS:   behavioural
 *
 * THE LAST 44 BYTES OF ASSEMBLY, AND THIS FILE IS ONLY FOR THE PORTABLE BUILD.
 *
 * These three constants are the Ctrl-C break requester's body and button text.
 * They are the one thing the character-at-a-time trick cannot retire, because
 * data_wdisp_p1.c writes their ADDRESSES into DEBUG_AbortRequesterTagChain --
 * a stack local has no address a linker can put in a table. Defining them in C
 * is the only other way, and on the Amiga that is exactly what must not happen:
 * SAS/C 6.51 places every string literal and initialised static in `data`, and
 * a DATA hunk that grows shifts every symbol after it and FREEZES THE DISPLAY.
 * Measured twice on data/flib.s, and again on a 16-byte static in
 * lib_hex_parse_sprintf.c.
 *
 * THE AMIGA BUILD MUST NOT LINK THIS FILE. It is named only by
 * src/c/replacements-portable.txt, which tools/portable_build.sh generates.
 * The default manifest leaves the assembly module in place and the box runs.
 *
 * THE PORTABLE BUILD HAS NO SUCH CONSTRAINT. Off-Amiga there is no hunk layout
 * to preserve, so these become ordinary string literals and the source set
 * contains no .s file at all -- which is the point of the exercise.
 *
 * THE SIZES ARE EXPLICIT AND THEY CARRY THE PADDING NULs. The assembly is
 * `DC.B "...",0,0`, so the arrays are 28, 10 and 6 bytes, not 27, 9 and 6.
 * Writing `char X[] = "..."` would drop a byte and shift every symbol after it
 * -- the rule data_to_c.py enforces for every converted data module, and the
 * reason data_offset_audit.py exists.
 */
#ifndef ESQ_PORTABLE
#define ESQ_PORTABLE 0
#endif

#if ESQ_PORTABLE

unsigned char DEBUG_STR_UserAbortRequested[28] = "** User Abort Requested **";
unsigned char DEBUG_STR_Continue[10]           = "CONTINUE";
unsigned char DEBUG_STR_Abort[6]               = "ABORT";

#endif
