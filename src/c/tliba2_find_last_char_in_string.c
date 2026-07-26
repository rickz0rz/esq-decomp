/* RESTORES: TLIBA2_FindLastCharInString
 * MODULE:   modules/groups/b/a/tliba2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff848e70110266d00081e2d000f42adfff8204b4a1866fc538891cb2008224bd3c053892b49fffc206dfffc1010b00766062b48fff8600c53adfffc206dfffcb1cb64e4202dfff84cdf08804e5d4e75
 *   got:     594f48e701341e2f001f2a6f001897cb2f4d0010206f00104a10670652af001060f2202f0010220d90812041d1c02448538a1012b0076604264a6006538ab5cd64f0200b4cdf2c80584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
char *TLIBA2_FindLastCharInString(char *s, char want)
{
    char *found = 0;
    char *p;
    char *e = s;

    while (*e)
        e++;
    p = s + (e - s) - 1;
    do {
        if (*p == want) {
            found = p;
            break;
        }
        p--;
    } while (p >= s);
    return found;
}
