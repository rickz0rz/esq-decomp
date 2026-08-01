/* RESTORES: _ESQ_ColdReboot
 * MODULE:   modules/groups/a/a/app2_p9.s
 * STATUS:   behavioural
 *
 * Reboots the machine. On Kickstart 2.0 and later it calls exec's ColdReboot();
 * on 1.x, which has no such call, it enters supervisor mode and runs
 * _ESQ_SupervisorColdReboot, which does the reset by hand.
 *
 * 16 ref vs 52 got, and the whole of that gap is the original being HAND-WRITTEN
 * ASSEMBLY rather than compiled C. Three separate idioms account for it: the
 * tail JMP below, one cached A6 serving both the version read and the call, and
 * no register saves at all. A 16-byte reference that a compiler answers with 52
 * is the diagnostic AGENTS.md describes -- a large positive delta with no
 * structural disagreement means the original was not compiled.
 *
 * THE VERSION TEST IS `< 36`, SIGNED. The original reads `CMPI.W #$24,20(A6)`
 * followed by `BLT.S`, and offset 20 of ExecBase is LibNode.lib_Version. 0x24 is
 * 36, the Kickstart 2.0 exec version, which is the release that added
 * ColdReboot.
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     4eeeffa2         JMP  _LVOColdReboot(A6)
 *   got:     4eaeffa2 4e75    JSR  _LVOColdReboot(A6) / RTS
 *   summary: the original TAIL-JUMPS into ColdReboot, leaving its own return
 *            address on the stack for ColdReboot to return through. SAS/C emits
 *            a call and then a return, which is 2 bytes longer and leaves one
 *            extra frame live for the instant before the machine resets.
 *            Nothing observes the difference: ColdReboot does not return.
 *            This is the single `tail-jump` site in the program -- AGENTS.md
 *            records that exactly one function ends in a tail JMP, and it is
 *            this one.
 *   tried:   nothing can reach it. SAS/C emits no tail jump for any call, and
 *            this project does not use inline assembly.
 *   scope:   one site.
 *   retest:  a compiler that turns a call in return position into a jump.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     one MOVEA.L AbsExecBase,A6 serving the version read and the call
 *   got:     a reload before the call, because esq-exec.h declares the base
 *            volatile
 *   summary: the extra load costs 6 bytes. It is deliberate and it is what makes
 *            every other exec call in this program safe -- see esq-libbase.md.
 *            There is no esq-exec-leaf.h by design.
 *   scope:   program-wide.
 *   retest:  not a compiler question; it is the header contract.
 *
 * SASC-MISMATCH: compare-signedness
 *   ref:     0c6e0024 0014 6d04   CMPI.W #36,20(A6) / BLT
 *   got:     7224 b041 6410       MOVEQ #36,D1 / CMP.W D1,D0 / BCC
 *   summary: the original compares SIGNED, the restoration UNSIGNED, because
 *            lib_Version is declared UWORD in exec/execbase.h and that is what
 *            the field is. The two agree for every version below 32768, so no
 *            Amiga can tell them apart. Same constant, same branch direction.
 *   scope:   one site.
 *   retest:  not a compiler question; it follows from the header's field type.
 */
#include "esq-exec.h"
#include <exec/execbase.h>

extern void ESQ_SupervisorColdReboot(void);

void ESQ_ColdReboot(void)
{
    if (SysBase->LibNode.lib_Version < 36)
        Supervisor((ULONG (*)())ESQ_SupervisorColdReboot);
    else
        ColdReboot();
}
