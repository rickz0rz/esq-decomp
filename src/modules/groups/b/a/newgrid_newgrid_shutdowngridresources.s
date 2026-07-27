    XDEF    _NEWGRID_ShutdownGridResources


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ShutdownGridResources   (Free grid rastports and reset state)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A0/A6
; CALLS:
;   _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _NEWGRID2_FreeBuffersIfAllocated, _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers, _NEWGRID_ResetShowtimeBuckets
; READS:
;   _NEWGRID_MainRastPortPtr
; WRITES:
;   _NEWGRID_MainRastPortPtr, _NEWGRID_GridResourcesInitializedFlag
; DESC:
;   Frees the grid rastport allocation and resets grid state flags.
; NOTES:
;   Always clears _NEWGRID_GridResourcesInitializedFlag and triggers dependent cleanup routines.
;------------------------------------------------------------------------------
_NEWGRID_ShutdownGridResources:
    TST.L   _NEWGRID_MainRastPortPtr
    BEQ.S   .skip_free

    PEA     100.W
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    PEA     148.W
    PEA     _Global_STR_NEWGRID_C_3
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.skip_free:
    JSR     _NEWGRID2_FreeBuffersIfAllocated(PC)

    JSR     _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(PC)

    CLR.W   _NEWGRID_GridResourcesInitializedFlag
    JSR     _NEWGRID_ResetShowtimeBuckets(PC)

    RTS

;!======