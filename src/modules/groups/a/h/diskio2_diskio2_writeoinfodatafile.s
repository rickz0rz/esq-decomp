    XDEF    _DISKIO2_WriteOinfoDataFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_WriteOinfoDataFile   (Write small config file _CTASKS_PATH_OINFO_DAT.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   _TEXTDISP_PrimaryGroupCode, _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr
; WRITES:
;   _DISKIO2_OinfoFileHandle
; DESC:
;   Opens _CTASKS_PATH_OINFO_DAT and writes two optional strings plus a header byte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_WriteOinfoDataFile:
    LINK.W  A5,#-8
    PEA     MODE_NEWFILE.W
    PEA     _CTASKS_PATH_OINFO_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_OinfoFileHandle
    TST.L   D0
    BNE.S   .loc_04F2

    MOVEQ   #-1,D0
    BRA.W   .loc_04F9

.loc_04F2:
    CLR.B   -5(A5)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    TST.L   _ESQIFF_PrimaryLineHeadPtr
    BNE.S   .loc_04F3

    LEA     -5(A5),A0
    BRA.S   .loc_04F4

.loc_04F3:
    MOVEA.L _ESQIFF_PrimaryLineHeadPtr,A0

.loc_04F4:
    MOVEA.L A0,A1

    ; Write first optional string.
.loc_04F5:
    TST.B   (A1)+
    BNE.S   .loc_04F5

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   _ESQIFF_PrimaryLineTailPtr
    BNE.S   .loc_04F6

    LEA     -5(A5),A0
    BRA.S   .loc_04F7

.loc_04F6:
    MOVEA.L _ESQIFF_PrimaryLineTailPtr,A0

.loc_04F7:
    MOVEA.L A0,A1

    ; Write second optional string.
.loc_04F8:
    TST.B   (A1)+
    BNE.S   .loc_04F8

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  _DISKIO2_OinfoFileHandle,(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #0,D0

.loc_04F9:
    UNLK    A5
    RTS

;!======