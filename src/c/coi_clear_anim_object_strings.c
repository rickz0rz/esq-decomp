/* RESTORES: COI_ClearAnimObjectStrings
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * 154 bytes in the original, 154 emitted -- and here the agreement IS structural,
 * not a coincidence: the instruction sequence matches one-for-one and the only
 * divergence is which address registers were chosen. (refbytes reports the body
 * as 148 because the MOVEM/RTS epilogue sits under the separate label
 * COI_ClearAnimObjectStrings_Return, 6 bytes; cdiff therefore shows 156 against
 * 148, the extra 2 being trailing alignment padding.)
 *
 * Frees the seven owned strings hanging off the anim object at ctx+48 by handing
 * each to ESQPARS_ReplaceOwnedString with a NULL replacement, zeroes the four
 * leading flag bytes, and clears the pointer at +32.
 *
 * Getting here took two corrections worth recording:
 *
 * 1. The body was written as *(char **)(obj + 4) and so on. That makes SAS/C
 *    compute each address with a LEA into A0 and dereference it, costing two
 *    bytes per access -- 212 bytes against 148. Rewriting the object as a struct
 *    makes it fold the offset into a (d16,An) displacement, which is what the
 *    original uses throughout. See the source-shapes table in AGENTS.md; the same
 *    rule is the whole story in ctasks_start_close_task_process.c.
 *
 *    With the struct, SAS/C also reproduces the original's stack-slot reuse --
 *    MOVE.L 8(A3),(A7) writing over the previous argument rather than popping and
 *    pushing again, with a single LEA 32(A7),A7 at the end. That idiom looked
 *    like a hand-written flourish; it is just what the compiler does once the
 *    argument is a foldable memory operand.
 *
 * 2. The reference ends with CLR.L 32(A2), an eighth field the C had simply
 *    omitted. Nothing in the diff pointed at it -- the size was wrong for an
 *    unrelated reason and the tail regions were misaligned. It surfaced only on
 *    reading the reference listing to the end. Worth the habit.
 *
 * SASC-MISMATCH: address-register-allocation
 *   ref:     48e70030 ... 266f000c    MOVEM.L A2-A3,-(A7) / MOVEA.L 12(A7),A3
 *            with the object in A2 and the context in A3
 *   got:     48e70014 ... 2a6f000c    MOVEM.L A3/A5,-(A7) / MOVEA.L 12(A7),A5
 *            with the object in A3 and the context in A5
 *   summary: the A5-as-register-variable class. Every displacement instruction
 *            differs only in its register field (2f2a0004 vs 2f2b0004,
 *            25400004 vs 27400004, 15400001 vs 17400001), which is why the region
 *            count is high while the byte count is exact. Costs nothing.
 *   scope:   the largest single divergence class in this directory; 304 functions.
 *            docs/compiler-version.md:191
 *   retest:  a compiler that does not reserve A5.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba17b4                 JSR  ..._ReplaceOwnedString(PC)
 *   got:     61000000                 BSR.W _..._ReplaceOwnedString
 *   summary: the standard call-encoding class, 7 sites here. Both 4 bytes.
 *
 * SASC-MISMATCH: epilogue-movem-form
 *   ref:     245f265f                 MOVEA.L (A7)+,A2 / MOVEA.L (A7)+,A3
 *   got:     4cdf2800                 MOVEM.L (A7)+,A3/A5
 *   summary: the original pops two address registers as two MOVEA.L instructions;
 *            SAS/C uses one MOVEM. Both 4 bytes.
 */
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newstr, char *old);

struct AnimObj {
    unsigned char b0, b1, b2, b3;
    char *s4, *s8, *s12, *s16, *s20, *s24, *s28, *s32;
};

void COI_ClearAnimObjectStrings(unsigned char *ctx)
{
    register struct AnimObj *obj;

    if (ctx)
        obj = *(struct AnimObj **)(ctx + 48);
    else
        obj = 0;

    if (obj == 0)
        return;

    obj->b3 = obj->b2 = obj->b1 = obj->b0 = 0;

    obj->s4  = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s4);
    obj->s8  = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s8);
    obj->s12 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s12);
    obj->s16 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s16);
    obj->s20 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s20);
    obj->s24 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s24);
    obj->s28 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, obj->s28);
    obj->s32 = 0;
}
