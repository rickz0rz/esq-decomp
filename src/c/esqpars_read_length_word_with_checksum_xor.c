/* RESTORES: ESQPARS_ReadLengthWordWithChecksumXor
 * MODULE:   modules/groups/a/o/esqpars_p1_2.s
 * STATUS:   behavioural
 *
 * The reference extract is 62 bytes and stops early: the epilogue is branched
 * to from the loop bound test, so it carries its own label
 * (ESQPARS_ReadLengthWordWithChecksumXor_Return) and refbytes stops there.
 * The epilogue is MOVE.L D7,D0 / MOVEM.L (A7)+,D5-D7 / RTS, 8 bytes, so the
 * real function is 70. With that added back it is 70 against 70, in FOUR
 * regions, none of which costs a byte. The entry MOVEM and the first
 * parameter load are byte-identical.
 *
 * Two type choices are load-bearing and each is worth 2 bytes:
 *   - `b` is `unsigned char`, not `long`. As a long the value makes a round
 *     trip through a second register (MOVE.L D0,D5 / MOVE.L D5,D0) before the
 *     EOR, which the original does not do.
 *   - the return type is `unsigned char`, not `long`. As a long the epilogue
 *     zero-extends (MOVEQ #0,D0 / MOVE.B D7,D0) where the original moves the
 *     register straight out.
 *
 * SASC-MISMATCH: zero-then-store-order
 *   ref:     7000 33c0<len> 2a00     MOVEQ #0,D0 / store D0 / copy D0 to D5
 *   got:     7c00 3006 33c0<len>     MOVEQ #0,D6 / copy D6 to D0 / store D0
 *   summary: 10 bytes either way. Both hold one zero in a register and use it
 *            twice, which is what `ESQIFF_RecordLength = i = 0;` asks for;
 *            they disagree only about which register holds it first.
 *   tried:   separate statements are worse -- they emit the store and the
 *            clear independently. The chain is the right form.
 *
 * SASC-MISMATCH: data-register-allocation
 *   ref:     i in D5, b in D6
 *   got:     i in D6, b in D5
 *   summary: the pair is swapped. Same instructions, same sizes. SAS/C 6.51
 *            allocates from D7 down in order of first use.
 *
 * SASC-MISMATCH: cross-unit-call-opcode
 *   ref:     4ebab0ac 4eba00ee      JSR (d16,PC), twice
 *   got:     61000000 61000000      BSR.W,        twice
 *   summary: same size, same semantics, different opcode. SAS/C 6.51 emits
 *            BSR.W for every call, whoever the callee is.
 *   scope:   the whole cross-unit bucket, and none of it is exact.
 *   retest:  a compiler that picks the opcode from the callee's translation
 *            unit matches.
 *
 * SASC-MISMATCH: return-move-width
 *   ref:     2e07      MOVE.L D7,D0
 *   got:     1007      MOVE.B D7,D0
 *   summary: 2 bytes either way. Only the low byte of D7 was ever written, so
 *            the long move carries undefined bits in the upper half and every
 *            caller reads the byte. The original's compiler moved the whole
 *            register because it was cheaper to not care.
 */
extern unsigned short ESQIFF_RecordLength;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern long ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);

unsigned char ESQPARS_ReadLengthWordWithChecksumXor(unsigned char xorAcc)
{
    short i;
    unsigned char b;

    ESQIFF_RecordLength = i = 0;
    while (i < 2) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        xorAcc ^= b;
        ESQIFF_RecordLength = (unsigned short)((ESQIFF_RecordLength << 8) + b);
        i++;
    }
    return xorAcc;
}
