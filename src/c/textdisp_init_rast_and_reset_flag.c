/* RESTORES: TEXTDISP_InitRastAndResetFlag
 * MODULE:   modules/groups/b/a/textdisp2_p0_p0.s
 * STATUS:   behavioural
 *
 * 36 bytes against 36, in TWO regions, and neither costs a byte. Everything
 * agrees: the three arguments in the original's order, the deferred
 * LEA 12(A7),A7 that cleans up after the SECOND call rather than the first,
 * and the CLR.W on the flag.
 *
 * SASC-MISMATCH: cross-unit-call-opcode
 *   ref:     4eba32d8 ... 4eba4b42      JSR (d16,PC), twice
 *   got:     61000000 ... 61000000      BSR.W,        twice
 *   summary: same size, same displacement width, same semantics; only the
 *            call opcode differs. The original used JSR (d16,PC) to reach a
 *            callee in another translation unit. SAS/C 6.51 emits BSR.W for
 *            every call, whoever the callee is.
 *   tried:   nothing reaches it from the source. The opcode is not selectable.
 *   scope:   the whole cross-unit bucket, and none of it is exact.
 *   retest:  a compiler that picks the call opcode from the callee's
 *            translation unit matches this byte for byte.
 */
extern void *WDISP_DisplayContextBase;
extern short WDISP_AccumulatorFlushPending;

extern void *TLIBA3_BuildDisplayContextForViewMode(long a, long b, long c);
extern void  WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);

void TEXTDISP_InitRastAndResetFlag(void)
{
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 3L);
    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();
    WDISP_AccumulatorFlushPending = 0;
}
