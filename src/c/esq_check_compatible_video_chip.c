/* RESTORES: ESQ_CheckCompatibleVideoChip
 * MODULE:   modules/groups/_main/b/b.s
 * STATUS:   exact
 *
 * Flags the machine as incompatible unless VPOSR reports a known chip revision.
 * Runs during startup, so getting it wrong stops the program dead.
 *
 * NOTE: VPOSR is declared extern and exported from src/hardware-exports.s
 * rather than written as *(volatile UWORD *)0xDFF004. The pointer-cast form
 * makes SAS/C emit MOVEA.L #imm,An + MOVE.W (An),Dn instead of the absolute
 * MOVE.W (xxx).L,Dn the original uses -- a guaranteed 2-byte divergence on
 * every hardware access.
 */
extern volatile unsigned short VPOSR;
extern short IS_COMPATIBLE_VIDEO_CHIP;

void ESQ_CheckCompatibleVideoChip(void)
{
    short raw = VPOSR;
    short id  = raw & 0x7f00;

    if (id != 0x3000 && id != 0x2000 && id != 0x3300)
        IS_COMPATIBLE_VIDEO_CHIP = 1;
}
