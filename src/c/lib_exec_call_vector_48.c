/* RESTORES: _EXEC_CallVector_48
 * MODULE:   modules/submodules/unknown40_p0.s
 * STATUS:   behavioural
 *
 * IT IS RawKeyConvert, AND THE DISASSEMBLY'S NAME FOR IT IS WRONG.
 * The body reads:
 *
 *     MOVEA.L _INPUTDEVICE_LibraryBaseFromConsoleIo,A6
 *     MOVEM.L 12(A7),A0-A1        ; event, buffer
 *     MOVEM.L 20(A7),D1/A2        ; length, keymap
 *     JSR     _LVOexecPrivate3(A6)
 *
 * `_LVOexecPrivate3` is -48, and the disassembly named it for EXEC because that
 * is the library its offset table happened to be labelled from. But the base
 * loaded here is the CONSOLE DEVICE, cached by ESQ from its console IO request,
 * and -48 on console.device is RawKeyConvert. The stock pragma settles it:
 *
 *     #pragma libcall ConsoleDevice RawKeyConvert 30 A19804
 *
 * `04` is the argument count and the nibbles before it are the registers, read
 * right to left: 8 = A0, 9 = A1, 1 = D1, A = A2 -- exactly the four the MOVEMs
 * load, in exactly that order. An offset alone would not have been enough to
 * identify it; the register spec is what makes it certain.
 *
 * So this function is a thin wrapper that exists only to give the register-based
 * device call an ordinary stack-argument signature. `src/c/esq-console.h`
 * restates the pragma against ESQ's own base variable, because the stock one
 * names `ConsoleDevice` and ESQ does not use that name.
 *
 * The one caller is `GCOMMAND_...` in `modules/groups/a/v/gcommand5.s`, which
 * uses it to turn a raw key event into characters when a command of type 1 is
 * compared against `_ED_StateRingTable`.
 *
 * SASC-MISMATCH: saved-register-set
 *   ref:     48e72022 / 4cdf4404      MOVEM.L A2/A6 saved and restored
 *   got:     whatever 6.51 needs for the inlined libcall
 *   summary: the original saves A2 and A6 because it loads both by hand. The
 *            pragma makes the compiler responsible for the base, so the saved
 *            set is its choice. Same call, same registers at the JSR.
 *   scope:   this function.
 *   retest:  not applicable.
 */
#include "esq-console.h"

long EXEC_CallVector_48(struct InputEvent *event, char *buffer, long length,
                        struct KeyMap *keyMap)
{
    return INPUTDEVICE_RawKeyConvert(event, buffer, length, keyMap);
}
