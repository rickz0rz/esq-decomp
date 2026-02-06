;------------------------------------------------------------------------------
; FUNC: STRUCT_FreeWithSizeField   (Free struct using size field at +18.)
; ARGS:
;   stack +12: A3 = struct pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A0-A1/A3/A6
; CALLS:
;   _LVOFreeMem
; DESC:
;   Marks fields as invalid and frees using size at offset 18.
; NOTES:
;   Structure layout is unknown; offsets 8/20/24/18 are used here.
;------------------------------------------------------------------------------
STRUCT_FreeWithSizeField:
    MOVEM.L A3/A6,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  #$ff,8(A3)
    MOVEA.W #$ffff,A0
    MOVE.L  A0,20(A3)
    MOVE.L  A0,24(A3)
    MOVEQ   #0,D0

    ; This must be pointing to a property in a struct?
    MOVE.W  18(A3),D0
    MOVEA.L A3,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEM.L (A7)+,A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: STRUCT_AllocWithOwner   (Allocate struct and initialize fields.)
; ARGS:
;   stack +20: A3 = owner/context pointer
;   stack +24: D7 = size (bytes)
; RET:
;   D0: struct pointer or 0 on failure
; CLOBBERS:
;   D0-D7/A2-A3/A6
; CALLS:
;   _LVOAllocMem
; DESC:
;   Allocates memory (public+clear), fills basic fields, returns pointer.
; NOTES:
;   Uses offsets 8/9/14/18; structure layout still unknown.
;------------------------------------------------------------------------------
STRUCT_AllocWithOwner:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  A3,D0
    BNE.S   .have_owner

    MOVEQ   #0,D0
    BRA.S   .return

.have_owner:
    MOVE.L  D7,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BEQ.S   .alloc_failed

    MOVE.B  #$5,8(A2)
    CLR.B   9(A2)
    MOVE.L  A3,14(A2)
    MOVE.L  D7,D0
    MOVE.W  D0,18(A2)

.alloc_failed:
    MOVE.L  A2,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
