/* RESTORES: SCRIPT_DeassertCtrlLineNow
 * MODULE:   modules/groups/b/a/script2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     61c84e75                  BSR.S _SCRIPT_DeassertCtrlLine / RTS
 *   got:     610000004e754e71          BSR.W _SCRIPT_DeassertCtrlLine / RTS / pad
 *   summary: the whole function is one call and a return. The original reaches
 *            its callee with an 8-bit BSR.S, because the callee sits a few
 *            bytes away in the same translation unit. SAS/C 6.51 has no 8-bit
 *            call form at all: it emits BSR.W for every call. That is +2 bytes,
 *            and it is the complete difference. Same target, same semantics.
 *   tried:   nothing to try. The source is one statement; there is no other C
 *            form of it.
 *   scope:   every restoration that calls anything. See
 *            script_read_next_rbf_byte.c for the same class in six bytes.
 *   retest:  a compiler that picks the branch width from the distance to the
 *            callee would match this exactly.
 */
extern void SCRIPT_DeassertCtrlLine(void);

void SCRIPT_DeassertCtrlLineNow(void)
{
    SCRIPT_DeassertCtrlLine();
}
