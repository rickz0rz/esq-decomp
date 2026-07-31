    XDEF    _ESQIFF2_ParseLineHeadTailRecord
    XDEF    ESQIFF2_ParseLineHeadTailRecord_Return



;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ParseLineHeadTailRecord   (Parse line head/tail text record by group)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D6/D7
; CALLS:
;   _ESQIFF2_ClearLineHeadTailByMode, _ESQPARS_ReplaceOwnedString
; READS:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr, _ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _ESQIFF_RecordLength
; WRITES:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr, _ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr, _ESQDISP_SecondaryLinePromotePendingFlag
; DESC:
;   Splits a line-head/tail record on delimiter 0x12 and updates primary or
;   secondary line-head/line-tail owned strings based on group code.
; NOTES:
;   Calls _ESQIFF2_ClearLineHeadTailByMode before replacing owned strings.
;------------------------------------------------------------------------------
_ESQIFF2_ParseLineHeadTailRecord:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .check_secondary_group

    PEA     1.W
    BSR.W   _ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .primary_split_or_head_only

    SUBA.L  A0,A0
    MOVE.L  A0,_ESQIFF_PrimaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .primary_tail_only_from_payload

    MOVE.L  A0,_ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_tail_only_from_payload:
    LEA     2(A3),A0
    MOVE.L  _ESQIFF_PrimaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,_ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_split_or_head_only:
    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .primary_scan_internal_delimiter

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CLR.B   -1(A3,D1.L)
    LEA     1(A3),A0
    MOVE.L  _ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,_ESQIFF_PrimaryLineHeadPtr
    CLR.L   _ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_scan_internal_delimiter:
    MOVEQ   #3,D6

.loop_primary_find_delimiter:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .primary_split_at_found_delimiter

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .primary_split_at_found_delimiter

    ADDQ.W  #1,D6
    BRA.S   .loop_primary_find_delimiter

.primary_split_at_found_delimiter:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  _ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVE.L  D0,_ESQIFF_PrimaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  _ESQIFF_PrimaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.check_secondary_group:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   ESQIFF2_ParseLineHeadTailRecord_Return

    PEA     2.W
    BSR.W   _ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVE.W  #1,_ESQDISP_SecondaryLinePromotePendingFlag
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .secondary_split_or_head_only

    SUBA.L  A0,A0
    MOVE.L  A0,_ESQIFF_SecondaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .secondary_tail_only_from_payload

    MOVE.L  A0,_ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_tail_only_from_payload:
    LEA     2(A3),A0
    MOVE.L  _ESQIFF_SecondaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,_ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_split_or_head_only:
    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .secondary_scan_internal_delimiter

    LEA     1(A3),A0
    MOVE.L  _ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,_ESQIFF_SecondaryLineHeadPtr
    CLR.L   _ESQIFF_SecondaryLineTailPtr
    BRA.S   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_scan_internal_delimiter:
    MOVEQ   #3,D6

.loop_secondary_find_delimiter:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .secondary_split_at_found_delimiter

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .secondary_split_at_found_delimiter

    ADDQ.W  #1,D6
    BRA.S   .loop_secondary_find_delimiter

.secondary_split_at_found_delimiter:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  _ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVE.L  D0,_ESQIFF_SecondaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  _ESQIFF_SecondaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_SecondaryLineTailPtr

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseLineHeadTailRecord_Return   (Return tail for line head/tail parser)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns from line-head/tail parse helper.
; NOTES:
;   Shared return for all parse paths and unsupported-group early exits.
;------------------------------------------------------------------------------
ESQIFF2_ParseLineHeadTailRecord_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======