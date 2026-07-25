/* RESTORES: ESQ_ReverseBitsIn6Bytes
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dbf-loop
 *   ref:     206f0004226f000848e7380070051819671c0c0400ff6716760022031204280374070501670207c4524351cafff610c451c8ffdc4cdf001c4e75
 *   got:     594f48e70f14266f00242a6f00207e051c1b1a0667467000100672004601b081673a78003f7c0007001a7a00302f001a48c0720001c170001006c0816710300448c0720001c17000100580812a005244302f001a536f001a4a4066d01ac5200753474a4066aa4cdf28f0584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
void ESQ_ReverseBitsIn6Bytes(unsigned char *dst, unsigned char *src)
{
    short n = 5;

    do {
        unsigned char v = *src++;
        unsigned char out = v;
        if (v != 0 && v != 0xFF) {
            short bit = 0;
            short i = 7;
            out = 0;
            do {
                if (v & (1 << i))
                    out |= (1 << bit);
                bit++;
            } while (i--);
        }
        *dst++ = out;
    } while (n--);
}
