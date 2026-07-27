    XDEF    _TEXTDISP_AddSourceConfigEntry


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_AddSourceConfigEntry   (Append SourceCfg entry)
; ARGS:
;   stack +8: namePtr (A3)
;   stack +12: typePtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   _MEMORY_AllocateMemory, _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString, _STRING_CompareNoCase
; READS:
;   _TEXTDISP_SourceConfigEntryCount, _TEXTDISP_PtrPrevueSportsTag, _TEXTDISP_SourceConfigFlagMask
; WRITES:
;   _TEXTDISP_SourceConfigEntryTable, _TEXTDISP_SourceConfigEntryCount, _TEXTDISP_SourceConfigFlagMask
; DESC:
;   Allocates a 6-byte SourceCfg entry, stores name/type, and updates flags.
; NOTES:
;   Marks entries matching \"PrevueSports\" with flag 0x08.
;------------------------------------------------------------------------------
_TEXTDISP_AddSourceConfigEntry:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  _TEXTDISP_SourceConfigEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     6.W
    PEA     1229.W
    PEA     _Global_STR_TEXTDISP_C_4
    MOVE.L  A0,24(A7)
    JSR     _MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .return

    ADDQ.L  #1,_TEXTDISP_SourceConfigEntryCount
    MOVEA.L D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  _TEXTDISP_PtrPrevueSportsTag,(A7)
    MOVE.L  A2,-(A7)
    JSR     _STRING_CompareNoCase(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .set_entry_flag

    MOVEQ   #8,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,4(A0)

.set_entry_flag:
    MOVE.B  _TEXTDISP_SourceConfigFlagMask,D0
    MOVEA.L -4(A5),A0
    OR.B    4(A0),D0
    MOVE.B  D0,_TEXTDISP_SourceConfigFlagMask

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======