/* RESTORES: _SCRIPT_SetCtrlContextMode
 * MODULE:   modules/groups/b/a/script3b_p0_p1.s
 * STATUS:   behavioural
 *
 * 34 bytes against 34, in TWO regions, and neither region changes the size.
 * Both offsets are visible in the reference and need no inference: the mode
 * goes to (A3) and the constant 1 to 2(A3). The caller side is already
 * restored in script_init_ctrl_context.c, which is exact.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     48e70110 266f000c 3e2f0012 ...   MOVEM / load ctx / load mode
 *   got:     48e70104 3e2f0012 2a6f000c ...   MOVEM / load mode / load ctx
 *   summary: the prologue loads the same two parameters from the same two
 *            stack slots into the same two registers, in the opposite order.
 *            Zero bytes either way. SAS/C 6.51 emits its parameter loads in
 *            reverse declaration order; the original emits them in
 *            declaration order.
 *   tried:   nothing reaches it from the source. The order is fixed in the
 *            prologue, before any statement of the body runs, so no
 *            rewriting of the body can move it.
 *   scope:   every restoration with two or more register-cached parameters.
 *   retest:  a compiler that loads parameters in declaration order matches
 *            this function byte for byte, together with the register choice
 *            below.
 *
 * SASC-MISMATCH: callee-saved-address-register
 *   ref:     266f000c 3687 377c00010002 2f0b 4cdf0880    ctx in A3
 *   got:     2a6f000c 3a87 3b7c00010002 2f0d 4cdf2080    ctx in A5
 *   summary: same instructions, same sizes, different address register. The
 *            function has no locals, so it emits no LINK and A5 is free;
 *            SAS/C 6.51 takes A5 first. The original took A3.
 *   tried:   SAS/C has no way to pin a local to a register. `register __a3`
 *            is accepted only on the parameters of an __asm function, and
 *            this function takes its arguments on the stack.
 *   scope:   program-wide, every LINK-less function that caches a pointer.
 *   retest:  a compiler that allocates A3 before A5 would remove this.
 */
struct SCRIPT_CtrlContext {
    short mode;                    /* +0 */
    short primarySearchFirstFlag;  /* +2 */
};

extern void SCRIPT_ResetCtrlContext(struct SCRIPT_CtrlContext *ctx);

void SCRIPT_SetCtrlContextMode(struct SCRIPT_CtrlContext *ctx, short mode)
{
    ctx->mode = mode;
    ctx->primarySearchFirstFlag = 1;
    SCRIPT_ResetCtrlContext(ctx);
}
