/* RESTORES: ESQ_InvokeGcommandInit
 * MODULE:   modules/groups/a/a/app3b.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04, AS AN `__asm` REGISTER FUNCTION.
 *
 * THIS IS AN INPUT-DEVICE HANDLER, not an ordinary routine, and the name hides
 * it. `KYBD_InitializeInputDevices` allocates an Interrupt, stores this
 * routine's address in `is_Code`, and sends io_Command 9 -- IND_ADDHANDLER --
 * to input.device. So input.device calls it, with the convention input.device
 * uses: A0 holds the InputEvent list, A1 holds `is_Data`, and D0 returns the
 * list the handler wants passed on.
 *
 * That is why the entry reads A0 and A1 without loading them, and
 * `register __a0` / `register __a1` state it exactly. The old DO-NOT-LINK
 * called this a convention "no C function can express", which is not true on
 * this toolchain.
 *
 * The original installs the JUMP-TABLE THUNK rather than this routine --
 * `LEA _GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(PC),A0` in kybd.s -- and the
 * thunk is a bare JMP, so the registers pass through untouched. The C build
 * installs this routine directly, which removes one JMP from every keystroke.
 * jmptbl_a_v_xjump.c keeps the thunk with the same `__asm` shape, so either
 * address works as a handler.
 *
 * SASC-MISMATCH: unread-second-argument
 *   ref:     48e700c04eb90001d320508f4e75   (14)
 *   summary: the original pushes BOTH A0 and A1 as arguments with one
 *            MOVEM.L A0-A1,-(A7), then cleans 8 bytes. Its callee
 *            GCOMMAND_ProcessCtrlCommand reads only the first -- its body
 *            starts `MOVEA.L 8(A5),A3` and never touches 12(A5). The C below
 *            passes the one argument the callee declares, so the second push
 *            and 4 of the 8 bytes of cleanup are gone. Nothing reads the byte
 *            that is no longer written, so this is a size difference only.
 *   tried:   declaring the callee with a second, ignored parameter reproduces
 *            the push, at the cost of a prototype that contradicts the
 *            callee's own restoration. AGENTS.md rule 1 says keep the honest
 *            declaration and record the divergence, which is what this is.
 *   scope:   one site.
 *   retest:  nothing to retest; it is a source-level choice, not codegen.
 */
#ifndef CTRLCOMMAND_DEFINED
struct CtrlCommand;
#endif

extern long __saveds GCOMMAND_ProcessCtrlCommand(struct CtrlCommand *cmd);

long __asm ESQ_InvokeGcommandInit(register __a0 struct CtrlCommand *events,
                                  register __a1 void *userData)
{
    return GCOMMAND_ProcessCtrlCommand(events);
}
