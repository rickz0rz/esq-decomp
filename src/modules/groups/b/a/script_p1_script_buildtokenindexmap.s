    XDEF    _SCRIPT_BuildTokenIndexMap



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_BuildTokenIndexMap   (BuildTokenIndexMapuncertain)
; ARGS:
;   stack +8: inputBytes (byte array)
;   stack +12: outIndexByToken (word array)
;   stack +18: tokenCount
;   stack +20: tokenTable (byte array, length tokenCount)
;   stack +26: maxScanCount
;   stack +31: terminatorByte
;   stack +34: fillMissingFlag (non-zero = fill -1 entries)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   (none)
; READS:
;   inputBytes, tokenTable
; WRITES:
;   outIndexByToken
; DESC:
;   Builds a token->index map by scanning inputBytes for entries in tokenTable.
; NOTES:
;   Stops on terminatorByte, maxScanCount, or when last token is assigned.
;------------------------------------------------------------------------------
_SCRIPT_BuildTokenIndexMap:
    LINK.W  A5,#-12
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  26(A5),D6
    MOVE.B  31(A5),D5

    MOVEQ   #0,D0
    MOVE.W  D0,-6(A5)
    MOVE.W  D0,-10(A5)

.init_table_loop:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .scan_setup

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),0(A2,D1.L)
    ADDQ.W  #1,-6(A5)
    BRA.S   .init_table_loop

.scan_setup:
    MOVEQ   #0,D0
    MOVE.W  D0,-8(A5)
    MOVE.W  D0,-4(A5)

.scan_input_loop:
    MOVE.W  -4(A5),D0
    MOVE.B  0(A3,D0.W),-1(A5)
    MOVE.B  -1(A5),D1
    CMP.B   D5,D1
    BEQ.S   .scan_done

    CMP.W   D6,D0
    BGE.S   .scan_done

    MOVE.W  -8(A5),-6(A5)

.scan_token_loop:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .after_token_scan

    MOVE.B  -1(A5),D1
    MOVEA.L 20(A5),A0
    CMP.B   0(A0,D0.W),D1
    BNE.S   .scan_token_next

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -4(A5),D0
    MOVE.L  D0,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,0(A2,D1.L)
    CLR.B   0(A3,D0.W)
    ADDQ.W  #1,-8(A5)
    MOVE.W  D0,-10(A5)
    BRA.S   .after_token_scan

.scan_token_next:
    ADDQ.W  #1,-6(A5)
    BRA.S   .scan_token_loop

.after_token_scan:
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -2(A2,D0.L),D1
    BNE.S   .scan_done

    ADDQ.W  #1,-4(A5)
    BRA.S   .scan_input_loop

.scan_done:
    TST.W   -10(A5)
    BNE.S   .ensure_last_index

    MOVE.W  -4(A5),-10(A5)

.ensure_last_index:
    TST.W   34(A5)
    BEQ.S   .return

    CLR.W   -6(A5)

.fill_missing_loop:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .return

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVEQ   #-1,D0
    CMP.W   0(A2,D1.L),D0
    BNE.S   .fill_missing_next

    MOVE.W  -10(A5),0(A2,D1.L)

.fill_missing_next:
    ADDQ.W  #1,-6(A5)
    BRA.S   .fill_missing_loop

.return:
    MOVE.W  -4(A5),D0

    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======