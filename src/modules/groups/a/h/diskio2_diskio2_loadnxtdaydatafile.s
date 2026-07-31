    XDEF    _DISKIO2_LoadNxtDayDataFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadNxtDayDataFile   (Load NXTDAY.DAT and populate entry tables.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +24: arg_4 (via 28(A5))
;   stack +28: arg_5 (via 32(A5))
;   stack +32: arg_6 (via 36(A5))
;   stack +33: arg_7 (via 37(A5))
;   stack +36: arg_8 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer/03B2/03B6, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory,
;   _GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults, _COI_EnsureAnimObjectAllocated, _GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _COI_LoadOiDataFile
; READS:
;   _Global_STR_DF0_NXTDAY_DAT, _Global_PTR_WORK_BUFFER, _DISKIO_CurrentDriveRevisionIndex, _TEXTDISP_SecondaryGroupCode
; WRITES:
;   _TEXTDISP_SecondaryGroupCode/222F/222E, _TEXTDISP_SecondaryGroupRecordChecksum/224E, _TEXTDISP_SecondaryEntryPtrTable/2237, _TEXTDISP_SecondaryGroupHeaderCode, _CTASKS_SecondaryOiWritePendingFlag/1B92
; DESC:
;   Parses NXTDAY.DAT, allocates per-entry records, and fills in-memory tables.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadNxtDayDataFile:
    LINK.W  A5,#-48
    MOVEM.L D5-D7/A2-A3,-(A7)

    PEA     _Global_STR_DF0_NXTDAY_DAT
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04D1

    MOVEQ   #-1,D0
    BRA.W   .loc_04E5

.loc_04D1:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,-36(A5)
    MOVE.L  _Global_PTR_WORK_BUFFER,-16(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  D1,-37(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04E2

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-40(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,_TEXTDISP_SecondaryGroupRecordChecksum
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_SecondaryGroupPresentFlag
    CLR.L   -32(A5)
    MOVEQ   #0,D7

    ; Allocate and populate each entry record.
.loc_04D2:
    CMP.W   -40(A5),D7
    BGE.W   .loc_04E2

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     948.W
    PEA     _Global_STR_DISKIO2_C_17
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04D3

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D3:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     954.W
    PEA     _Global_STR_DISKIO2_C_18
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04D4

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     958.W
    PEA     _Global_STR_DISKIO2_C_19
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04E2

.loc_04D4:
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(PC)

    MOVE.L  A3,(A7)
    JSR     _COI_EnsureAnimObjectAllocated(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04D5:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BCC.S   .loc_04D6

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04D5

.loc_04D6:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04D7

    MOVE.L  A0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D7:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04D8:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04D8

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04D9:
    ; Per-slot parsing loop (flags + optional strings).
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04DF

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,_DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04DC

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04DA

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04DA:
    CMP.W   D0,D5
    BGE.S   .loc_04DB

    BRA.W   .loc_04DE

.loc_04DB:
    MOVE.W  #(-1),-28(A5)

.loc_04DC:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,7(A2,D5.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04DD

    MOVE.L  A0,-32(A5)
    BRA.S   .loc_04DF

.loc_04DD:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loc_04DE

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04DE:
    ADDQ.W  #1,D5
    BRA.W   .loc_04D9

.loc_04DF:
    CMPI.W  #4,_DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04E0

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04E0

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04E0:
    MOVEQ   #-1,D0
    CMP.L   -32(A5),D0
    BNE.S   .loc_04E1

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     1027.W
    PEA     _Global_STR_DISKIO2_C_20
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     1028.W
    PEA     _Global_STR_DISKIO2_C_21
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04E2

.loc_04E1:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04D2

.loc_04E2:
    MOVE.B  -37(A5),_TEXTDISP_SecondaryGroupHeaderCode
    MOVE.L  D7,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVE.L  -36(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1041.W
    PEA     _Global_STR_DISKIO2_C_22
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -37(A5),D0
    MOVE.L  D0,(A7)
    JSR     _COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04E3

    MOVE.B  #$1,_CTASKS_SecondaryOiWritePendingFlag
    MOVE.B  -37(A5),_CTASKS_PendingSecondaryOiDiskId
    BRA.S   .loc_04E4

.loc_04E3:
    MOVEQ   #0,D0
    MOVE.B  D0,_CTASKS_SecondaryOiWritePendingFlag
    MOVE.B  D0,_CTASKS_PendingSecondaryOiDiskId

.loc_04E4:
    MOVE.L  -32(A5),D0

.loc_04E5:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======