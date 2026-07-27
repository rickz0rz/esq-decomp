    XDEF    _ED_CaptureKeySequence


;------------------------------------------------------------------------------
; FUNC: _ED_CaptureKeySequence   (Capture key sequenceuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit, _GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   _ED_StateRingIndex, _ED_StateRingTable, _WDISP_CharClassTable, _ED_CustomPaletteCapturePhaseMod4, _ED_CustomPaletteCaptureIndexOrSentinel
; WRITES:
;   _ED_CustomPaletteCapturePhaseMod4, _ED_CustomPaletteCaptureIndexOrSentinel, _KYBD_CustomPaletteCaptureScratchBase, _KYBD_CustomPaletteTriplesRBase, _ED_MenuStateId
; DESC:
;   Captures an input sequence and writes it into the _KYBD_CustomPaletteCaptureScratchBase/_KYBD_CustomPaletteTriplesRBase buffers.
; NOTES:
;   Copies a 24-byte template from _ED_CustomPaletteTriplesDefaultTemplate24B into the output buffer on completion.
;------------------------------------------------------------------------------
_ED_CaptureKeySequence:
    LINK.W  A5,#-28
    MOVE.L  D7,-(A7)
    LEA     _ED_CustomPaletteTriplesDefaultTemplate24B,A0
    LEA     -25(A5),A1
    MOVEQ   #23,D0

.copy_template_to_stack:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_template_to_stack
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,_ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.S   .no_capture_flag

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    TST.L   _ED_CustomPaletteCapturePhaseMod4
    BNE.S   .have_pending_capture

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,_ED_CustomPaletteCaptureIndexOrSentinel
    BRA.S   .advance_capture_slot

.have_pending_capture:
    MOVE.L  _ED_CustomPaletteCaptureIndexOrSentinel,D0
    TST.L   D0
    BMI.S   .invalidate_capture

    MOVEQ   #8,D1
    CMP.L   D1,D0
    BGE.S   .invalidate_capture

    MOVEQ   #13,D1
    CMP.B   D1,D7
    BCC.S   .invalidate_capture

    LSL.L   #2,D0
    SUB.L   _ED_CustomPaletteCaptureIndexOrSentinel,D0
    MOVE.L  _ED_CustomPaletteCapturePhaseMod4,D1
    ADD.L   D1,D0
    LEA     _KYBD_CustomPaletteCaptureScratchBase,A0
    ADDA.L  D0,A0
    MOVE.B  D7,(A0)
    BRA.S   .advance_capture_slot

.invalidate_capture:
    MOVEQ   #-1,D0
    MOVE.L  D0,_ED_CustomPaletteCaptureIndexOrSentinel
    BRA.S   .advance_capture_slot

.no_capture_flag:
    MOVEQ   #-1,D0
    MOVE.L  D0,_ED_CustomPaletteCaptureIndexOrSentinel

.advance_capture_slot:
    MOVE.L  _ED_CustomPaletteCapturePhaseMod4,D0
    ADDQ.L  #1,D0
    MOVEQ   #4,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,_ED_CustomPaletteCapturePhaseMod4
    BNE.S   .return

    MOVE.L  _ED_CustomPaletteCaptureIndexOrSentinel,D0
    TST.L   D0
    BPL.S   .finish_capture

    CLR.L   _ED_CustomPaletteCaptureIndexOrSentinel

.copy_buffer_loop:
    MOVE.L  _ED_CustomPaletteCaptureIndexOrSentinel,D0
    MOVEQ   #24,D1
    CMP.L   D1,D0
    BGE.S   .finish_capture

    LEA     _KYBD_CustomPaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVE.B  -25(A5,D0.L),(A0)
    ADDQ.L  #1,_ED_CustomPaletteCaptureIndexOrSentinel
    BRA.S   .copy_buffer_loop

.finish_capture:
    CLR.B   _ED_MenuStateId

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======