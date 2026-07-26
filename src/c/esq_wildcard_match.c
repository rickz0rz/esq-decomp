/* RESTORES: ESQ_WildcardMatch
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: byte-return-width
 *   ref:     206f0004226f0008b0fc00006720b2fc0000671a7000101812190c01002a67184a0067100c01003f67ec900167e8103c00014e754a0166f6103c00004e75
 *   got:     48e70314266f00182a6f0014200d6704200b66047001602a1e1d1c1b702abc0066047000601c4a07660c4a0656c04400488048c0600c703fbc0067dcbe0667d870014cdf28c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long ESQ_WildcardMatch(char *text, char *pattern)
{
    char t, p;

    if (text == 0 || pattern == 0)
        return 1;
    for (;;) {
        t = *text++;
        p = *pattern++;
        if (p == '*')
            return 0;
        if (t == 0)
            return p != 0;
        if (p == '?')
            continue;
        if (t != p)
            return 1;
    }
}
