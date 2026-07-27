    XDEF    _ED_ApplyActiveFlagToAdData


;------------------------------------------------------------------------------
; FUNC: _ED_ApplyActiveFlagToAdData   (Apply active flag to ad datauncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D1/D2
; CALLS:
;   (none)
; READS:
;   _ED_AdActiveFlag, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_AdRecordPtrTable
; WRITES:
;   Ad data (first word / word+2) via _ED_AdRecordPtrTable
; DESC:
;   Writes the active/inactive flag for the current ad into its data record.
; NOTES:
;   Clears both words when inactive; sets word0=1 and word2=$30 when active.
;------------------------------------------------------------------------------
_ED_ApplyActiveFlagToAdData:
    MOVEM.L D2/A2,-(A7)

    TST.L   _ED_AdActiveFlag
    BNE.S   .set_active

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    MOVE.L  D0,D1
    ASL.L   #2,D1
    LEA     _ED_AdRecordPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVEQ   #0,D2
    MOVE.W  D2,(A2)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVE.W  D2,2(A2)
    BRA.S   .return

.set_active:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    ASL.L   #2,D0
    LEA     _ED_AdRecordPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.W  #1,(A2)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.W  #$30,2(A1)

.return:
    MOVEM.L (A7)+,D2/A2
    RTS

;!======