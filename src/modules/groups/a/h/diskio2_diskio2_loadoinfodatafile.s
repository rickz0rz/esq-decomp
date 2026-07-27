    XDEF    _DISKIO2_LoadOinfoDataFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadOinfoDataFile   (Read config file _CTASKS_PATH_OINFO_DAT.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +28: arg_3 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer, _DISKIO_ConsumeCStringFromWorkBuffer, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _CTASKS_PATH_OINFO_DAT, _TEXTDISP_PrimaryGroupCode
; WRITES:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr
; DESC:
;   Parses two strings from _CTASKS_PATH_OINFO_DAT and stores them in globals.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadOinfoDataFile:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A2,-(A7)
    SUBA.L  A0,A0
    PEA     _CTASKS_PATH_OINFO_DAT
    MOVE.L  A0,-8(A5)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04FB

    MOVEQ   #-1,D0
    BRA.W   .loc_04FE

.loc_04FB:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  _Global_PTR_WORK_BUFFER,-12(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVE.L  D1,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .loc_04FC

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVE.L  D0,-4(A5)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVE.L  D0,-8(A5)

.loc_04FC:
    MOVEA.W #$ffff,A0
    MOVEA.L -4(A5),A1
    CMPA.L  A1,A0
    BEQ.S   .loc_04FD

    MOVEA.L -8(A5),A2
    CMPA.L  A0,A2
    BEQ.S   .loc_04FD

    MOVE.L  _ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_ESQIFF_PrimaryLineHeadPtr
    MOVE.L  _ESQIFF_PrimaryLineTailPtr,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_PrimaryLineTailPtr

.loc_04FD:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1191.W
    PEA     _Global_STR_DISKIO2_C_23
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.loc_04FE:
    MOVEM.L -32(A5),D6-D7/A2
    UNLK    A5
    RTS

;!======