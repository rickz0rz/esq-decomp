/* RESTORES: SCRIPT_ReadHandshakeBit5Mask
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * Returns CIAB port A bit 5 as a mask. 30 bytes both ways.
 *
 * SASC-MISMATCH: assignment-sunk-into-branches
 *   ref:     ... 7220 c081 2c00 2006   (mask in D0, then stored once to D6)
 *   got:     ... 2c00 7220 cc81 2006   (copied to D6 first, then masked there)
 *   summary: The original computes the whole expression in D0 and stores the
 *            result to the D6-allocated local once; SAS/C moves the value into
 *            D6 first and operates there. Same class as
 *            [newgrid_get_grid_mode_index.c].
 *   tried:   one local vs two, explicit (unsigned short) cast on the widening,
 *            returning the expression directly.
 *   retest:  a compiler that keeps whole-expression evaluation in D0 before the
 *            store should match this source.
 */
extern volatile unsigned char CIAB_PRA;

long SCRIPT_ReadHandshakeBit5Mask(void)
{
    unsigned short v = CIAB_PRA;
    long mask = v & 32;

    return mask;
}
