/* RESTORES: (nothing -- this module was a jump table)
 * MODULE:   modules/groups/b/a/textdisp_p3.s
 * STATUS:   behavioural
 *
 * DELIBERATELY EMPTY. Every thunk this module held is gone.
 *
 * A jump table entry was one `JMP target`. The tables existed because
 * the ORIGINAL's translation units could not reach each other with a
 * 16-bit PC-relative call. Compiled C has no such limit, so every
 * caller now calls the target directly and the thunk is dead weight --
 * one extra call and one extra frame per invocation.
 *
 * THIS FILE AND ITS MANIFEST ROW MUST STAY. gen_units.py links the
 * assembly module wherever a row is absent, so deleting either would
 * put the jump table back and reintroduce assembly.
 *
 * Removed by tools/remove_jmptbl.py.
 */
