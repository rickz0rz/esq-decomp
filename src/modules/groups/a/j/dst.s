;------------------------------------------------------------------------------
; FUNC: LAB_0613   (Free banner buffers and container??)
; ARGS:
;   stack +4: struct* ?? (A3)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A3 ??
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   (A3), 4(A3)
; WRITES:
;   ??
; DESC:
;   Frees the buffers referenced by the struct and then the struct itself.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0613:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    ; Free primary banner buffer if present.
    TST.L   (A3)
    BEQ.S   .free_slot1

    PEA     22.W
    MOVE.L  (A3),-(A7)
    PEA     773.W
    PEA     GLOB_STR_DST_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_slot1:
    ; Free secondary banner buffer if present.
    TST.L   4(A3)
    BEQ.S   .free_struct

    PEA     22.W
    MOVE.L  4(A3),-(A7)
    PEA     777.W
    PEA     GLOB_STR_DST_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_struct:
    ; Free the container struct.
    PEA     18.W
    MOVE.L  A3,-(A7)
    PEA     779.W
    PEA     GLOB_STR_DST_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0617   (Free both buffers referenced by the banner struct.)
; ARGS:
;   stack +4: struct* ?? (A3)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A3 ??
; CALLS:
;   LAB_0613
; READS:
;   (A3), 4(A3)
; WRITES:
;   (A3), 4(A3)
; DESC:
;   Frees both buffer pointers in the struct and clears them.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0617:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Free both buffers referenced by the struct.
    MOVE.L  (A3),-(A7)
    BSR.S   LAB_0613

    CLR.L   (A3)
    MOVE.L  4(A3),(A7)
    BSR.S   LAB_0613

    ADDQ.W  #4,A7
    CLR.L   4(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0618   (Allocate banner struct and buffers.)
; ARGS:
;   stack +4: struct* ?? (A3) (existing, may be freed)
; RET:
;   D0: struct* ?? (or 0 on failure)
; CLOBBERS:
;   D0/D7/A3 ??
; CALLS:
;   LAB_0613, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   ??
; WRITES:
;   (A3), 4(A3), 16(A3)
; DESC:
;   Frees any existing buffers, allocates a new struct and two buffers.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0618:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Tear down existing buffers, then allocate fresh struct+buffers.
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0613

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     18.W                            ; What's 18 bytes big?
    PEA     798.W
    PEA     GLOB_STR_DST_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     803.W
    PEA     GLOB_STR_DST_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     807.W
    PEA     GLOB_STR_DST_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,4(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVEQ   #1,D7
    CLR.W   16(A3)

.alloc_failed:
    ; Allocation failed: free any partial state.
    TST.L   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0613

    ADDQ.W  #4,A7

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_061B   (Rebuild banner buffers in-place.)
; ARGS:
;   stack +4: struct* ?? (A3)
; RET:
;   D0: success flag (0/1?)
; CLOBBERS:
;   D0/D7/A3 ??
; CALLS:
;   LAB_0617, LAB_0618
; READS:
;   (A3), 4(A3)
; WRITES:
;   (A3), 4(A3)
; DESC:
;   Frees and re-allocates the banner buffers referenced by the struct.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_061B:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Rebuild banner buffers in-place.
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0617

    MOVE.L  (A3),(A7)
    BSR.W   LAB_0618

    ADDQ.W  #4,A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_0618

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    TST.L   (A3)
    BEQ.S   .alloc_failed

    MOVEQ   #1,D7

.alloc_failed:
    TST.W   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0617

    ADDQ.W  #4,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_061E   (Load G2/G3 banner fragments into buffers and refresh queue.)
; ARGS:
;   stack +4: struct* ?? (A3)
; RET:
;   D0: 1 on success, 0 on failure
; CLOBBERS:
;   D0/D7/A3 ??
; CALLS:
;   LAB_061B, LAB_03AC, LAB_066C, LAB_05FC, LAB_05F8, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, DST_UpdateBannerQueue
; READS:
;   LAB_1CF7, GLOB_STR_G2, GLOB_STR_G3
; WRITES:
;   (A3), 4(A3)
; DESC:
;   Clears buffers, loads G2/G3 fragments, and updates the banner queue.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_061E:
    LINK.W  A5,#-56
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    ; Reset buffers and load G2/G3 banner fragments.
    MOVE.L  A3,-(A7)
    BSR.S   LAB_061B

    MOVE.L  LAB_1CF7,(A7)
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .init_ok

    MOVEQ   #0,D0
    BRA.W   .return

.init_ok:
    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    PEA     GLOB_STR_G2
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-48(A5)
    JSR     LAB_066C(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g2

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7

.skip_g2:
    PEA     GLOB_STR_G3
    MOVE.L  -48(A5),-(A7)
    JSR     LAB_066C(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g3

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  (A3),-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7

.skip_g3:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     889.W
    PEA     GLOB_STR_DST_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVE.L  A3,(A7)
    BSR.W   DST_UpdateBannerQueue

    MOVEQ   #1,D0

.return:
    MOVEM.L -64(A5),D7/A3
    UNLK    A5
    RTS
