/* RESTORES: ED_HandleEditorInput
 * MODULE:   modules/groups/a/k/ed_ed_handleeditorinput.s
 * STATUS:   behavioural
 *
 * The text editor's keyboard handler: 2850 bytes, and structurally two nested
 * dispatchers rather than one.
 *
 * The OUTER switch is on ED_LastKeyCode, which carries raw key numbers -- 1, 2,
 * 3, 6, 8, 9, 13, 14, 27, 127 and 155. 155 is CSI, and it opens the INNER
 * switch on the second byte of the current ring-table entry: 32, then 48..57,
 * 63, and 65..68. Those are the digits, '?' and 'A'..'D' of an ANSI escape
 * sequence, which is why the inner set looks like ASCII and the outer set does
 * not.
 *
 * Both are written as `switch`, not as if/else chains. The original tests with a
 * running SUBI.W that consumes the difference, which a `switch` reproduces and an
 * if/else chain does not. 6.51 turns the inner one into a real PC-relative jump
 * table, exactly as the original does.
 *
 * SHORTINT was TRIED AND REJECTED here: 2888 bytes against 2864 without it. That
 * is worth stating because AGENTS.md records SHORTINT as the companion to a
 * `switch` on key codes, and it is the companion in the three ED handlers that
 * need it -- but not in this one. The rule is a tool to try, not a law.
 *
 * KEY 8 FALLS THROUGH INTO KEY 127, deliberately. Backspace steps the cursor
 * left and then does exactly what delete-at-cursor does; the original branches
 * into the middle of that case. Giving key 8 its own body would duplicate ~300
 * bytes and change nothing.
 *
 * Three shift-and-refresh bodies (line spacing modes 1, 2 and 3, reached by
 * '2'/'3'/'4') are the same shape with a different transform. They are written
 * out rather than folded into a loop over function pointers, because that is
 * what the original does and a table of pointers would emit an indirect call
 * where it has a direct one.
 *
 * ED_StateRingTable has a 5-byte stride, which the original computes as
 * `LSL.L #2` plus the index. `struct EdRingEntry` gives it that stride so the
 * index multiply stays a multiply rather than becoming a shift plus an add on a
 * cast pointer.
 *
 * The three shifted buffer bases (ED_EditBufferScratchShiftBase,
 * ED_EditBufferLiveShiftBase, ED_EditBufferLiveIndexBaseMinus1,
 * ED_EditBufferScratchIndexBaseMinus1) are kept as their own externs, exactly as
 * the assembly names them, rather than being rewritten as base+1 / base-1
 * expressions. That keeps the relocation target identical and avoids asserting
 * an offset this file cannot verify.
 *
 * SASC-MISMATCH: register-argument-arithmetic-helpers
 *   ref:     7028 4eba....       MOVEQ #40,D0 / JSR MATH_Mulu32
 *   got:     the multiply, or a call to __CXM33
 *   summary: the original reaches its own MATH_Mulu32 and MATH_DivS32 with the
 *            operands ALREADY in D0/D1 and, for the divides, reads the remainder
 *            back out of D1. That is not a C calling convention, and the
 *            remainder cannot come back through a return value at all, so every
 *            such site is written as plain `*` and `%`. There are 21 Mulu32
 *            sites and 2 DivS32 sites in this function.
 *   tried:   nothing -- `__asm` register parameters would let a C prototype name
 *            D0/D1, but SAS/C still copies the arguments into its own
 *            callee-saved registers, so the call sequence does not match either.
 *   scope:   program-wide wherever MATH_Mulu32/MATH_DivS32 appear.
 *   retest:  a compiler whose integer multiply and divide helpers ARE these
 *            routines, i.e. one built against the same runtime.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                        JSR (d16,PC)
 *   got:     61000000                        BSR.W
 *   summary: same size, same displacement, different opcode. Costs nothing and
 *            is why the size delta is attributable elsewhere.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fffc ... 4e5d               LINK.W A5,#-4 / UNLK A5
 *   got:     A7-relative locals
 *   summary: 6.51 does not build a frame for four bytes of locals.
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 2864 against 2850, +14 over 82 regions -- 0.5% on a 2850-byte body.
 *            casm.py itemises the +14 across 25 non-zero hunks and its total
 *            MATCHES the observed delta, but no single hunk is worth more than
 *            +/-4 and they are register-allocation and block-ordering noise, so
 *            there is nothing to name. Recorded as a known-unknown per AGENTS.md
 *            rule 3 rather than attributed by guesswork.
 *   tried:   SHORTINT, which is worse (+38). See above.
 *   retest:  itemise again once the arithmetic-helper class is resolved.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include "esq-graphics.h"

struct EdRingEntry {
    char c0;
    char c1;
    char c2;
    char c3;
    char c4;
};

extern long ED_TextModeReinitPendingFlag;
extern long Global_REF_BOOL_IS_TEXT_OR_CURSOR;
extern long Global_REF_BOOL_IS_LINE_OR_PAGE;
extern long ED_EditCursorOffset;
extern long ED_ViewportOffset;
extern long ED_BlockOffset;
extern long ED_TextLimit;
extern long ED_TempCopyOffset;
extern long ED_AdActiveFlag;
extern long ED_StateRingIndex;

extern unsigned char ED_CurrentChar;
extern unsigned char ED_LastKeyCode;
extern unsigned char ED_LastMenuInputChar;
extern unsigned char ED_MenuStateId;

extern char ED_EditBufferLive[];
extern char ED_EditBufferScratch[];
extern char ED_EditBufferScratchShiftBase[];
extern char ED_EditBufferLiveShiftBase[];
extern char ED_EditBufferLiveIndexBaseMinus1[];
extern char ED_EditBufferScratchIndexBaseMinus1[];
extern struct EdRingEntry ED_StateRingTable[];

extern char ED2_STR_LINE[];
extern char ED2_STR_PAGE[];
extern struct RastPort *Global_REF_RASTPORT_1;

extern void ED_DrawCursorChar(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawCurrentColorIndicator(long ch);
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_RedrawAllRows(void);
extern void ED_RedrawRow(long row);
extern void ED_TransformLineSpacing_Mode1(void);
extern void ED_TransformLineSpacing_Mode2(void);
extern void ED_TransformLineSpacing_Mode3(void);
extern void ED_CommitCurrentAdEdits(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_NextAdNumber(void);
extern void ED_PrevAdNumber(void);
extern void ED_DrawEditHelpText(void);
extern long LADFUNC_GetPackedPenLowNibble(long v);
extern long LADFUNC_GetPackedPenHighNibble(long v);
extern long LADFUNC_SetPackedPenLowNibble(long ch, long nib);
extern long LADFUNC_SetPackedPenHighNibble(long nib, long ch);
extern void MEM_Move(char *a, char *b, long n);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(long mode);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);

void ED_HandleEditorInput(void)
{
    char *label;
    char *p;
    unsigned long n;
    long row;
    long i;
    /* Holds a nibble before it is wrapped. The wrap is written as
     * `v - (v / 8) * 8` rather than `v % 8` so it never reads the remainder out
     * of D1 -- see tools/d1_remainder_audit.py. That form names its operand
     * TWICE, so the extractor call has to be hoisted or it would run twice. */
    long nib;

    if (ED_TextModeReinitPendingFlag != 0) {
        Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
        ED_CurrentChar = ED_EditBufferLive[ED_EditCursorOffset];
        ED_TextModeReinitPendingFlag = 0;
    }

    ED_DrawCursorChar();

    switch (ED_LastKeyCode) {

    case 1:
        ED_AdActiveFlag = 1;
        ED_ApplyActiveFlagToAdData();
        break;

    case 14:
        ED_AdActiveFlag = 0;
        ED_ApplyActiveFlagToAdData();
        break;

    case 2:
        /* Step the HIGH nibble, wrapping at 8. */
        nib = LADFUNC_GetPackedPenHighNibble(ED_CurrentChar) + 1;
        ED_CurrentChar = (unsigned char)LADFUNC_SetPackedPenHighNibble(
            nib - (nib / 8) * 8,
            ED_CurrentChar);
        if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1)
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
        break;

    case 6:
        /* Step the LOW nibble, wrapping at 8. */
        nib = LADFUNC_GetPackedPenLowNibble(ED_CurrentChar) + 1;
        ED_CurrentChar = (unsigned char)LADFUNC_SetPackedPenLowNibble(
            ED_CurrentChar,
            nib - (nib / 8) * 8);
        if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1)
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
        break;

    case 3:
        if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1)
            Global_REF_BOOL_IS_TEXT_OR_CURSOR = 0;
        else
            Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
        SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(
            Global_REF_BOOL_IS_TEXT_OR_CURSOR);
        break;

    case 9:
        break;

    case 13:
        if (ED_EditCursorOffset >= 40 * (ED_TextLimit - 1))
            ED_EditCursorOffset = 40 * (ED_TextLimit - 1);
        else
            ED_EditCursorOffset = 40 * (ED_ViewportOffset + 1);
        break;

    case 27:
        Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
        ED_TextModeReinitPendingFlag = 1;
        ED_CommitCurrentAdEdits();
        ED_DrawESCMenuBottomHelp();
        return;

    case 8:
        if (ED_EditCursorOffset == 0)
            break;
        ED_EditCursorOffset = ED_EditCursorOffset - 1;
        /* falls through into delete-at-cursor, as the original branches in */

    case 127:
        if (ED_EditCursorOffset >= ED_BlockOffset - 1) {
            ED_EditBufferScratchIndexBaseMinus1[ED_BlockOffset] = ' ';
            ED_DrawCursorChar();
        } else if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
            ED_TempCopyOffset = ED_BlockOffset - 1;
            MEM_Move(
                &ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                &ED_EditBufferScratch[ED_EditCursorOffset],
                ED_TempCopyOffset - ED_EditCursorOffset);
            MEM_Move(
                &ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                &ED_EditBufferLive[ED_EditCursorOffset],
                ED_TempCopyOffset - ED_EditCursorOffset);
            ED_EditBufferScratch[ED_TempCopyOffset] = ' ';
            ED_EditBufferLive[ED_TempCopyOffset] =
                ED_EditBufferLiveIndexBaseMinus1[ED_TempCopyOffset];
            ED_EditBufferScratch[ED_BlockOffset] = 0;
            ED_RedrawAllRows();
        } else {
            ED_TempCopyOffset = 40 * (ED_ViewportOffset + 1) - 1;
            if (ED_EditCursorOffset < ED_TempCopyOffset) {
                MEM_Move(
                    &ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                    &ED_EditBufferScratch[ED_EditCursorOffset],
                    ED_TempCopyOffset - ED_EditCursorOffset);
                MEM_Move(
                    &ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                    &ED_EditBufferLive[ED_EditCursorOffset],
                    ED_TempCopyOffset - ED_EditCursorOffset);
            }
            ED_EditBufferScratch[ED_TempCopyOffset] = ' ';
            ED_EditBufferLive[ED_TempCopyOffset] =
                ED_EditBufferLiveIndexBaseMinus1[ED_TempCopyOffset];
            ED_RedrawRow(ED_ViewportOffset);
        }
        break;

    case 155:
        ED_LastMenuInputChar = ED_StateRingTable[ED_StateRingIndex].c1;

        switch (ED_LastMenuInputChar) {

        case 32:
            ED_LastKeyCode = ED_StateRingTable[ED_StateRingIndex].c2;
            if (ED_LastKeyCode == 64)
                ED_NextAdNumber();
            if (ED_LastKeyCode == 65)
                ED_PrevAdNumber();
            break;

        case 48:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 1)
                ED_EditCursorOffset = 0;
            else
                ED_EditCursorOffset = 40 * ED_ViewportOffset;
            break;

        case 49:
            SetAPen(Global_REF_RASTPORT_1, 1L);
            SetBPen(Global_REF_RASTPORT_1, 6L);
            Global_REF_BOOL_IS_LINE_OR_PAGE =
                ((Global_REF_BOOL_IS_LINE_OR_PAGE + 1) - ((Global_REF_BOOL_IS_LINE_OR_PAGE + 1) / 2) * 2);
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0)
                label = ED2_STR_LINE;
            else
                label = ED2_STR_PAGE;
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L, label);
            SetBPen(Global_REF_RASTPORT_1, 2L);
            break;

        case 50:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                ED_ViewportOffset = 0;
                while (ED_ViewportOffset < ED_TextLimit) {
                    ED_TransformLineSpacing_Mode3();
                    ED_ViewportOffset = ED_ViewportOffset + 1;
                }
                ED_EditCursorOffset = 0;
                ED_RedrawAllRows();
            } else {
                ED_TransformLineSpacing_Mode3();
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 51:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                ED_ViewportOffset = 0;
                while (ED_ViewportOffset < ED_TextLimit) {
                    ED_TransformLineSpacing_Mode1();
                    ED_ViewportOffset = ED_ViewportOffset + 1;
                }
                ED_EditCursorOffset = 0;
                ED_RedrawAllRows();
            } else {
                ED_TransformLineSpacing_Mode1();
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 52:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                ED_ViewportOffset = 0;
                while (ED_ViewportOffset < ED_TextLimit) {
                    ED_TransformLineSpacing_Mode2();
                    ED_ViewportOffset = ED_ViewportOffset + 1;
                }
                ED_EditCursorOffset = 0;
                ED_RedrawAllRows();
            } else {
                ED_TransformLineSpacing_Mode2();
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 53:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                p = ED_EditBufferScratch;
                n = ED_BlockOffset;
                while (n-- != 0)
                    *p++ = ' ';
                p = ED_EditBufferLive;
                n = ED_BlockOffset;
                while (n-- != 0)
                    *p++ = ED_CurrentChar;
                ED_EditBufferScratch[ED_BlockOffset] = 0;
                ED_RedrawAllRows();
            } else {
                p = &ED_EditBufferScratch[40 * ED_ViewportOffset];
                for (i = 0; i < 40; i++)
                    *p++ = ' ';
                p = &ED_EditBufferLive[40 * ED_ViewportOffset];
                for (i = 0; i < 40; i++)
                    *p++ = ED_CurrentChar;
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 54:
            /* insert a row: shift everything below down by one line */
            if (ED_ViewportOffset >= ED_TextLimit - 1)
                break;
            MEM_Move(
                &ED_EditBufferScratch[40 * ED_ViewportOffset],
                &ED_EditBufferScratch[40 * (ED_ViewportOffset + 1)],
                ED_BlockOffset - 40 * (ED_ViewportOffset + 1));
            MEM_Move(
                &ED_EditBufferLive[40 * ED_ViewportOffset],
                &ED_EditBufferLive[40 * (ED_ViewportOffset + 1)],
                ED_BlockOffset - 40 * (ED_ViewportOffset + 1));
            p = &ED_EditBufferScratch[40 * ED_ViewportOffset];
            for (i = 0; i < 40; i++)
                *p++ = ' ';
            p = &ED_EditBufferLive[40 * ED_ViewportOffset];
            for (i = 0; i < 40; i++)
                *p++ = ED_CurrentChar;
            ED_EditBufferScratch[ED_BlockOffset] = 0;
            for (row = ED_ViewportOffset; row < ED_TextLimit; row++)
                ED_RedrawRow(row);
            break;

        case 55:
            /* delete a row: shift everything below up by one line */
            if (ED_ViewportOffset >= ED_TextLimit - 1)
                break;
            MEM_Move(
                &ED_EditBufferScratch[40 * (ED_ViewportOffset + 1)],
                &ED_EditBufferScratch[40 * ED_ViewportOffset],
                ED_BlockOffset - 40 * (ED_ViewportOffset + 1));
            MEM_Move(
                &ED_EditBufferLive[40 * (ED_ViewportOffset + 1)],
                &ED_EditBufferLive[40 * ED_ViewportOffset],
                ED_BlockOffset - 40 * (ED_ViewportOffset + 1));
            p = &ED_EditBufferScratch[40 * (ED_TextLimit - 1)];
            for (i = 0; i < 40; i++)
                *p++ = ' ';
            p = &ED_EditBufferLive[40 * (ED_TextLimit - 1)];
            for (i = 0; i < 40; i++)
                *p++ = ED_CurrentChar;
            ED_EditBufferScratch[ED_BlockOffset] = 0;
            for (row = ED_ViewportOffset; row < ED_TextLimit; row++)
                ED_RedrawRow(row);
            break;

        case 56:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                p = ED_EditBufferLive;
                n = ED_BlockOffset;
                while (n-- != 0)
                    *p++ = ED_CurrentChar;
                ED_RedrawAllRows();
            } else {
                p = &ED_EditBufferLive[40 * ED_ViewportOffset];
                for (i = 0; i < 40; i++)
                    *p++ = ED_CurrentChar;
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 57:
            if (ED_EditCursorOffset >= ED_BlockOffset - 1) {
                ED_EditBufferScratchIndexBaseMinus1[ED_BlockOffset] = ' ';
                ED_DrawCursorChar();
            } else if (Global_REF_BOOL_IS_LINE_OR_PAGE != 0) {
                ED_TempCopyOffset = ED_BlockOffset - 1;
                MEM_Move(
                    &ED_EditBufferScratch[ED_EditCursorOffset],
                    &ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                    ED_TempCopyOffset - ED_EditCursorOffset);
                MEM_Move(
                    &ED_EditBufferLive[ED_EditCursorOffset],
                    &ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                    ED_TempCopyOffset - ED_EditCursorOffset);
                ED_EditBufferScratch[ED_EditCursorOffset] = ' ';
                ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
                ED_EditBufferScratch[ED_BlockOffset] = 0;
                ED_RedrawAllRows();
            } else {
                ED_TempCopyOffset = 40 * (ED_ViewportOffset + 1) - 1;
                if (ED_EditCursorOffset < ED_TempCopyOffset) {
                    MEM_Move(
                        &ED_EditBufferScratch[ED_EditCursorOffset],
                        &ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                        ED_TempCopyOffset - ED_EditCursorOffset);
                    MEM_Move(
                        &ED_EditBufferLive[ED_EditCursorOffset],
                        &ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                        ED_TempCopyOffset - ED_EditCursorOffset);
                }
                ED_EditBufferScratch[ED_EditCursorOffset] = ' ';
                ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
                ED_RedrawRow(ED_ViewportOffset);
            }
            break;

        case 63:
            ED_MenuStateId = 9;
            ED_DrawEditHelpText();
            break;

        case 65:
            if (ED_EditCursorOffset > 39)
                ED_EditCursorOffset = ED_EditCursorOffset - 40;
            break;

        case 66:
            if (ED_EditCursorOffset < 40 * (ED_TextLimit - 1))
                ED_EditCursorOffset = ED_EditCursorOffset + 40;
            break;

        case 67:
            if (ED_EditCursorOffset < ED_BlockOffset - 1)
                ED_EditCursorOffset = ED_EditCursorOffset + 1;
            break;

        case 68:
            if (ED_EditCursorOffset > 0)
                ED_EditCursorOffset = ED_EditCursorOffset - 1;
            break;

        default:
            break;
        }
        break;

    default:
        /* A printable key: 26..127 goes into the buffer. */
        if (ED_LastKeyCode > 25 && ED_LastKeyCode < 128) {
            ED_EditBufferScratch[ED_EditCursorOffset] = ED_LastKeyCode;
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
            ED_DrawCursorChar();
            if (ED_EditCursorOffset < ED_BlockOffset - 1)
                ED_EditCursorOffset = ED_EditCursorOffset + 1;
        }
        break;
    }

    if (Global_REF_BOOL_IS_TEXT_OR_CURSOR != 0)
        ED_CurrentChar = ED_EditBufferLive[ED_EditCursorOffset];
    else
        ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;

    if (ED_MenuStateId == 4) {
        ED_RedrawCursorChar();
        ED_DrawCurrentColorIndicator(ED_CurrentChar);
    }
}
