/* RESTORES: (nothing)
 * MODULE:   modules/groups/a/t/gcommand2_p1.s
 * STATUS:   behavioural
 *
 * DELIBERATELY EMPTY -- this module is pure alignment padding, and the
 * maximum-C build drops it. The full reasoning, the measurement showing
 * C cannot emit bytes into the code section, and the list of all
 * thirteen such modules are in src/c/padding_removed.c.
 *
 * One file per module because gen_all_manifest.py de-duplicates extra
 * rows by C FILE, which is a guard worth keeping: two modules sharing a
 * real restoration would link duplicate symbols.
 */
