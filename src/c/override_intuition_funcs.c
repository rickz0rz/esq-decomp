/* RESTORES: OVERRIDE_INTUITION_FUNCS
 * MODULE:   modules/groups/a/z/locavail2.s
 * STATUS:   behavioural
 *
 * Patches intuition.library so the program can never be interrupted by a system
 * requester: AutoRequest is replaced by a no-op and DisplayAlert by a routine
 * that pauses and reboots. Both originals are saved so they can be put back.
 *
 * This is a set-top box with no keyboard attached in normal operation -- a
 * requester waiting for a mouse click would hang it forever, and a guru would sit
 * on screen. Rebooting is the recovery.
 *
 * 62 bytes in the original, 62 emitted, and the ONLY difference is where the LVO
 * offset is loaded into A0 relative to the other two arguments. Same instruction,
 * same encoding, moved four bytes. Everything else matches, including the
 * PC-relative LEA of each replacement routine's address.
 *
 * SASC-MISMATCH: argument-setup-order
 *   ref:     A1 = library, A0 = offset, A2 = routine, D0 = A2
 *   got:     A1 = library, A2 = routine, D0 = A2, A0 = offset
 *   summary: The pragma fixes which register each argument lands in, not the
 *            order they are set up in, and the two code generators pick different
 *            orders. casm reports it as a -4 / +4 pair at each of the two calls.
 *            Not reachable from the source: routing the offset through a local
 *            makes it worse (+6, and A5 enters the save mask).
 *   scope:   any library call whose arguments are set up from more than one
 *            expression. Same family as the argument-pop ordering recorded in
 *            esqiff_handle_brush_ini_reload_hotkey.c.
 */
#include <proto/exec.h>

extern void LOCAVAIL2_AutoRequestNoOp();
extern void LOCAVAIL2_DisplayAlertDelayAndReboot();

extern struct Library *Global_REF_INTUITION_LIBRARY;
extern void *Global_REF_BACKED_UP_INTUITION_AUTOREQUEST;
extern void *Global_REF_BACKED_UP_INTUITION_DISPLAYALERT;

void OVERRIDE_INTUITION_FUNCS(void)
{
    Global_REF_BACKED_UP_INTUITION_AUTOREQUEST =
        SetFunction(Global_REF_INTUITION_LIBRARY, -348L,
                    (unsigned long (*)())LOCAVAIL2_AutoRequestNoOp);
    Global_REF_BACKED_UP_INTUITION_DISPLAYALERT =
        SetFunction(Global_REF_INTUITION_LIBRARY, -90L,
                    (unsigned long (*)())LOCAVAIL2_DisplayAlertDelayAndReboot);
}
