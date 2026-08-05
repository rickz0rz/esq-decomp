/* RESTORES: (nothing -- see below)
 * MODULE:   modules/groups/_main/a/a_strings.s
 * STATUS:   behavioural
 *
 * THIS TRANSLATION UNIT IS DELIBERATELY EMPTY, and that is the whole point.
 *
 * The module it replaces holds one thing: `ESQ_STR_DosLibrary`, the string
 * "dos.library" sitting in the CODE section and reached PC-relative. Its only
 * reader is ESQ_StartupEntry, which now builds those eleven characters into a
 * stack local (`dos_library_name()` in lib_esq_startup_entry.c). So in the
 * maximum-C build the symbol has no reader and the module has nothing to
 * contribute -- and an empty object contributing nothing is exactly the right
 * replacement for it.
 *
 * WHY NOT JUST DEFINE THE STRING IN C? Because SAS/C 6.51 places every string
 * literal and every initialised static in `data`, with no option to put it
 * anywhere else, and a DATA hunk that grows shifts every symbol after it.
 * AGENTS.md records that `data/flib.s` did exactly that and froze the display,
 * measured twice. Building the text into a local keeps it in CODE, which is
 * where the original has it.
 *
 * WHY NOT DELETE THE ASSEMBLY MODULE? Because `src/Prevue.asm` is what the
 * BYTE-EXACT build assembles, and removing the module would move every byte
 * after it and fail `test-hash.sh`. The module stays; only the maximum-C build
 * replaces it. That is the same arrangement every other converted module has.
 *
 * This is the pattern for retiring a CODE-section string whose only reader is
 * C. It does NOT work when something else holds the string's ADDRESS -- see
 * strings_now_local_unknown36.c for the three that cannot move.
 */
