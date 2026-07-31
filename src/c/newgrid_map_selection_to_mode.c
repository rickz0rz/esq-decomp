/* RESTORES: NEWGRID_MapSelectionToMode
 * MODULE:   modules/groups/b/a/newgrid_p1_p0.s
 * STATUS:   behavioural
 *
 * Maps a selection code 0..12 to a display mode. This is a real JUMP TABLE
 * switch in the original -- CMPI.L #13 / BCC / ADD.W D0,D0 / MOVE.W (table,PC,D0.W)
 * / JMP -- so it is written as a switch and the bound check is left to the
 * switch's own default.
 *
 * AGENTS.md is explicit about that last point: a range test immediately before
 * a PC-relative jump table belongs to the table, and writing an extra `if`
 * makes SAS/C emit the test twice. ed_get_esc_menu_action_code.c lost 16 bytes
 * to exactly that.
 *
 * The table is read off the 13 word entries at 0x2061A, and two of them matter:
 *
 *  - Entries 5 through 10 all point at the SAME arm, which is why those six
 *    cases share one body.
 *  - Entry 12 points at the SAME arm as entry 0, but entry 11 points at a
 *    SEPARATE arm that also yields 1. The original emits two distinct
 *    MOVEQ #1,D7 (0x20634 and 0x20674), so case 11 is kept apart rather than
 *    merged with 0 and 12. Merging them would drop an instruction the original
 *    has.
 *
 * Case 4 FALLS THROUGH into the shared 5..10 arm when the niche flag is clear:
 * the BEQ at 0x20660 lands on the SelectNextMode call rather than on a body of
 * its own.
 *
 * The grid-ready helper returns a word (TST.W D0).
 *
 * 136 ref vs 136 got, and the JUMP TABLE ITSELF is reproduced -- which is the
 * result worth recording, because a switch that comes out as a compare chain
 * would be a different program shape at the same byte count.
 *
 *     ref  0c800000000d 6468 d040 303b0006 4efb0004  + 13 word entries
 *     got  0c800000000d 6466 d040 303b0006 4efb0004  + 13 word entries
 *
 * The bound, the doubling, the PC-relative table load and the JMP all agree,
 * and the entry PATTERN agrees too: entries 5..10 share one target, entry 12
 * shares entry 0, and entry 11 has its own. Only the displacements differ, by
 * 2, because 6.51 emits the first arms two bytes shorter -- which is the item
 * below.
 *
 * SASC-MISMATCH: result-register-allocation
 *   ref:     7e01 6042 / 7e02 603e / 7e03 603a / 2e00
 *            MOVEQ into D7 in each arm, funnelled through D0 for case 3
 *   got:     7a01 6040 / 7a02 603c / 7a03 6038 / 2a00
 *            the same against D5
 *   summary: the mode lands in a different data register, and 6.51 also folds
 *            the case-3 pair (700b 6002 7004 2e00 against 7a0b 6024 7a04 6020)
 *            so each arm writes the result directly. Same constants, same
 *            branches, and the whole difference shows up as the 2-byte shift in
 *            the table displacements.
 *   scope:   program-wide register allocation. docs/compiler-version.md,
 *            "A third divergence: register allocation order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern short NEWGRID_IsGridReadyForInput(long arg);
extern long  NEWGRID_SelectNextMode(void);

extern long GCOMMAND_NicheForceMode5Flag;
extern long GCOMMAND_NicheModeCycleCount;

long NEWGRID_MapSelectionToMode(long selection, short arg)
{
    long mode;

    switch (selection) {
    case 0:
    case 12:
        mode = 1;
        break;
    case 1:
        mode = 2;
        break;
    case 2:
        mode = 3;
        break;
    case 3:
        if (NEWGRID_IsGridReadyForInput((long)arg))
            mode = 11;
        else
            mode = 4;
        break;
    case 4:
        if (GCOMMAND_NicheForceMode5Flag) {
            mode = 5;
            GCOMMAND_NicheModeCycleCount = 0;
            break;
        }
        /* falls through to the shared arm below -- see the header */
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
        mode = NEWGRID_SelectNextMode();
        break;
    case 11:
        mode = 1;
        break;
    default:
        mode = 0;
        break;
    }
    return mode;
}
