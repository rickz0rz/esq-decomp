;------------------------------------------------------------------------------
; FUNC: STRING_FindSubstring   (Find a substring within a string.)
; ARGS:
;   stack +4: A0 = haystack string
;   stack +8: A1 = needle string
; RET:
;   D0: pointer to first match in A0, or 0 if not found
; CLOBBERS:
;   D0/A0-A3
; DESC:
;   Naive substring search; returns pointer to first match.
;------------------------------------------------------------------------------
STRING_FindSubstring:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)
    BRA.S   .check_at_current

.advance_start:
    CMPI.B  #0,(A2)
    BEQ.S   .not_found

    ADDQ.L  #1,A0
    CMPI.B  #0,(A0)
    BEQ.S   .not_found

.check_at_current:
    MOVEA.L A0,A2
    MOVEA.L A1,A3

.compare_loop:
    CMPI.B  #0,(A3)
    BEQ.S   .found

    CMPM.B  (A2)+,(A3)+
    BNE.S   .advance_start

    BRA.S   .compare_loop

.not_found:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

.found:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ALLOC_InsertFreeBlock   (Insert a block into the allocation free list.)
; ARGS:
;   stack +8: A2 = block pointer
;   stack +52: D7 = size (bytes)
; RET:
;   D0: 0 on success, -1 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; READS:
;   Global_AllocListHead, Global_AllocBytesTotal
; WRITES:
;   Global_AllocListHead, Global_AllocBytesTotal
; DESC:
;   Inserts a block into the free list and merges adjacent blocks.
; NOTES:
;   Size is aligned to 4 bytes and clamped to a minimum of 8 bytes.
;------------------------------------------------------------------------------
ALLOC_InsertFreeBlock:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  52(A7),D7
    TST.L   D7
    BGT.S   .have_size

    MOVEQ   #-1,D0
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
    MOVEA.L 8(A5),A2
    MOVE.L  8(A5),D0
    ADD.L   D7,D0
    ADD.L   D7,Global_AllocBytesTotal(A4)
    LEA     Global_AllocListHead(A4),A0
    MOVEA.L (A0),A3
    MOVE.L  D0,-16(A5)
    MOVE.L  A0,-12(A5)

.scan_list:
    MOVE.L  A3,D0
    BEQ.W   .append_tail

    MOVEA.L A3,A0
    MOVE.L  4(A3),D0
    ADDA.L  D0,A0
    MOVE.L  A0,-20(A5)
    MOVEA.L -16(A5),A1
    CMPA.L  A1,A3
    BLS.S   .insert_before

    MOVE.L  A3,(A2)
    MOVE.L  D7,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   .return

.insert_before:
    CMPA.L  A1,A3
    BNE.S   .check_adjacent

    MOVEA.L (A3),A6
    MOVE.L  A6,(A2)
    MOVE.L  4(A3),D0
    MOVE.L  D0,D1
    ADD.L   D7,D1
    MOVE.L  D1,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   .return

.check_adjacent:
    CMPA.L  A0,A2
    BCC.S   .maybe_merge

    SUB.L   D7,Global_AllocBytesTotal(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.maybe_merge:
    CMPA.L  A0,A2
    BNE.S   .next_node

    TST.L   (A3)
    BEQ.S   .merge_next

    MOVEA.L (A3),A0
    CMPA.L  A0,A1
    BLS.S   .merge_next

    SUB.L   D7,Global_AllocBytesTotal(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.merge_next:
    ADD.L   D7,4(A3)
    TST.L   (A3)
    BEQ.S   .return_ok

    CMPA.L  (A3),A1
    BNE.S   .return_ok

    MOVE.L  4(A1),D0
    ADD.L   D0,4(A3)
    MOVE.L  (A1),(A3)

.return_ok:
    MOVEQ   #0,D0
    BRA.S   .return

.next_node:
    MOVE.L  A3,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L (A3),A3
    BRA.W   .scan_list

.append_tail:
    MOVEA.L -12(A5),A0
    MOVE.L  A2,(A0)
    CLR.L   (A2)
    MOVE.L  D7,4(A2)
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
