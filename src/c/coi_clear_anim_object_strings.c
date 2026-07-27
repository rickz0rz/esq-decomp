/* RESTORES: COI_ClearAnimObjectStrings
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * 148 bytes in the original, 212 emitted, 9 differing regions. A large delta from
 * one cause -- see below.
 *
 * Reproduces: the null-context guard producing a null object rather than an early
 * return, the four leading flag bytes cleared from one zeroed register, and all
 * seven owned strings released through ReplaceOwnedString(0, ...) with each
 * result stored back.
 *
 * SASC-MISMATCH: stack-slot-reuse-not-applied
 *   ref:     2eaa0008 42a7 4eba....     MOVE.L 8(A2),(A7) / CLR.L -(A7) / JSR
 *   got:     fresh push pair plus LEA cleanup per call
 *   summary: The original writes each successive argument into the SAME stack
 *            slot the previous call left behind, pushing only the new NULL, and
 *            cleans up once with a single LEA 32(A7),A7 at the end. SAS/C pushes
 *            a fresh pair for every call and balances each one. Across seven
 *            calls that is the entire +64.
 *   tried:   register qualifier on the object pointer -- no effect.
 *   NOTE:    SAS/C DOES apply this reuse elsewhere, for instance across the two
 *            adjacent calls in esqiff2_clear_line_head_tail_by_mode.c, so the
 *            optimisation exists but does not extend to a run of seven. The
 *            difference is worth recording precisely because a blanket
 *            "SAS/C cannot reuse stack slots" would be false.
 *   scope:   any function making several same-shape calls in sequence.
 */
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newstr, char *old);

void COI_ClearAnimObjectStrings(unsigned char *ctx)
{
    register unsigned char *obj;

    if (ctx)
        obj = *(unsigned char **)(ctx + 48);
    else
        obj = 0;

    if (obj == 0)
        return;

    obj[3] = obj[2] = obj[1] = obj[0] = 0;

    *(char **)(obj +  4) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj +  4));
    *(char **)(obj +  8) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj +  8));
    *(char **)(obj + 12) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj + 12));
    *(char **)(obj + 16) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj + 16));
    *(char **)(obj + 20) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj + 20));
    *(char **)(obj + 24) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj + 24));
    *(char **)(obj + 28) = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(char **)(obj + 28));
}
