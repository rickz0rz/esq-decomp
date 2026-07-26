/* RESTORES: ESQ_ReadSerialRbfByte
 * MODULE:   modules/groups/a/a/app.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     7200200132390000a33c2079000086f2d1c1101052410c41fa006602720033c10000a33c2f0030390000a33a9041640000060640fa000c79010200005e8e660000120c40bb806400000a33fc000000005e8e201f4e75
 *   got:     48e727007e003c390000000020790000000070003006d1c07e001e105246700030060c800000fa0066027c00300633c00000000032390000000048c17400340092822a0132390000000048c174003400b2826c0c7200320506810000fa002a013239000000000c4101026612720032050c810000bb806c0642790000000020074cdf00e44e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short Global_WORD_T_VALUE, Global_WORD_H_VALUE;
extern unsigned char *Global_REF_INTB_RBF_64K_BUFFER;
extern short ESQPARS2_ReadModeFlags;

long ESQ_ReadSerialRbfByte(void)
{
    long b = 0;
    unsigned short t = Global_WORD_T_VALUE;
    unsigned short fill;

    b = Global_REF_INTB_RBF_64K_BUFFER[t];
    t++;
    if (t == 0xfa00)
        t = 0;
    Global_WORD_T_VALUE = t;
    fill = Global_WORD_H_VALUE - t;
    if (Global_WORD_H_VALUE < t)
        fill += 0xfa00;
    if (ESQPARS2_ReadModeFlags == 0x102 && fill < 0xbb80)
        ESQPARS2_ReadModeFlags = 0;
    return b;
}
