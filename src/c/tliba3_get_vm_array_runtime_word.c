/* RESTORES: TLIBA3_GetVmArrayRuntimeWord
 * MODULE:   modules/groups/b/a/tliba3_p2.s   (its only block)
 * STATUS:   behavioural
 *
 * Reads the word at +2 of one entry in the view-mode runtime table.
 *
 * THE DISASSEMBLY ALREADY CALLED IT DEAD -- the module's first line is
 * `; Dead code.` -- and it carried no label until 2026-08-04. The module before
 * it in src/Prevue.asm ends in RTS, so it cannot be reached by fall-through
 * either. Adding the label is byte-neutral. The name is OURS.
 *
 * THE STRIDE IS 154 AND THE ORIGINAL BUILDS IT AT RUN TIME. It loads 77 into D1
 * and then doubles it with `ADD.L D1,D1` rather than loading 154 directly,
 * which is how a MOVEQ reaches a value above 127. Holding the stride in a local
 * is what keeps SAS/C from strength-reducing the multiply into shifts and adds:
 * against the literal it emits no call, where the original calls MATH_Mulu32.
 * Same lever as unknown_parse_list_and_update_entries.c.
 *
 * SASC-MISMATCH: movq-doubled-constant
 *   ref:     7a4d d282   MOVEQ #77,D1 then ADD.L D1,D1
 *   got:     the constant materialised once
 *   summary: 2 bytes. The multiply itself is the same helper call.
 *   scope:   any restoration whose constant exceeds a MOVEQ's range.
 *   retest:  nothing to retest; it is an assembler-level choice.
 */
struct TlibaVmRuntimeEntry {
    short f0;
    short word;                 /* +2 -- the field this returns */
};

extern struct TlibaVmRuntimeEntry TLIBA3_VmArrayRuntimeTable[];

long TLIBA3_GetVmArrayRuntimeWord(long index)
{
    long stride = 77 * 2;

    return ((struct TlibaVmRuntimeEntry *)
            ((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->word;
}
