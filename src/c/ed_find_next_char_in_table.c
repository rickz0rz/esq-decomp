/* RESTORES: ED_FindNextCharInTable
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc48e701101e2d000b266d000c700010072f002f0b4ebae076504f2b40fffc4a80670652adfffc60042b4bfffc206dfffc4a1066042b4bfffc206dfffc10104cdf08804e5d4e75
 *   got:     48e701141e2f00132a6f0014700010072f002f0d6100000026404a80504f6704528b6002264d10136602264d1013488048c04cdf28804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(char *s, long c);
long ED_FindNextCharInTable(unsigned char c, char *table)
{
    char *p;

    p = GROUP_AI_JMPTBL_STR_FindCharPtr(table, (long)c);
    if (p != 0)
        p = p + 1;
    else
        p = table;
    if (*p == 0)
        p = table;
    return *p;
}
