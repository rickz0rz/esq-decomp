    XDEF    _ESQPARS_ClearAliasStringPointers


;------------------------------------------------------------------------------
; FUNC: _ESQPARS_ClearAliasStringPointers   (Free alias records and clear pointer table)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQPARS_ReplaceOwnedString
; READS:
;   _TEXTDISP_AliasCount, _TEXTDISP_AliasPtrTable, _Global_STR_ESQPARS_C_1
; WRITES:
;   _TEXTDISP_AliasPtrTable entries, alias record string-pointer fields
; DESC:
;   Walks alias pointer entries and releases both owned strings for each alias
;   record, then frees the alias record and nulls its table slot.
; NOTES:
;   Iterates alias indices 0..(_TEXTDISP_AliasCount-1).
;------------------------------------------------------------------------------
_ESQPARS_ClearAliasStringPointers:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.alias_loop:
    MOVE.W  _TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-6(A5)
    MOVE.L  A1,D0
    BEQ.S   .next_alias

    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  4(A0),(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,4(A0)
    PEA     8.W
    MOVE.L  A0,-(A7)
    PEA     945.W
    PEA     _Global_STR_ESQPARS_C_1
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.next_alias:
    ADDQ.W  #1,D7
    BRA.S   .alias_loop

.done:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======