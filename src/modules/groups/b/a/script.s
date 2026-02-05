;------------------------------------------------------------------------------
; FUNC: SCRIPT_AllocateBufferArray   (AllocateBufferArray??)
; ARGS:
;   stack +4: outPtrs (array of long pointers)
;   stack +8: byteSize
;   stack +12: count
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   GROUPD_JMPTBL_MEMORY_AllocateMemory
; READS:
;   (none)
; WRITES:
;   outPtrs[0..count-1]
; DESC:
;   Allocates count blocks of byteSize and stores the pointers into outPtrs.
; NOTES:
;   Uses MEMF_PUBLIC+MEMF_CLEAR and tags allocations with SCRIPT.C metadata.
;------------------------------------------------------------------------------
SCRIPT_AllocateBufferArray:
LAB_1498:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStackAfterLink 4,4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.W  .stackOffsetBytes+10(A7),D7
    MOVE.W  .stackOffsetBytes+14(A7),D6
    MOVEQ   #0,D5

.alloc_loop:
    CMP.W   D6,D5
    BGE.S   .return

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D1,-(A7)
    PEA     394.W
    PEA     GLOB_STR_SCRIPT_C_1
    MOVE.L  D0,32(A7)
    JSR     GROUPD_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  16(A7),D1
    MOVE.L  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   .alloc_loop

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DeallocateBufferArray   (DeallocateBufferArray??)
; ARGS:
;   stack +4: outPtrs (array of long pointers)
;   stack +8: byteSize
;   stack +12: count
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   GROUPD_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   outPtrs[0..count-1]
; WRITES:
;   outPtrs[0..count-1] (cleared)
; DESC:
;   Deallocates count blocks of byteSize and clears the pointer slots.
; NOTES:
;   Tags deallocations with SCRIPT.C metadata.
;------------------------------------------------------------------------------
SCRIPT_DeallocateBufferArray:
LAB_149B:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6

    MOVEQ   #0,D5

.free_loop:
    CMP.W   D6,D5
    BGE.S   .return

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  0(A3,D0.L),-(A7)
    PEA     405.W
    PEA     GLOB_STR_SCRIPT_C_2
    JSR     GROUPD_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   0(A3,D0.L)
    ADDQ.W  #1,D5
    BRA.S   .free_loop

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_BuildTokenIndexMap   (BuildTokenIndexMap??)
; ARGS:
;   stack +8: inputBytes (byte array)
;   stack +12: outIndexByToken (word array)
;   stack +18: tokenCount
;   stack +20: tokenTable (byte array, length tokenCount)
;   stack +26: maxScanCount
;   stack +31: terminatorByte
;   stack +34: fillMissingFlag (non-zero = fill -1 entries)
; RET:
;   D0: scanIndex (byte position) ??
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
SCRIPT_BuildTokenIndexMap:
LAB_149E:
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

    ; Alignment
    RTS
    DC.W    $0000

;!======

GROUPD_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

GROUPD_JMPTBL_LAB_03A0:
    JMP     LAB_03A0

GROUPD_JMPTBL_LAB_039A:
    JMP     LAB_039A

GROUPD_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

GROUPD_JMPTBL_DISKIO_OpenFileWithBuffer:
    JMP     DISKIO_OpenFileWithBuffer

;======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000
