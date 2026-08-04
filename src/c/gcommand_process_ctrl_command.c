/* RESTORES: GCOMMAND_ProcessCtrlCommand
 * MODULE:   modules/groups/a/v/gcommand5.s
 * STATUS:   behavioural
 *
 * Dispatches one CTRL command by its type byte. Type 1 formats the command into
 * the next five-byte slot of the editor state ring and advances the write index,
 * wrapping at 20; types 15 and 16 both just raise the drive-probe request flag.
 * Anything else is ignored. The return is always zero.
 *
 * `__saveds` is what produces the `LEA Global_REF_LONG_FILE_SCRATCH,A4` in the
 * prologue and the matching A4 in the register-save mask -- the routine is reached
 * as a callback, so it reloads the data base rather than trusting the caller's.
 *
 * The `r != -1` test after `r > 0` is redundant and is in the original; it is kept
 * because removing it changes the emitted code, and a restoration that tidies the
 * source is no longer evidence about the compiler.
 *
 * 148 bytes in the original, 140 emitted, six differing hunks and no padding. The
 * -8 is -6 of frame class and -2 of reload-vs-cache; `tools/casm.py` itemises it.
 * This is the fourth __saveds function found, and the first outside ctasks.s.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc 266d0008 ... 4e5d   LINK.W A5,#-4 / MOVEA.L 8(A5),A3 / UNLK
 *   got:     2a6f0014                     MOVEA.L 20(A7),A5, no frame
 *   summary: The A5-frame class: -4 for the argument fetch folding into the
 *            prologue MOVEM, -2 for the absent UNLK.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     e588 d0b90000b350       LSL.L #2,D0 / ADD.L ED_StateRingWriteIndex,D0
 *   got:     2200 e581 d280          MOVE.L D0,D1 / ASL.L #2,D1 / ADD.L D0,D1
 *   summary: index*5 for the ring slot. The original re-reads the global for the
 *            second term; 6.51 already has it in D0 and adds the register. -2.
 *
 * SASC-MISMATCH: minus-one-test-form
 *   ref:     70ff be80              MOVEQ #-1,D0 / CMP.L D0,D7
 *   got:     2007 5280              MOVE.L D7,D0 / ADDQ.L #1,D0
 *   summary: `written != -1` as a compare against a materialised -1 in the
 *            original, as an increment-and-test-zero in 6.51. Four bytes either
 *            way, so it costs nothing, but it is a codegen difference and not a
 *            source-shape one -- no way to write it that picks the other form.
 *
 * SASC-MISMATCH: duplicate-store-encoding
 *   ref:     7201 33c100006900   and   33fc000100006900
 *   summary: Not a mismatch against us so much as a curiosity in the original: the
 *            SAME statement, `flag = 1`, is emitted two different ways in the two
 *            arms -- MOVEQ into D1 then MOVE.W D1, versus MOVE.W #1 immediate.
 *            Both are 8 bytes. Recorded because it bears on the constant rule in
 *            docs/compiler-version.md: whatever picks the short form is not
 *            purely a function of the constant.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */

extern long EXEC_CallVector_48(void *cmd, char *slot, long n, long z);

extern long ED_StateRingWriteIndex;
extern char ED_StateRingTable[][5];
extern short GCOMMAND_DriveProbeRequestedFlag;

/* Guarded so a forward `struct CtrlCommand;` can precede it. SAS/C 6.51
 * accepts a tag declaration BEFORE the definition and rejects the reverse with
 * Error 63, so an unguarded pair compiles or not depending on merge order --
 * see AGENTS.md. esq_invoke_gcommand_init.c is the file that needs it. */
#ifndef CTRLCOMMAND_DEFINED
#define CTRLCOMMAND_DEFINED
struct CtrlCommand {
    char pad[4];
    char type;
};
#endif

long __saveds GCOMMAND_ProcessCtrlCommand(struct CtrlCommand *cmd)
{
    long written;
    char type;

    if (cmd->type == 1) {
        written = EXEC_CallVector_48(
                      cmd, ED_StateRingTable[ED_StateRingWriteIndex], 5L, 0L);
        if (written > 0 && written != -1) {
            ED_StateRingWriteIndex++;
            if (ED_StateRingWriteIndex >= 20)
                ED_StateRingWriteIndex = 0;
        }
    } else {
        type = cmd->type;
        if (type == 16)
            GCOMMAND_DriveProbeRequestedFlag = 1;
        else if (type == 15)
            GCOMMAND_DriveProbeRequestedFlag = 1;
    }

    return 0;
}
