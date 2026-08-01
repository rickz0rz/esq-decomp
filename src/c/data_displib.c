/* RESTORES: (data module -- no function)
 * MODULE:   data/displib.s
 * STATUS:   behavioural
 *
 * THE FIRST DATA MODULE MOVED TO C. It is the proof that the DATA section can
 * follow the code out of assembly, and it is deliberately the smallest one:
 * three symbols, 24 bytes.
 *
 * WHY IT WORKS AT ALL. tools/gen_units.py runs its replacement map over BOTH the
 * code group and the data group -- `coalesce(...)` is called twice with the same
 * `repl` -- so a manifest line naming a path under data/ already links a C object
 * at that module's position. No build change was needed to try this.
 *
 * `NStr` IS STRING PLUS NUL PLUS EVEN ALIGNMENT (`DC.B \1,0` then `CNOP 0,2`),
 * which is exactly what a C string literal in an array of unspecified size
 * emits. "DISPLIB.c" is 9 characters, so both spellings occupy 10 bytes and the
 * next symbol starts on an even address either way.
 *
 * THE UNINITIALISED LONG IS WRITTEN `= 0` ON PURPOSE. `DS.L 1` inside a loaded
 * DATA hunk contributes four zero bytes to the image. A C global with no
 * initialiser is a tentative definition that SAS/C may place in BSS, which the
 * linker would put in a different hunk and move everything after it. Writing the
 * zero keeps the symbol in S_1 where the original has it. Check the emitted
 * section with `python3 tools/objbytes.py` before adding any further data module
 * -- this is the one thing about data that code restorations never had to think
 * about.
 *
 * THE SYMBOLS ALREADY CARRY LEADING UNDERSCORES in the assembly, so the C names
 * drop them and no rename pass is needed. Most data modules are NOT like this;
 * run tools/check_c_symbols.py after adding one.
 *
 * ORDER WITHIN THE FILE IS THE ORDER IN THE ORIGINAL, and it has to be. C says
 * nothing about where two globals land relative to each other, so any module
 * whose code reads across a symbol boundary must become one struct or array
 * first. tools/data_adjacency_audit.py finds exactly eight such groups over
 * 2,218 symbols, and none of them is here.
 */

char Global_STR_DISPLIB_C_1[] = "DISPLIB.c";
char Global_STR_DISPLIB_C_2[] = "DISPLIB.c";

/* Per-line horizontal pixel offset for inline markers. `DS.L 1` in the original;
 * see the note above on why the zero is written out. */
long DISPTEXT_ControlMarkerXOffsetPx = 0;
