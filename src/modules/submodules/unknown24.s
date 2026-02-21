    XDEF    MEMLIST_AllocTracked
    XDEF    MEMLIST_FreeAll
    XDEF    PARSE_ReadSignedLongSkipClass3
    XDEF    PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLongSkipClass3   (Parse signed long after skipping class3.)
; ARGS:
;   stack +16: A3 = input string
; RET:
;   D0: parsed value (0 if input is null)
; CLOBBERS:
;   D0/A0/A3
; CALLS:
;   STR_SkipClass3Chars (skip class3), PARSE_ReadSignedLong (parse signed decimal)
; DESC:
;   Skips class-3 characters, parses a signed decimal, returns the value.
;------------------------------------------------------------------------------
PARSE_ReadSignedLongSkipClass3:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .have_input

    MOVEQ   #0,D0
    BRA.S   .return

.have_input:
    MOVE.L  A3,-(A7)
    JSR     STR_SkipClass3Chars(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     PARSE_ReadSignedLong(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLongSkipClass3_Alt   (Alternate signed decimal parser.)
; ARGS:
;   stack +16: A3 = input string
; RET:
;   D0: parsed value (0 if input is null)
; CLOBBERS:
;   D0/A0/A3
; CALLS:
;   STR_SkipClass3Chars (skip class3), PARSE_ReadSignedLong_NoBranch (parse signed decimal)
; DESC:
;   Skips class-3 characters, parses a signed decimal, returns the value.
; NOTES:
;   Uses PARSE_ReadSignedLong_NoBranch instead of PARSE_ReadSignedLong (behavior differences unknown).
;------------------------------------------------------------------------------
PARSE_ReadSignedLongSkipClass3_Alt:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .have_input

    MOVEQ   #0,D0
    BRA.S   .return

.have_input:
    MOVE.L  A3,-(A7)
    JSR     STR_SkipClass3Chars(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     PARSE_ReadSignedLong_NoBranch(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: MEMLIST_FreeAll   (Free all tracked allocations.)
; ARGS:
;   none
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A0-A3/A6
; CALLS:
;   _LVOFreeMem
; READS:
;   Global_MemListHead
; WRITES:
;   Global_MemListHead, Global_MemListTail
; DESC:
;   Walks the tracked allocation list and frees each block.
;------------------------------------------------------------------------------
MEMLIST_FreeAll:
    MOVEM.L A2-A3/A6,-(A7)
    MOVEA.L Global_MemListHead(A4),A3

.free_loop:
    MOVE.L  A3,D0
    BEQ.S   .done

    MOVEA.L (A3),A2
    MOVEA.L A3,A1
    MOVE.L  8(A3),D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEA.L A2,A3
    BRA.S   .free_loop

.done:
    SUBA.L  A0,A0
    MOVE.L  A0,Global_MemListTail(A4)
    MOVE.L  A0,Global_MemListHead(A4)
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: MEMLIST_AllocTracked   (Allocate and track a block in the mem list.)
; ARGS:
;   stack +20: D7 = requested size (bytes)
; RET:
;   D0: pointer to usable bytes (after 12-byte header), or 0 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOAllocMem
; READS:
;   Global_MemListHead, Global_MemListTail, Global_MemListFirstAllocNode
; WRITES:
;   Global_MemListHead, Global_MemListTail, Global_MemListFirstAllocNode
; DESC:
;   Allocates a block (size+12), links it into the list, returns data ptr.
;------------------------------------------------------------------------------
MEMLIST_AllocTracked:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  20(A7),D7

    MOVEQ   #12,D0
    ADD.L   D0,D7
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .alloc_ok

    MOVEQ   #0,D0
    BRA.S   .return

.alloc_ok:
    MOVE.L  D7,8(A3)
    LEA     Global_MemListHead(A4),A2
    MOVEA.L 4(A2),A0
    MOVE.L  A0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    TST.L   (A2)
    BNE.S   .link_tail

    MOVE.L  A3,(A2)

.link_tail:
    TST.L   4(A2)
    BEQ.S   .write_tail

    MOVEA.L 4(A2),A1
    MOVE.L  A3,(A1)

.write_tail:
    MOVE.L  A3,4(A2)
    TST.L   Global_MemListFirstAllocNode(A4)
    BNE.S   .return_data

    MOVE.L  A3,Global_MemListFirstAllocNode(A4)

.return_data:
    LEA     12(A3),A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    DC.W    $0000
