#include <exec/types.h>
extern LONG ED_TextModeReinitPendingFlag;
extern LONG Global_REF_BOOL_IS_TEXT_OR_CURSOR;
extern LONG Global_REF_BOOL_IS_LINE_OR_PAGE;
extern UBYTE ED_EditBufferLive[];
extern char ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLiveShiftBase[];
extern UBYTE ED_EditBufferScratchShiftBase[];
extern UBYTE ED_EditBufferLiveIndexBaseMinus1[];
extern UBYTE ED_EditBufferScratchIndexBaseMinus1[];
extern LONG ED_EditCursorOffset;
extern LONG ED_ViewportOffset;
extern LONG ED_BlockOffset;
extern LONG ED_TextLimit;
extern LONG ED_TempCopyOffset;
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern UBYTE ED_LastMenuInputChar;
extern UBYTE ED_CurrentChar;
extern LONG ED_AdActiveFlag;
extern UBYTE ED_MenuStateId;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char ED2_STR_PAGE[];
extern const char ED2_STR_LINE[];

extern void ED_DrawCursorChar(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_CommitCurrentAdEdits(void);
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_RedrawAllRows(void);
extern void ED_RedrawRow(LONG row);
extern void ED_TransformLineSpacing_Mode1(void);
extern void ED_TransformLineSpacing_Mode2(void);
extern void ED_TransformLineSpacing_Mode3(void);
extern void ED_NextAdNumber(void);
extern void ED_PrevAdNumber(void);
extern void ED_DrawEditHelpText(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawCurrentColorIndicator(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(LONG value);
extern LONG GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(LONG value);
extern LONG ED1_JMPTBL_LADFUNC_MergeHighLowNibbles(LONG lo, LONG hi);
extern LONG ED1_JMPTBL_LADFUNC_PackNibblesToByte(LONG hi, LONG lo);
extern void *ED1_JMPTBL_MEM_Move(void *dst, const void *src, LONG len);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(LONG mode);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern void DISPLIB_DisplayTextAtPosition(char *rp, LONG x, LONG y, const char *text);
extern void _LVOSetAPen(void *gfxBase, char *rp, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rp, LONG pen);

static void sync_current_char_and_maybe_draw_indicator(void)
{
    if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 0) {
        ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
    } else {
        ED_CurrentChar = ED_EditBufferLive[ED_EditCursorOffset];
    }

    if ((UBYTE)(ED_MenuStateId - 4) == 0) {
        ED_RedrawCursorChar();
        ED_DrawCurrentColorIndicator((LONG)ED_CurrentChar);
    }
}

static void do_spacing_transform(void (*fn)(void))
{
    if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
        fn();
        ED_RedrawRow(ED_ViewportOffset);
        return;
    }

    ED_ViewportOffset = 0;
    while (ED_ViewportOffset < ED_TextLimit) {
        fn();
        ED_ViewportOffset += 1;
    }
    ED_EditCursorOffset = 0;
    ED_RedrawAllRows();
}

static void clear_line_or_page(void)
{
    LONG i;

    if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
        LONG off = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
        for (i = 0; i < 40; i++) {
            ED_EditBufferScratch[off + i] = ' ';
            ED_EditBufferLive[off + i] = ED_CurrentChar;
        }
        ED_RedrawRow(ED_ViewportOffset);
        return;
    }

    for (i = 0; i < ED_BlockOffset; i++) {
        ED_EditBufferScratch[i] = ' ';
        ED_EditBufferLive[i] = ED_CurrentChar;
    }
    ED_EditBufferScratch[ED_BlockOffset] = 0;
    ED_RedrawAllRows();
}

static void nav_alt_code(void)
{
    LONG ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
    UBYTE alt = ED_StateRingTable[ringOff + 2];

    ED_LastKeyCode = alt;
    if (alt == 64) {
        ED_NextAdNumber();
    } else if (alt == 65) {
        ED_PrevAdNumber();
    }
}

