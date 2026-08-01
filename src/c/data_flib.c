/* RESTORES: (data module -- no function)
 * MODULE:   data/flib.s
 * STATUS:   behavioural
 *
 * DO-NOT-LINK: the module is 154 bytes, which is not a multiple of 4. A hunk
 *   object is longword-sized, so replacing it grows the DATA hunk by 4 and moves
 *   every symbol after it. The display then freezes within seconds. Measured
 *   twice, reproducibly: `hunk1 MISMATCH size: 55820 vs 55824`, soak 3 of 10
 *   distinct frames, 2 illegal/exception lines against 1 for a healthy build.
 *   The two data modules that ARE linked, displib (24 bytes) and esqpars (92),
 *   are both multiples of 4, change the DATA hunk size by nothing, and run.
 *
 * THE CONTENT OF THIS FILE IS CORRECT and was checked byte by byte against the
 * assembly before the failure was understood: 8, 8, 2, 24, 24, 28, 24, 22, 14 at
 * offsets 0, 8, 16, 18, 42, 66, 94, 118, 140, totalling 154. Nothing here needs
 * changing. What it needs is a way to occupy 154 bytes rather than 156, and an
 * object cannot.
 *
 * WHAT THE EVIDENCE SHOWS AND WHAT IT DOES NOT. It shows that shifting the data
 * section by 4 bytes breaks the program. It does NOT show which symbol minds.
 * The likely reason is that something after this module needs an alignment
 * stronger than the shift preserves, or is read at a fixed distance from a
 * neighbour -- tools/data_adjacency_audit.py skips any symbol the code only ever
 * takes the ADDRESS of, so it cannot see that class. Do not guess; if this
 * module is wanted, bisect the DATA section by inserting 4 bytes of padding at
 * successive points in the assembly and find what stops working.
 *
 * Eight strings and one two-byte zero. No cross-symbol reads. See
 * src/c/data_displib.c for why a data module can be replaced at all.
 *
 * EVERY ARRAY CARRIES AN EXPLICIT SIZE, AND THAT IS NOT STYLE. `NStr` ends in
 * `CNOP 0,2`, so a string of ODD length gets a pad byte. **SAS/C 6.51 does NOT
 * word-align consecutive char arrays**, so leaving the sizes off does not
 * reproduce that padding: written `char X[] = "FLIB.c"` this module compiled to
 * 148 bytes against the assembly's 154, with the second string at offset 7
 * instead of 8 and every symbol after it shifted. With the padded sizes written
 * out the offsets are 0, 8, 16, 18, 42, 66, 94, 118, 140 -- the assembly's own
 * layout, exactly.
 *
 * So the size of each array is the NStr footprint: string, plus the NUL, rounded
 * UP to even. Check any new data module with `python3 tools/objbytes.py` and
 * compare the offsets against the assembly. The total alone is not enough --
 * data/esqpars.c came out at the right total size with two symbols in the wrong
 * place, because the padding it lost and the object rounding it gained happened
 * to cancel.
 *
 * `FLIB_EmptyLogReplacementString` IS TWO ZERO BYTES, NOT ONE. The original is
 * `DC.B 0,0`, and the comment in the assembly explains it: the symbol is passed
 * by ADDRESS as a source string, so one NUL would do, and the second byte keeps
 * the following symbol on an even address without a CNOP. Written `= {0, 0}`
 * rather than left uninitialised, so SAS/C keeps it in the data section instead
 * of moving it to BSS -- see the note in data_displib.c.
 */

char Global_STR_FLIB_C_1[8] = "FLIB.c";
char Global_STR_FLIB_C_2[8] = "FLIB.c";

/* Two NULs. Passed by address as an empty source string. */
char FLIB_EmptyLogReplacementString[2] = { 0, 0 };

char FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02[24] = "%02ld:%02ld:%02ld:%02ld";

char FLIB_STR_DIGITAL_NICHE_LISTINGS[24]     = "Digital Niche Listings";
char FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS[28] = "Digital Multiplex Listings";
char FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S[24] = "Digital Multiplex at %s";
char FLIB_STR_DIGITAL_PPV_LISTINGS[22]       = "Digital PPV Listings";
char Global_STR_DIGITAL_PPV_PERIOD[14]       = "Digital PPV.";
