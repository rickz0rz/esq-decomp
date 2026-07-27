    XDEF    _LOCAVAIL_FreeNodeAtPointer


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_FreeNodeAtPointer   (Free node payload buffer then clear node record)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_LOCAVAIL_C_1
; WRITES:
;   (none observed)
; DESC:
;   Releases node-owned payload at +6 when present and length (+4) is positive,
;   then clears the node fields via `_LOCAVAIL_FreeNodeRecord`.
; NOTES:
;   No-op for NULL node pointers.
;------------------------------------------------------------------------------
_LOCAVAIL_FreeNodeAtPointer:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   6(A3)
    BEQ.S   .clear_node_record

    MOVE.W  4(A3),D0
    TST.W   D0
    BLE.S   .clear_node_record

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     106.W
    PEA     _Global_STR_LOCAVAIL_C_1
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.clear_node_record:
    MOVE.L  A3,-(A7)
    BSR.S   _LOCAVAIL_FreeNodeRecord

    ADDQ.W  #4,A7

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======