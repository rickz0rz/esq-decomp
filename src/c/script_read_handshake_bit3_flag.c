/* RESTORES: SCRIPT_ReadHandshakeBit3Flag
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * Reads CIAB port A bit 3, the serial handshake line. 32 bytes both ways;
 * only the data-register pair is swapped (ref D7 then D6, got D6 then D7).
 *
 * NOTE: CIAB_PRA comes from src/hardware-exports.s for the same reason as
 * VPOSR -- a pointer cast would emit MOVEA.L #imm,An + MOVE.B (An),Dn.
 *
 * SASC-MISMATCH: register-allocation-order
 *   summary: SAS/C 6.51 allocates A5 for the first pointer local where the
 *            original always uses A3, and D6 before D7 where the original uses
 *            D7 first. Every other byte matches. Not the data model (reproduces
 *            with and without DATA=FAR, and these touch no globals) and not an
 *            option: NOAUTOREG, OPTIMIZE and SHORTINT all leave it in place.
 *            Consistent across every function with a pointer local, so it is a
 *            code-generator difference, not a source-form one.
 *   tried:   DATA=FAR on/off, NOAUTOREG, OPTIMIZE, SHORTINT.
 *   retest:  a compiler that picks A3 before A5, and D7 before D6, should match
 *            these sources unchanged.
 */
extern volatile unsigned char CIAB_PRA;

long SCRIPT_ReadHandshakeBit3Flag(void)
{
    long flag;
    long value = CIAB_PRA;

    if (value & 8)
        flag = 1;
    else
        flag = 0;
    return flag;
}
