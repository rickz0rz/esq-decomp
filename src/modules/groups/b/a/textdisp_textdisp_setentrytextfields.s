    XDEF    _TEXTDISP_SetEntryTextFields


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_SetEntryTextFields   (Populate short/long name fields)
; ARGS:
;   stack +8: entryPtr (A3)
;   stack +12: shortNamePtr (A2)
;   stack +16: longNamePtr
; RET:
;   none
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   _STRING_CopyPadNul
; READS:
;   _CONFIG_LRBN_FlagChar, _TEXTDISP_LrbnEntryWidthPx, _CONFIG_BannerCopperHeadByte
; WRITES:
;   entry+0..9, entry+10..208, _TEXTDISP_EntryTextBaseWidthPx
; DESC:
;   Copies short and long names into the entry struct, padding with NULs.
; NOTES:
;   Selects a base width (_TEXTDISP_EntryTextBaseWidthPx) depending on region/flag.
;------------------------------------------------------------------------------
_TEXTDISP_SetEntryTextFields:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  _CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .use_hex_code

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_LrbnEntryWidthPx,D0
    MOVE.L  D0,_TEXTDISP_EntryTextBaseWidthPx
    BRA.S   .after_hex_code

.use_hex_code:
    MOVEQ   #0,D0
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVE.L  D0,_TEXTDISP_EntryTextBaseWidthPx

.after_hex_code:
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   .copy_short_name

    PEA     9.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,9(A0)
    BRA.S   .after_short_name

.copy_short_name:
    CLR.B   (A0)

.after_short_name:
    LEA     10(A3),A1
    MOVE.L  A1,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   .copy_long_name

    PEA     199.W
    MOVE.L  16(A5),-(A7)
    MOVE.L  A1,-(A7)
    JSR     _STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,199(A0)
    BRA.S   .return

.copy_long_name:
    CLR.B   (A1)

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======