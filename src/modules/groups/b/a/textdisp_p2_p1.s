    XDEF    TEXTDISP_ApplySourceConfigAllEntries
    XDEF    TEXTDISP_ApplySourceConfigToEntry
    XDEF    TEXTDISP_ClearSourceConfig


;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ClearSourceConfig   (Free SourceCfg table)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString, _MEMORY_DeallocateMemory
; READS:
;   _TEXTDISP_SourceConfigEntryTable, _TEXTDISP_SourceConfigEntryCount
; WRITES:
;   _TEXTDISP_SourceConfigEntryTable, _TEXTDISP_SourceConfigEntryCount, _TEXTDISP_SourceConfigFlagMask
; DESC:
;   Frees all SourceCfg entries and resets the table/state.
; NOTES:
;   Each entry is 6 bytes.
;------------------------------------------------------------------------------
TEXTDISP_ClearSourceConfig:
    LINK.W  A5,#-8
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

.loop_entries:
    CMP.L   _TEXTDISP_SourceConfigEntryCount,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .free_entry

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,20(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    ADDA.L  D0,A0
    PEA     6.W
    MOVE.L  (A0),-(A7)
    PEA     1153.W
    PEA     Global_STR_TEXTDISP_C_3
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.free_entry:
    ADDQ.L  #1,D7
    BRA.S   .loop_entries

.return:
    CLR.L   _TEXTDISP_SourceConfigEntryCount
    CLR.B   _TEXTDISP_SourceConfigFlagMask
    MOVEM.L (A7)+,D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ApplySourceConfigToEntry   (Apply SourceCfg flags)
; ARGS:
;   stack +20: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _STRING_CompareNoCaseN
; READS:
;   _TEXTDISP_SourceConfigEntryTable, _TEXTDISP_SourceConfigEntryCount, _TEXTDISP_SourceConfigFlagMask
; WRITES:
;   entry+40
; DESC:
;   Compares entry name against SourceCfg entries and ORs matching flags.
; NOTES:
;   Clears masked flags before applying matches.
;------------------------------------------------------------------------------
TEXTDISP_ApplySourceConfigToEntry:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVE.B  _TEXTDISP_SourceConfigFlagMask,D0
    NOT.B   D0
    AND.B   D0,40(A3)
    MOVEQ   #0,D7

.loop_entries:
    CMP.L   _TEXTDISP_SourceConfigEntryCount,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    LEA     12(A3),A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A6
    MOVEA.L (A6),A0

.compare_entry_name:
    TST.B   (A0)+
    BNE.S   .compare_entry_name

    SUBQ.L  #1,A0
    SUBA.L  (A6),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     _STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .set_entry_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  4(A1),D0
    OR.B    D0,40(A3)

.set_entry_flag:
    ADDQ.L  #1,D7
    BRA.S   .loop_entries

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ApplySourceConfigAllEntries   (Apply SourceCfg to all entries)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, TEXTDISP_ApplySourceConfigToEntry
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount
; DESC:
;   Iterates entries across both groups and applies SourceCfg flags.
; NOTES:
;   Uses group IDs 1 and 2.
;------------------------------------------------------------------------------
TEXTDISP_ApplySourceConfigAllEntries:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.loop_group1:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .loop_group1_done

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   TEXTDISP_ApplySourceConfigToEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .loop_group1

.loop_group1_done:
    MOVEQ   #0,D7

.loop_group2:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   TEXTDISP_ApplySourceConfigToEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .loop_group2

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======