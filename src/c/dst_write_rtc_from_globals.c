/* RESTORES: DST_WriteRtcFromGlobals
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: cross-unit-call-opcode
 *   ref:     4eba066c4e75      JSR (d16,PC) / RTS
 *   got:     610000004e75      BSR.W        / RTS
 *   summary: the whole function is one call to the group jump stub and a
 *            return. Size, displacement width and semantics agree; only the
 *            call opcode differs. The original used JSR (d16,PC), which is how
 *            it reached a callee in another translation unit. SAS/C 6.51 emits
 *            BSR.W for every call, whoever the callee is.
 *   tried:   nothing to try. The source is one statement.
 *   scope:   the whole cross-unit bucket, 153 restorations and none of them
 *            exact. script_read_next_rbf_byte.c is the same class in six bytes.
 *   retest:  a compiler that picks the call opcode from the callee's
 *            translation unit would match this byte for byte.
 */
extern void PARSEINI_WriteRtcFromGlobals(void);

void DST_WriteRtcFromGlobals(void)
{
    PARSEINI_WriteRtcFromGlobals();
}
