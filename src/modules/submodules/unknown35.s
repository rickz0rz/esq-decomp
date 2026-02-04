;------------------------------------------------------------------------------
; FUNC: HANDLE_OpenWithMode   (Allocate/locate handle struct and open by mode.)
; ARGS:
;   stack +8: A0 = path string ??
;   stack +12: A1 = mode string ??
; RET:
;   D0: handle/struct pointer, or 0 on failure
; CLOBBERS:
;   D0-D1/A0-A3
; CALLS:
;   ALLOC_AllocFromFreeList (allocator), HANDLE_OpenFromModeString (parse mode/open)
; READS:
;   Global_A4_1120_Base
; DESC:
;   Finds a free handle struct or allocates a new one, then initializes it
;   via the mode/parser helper.
; NOTES:
;   Uses a 34-byte handle struct; layout still unknown.
;------------------------------------------------------------------------------
HANDLE_OpenWithMode:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    LEA     Global_A4_1120_Base(A4),A3

.scan_for_free:
    MOVE.L  A3,D0
    BEQ.S   .no_free

    TST.L   24(A3)
    BEQ.S   .no_free

    MOVEA.L A3,A2
    MOVEA.L (A3),A3
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
    MOVE.L  A3,(A2)
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
