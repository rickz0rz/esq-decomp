/* RESTORES: ESQ_HandleSerialRbfInterrupt
 * MODULE:   modules/groups/a/a/app.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     700030390000a33ad3c03228001812810801000f670e32390000a33e524133c10000a33e52400c40fa006602700033c00000a33a32390000a33c9041640000060640fa0033c00000a342b0790000a3406500000833c00000a3400c40dac06500001c0c79010200005e8e6700001033fc010200005e8e52b9000070b8317c0800009c4e75
 *   got:     48e73714266f00242a6f00203e39000000003c2d0018700030073206178108000801000f670e303900000000524033c0000000005247700030070c800000fa0066027e00300733c0000000003439000000002a079a42b042640c7400340506820000fa002a02340533c200000000363900000000b443650633c200000000760036020c830000dac06d1a3639000000000c430102670e33fc01020000000052b9000000003b7c0800009c4cdf28ec4e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the custom-chip base arrives in A0 and the ring
 * buffer pointer in A1; it is a serial RBF interrupt handler. Documented only. */
extern short Global_WORD_H_VALUE, Global_WORD_T_VALUE, Global_WORD_MAX_VALUE;
extern short ESQ_SerialRbfErrorCount, ESQ_SerialRbfFillLevel;
extern short ESQPARS2_ReadModeFlags;
extern long  SCRIPT_SerialReadModeOverflowCount;

void ESQ_HandleSerialRbfInterrupt(volatile short *custom, unsigned char *ring)
{
    unsigned short h = Global_WORD_H_VALUE;
    unsigned short serdatr = custom[12];
    unsigned short fill;

    ring[h] = (unsigned char)serdatr;
    if (serdatr & 0x8000)
        ESQ_SerialRbfErrorCount = ESQ_SerialRbfErrorCount + 1;
    h++;
    if (h == 0xfa00)
        h = 0;
    Global_WORD_H_VALUE = h;
    fill = h - (unsigned short)Global_WORD_T_VALUE;
    if (h < (unsigned short)Global_WORD_T_VALUE)
        fill += 0xfa00;
    ESQ_SerialRbfFillLevel = fill;
    if (fill >= (unsigned short)Global_WORD_MAX_VALUE)
        Global_WORD_MAX_VALUE = fill;
    if (fill >= 0xdac0 && ESQPARS2_ReadModeFlags != 0x102) {
        ESQPARS2_ReadModeFlags = 0x102;
        SCRIPT_SerialReadModeOverflowCount += 1;
    }
    custom[78] = 0x800;
}
