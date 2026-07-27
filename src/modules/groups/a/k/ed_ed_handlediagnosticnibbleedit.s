    XDEF    _ED_HandleDiagnosticNibbleEdit


;------------------------------------------------------------------------------
; FUNC: _ED_HandleDiagnosticNibbleEdit   (Handle diagnostic nibble editsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2
; CALLS:
;   _ED_DrawESCMenuBottomHelp, _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp, _ED_DrawDiagnosticRegisterValues
; READS:
;   _ED_LastKeyCode, _ED_TempCopyOffset, _ED_StateRingIndex, _ED_StateRingTable
; WRITES:
;   _ED_TempCopyOffset, _ED_LastMenuInputChar, _GCOMMAND_PresetFallbackValue0, _GCOMMAND_PresetFallbackValue1, _GCOMMAND_PresetFallbackValue2
; DESC:
;   Adjusts per-entry nibble values and selection index, then refreshes display.
; NOTES:
;   Wraps nibble values in the 0..15 range.
;------------------------------------------------------------------------------
_ED_HandleDiagnosticNibbleEdit:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBI.W  #13,D0
    BEQ.S   .case_show_help

    SUBI.W  #14,D0
    BEQ.S   .case_show_help

    SUBI.W  #$27,D0
    BEQ.W   .case_inc_table2

    SUBQ.W  #5,D0
    BEQ.W   .case_inc_table1

    SUBI.W  #11,D0
    BEQ.S   .case_inc_table0

    SUBI.W  #16,D0
    BEQ.W   .case_dec_table2

    SUBQ.W  #5,D0
    BEQ.W   .case_dec_table1

    SUBI.W  #11,D0
    BEQ.S   .case_dec_table0

    SUBI.W  #$29,D0
    BEQ.W   .case_adjust_index

    BRA.W   .case_increment_index

.case_show_help:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_inc_table0:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   .after_index_update

.case_dec_table0:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table1:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   .after_index_update

.case_dec_table1:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   .after_index_update

.case_inc_table2:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.S   .after_index_update

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.S   .after_index_update

.case_dec_table2:
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.S   .after_index_update

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.S   .after_index_update

.case_adjust_index:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,_ED_LastMenuInputChar
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_index

    SUBQ.L  #1,_ED_TempCopyOffset
    BGE.S   .after_index_update

    MOVEQ   #39,D0
    MOVE.L  D0,_ED_TempCopyOffset
    BRA.S   .after_index_update

.case_increment_index:
    ADDQ.L  #1,_ED_TempCopyOffset
    MOVEQ   #40,D0
    CMP.L   _ED_TempCopyOffset,D0
    BNE.S   .after_index_update

    CLR.L   _ED_TempCopyOffset

.after_index_update:
    MOVE.L  _ED_TempCopyOffset,D0
    TST.L   D0
    BMI.S   .skip_refresh

    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .skip_refresh

    JSR     _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(PC)

.skip_refresh:
    JSR     _ED_DrawDiagnosticRegisterValues(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======