    XDEF    _P_TYPE_ParseAndStoreTypeRecord



;------------------------------------------------------------------------------
; FUNC: _P_TYPE_ParseAndStoreTypeRecord   (Parse one type line and update selected list)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +9: arg_2 (via 13(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +12: arg_4 (via 16(A5))
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _P_TYPE_FreeEntry, _P_TYPE_AllocateEntry, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _SCRIPT3_JMPTBL_STRING_CopyPadNul
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _P_TYPE_PrimaryGroupListPtr
; WRITES:
;   (none observed)
; DESC:
;   Parses group code + payload length from text, selects primary/secondary slot,
;   then replaces that slot with a newly allocated entry.
; NOTES:
;   Returns 1 when a slot is updated, 0 when parsed group code is unsupported.
;------------------------------------------------------------------------------
_P_TYPE_ParseAndStoreTypeRecord:
    LINK.W  A5,#-24
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D4
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     _SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -13(A5)
    PEA     -16(A5)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #3,A3
    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     _SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -14(A5)
    PEA     -16(A5)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     32(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #2,A3
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .if_ne_1374

    MOVEQ   #0,D5
    BRA.S   .skip_1376

.if_ne_1374:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .if_ne_1375

    MOVEQ   #1,D5
    BRA.S   .skip_1376

.if_ne_1375:
    MOVEQ   #2,D5

.skip_1376:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BEQ.S   .if_eq_1377

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _P_TYPE_FreeEntry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  A3,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,32(A7)
    BSR.W   _P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #1,D4

.if_eq_1377:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======