/* RESTORES: COI_CountEscape14BeforeNull
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70f10266f00182e2f001c7a007c0028064a456626200648c0b0876c1e7000103360004a40670804400014670660087a01600452445246524660d620044cdf08f04e75
 *   got:     594f48e70f042e2f00202a6f001c7c007a0078004a44662a300548c0b0876c22103550007200120048af0002001666047801600a7014b240660452465245524560d2300648c04cdf20f0584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long COI_CountEscape14BeforeNull(char *buf, long limit)
{
    short count = 0;
    short i = 0;
    short done = 0;

    while (!done && (long)i < limit) {
        short c = (unsigned char)buf[i];
        if (c == 0)
            done = 1;
        else if (c == 20) {
            count++;
            i++;
        }
        i++;
    }
    return count;
}
