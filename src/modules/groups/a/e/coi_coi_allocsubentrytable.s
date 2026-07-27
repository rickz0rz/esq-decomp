    XDEF    _COI_AllocSubEntryTable


;------------------------------------------------------------------------------
; FUNC: _COI_AllocSubEntryTable   (AllocSubEntryTableuncertain)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   D0: subentry table pointer (or 0 if none/failed)
; CLOBBERS:
;   D0-D1/A0-A3
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray
; READS:
;   _Global_STR_COI_C_5, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A0+38 (subentry table pointer)
; DESC:
;   Allocates and initializes a cleared longword table for subentries when the
;   entry's count field is positive.
; NOTES:
;   Table size is `count * 4` bytes; _GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray initializes the table entries.
;------------------------------------------------------------------------------
_COI_AllocSubEntryTable:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .null_parent

    MOVEA.L 48(A3),A0
    BRA.S   .have_anim_ptr

.null_parent:
    SUBA.L  A0,A0

.have_anim_ptr:
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return_status

    MOVE.W  36(A0),D0
    TST.W   D0
    BLE.S   .return_status

    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1123.W
    PEA     _Global_STR_COI_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,38(A0)
    MOVE.W  36(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    PEA     30.W
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(PC)

    LEA     24(A7),A7

.return_status:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======