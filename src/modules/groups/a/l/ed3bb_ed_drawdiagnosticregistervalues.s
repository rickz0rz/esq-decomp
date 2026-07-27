    XDEF    _ED_DrawDiagnosticRegisterValues


;------------------------------------------------------------------------------
; FUNC: _ED_DrawDiagnosticRegisterValues   (Draw diagnostic register valuesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_TempCopyOffset, _GCOMMAND_PresetFallbackValue0, _GCOMMAND_PresetFallbackValue1, _GCOMMAND_PresetFallbackValue2, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws diagnostic register labels and formatted values.
; NOTES:
;   Formats values into _ED_EditBufferScratch before display.
;------------------------------------------------------------------------------
_ED_DrawDiagnosticRegisterValues:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_REGISTER
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  _ED_TempCopyOffset,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     240.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_R_EQUALS
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue0,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    LEA     72(A7),A7
    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     85.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_G_EQUALS
    PEA     270.W
    PEA     135.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue1,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     180.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_B_EQUALS
    PEA     270.W
    PEA     230.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVE.L  _ED_TempCopyOffset,D0
    LSL.L   #2,D0
    SUB.L   _ED_TempCopyOffset,D0
    LEA     _GCOMMAND_PresetFallbackValue2,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     270.W
    PEA     275.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    RTS

;!======