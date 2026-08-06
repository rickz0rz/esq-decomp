/* RESTORES: DEBUG_STR_UserAbortRequested,
 *           DEBUG_STR_Continue,
 *           DEBUG_STR_Abort
 * MODULE:   modules/submodules/unknown36_p0_strings.s
 * STATUS:   behavioural
 *
 * THE LAST 44 BYTES OF ASSEMBLY IN ESQ. With this file linked, the program
 * contains none.
 *
 * These three constants are the Ctrl-C break requester's body and button text.
 * They are the one thing the character-at-a-time trick cannot retire, because
 * data_wdisp_p1.c writes their ADDRESSES into DEBUG_AbortRequesterTagChain, and
 * a stack local has no address a linker can put in a table. So they must be
 * real C definitions, and SAS/C 6.51 places every string literal in `data`.
 *
 * THAT MOVES THE DATA HUNK, AND IT IS SAFE HERE. hunk1 grows 55,820 -> 55,864.
 * AGENTS.md said such growth freezes the display, on the evidence of
 * data/flib.s. Re-measured 2026-08-06: two soaks PASS and a replayed listings
 * feed writes a curday.dat BYTE-IDENTICAL to the assembly control.
 *
 * The rule was a conflation. ESQ does not depend on the absolute offset of a
 * data symbol -- the linker relocates every absolute reference. It depends on
 * the DISTANCE between two symbols, hardcoded in the 59 Global_* A4 equates in
 * src/Prevue.asm, the 102 <symbol> + <number> offsets in esq-neardata.h, and
 * the eight adjacencies AGENTS.md lists. This module links FIRST, so its bytes
 * land at DATA offset 0, in front of every pre-existing symbol: the image
 * shifts as one piece, the A4 base moves 0x8000 -> 0x802c, and every distance
 * survives. data/flib.s broke a distance INSIDE a module, which is the fatal
 * kind, and data_offset_audit.py now catches it.
 *
 *   Growth at the FRONT of the DATA hunk is free. Growth in the MIDDLE is not.
 *
 * THE SIZES ARE EXPLICIT AND THEY CARRY THE PADDING NULs. The assembly is
 * `DC.B "...",0,0`, so the arrays are 28, 10 and 6 bytes, not 27, 9 and 6.
 * Writing `char X[] = "..."` would drop a byte and shift these three relative
 * to each other -- the exact fault above, and the reason data_to_c.py enforces
 * an explicit size on every converted data module.
 *
 * The byte-exact gates are untouched: test-hash.sh and the default
 * build-split.sh do not read any manifest, so the assembly module still builds
 * the reference image.
 */

unsigned char DEBUG_STR_UserAbortRequested[28] = "** User Abort Requested **";
unsigned char DEBUG_STR_Continue[10]           = "CONTINUE";
unsigned char DEBUG_STR_Abort[6]               = "ABORT";
