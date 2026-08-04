/* RESTORES: LOCAVAIL2_AutoRequestNoOp
 * MODULE:   modules/groups/a/z/locavail2_locavail2_autorequestnoop.s
 * STATUS:   exact
 *
 * BYTE-EXACT, confirmed by `tools/mismatches.py --recheck` on 2026-08-04:
 * 14 bytes against 14. It became exact when `__saveds` was added, which is
 * the strongest evidence that the keyword is the right one for an
 * OS-entered callback whose original opens MOVE.L A4,-(A7) / LEA <data>,A4.
 *
 *
 * SASC-MISMATCH: unused-a4-setup
 *   ref:     2f0c49f9000080007000285f4e75
 *   got:     70004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: installed over intuition.library/AutoRequest by SetFunction: library register convention.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
extern char Global_REF_LONG_FILE_SCRATCH[];
long __saveds LOCAVAIL2_AutoRequestNoOp(void)
{
    return 0;
}
