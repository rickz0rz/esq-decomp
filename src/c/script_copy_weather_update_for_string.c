/* RESTORES: SCRIPT_CopyWeatherUpdateForString
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * 22 bytes against 22, in ONE region, and the region costs nothing. Every
 * instruction agrees, including the inlined copy loop -- strcpy expands to the
 * original's MOVE.B (A0)+,(A1)+ / BNE.S with no library call involved.
 *
 * SASC-MISMATCH: callee-saved-address-register
 *   ref:     2f0b 266f0008 ... 224b ... 265f    outBuffer in A3
 *   got:     2f0d 2a6f0008 ... 224d ... 2a5f    outBuffer in A5
 *   summary: same instructions, same sizes, different address register. The
 *            function has no locals, so it emits no LINK and A5 is free;
 *            SAS/C 6.51 takes A5 first. The original took A3.
 *   tried:   SAS/C cannot pin a local to a register. `register __a3` is
 *            accepted only on the parameters of an __asm function, and this
 *            function takes its argument on the stack.
 *   scope:   program-wide, every LINK-less function that caches a pointer.
 *            script_set_ctrl_context_mode.c records the same class.
 *   retest:  a compiler that allocates A3 before A5 matches this byte for
 *            byte.
 */
#include <string.h>

extern char Global_STR_WEATHER_UPDATE_FOR[];

void SCRIPT_CopyWeatherUpdateForString(char *outBuffer)
{
    strcpy(outBuffer, Global_STR_WEATHER_UPDATE_FOR);
}
