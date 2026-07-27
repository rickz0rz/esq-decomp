/* RESTORES: ED2_HandleScrollSpeedSelection
 * MODULE:   modules/groups/a/k/ed2.s
 * STATUS:   behavioural
 *
 * Handles input on the scroll-speed menu. RETURN and ESC (13 and 27) commit the
 * current row as the state index and drop back to the ESC menu; the CSI prefix
 * (155) moves the selection, up for 'A' and down for anything else; any other key
 * moves the selection down as well.
 *
 * The selection wrap is asymmetric and deliberate: moving up from row 0 lands on
 * 8, but moving down skips row 1 entirely (1 becomes 3) and wraps 9 to 0. Row 1
 * and row 2 are not reachable by moving down.
 *
 * The down-move body is written out twice, once in the 155 case and once in the
 * default, because the original emits it twice rather than branching to a shared
 * copy.
 *
 * 280 bytes in the original, 280 emitted (278 plus one alignment NOP), 12 hunks
 * of which 6 are nonzero.
 *
 * NO SHORTINT, and that is the interesting part. Its sibling in the same module,
 * ED2_HandleDiagnosticsMenuActions, NEEDS SHORTINT: there it reproduces all 23
 * chained-subtract instructions for 4 bytes. Here the chain is only three
 * instructions long, and SHORTINT buys those three for +12 -- of which +14 is
 * SAS/C recomputing the ring-slot address a second time for the [1] access, an
 * address the original computes once and reuses through two registers.
 *
 * By the rule in AGENTS.md that is the wrong trade: a spurious address
 * computation is a STRUCTURAL disagreement, where the chain difference is only a
 * width. Three instructions at the wrong width beats one address computed twice.
 * So the same dispatch shape in the same module gets opposite answers, which is
 * the concrete case AGENTS.md means when it calls SHORTINT "a tool to try, not a
 * universal rule".
 *
 * SASC-MISMATCH: dispatch-chain-width
 *   ref:     0440000d 0440000e 04400080   SUBI.W #13 / #14 / #128
 *   got:     the same subtractions at long width
 *   summary: Costs no bytes. Fixable with SHORTINT, at the cost above.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     e588 d0b90000b354   LSL.L #2,D0 / ADD.L ED_StateRingIndex,D0
 *            203900008180       the cursor offset re-read after the test
 *   got:     the value kept in a register both times
 *   summary: -2 and -6. Same class as gcommand_process_ctrl_command.c, which has
 *            the identical index*5 expression.
 *
 * SASC-MISMATCH: register-pressure
 *   summary: 6.51 saves D2 where the original saves nothing. +2 and +2.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */

extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawMenuSelectionHighlight(long n);
extern void ED_DrawScrollSpeedMenuText(void);

extern long ED_StateRingIndex;
extern unsigned char ED_StateRingTable[][5];
extern unsigned char ED_LastKeyCode;
extern unsigned char ED_LastMenuInputChar;
extern long ED_EditCursorOffset;
extern long ED_SavedScrollSpeedIndex;
extern short ESQPARS2_StateIndex;
extern unsigned char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;

void ED2_HandleScrollSpeedSelection(void)
{
    ED_LastKeyCode = ED_StateRingTable[ED_StateRingIndex][0];
    ED_LastMenuInputChar = ED_StateRingTable[ED_StateRingIndex][1];

    switch (ED_LastKeyCode) {
    case 13:
    case 27:
        ED_SavedScrollSpeedIndex = ED_EditCursorOffset;
        if (ED_EditCursorOffset == 0)
            ESQPARS2_StateIndex = ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED - 48;
        else
            ESQPARS2_StateIndex = ED_EditCursorOffset - 1;
        ED_DrawESCMenuBottomHelp();
        break;

    case 155:
        if (ED_LastMenuInputChar == 65) {
            ED_EditCursorOffset = ED_EditCursorOffset - 1;
            if (ED_EditCursorOffset < 0)
                ED_EditCursorOffset = 8;
        } else {
            ED_EditCursorOffset = ED_EditCursorOffset + 1;
            if (ED_EditCursorOffset == 1)
                ED_EditCursorOffset = 3;
            else if (ED_EditCursorOffset == 9)
                ED_EditCursorOffset = 0;
        }
        ED_DrawMenuSelectionHighlight(9L);
        ED_DrawScrollSpeedMenuText();
        break;

    default:
        ED_EditCursorOffset = ED_EditCursorOffset + 1;
        if (ED_EditCursorOffset == 1)
            ED_EditCursorOffset = 3;
        else if (ED_EditCursorOffset == 9)
            ED_EditCursorOffset = 0;
        ED_DrawMenuSelectionHighlight(9L);
        ED_DrawScrollSpeedMenuText();
        break;
    }
}
