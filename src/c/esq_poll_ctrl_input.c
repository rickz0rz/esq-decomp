/* RESTORES: ESQ_PollCtrlInput
 * MODULE:   modules/groups/a/a/app_esq_pollctrlinput.s
 * STATUS:   behavioural
 * LINKED SINCE 2026-08-04. The header used to carry a prose "DO NOT LINK"
 *   saying the function is "installed as the AUD1 interrupt vector: entered
 *   with is_Data in A1, nothing on the stack". That is what it is, and it is
 *   not a reason it cannot be C: the body reads nothing from A1 and takes no
 *   arguments at all. AGENTS.md records this exact failure -- "A prose warning
 *   in a header protects nothing" -- and the warning was never true here.
 *
 *   It carries `__saveds`, which reproduces the original's A4 save. Measured
 *   at 44 bytes against 44.
 *
 * A REAL DEFECT WAS FIXED WHEN IT WAS LINKED, and being unlinked is why nothing
 * caught it. The gate byte is at offset 18 of the status packet --
 * `MOVE.B $12(A4),D1` in the original, and src/data-offsets.s spells the
 * constant `ESQ_StatusPacket__Bit3CaptureGateChar = 18`. The C read index 6.
 * The emitted bytes said so plainly and had said so for as long as the file
 * existed: ref `122c0012`, got `103900000006`. Reading the wrong byte gates
 * the CTRL bit-3 capture on whatever happens to sit six bytes into the packet,
 * so the capture would run when it should not or not run when it should.
 *
 * A4 IS A SCRATCH POINTER HERE, NOT THE NEAR-DATA BASE. The original saves it,
 * loads it with _ESQ_STR_B and indexes the packet through it. Neither
 * ESQ_CaptureCtrlBit4Stream nor ESQ_CaptureCtrlBit3Stream reads A4 -- checked,
 * both are zero hits -- so `__saveds` setting it to LinkerDB before the body
 * changes nothing for them. The C addresses ESQ_STR_B absolutely.
 *
 * SASC-MISMATCH: register-save-shape
 *   ref:     2f0d2f0c612649f9000028d0122c00120c01004e66044ebafeae207c00dff000317c0100009c285f2a5f4e75   (44)
 *   summary: the original saves A5 and A4 with two MOVE.L and holds the custom
 *            base in an address register for the INTREQ write. SAS/C saves
 *            through MOVEM and reaches INTREQ as an absolute. Same two calls,
 *            same gate test, same interrupt clear, same 44 bytes.
 *   scope:   program-wide.
 *   retest:  a compiler that pools nearby absolute addresses into a base
 *            register.
 */
extern char ESQ_STR_B[];
extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
#define INTREQW (*(volatile unsigned short *)0xDFF09CL)
void __saveds ESQ_PollCtrlInput(void)
{
    ESQ_CaptureCtrlBit4Stream();
    if (ESQ_STR_B[18] == 'N')   /* the gate byte is at +18 -- see header */
        ESQ_CaptureCtrlBit3Stream();
    INTREQW = 0x100;
}
