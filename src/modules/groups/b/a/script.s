    XDEF    SCRIPT_AllocateBufferArray


;------------------------------------------------------------------------------
; FUNC: SCRIPT_AllocateBufferArray   (AllocateBufferArrayuncertain)
; ARGS:
;   stack +4: outPtrs (array of long pointers)
;   stack +8: byteSize
;   stack +12: count
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   _SCRIPT_JMPTBL_MEMORY_AllocateMemory
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
    PEA     Global_STR_SCRIPT_C_1
    MOVE.L  D0,32(A7)
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

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