void ED_HandleEditorInput(void)
{
    LONG d0;
    LONG ringOff;

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
    case 2:
        d0 = GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble((LONG)ED_CurrentChar);
        d0 = GROUP_AG_JMPTBL_MATH_DivS32(d0 + 1, 8);
        ED_CurrentChar = (UBYTE)ED1_JMPTBL_LADFUNC_PackNibblesToByte(d0, (LONG)ED_CurrentChar);
        if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1) {
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
        }
        break;
    case 3:
        Global_REF_BOOL_IS_TEXT_OR_CURSOR = (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1) ? 0 : 1;
        SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(Global_REF_BOOL_IS_TEXT_OR_CURSOR);
        break;
    case 6:
        d0 = GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble((LONG)ED_CurrentChar);
        d0 = GROUP_AG_JMPTBL_MATH_DivS32(d0 + 1, 8);
        ED_CurrentChar = (UBYTE)ED1_JMPTBL_LADFUNC_MergeHighLowNibbles(d0, (LONG)ED_CurrentChar);
        if (Global_REF_BOOL_IS_TEXT_OR_CURSOR == 1) {
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
        }
        break;
    case 8:
        if (ED_EditCursorOffset > 0) {
            ED_EditCursorOffset -= 1;
        }
        /* fall through */
    case 0x6c:
        if ((ED_BlockOffset - 1) > ED_EditCursorOffset) {
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
                d0 = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset + 1, 40) - 1;
            } else {
                d0 = ED_BlockOffset - 1;
            }
            ED_TempCopyOffset = d0;
            if (ED_EditCursorOffset < d0) {
                ED1_JMPTBL_MEM_Move(&ED_EditBufferScratch[ED_EditCursorOffset],
                                    &ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                                    d0 - ED_EditCursorOffset);
                ED1_JMPTBL_MEM_Move(&ED_EditBufferLive[ED_EditCursorOffset],
                                    &ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                                    d0 - ED_EditCursorOffset);
            }
            ED_EditBufferScratch[ED_TempCopyOffset] = ' ';
            ED_EditBufferLive[ED_TempCopyOffset] = ED_EditBufferLiveIndexBaseMinus1[ED_TempCopyOffset];
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
                ED_RedrawRow(ED_ViewportOffset);
            } else {
                ED_EditBufferScratch[ED_BlockOffset] = 0;
                ED_RedrawAllRows();
            }
        } else {
            ED_EditBufferScratchIndexBaseMinus1[ED_BlockOffset] = ' ';
            ED_DrawCursorChar();
        }
        break;
    case 9:
        break;
    case 13:
        if (ED_TextLimit > 0) {
            LONG maxOff = GROUP_AG_JMPTBL_MATH_Mulu32(ED_TextLimit - 1, 40);
            if (ED_EditCursorOffset < maxOff) {
                ED_EditCursorOffset = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset + 1, 40);
            } else {
                ED_EditCursorOffset = maxOff;
            }
        }
        break;
    case 14:
        ED_AdActiveFlag = 0;
        ED_ApplyActiveFlagToAdData();
        break;
    case 27:
        Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
        ED_TextModeReinitPendingFlag = 1;
        ED_CommitCurrentAdEdits();
        ED_DrawESCMenuBottomHelp();
        break;
    case 0x80:
        ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
        ED_LastMenuInputChar = ED_StateRingTable[ringOff + 1];
        switch (ED_LastMenuInputChar) {
        case 0x20:
            nav_alt_code();
            break;
        case 0x30:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 1) {
                ED_EditCursorOffset = 0;
            } else {
                ED_EditCursorOffset = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
            }
            break;
        case 0x31:
            _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
            _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
            d0 = GROUP_AG_JMPTBL_MATH_DivS32(Global_REF_BOOL_IS_LINE_OR_PAGE + 1, 2);
            Global_REF_BOOL_IS_LINE_OR_PAGE = d0;
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390,
                                          Global_REF_BOOL_IS_LINE_OR_PAGE ? ED2_STR_PAGE : ED2_STR_LINE);
            _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
            break;
        case 0x32:
            do_spacing_transform(ED_TransformLineSpacing_Mode3);
            break;
        case 0x33:
            do_spacing_transform(ED_TransformLineSpacing_Mode1);
            break;
        case 0x34:
            do_spacing_transform(ED_TransformLineSpacing_Mode2);
            break;
        case 0x35:
            clear_line_or_page();
            break;
        case 0x36:
            if ((ED_TextLimit - 1) > ED_ViewportOffset) {
                LONG base = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
                LONG next = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset + 1, 40);
                LONG tail = ED_BlockOffset - next;
                ED1_JMPTBL_MEM_Move(&ED_EditBufferScratch[next], &ED_EditBufferScratch[base], tail);
                ED1_JMPTBL_MEM_Move(&ED_EditBufferLive[next], &ED_EditBufferLive[base], tail);
                for (d0 = 0; d0 < 40; d0++) {
                    ED_EditBufferScratch[base + d0] = ' ';
                    ED_EditBufferLive[base + d0] = ED_CurrentChar;
                }
                ED_EditBufferScratch[ED_BlockOffset] = 0;
                ED_RedrawAllRows();
            }
            break;
        case 0x37:
            if ((ED_TextLimit - 1) > ED_ViewportOffset) {
                LONG base = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
                LONG next = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset + 1, 40);
                LONG tail = ED_BlockOffset - next;
                ED1_JMPTBL_MEM_Move(&ED_EditBufferScratch[base], &ED_EditBufferScratch[next], tail);
                ED1_JMPTBL_MEM_Move(&ED_EditBufferLive[base], &ED_EditBufferLive[next], tail);
                base = GROUP_AG_JMPTBL_MATH_Mulu32(ED_TextLimit - 1, 40);
                for (d0 = 0; d0 < 40; d0++) {
                    ED_EditBufferScratch[base + d0] = ' ';
                    ED_EditBufferLive[base + d0] = ED_CurrentChar;
                }
                ED_EditBufferScratch[ED_BlockOffset] = 0;
                ED_RedrawAllRows();
            }
            break;
        case 0x38:
            if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
                LONG base = GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
                for (d0 = 0; d0 < 40; d0++) {
                    ED_EditBufferLive[base + d0] = ED_CurrentChar;
                }
                ED_RedrawRow(ED_ViewportOffset);
            } else {
                for (d0 = 0; d0 < ED_BlockOffset; d0++) {
                    ED_EditBufferLive[d0] = ED_CurrentChar;
                }
                ED_RedrawAllRows();
            }
            break;
        case 0x39:
            if ((ED_BlockOffset - 1) > ED_EditCursorOffset) {
                LONG end = (Global_REF_BOOL_IS_LINE_OR_PAGE == 0)
                    ? (GROUP_AG_JMPTBL_MATH_Mulu32(ED_ViewportOffset + 1, 40) - 1)
                    : (ED_BlockOffset - 1);
                if (ED_EditCursorOffset < end) {
                    ED1_JMPTBL_MEM_Move(&ED_EditBufferScratchShiftBase[ED_EditCursorOffset],
                                        &ED_EditBufferScratch[ED_EditCursorOffset],
                                        end - ED_EditCursorOffset);
                    ED1_JMPTBL_MEM_Move(&ED_EditBufferLiveShiftBase[ED_EditCursorOffset],
                                        &ED_EditBufferLive[ED_EditCursorOffset],
                                        end - ED_EditCursorOffset);
                }
                ED_EditBufferScratch[ED_EditCursorOffset] = ' ';
                ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
                if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
                    ED_RedrawRow(ED_ViewportOffset);
                } else {
                    ED_EditBufferScratch[ED_BlockOffset] = 0;
                    ED_RedrawAllRows();
                }
            } else {
                ED_EditBufferScratchIndexBaseMinus1[ED_BlockOffset] = ' ';
                ED_DrawCursorChar();
            }
            break;
        case 0x40:
            ED_MenuStateId = 9;
            ED_DrawEditHelpText();
            break;
        case 0x42:
            if (ED_EditCursorOffset > 39) {
                ED_EditCursorOffset -= 40;
            }
            break;
        case 0x43: {
            LONG maxOff = GROUP_AG_JMPTBL_MATH_Mulu32(ED_TextLimit - 1, 40);
            if (ED_EditCursorOffset < maxOff) {
                ED_EditCursorOffset += 40;
            }
            break;
        }
        case 0x44:
            if (ED_EditCursorOffset < (ED_BlockOffset - 1)) {
                ED_EditCursorOffset += 1;
            }
            break;
        case 0x45:
            if (ED_EditCursorOffset > 0) {
                ED_EditCursorOffset -= 1;
            }
            break;
        default:
            break;
        }
        break;
    default:
        if (ED_LastKeyCode > 25 && ED_LastKeyCode < 128) {
            ED_EditBufferScratch[ED_EditCursorOffset] = ED_LastKeyCode;
            ED_EditBufferLive[ED_EditCursorOffset] = ED_CurrentChar;
            ED_DrawCursorChar();
            if (ED_EditCursorOffset < (ED_BlockOffset - 1)) {
                ED_EditCursorOffset += 1;
            }
        }
        break;
    }

    sync_current_char_and_maybe_draw_indicator();
}
