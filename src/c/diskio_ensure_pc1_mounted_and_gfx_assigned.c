/* RESTORES: _DISKIO_EnsurePc1MountedAndGfxAssigned
 * MODULE:   modules/groups/a/g/diskio_p5_p0.s
 * STATUS:   behavioural
 *
 * Mounts the PC1 device and assigns GFX: to it, once per run. A guard flag
 * makes the second and later calls return immediately.
 *
 * The flag is set BEFORE the first Execute, not after. Execute() can re-enter
 * this code through the shell it starts, so the original closes the window
 * first. Keep that order.
 *
 * SIZE: the reference reads 56 bytes because the epilogue carries its own
 * `_Return` label. Add the 4-byte `MOVEM.L (A7)+,D2-D3` / `RTS` for a true
 * reference of 60.
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     2c79 <base> ... 4eaefdd8 ... 4eaefdd8
 *            MOVEA.L DOSBase,A6 loaded ONCE, then two JSRs on it
 *   got:     the base is reloaded before each JSR
 *   summary: the original caches the DOS base across the two Execute calls.
 *            `esq-dos.h` declares the base `volatile`, which forces a reload
 *            and costs 6 bytes at the second call. The volatile header is
 *            REQUIRED here rather than optional: ESQ assembly does not honour
 *            the callee-saved rule for A6, so a cached base is a machine reset
 *            waiting for the wrong callee. See src/c/esq-libbase.md.
 *   tried:   nothing. There is deliberately no `esq-dos-leaf.h` -- AGENTS.md
 *            records that every DOS restoration so far reloads the base in the
 *            original anyway. THIS FUNCTION IS THE FIRST COUNTER-EXAMPLE, so if
 *            a leaf DOS header is ever added, this file is the case to test it
 *            on. `tools/a6_audit.py` already proves the precondition: both
 *            calls here are library calls with no ESQ call between them.
 *   scope:   6 bytes here.
 *   retest:  compile against a non-volatile DOS base and confirm a6_audit stays
 *            clean.
 */
#include "esq-dos.h"

extern short DISKIO_Pc1MountAssignFlag;
extern char DISKIO_CMD_MOUNT_PC1[];
extern char DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT[];

void DISKIO_EnsurePc1MountedAndGfxAssigned(void)
{
    if (DISKIO_Pc1MountAssignFlag)
        return;

    DISKIO_Pc1MountAssignFlag = 1;

    Execute(DISKIO_CMD_MOUNT_PC1, 0L, 0L);
    Execute(DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT, 0L, 0L);
}
