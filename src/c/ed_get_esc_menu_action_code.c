/* RESTORES: ED_GetEscMenuActionCode
 * MODULE:   modules/groups/a/l/ed3.s
 * STATUS:   behavioural
 *
 * 150 bytes in the original, 156 emitted, 10 differing regions.
 *
 * A pure dispatcher -- no calls at all, which made it a candidate for an exact
 * match. It does not get there, but the two things standing in the way are both
 * known idiom classes rather than anything structural.
 *
 * Reproduces: the menu input char latched from the ring table before any
 * dispatch, the outer chained-subtract key dispatch (3, 13, 27, 155, default),
 * the inner PC-relative jump table over the cursor offset, and the four distinct
 * result values on the 155 path.
 *
 * ONE SOURCE MISTAKE WORTH RECORDING, because it cost 16 bytes before it was
 * spotted. The original's `CMPI.L #6` before the inner jump table is the SWITCH'S
 * OWN range check, not a separate guard. Writing
 *
 *     if (ED_EditCursorOffset >= 6) return 8;
 *     switch (ED_EditCursorOffset) { ... }
 *
 * makes SAS/C emit the bound test TWICE -- once for the if, once for the switch.
 * Dropping the explicit guard and letting the switch's default handle the
 * out-of-range case took this from 172 bytes to 156. When the original shows a
 * range test immediately before a jump table, that test belongs to the table.
 *
 * SASC-MISMATCH: multiply-by-five-idiom
 *   ref:     e588 d0b9xxxxxxxx     LSL.L #2,D0 / ADD.L (abs).L,D0
 *   got:     2200 e581 d280        MOVE.L D0,D1 / ASL.L #2,D1 / ADD.L D0,D1
 *   summary: index*5. Same as ed_capture_key_sequence.c -- the original re-reads
 *            the global to add it back, SAS/C keeps a register copy.
 *
 * SASC-MISMATCH: dispatch-subtract-width
 *   ref:     5740 0440000a         SUBQ.W #3,D0 / SUBI.W #10,D0
 *   got:     5780 720a 9081        SUBQ.L #3,D0 / MOVEQ #10,D1 / SUB.L D1,D0
 *   summary: The chained-subtract dispatch at the wrong width. SHORTINT fixes
 *            this shape elsewhere (ed_handle_edit_attributes_input.c) but does
 *            NOT here -- it leaves the size unchanged and adds a region. Recorded
 *            as a case where the documented recipe does not apply, so the next
 *            session does not assume it always will.
 */
extern long ED_StateRingIndex;
extern unsigned char ED_StateRingTable[];
extern unsigned char ED_LastMenuInputChar;
extern unsigned char ED_LastKeyCode;
extern unsigned long ED_EditCursorOffset;

long ED_GetEscMenuActionCode(void)
{
    ED_LastMenuInputChar = ED_StateRingTable[ED_StateRingIndex * 5 + 1];

    switch (ED_LastKeyCode) {
    case 3:
        return 8;

    case 13:
        switch (ED_EditCursorOffset) {
        case 0: return 1;
        case 1: return 2;
        case 2: return 3;
        case 3: return 4;
        case 4: return 5;
        case 5: return 6;
        }
        return 8;

    case 27:
        return 0;

    case 155:
        if (ED_LastMenuInputChar == 'A')
            return 9;
        return 10;
    }

    return 10;
}
