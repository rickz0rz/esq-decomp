/* RESTORES: ESQ_FindSubstringCaseFold
 * MODULE:   modules/groups/a/a/app2_esq_findsubstringcasefold.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     206f0004226f000848e7003070004a11670e264824494a10660c4a126602200b245f265f4e754a1267f41218b21266044a1a60e208410005b21266044a1a60d6240ab3c267062208538120412648244960c4
 *   got:     594f48e70134266f001c2a6f00184a1366047000604c244d2f4b00104a156610206f00101010670470006036200a6032206f001010106604200a60261e1d1010b007671808470005be006710b1cb6702538d244d224b2f49001060c052af001060ba4cdf2c80584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
char *ESQ_FindSubstringCaseFold(char *hay, char *needle)
{
    char *start, *n;
    char c;

    if (*needle == 0)
        return 0;
    start = hay;
    n = needle;
    for (;;) {
        if (*hay == 0) {
            if (*n != 0)
                return 0;
            return start;
        }
        if (*n == 0)
            return start;
        c = *hay++;
        if (c != *n) {
            c ^= 0x20;
            if (c != *n) {
                if (needle != n)
                    hay--;
                start = hay;
                n = needle;
                continue;
            }
        }
        n++;
    }
}
