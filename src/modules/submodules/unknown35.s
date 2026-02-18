    XDEF    HANDLE_OpenWithMode

;------------------------------------------------------------------------------
; FUNC: HANDLE_OpenWithMode   (Allocate/locate handle struct and open by mode.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: handle/struct pointer, or 0 on failure
; CLOBBERS:
;   D0-D1/A0-A3
; CALLS:
;   ALLOC_AllocFromFreeList (allocator), HANDLE_OpenFromModeString (parse mode/open)
; READS:
;   Global_PreallocHandleNode0
; DESC:
;   Finds a free handle struct or allocates a new one, then initializes it
;   via the mode/parser helper.
; NOTES:
;   Uses a 34-byte node; +0 links next node and +24 is open/in-use flags.
;------------------------------------------------------------------------------
HANDLE_OpenWithMode:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    LEA     Global_PreallocHandleNode0(A4),A3

.scan_for_free:
    MOVE.L  A3,D0
    BEQ.S   .no_free

    TST.L   Struct_PreallocHandleNode__OpenFlags(A3)
    BEQ.S   .no_free

    MOVEA.L A3,A2
    MOVEA.L Struct_PreallocHandleNode__Next(A3),A3
    BRA.S   .scan_for_free

.no_free:
    MOVE.L  A3,D0
    BNE.S   .init_handle

    PEA     34.W
    JSR     ALLOC_AllocFromFreeList(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    TST.L   D0
    BNE.S   .alloc_ok

    MOVEQ   #0,D0
    BRA.S   .return

.alloc_ok:
    MOVE.L  A3,Struct_PreallocHandleNode__Next(A2)
    MOVEQ   #33,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

.clear_struct:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_struct

.init_handle:
    MOVE.L  A3,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     HANDLE_OpenFromModeString(PC)

.return:
    MOVEM.L -16(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
