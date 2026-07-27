    XDEF    _SCRIPT_DeallocateBufferArray


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DeallocateBufferArray   (DeallocateBufferArrayuncertain)
; ARGS:
;   stack +4: outPtrs (array of long pointers)
;   stack +8: byteSize
;   stack +12: count
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   outPtrs[0..count-1]
; WRITES:
;   outPtrs[0..count-1] (cleared)
; DESC:
;   Deallocates count blocks of byteSize and clears the pointer slots.
; NOTES:
;   Tags deallocations with SCRIPT.C metadata.
;------------------------------------------------------------------------------
_SCRIPT_DeallocateBufferArray:
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
    PEA     _Global_STR_SCRIPT_C_2
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

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