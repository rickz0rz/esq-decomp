/* RESTORES: DISKIO_ParseLongFromWorkBuffer
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc61b2307cffff2b40fffcb0886604200860062f004eba19a24e5d4e75
 *   got:     2f0d610000002a40207c0000ffffb1cd6608203c0000ffff60082f0d61000000584f2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern long  GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
long DISKIO_ParseLongFromWorkBuffer(void)
{
    char *s = DISKIO_ConsumeCStringFromWorkBuffer();

    if (s == (char *)-1)
        return -1;
    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(s);
}
