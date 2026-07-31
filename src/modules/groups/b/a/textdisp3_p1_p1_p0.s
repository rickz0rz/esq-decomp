    XDEF    TEXTDISP_BuildEntryShortName
    XDEF    TEXTDISP_DrawInsetRectFrame


;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawInsetRectFrame   (Draw inset rectangle)
; ARGS:
;   stack +8: rectPtr
;   stack +14: mode (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   TLIBA1_DrawFormattedTextBlock
; READS:
;   _WDISP_DisplayContextBase
; DESC:
;   Computes a rectangle from _WDISP_DisplayContextBase metrics and draws it via
;   TLIBA1_DrawFormattedTextBlock.
; NOTES:
;   Mode 2 adjusts half-width; mode 3 uses rastport defaults.
;------------------------------------------------------------------------------
TEXTDISP_DrawInsetRectFrame:
    LINK.W  A5,#-8
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,D4
    SUBQ.W  #1,D4
    MOVEQ   #0,D5
    MOVE.W  4(A0),D0
    SUBQ.W  #1,D0
    MOVEM.W D0,-8(A5)
    MOVEQ   #2,D1
    CMP.W   D1,D7
    BNE.S   .check_mode_3

    MOVE.L  D4,D1
    TST.W   D1
    BPL.S   .calc_half_width

    ADDQ.W  #1,D1

.calc_half_width:
    ASR.W   #1,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6

.check_mode_3:
    MOVEQ   #3,D1
    CMP.W   D1,D7
    BNE.S   .draw_in_entry_rast

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.L  D4,D3
    EXT.L   D3
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  _Global_REF_RASTPORT_2,-(A7)
    BSR.W   TLIBA1_DrawFormattedTextBlock

    LEA     24(A7),A7
    BRA.S   .return

.draw_in_entry_rast:
    LEA     10(A0),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D4,D2
    EXT.L   D2
    MOVE.W  -8(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   TLIBA1_DrawFormattedTextBlock

    LEA     24(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildEntryShortName   (Build entry display name)
; ARGS:
;   stack +8: entryPtr (A3)
;   stack +12: outPtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TEXTDISP_FindAliasIndexByName, _STRING_AppendAtNull
; READS:
;   _TEXTDISP_AliasPtrTable, _TEXTDISP_CenterAlignToken
; DESC:
;   Writes a short display name to outPtr, using alias table when available.
; NOTES:
;   Falls back to entry+19 and prefixes a center-align token when short.
;------------------------------------------------------------------------------
TEXTDISP_BuildEntryShortName:
    LINK.W  A5,#-12
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.B   (A2)
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_FindAliasIndexByName

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    EXT.L   D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .fallback_entry_name

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A1
    MOVEA.L 4(A1),A0
    MOVEA.L A2,A1

.copy_alias:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_alias

    BRA.S   .return

.fallback_entry_name:
    LEA     19(A3),A0
    MOVEA.L A0,A1

.measure_fallback:
    TST.B   (A1)+
    BNE.S   .measure_fallback

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEQ   #8,D0
    CMP.L   D0,D6
    BGE.S   .return

    TST.L   D6
    BEQ.S   .return

    LEA     _TEXTDISP_CenterAlignToken,A0
    MOVEA.L A2,A1

.prepend_align:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .prepend_align

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======