/* RESTORES: ED_HandleDiagnosticNibbleEdit
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * 444 bytes in the original, 452 emitted, 21 differing regions. Not a near-match;
 * semantically faithful but laid out differently in places.
 *
 * What reproduces: the nine-way chained-subtract dispatch and its exact constants
 * (SUBI.W #13 / #14 / #$27 / SUBQ.W #5 / #11 / #16 / #5 / #11 / #$29, selecting
 * keys 13, 27, 'R', 'G', 'B', 'r', 'g', 'b' and 155), all six nibble
 * increment/decrement bodies against the three PresetFallbackValue tables, the
 * case-155 fall-through into the default when the ring character is not 'D', and
 * the tail where the bounds check guards only the palette reload while
 * ED_DrawDiagnosticRegisterValues is called unconditionally.
 *
 * SASC-MISMATCH: multiply-by-three-idiom
 *   ref:     e588 90b900008196          LSL.L #2,D0 / SUB.L ED_TempCopyOffset,D0
 *   got:     2200 d281 d280             MOVE.L D0,D1 / ADD.L D1,D1 / ADD.L D0,D1
 *   summary: Same class as in ed_draw_diagnostic_register_values.c; six sites here.
 *
 * SASC-MISMATCH: byte-rmw-register-shape
 *   ref:     1211 5211 740f b202        MOVE.B (A1),D1 / ADDQ.B #1,(A1) / MOVEQ #15,D2 / CMP.B D2,D1
 *   got:     1400 5202 1282 740f b002   an extra register copy around the same read-modify-write
 *   summary: The post-increment-then-test (p[i]++ >= 15) is built with one more
 *            move than the original needs, and SAS/C saves the extra registers
 *            with MOVEM (48E721) where the original needed only MOVE.L D2,-(A7).
 *            This is where the +8 bytes come from.
 *   scope:   read-modify-write on a byte through a computed pointer.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100, all three calls cross-unit in the original.
 */
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawDiagnosticRegisterValues(void);
extern void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);
extern unsigned char ED_LastKeyCode;
extern long ED_TempCopyOffset;
extern long ED_StateRingIndex;
extern char ED_StateRingTable[];
extern char ED_LastMenuInputChar;
extern unsigned char GCOMMAND_PresetFallbackValue0[];
extern unsigned char GCOMMAND_PresetFallbackValue1[];
extern unsigned char GCOMMAND_PresetFallbackValue2[];

void ED_HandleDiagnosticNibbleEdit(void)
{
    char navChar;

    switch (ED_LastKeyCode) {
    case 13:
    case 27:
        ED_DrawESCMenuBottomHelp();
        return;

    case 'R':
        if (GCOMMAND_PresetFallbackValue0[ED_TempCopyOffset * 3]++ >= 15)
            GCOMMAND_PresetFallbackValue0[ED_TempCopyOffset * 3] = 0;
        break;
    case 'r':
        if (--GCOMMAND_PresetFallbackValue0[ED_TempCopyOffset * 3] > 15)
            GCOMMAND_PresetFallbackValue0[ED_TempCopyOffset * 3] = 15;
        break;

    case 'G':
        if (GCOMMAND_PresetFallbackValue1[ED_TempCopyOffset * 3]++ >= 15)
            GCOMMAND_PresetFallbackValue1[ED_TempCopyOffset * 3] = 0;
        break;
    case 'g':
        if (--GCOMMAND_PresetFallbackValue1[ED_TempCopyOffset * 3] > 15)
            GCOMMAND_PresetFallbackValue1[ED_TempCopyOffset * 3] = 15;
        break;

    case 'B':
        if (GCOMMAND_PresetFallbackValue2[ED_TempCopyOffset * 3]++ >= 15)
            GCOMMAND_PresetFallbackValue2[ED_TempCopyOffset * 3] = 0;
        break;
    case 'b':
        if (--GCOMMAND_PresetFallbackValue2[ED_TempCopyOffset * 3] > 15)
            GCOMMAND_PresetFallbackValue2[ED_TempCopyOffset * 3] = 15;
        break;

    case 155:
        navChar = ED_StateRingTable[ED_StateRingIndex * 5 + 1];
        ED_LastMenuInputChar = navChar;
        if (navChar == 'D') {
            if (--ED_TempCopyOffset < 0)
                ED_TempCopyOffset = 39;
            break;
        }
        /* fall through */

    default:
        ED_TempCopyOffset++;
        if (ED_TempCopyOffset == 40)
            ED_TempCopyOffset = 0;
        break;
    }

    if (ED_TempCopyOffset >= 0 && ED_TempCopyOffset < 40)
        ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();
    ED_DrawDiagnosticRegisterValues();
}
