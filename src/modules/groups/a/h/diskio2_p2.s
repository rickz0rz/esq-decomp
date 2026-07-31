    XDEF    DISKIO2_FlushDataFilesIfNeeded


;------------------------------------------------------------------------------
; FUNC: DISKIO2_FlushDataFilesIfNeeded   (Flush disk data files if needed.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0
; CALLS:
;   _DISKIO2_WriteCurDayDataFile, _DISKIO2_WriteNxtDayDataFile, _DISKIO2_WriteOinfoDataFile, _COI_WriteOiDataFile
; READS:
;   DISKIO2_FlushDataFilesGuardFlag, _TEXTDISP_PrimaryGroupEntryCount, _CTASKS_PrimaryOiWritePendingFlag/1B90
; WRITES:
;   DISKIO2_FlushDataFilesGuardFlag
; DESC:
;   Guards against reentry and writes disk-related data files when eligible.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_FlushDataFilesIfNeeded:
    TST.W   DISKIO2_FlushDataFilesGuardFlag
    BNE.S   .loc_0538

    MOVE.W  #1,DISKIO2_FlushDataFilesGuardFlag
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMPI.W  #$c9,D0
    BCC.S   .loc_0537

    BSR.W   _DISKIO2_WriteCurDayDataFile

    BSR.W   _DISKIO2_WriteNxtDayDataFile

    BSR.W   _DISKIO2_WriteOinfoDataFile

    TST.B   _CTASKS_PrimaryOiWritePendingFlag
    BEQ.S   .loc_0536

    MOVEQ   #0,D0
    MOVE.B  _CTASKS_PendingPrimaryOiDiskId,D0
    MOVE.L  D0,-(A7)
    JSR     _COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0536:
    TST.B   _CTASKS_SecondaryOiWritePendingFlag
    BEQ.S   .loc_0537

    MOVEQ   #0,D0
    MOVE.B  _CTASKS_PendingSecondaryOiDiskId,D0
    MOVE.L  D0,-(A7)
    JSR     _COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0537:
    CLR.W   DISKIO2_FlushDataFilesGuardFlag

.loc_0538:
    RTS

;!======
