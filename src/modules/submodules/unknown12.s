;------------------------------------------------------------------------------
; FUNC: ALLOC_AllocFromFreeList   (Allocate a block from the internal free list.)
; ARGS:
;   stack +20: D7 = size (bytes)
; RET:
;   D0: pointer to block, or 0 on failure
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   MATH_DivS32 (div helper), MATH_Mulu32 (mul helper), MEMLIST_AllocTracked (alloc tracked),
;   ALLOC_InsertFreeBlock (insert free block)
; READS:
;   Global_AllocListHead, Global_AllocBlockSize, Global_AllocBytesTotal
; WRITES:
;   Global_AllocListHead, Global_AllocBytesTotal
; DESC:
;   Satisfies an allocation from the free list or grows the pool.
; NOTES:
;   Size is aligned to 4 bytes and clamped to a minimum of 8 bytes.
;------------------------------------------------------------------------------
ALLOC_AllocFromFreeList:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    TST.L   D7
    BGT.S   .have_size

    MOVEQ   #0,D0
    BRA.W   .return

.have_size:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BCC.S   .align_size

    MOVE.L  D0,D7

.align_size:
    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D7
    ANDI.W  #$fffc,D7
    LEA     Global_AllocListHead(A4),A2
    MOVEA.L (A2),A3

.scan_list:
    MOVE.L  A3,D0
    BEQ.S   .need_new_block

    MOVE.L  4(A3),D0
    CMP.L   D7,D0
    BLT.S   .next_node

    CMP.L   D7,D0
    BNE.S   .split_block

    MOVEA.L (A3),A0
    MOVE.L  A0,(A2)
    SUB.L   D7,Global_AllocBytesTotal(A4)
    MOVE.L  A3,D0
    BRA.S   .return

.split_block:
    MOVE.L  4(A3),D0
    SUB.L   D7,D0
    MOVEQ   #8,D1
    CMP.L   D1,D0
    BCS.S   .next_node

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVE.L  A0,(A2)
    MOVEA.L A0,A2
    MOVE.L  (A3),(A2)
    MOVE.L  D0,4(A2)
    SUB.L   D7,Global_AllocBytesTotal(A4)
    MOVE.L  A3,D0
    BRA.S   .return

.next_node:
    MOVEA.L A3,A2
    MOVEA.L (A3),A3
    BRA.S   .scan_list

.need_new_block:
    MOVE.L  D7,D0
    MOVE.L  Global_AllocBlockSize(A4),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    JSR     MATH_DivS32(PC)

    MOVE.L  Global_AllocBlockSize(A4),D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  D0,D6
    ADDQ.L  #8,D6
    MOVE.L  D6,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D6
    ANDI.W  #$fffc,D6
    MOVE.L  D6,-(A7)
    JSR     MEMLIST_AllocTracked(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .alloc_failed

    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     ALLOC_InsertFreeBlock(PC)

    MOVE.L  D7,(A7)
    BSR.W   ALLOC_AllocFromFreeList

    ADDQ.W  #8,A7
    BRA.S   .return

.alloc_failed:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
