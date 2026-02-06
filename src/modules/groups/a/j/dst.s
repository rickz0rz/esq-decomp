;------------------------------------------------------------------------------
; FUNC: DST_FreeBannerStruct   (Free banner struct and its two buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   A3+0/4 (buffer pointers)
; WRITES:
;   (none observed)
; DESC:
;   Frees the two buffers referenced by the banner struct, then the struct itself.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_FreeBannerStruct:
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
; FUNC: DST_FreeBannerPair   (Free both banner structs referenced by the pair.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7
; CALLS:
;   DST_FreeBannerStruct
; READS:
;   A3+0/4 (banner struct pointers)
; WRITES:
;   A3+0/4
; DESC:
;   Frees both banner structs referenced by the pair and clears the pointers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_FreeBannerPair:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Free both banner structs referenced by the pair.
    MOVE.L  (A3),-(A7)
    BSR.S   DST_FreeBannerStruct

    CLR.L   (A3)
    MOVE.L  4(A3),(A7)
    BSR.S   DST_FreeBannerStruct

    ADDQ.W  #4,A7
    CLR.L   4(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_AllocateBannerStruct   (Allocate banner struct and its buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   DST_FreeBannerStruct, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   GLOB_STR_DST_C_4, GLOB_STR_DST_C_5, GLOB_STR_DST_C_6, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A3+0/4/16 (buffer pointers, state)
; DESC:
;   Frees any existing banner struct, then allocates a new struct plus two buffers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_AllocateBannerStruct:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Tear down existing buffers, then allocate fresh struct+buffers.
    MOVE.L  A3,-(A7)
    BSR.W   DST_FreeBannerStruct

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
    BSR.W   DST_FreeBannerStruct

    ADDQ.W  #4,A7

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_RebuildBannerPair   (Rebuild both banner structs in the pair)
; ARGS:
;   (none observed)
; RET:
;   D0: success flag (0/1?)
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   DST_FreeBannerPair, DST_AllocateBannerStruct
; READS:
;   A3+0/4 (banner struct pointers)
; WRITES:
;   A3+0/4
; DESC:
;   Frees and re-allocates both banner structs referenced by the pair.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_RebuildBannerPair:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Rebuild both banner structs in-place.
    MOVE.L  A3,-(A7)
    BSR.W   DST_FreeBannerPair

    MOVE.L  (A3),(A7)
    BSR.W   DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  4(A3),-(A7)
    BSR.W   DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    TST.L   (A3)
    BEQ.S   .alloc_failed

    MOVEQ   #1,D7

.alloc_failed:
    TST.W   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   DST_FreeBannerPair

    ADDQ.W  #4,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_LoadBannerPairFromFiles   (Load G2/G3 banner fragments and refresh queue)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +18: arg_2 (via 22(A5))
;   stack +40: arg_3 (via 44(A5))
;   stack +44: arg_4 (via 48(A5))
;   stack +48: arg_5 (via 52(A5))
;   stack +60: arg_6 (via 64(A5))
; RET:
;   D0: 1 on success, 0 on failure
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   DST_RebuildBannerPair, DISKIO_LoadFileToWorkBuffer, GROUP_AJ_JMPTBL_STRING_FindSubstring, DATETIME_ParseString, DATETIME_CopyPairAndRecalc, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, DST_UpdateBannerQueue
; READS:
;   DATA_DST_CONST_LONG_1CF7, GLOB_STR_G2, GLOB_STR_G3
; WRITES:
;   (A3), 4(A3)
; DESC:
;   Rebuilds the pair, loads G2/G3 fragments, and updates the banner queue.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_LoadBannerPairFromFiles:
    LINK.W  A5,#-56
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    ; Reset buffers and load G2/G3 banner fragments.
    MOVE.L  A3,-(A7)
    BSR.S   DST_RebuildBannerPair

    MOVE.L  DATA_DST_CONST_LONG_1CF7,(A7)
    JSR     DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .init_ok

    MOVEQ   #0,D0
    BRA.W   .return

.init_ok:
    MOVEA.L GLOB_PTR_WORK_BUFFER,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    PEA     GLOB_STR_G2
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-48(A5)
    JSR     GROUP_AJ_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g2

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  4(A3),-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.skip_g2:
    PEA     GLOB_STR_G3
    MOVE.L  -48(A5),-(A7)
    JSR     GROUP_AJ_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   .skip_g3

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  (A3),-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

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
