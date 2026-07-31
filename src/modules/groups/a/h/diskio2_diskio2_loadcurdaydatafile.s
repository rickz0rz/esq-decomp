    XDEF    _DISKIO2_LoadCurDayDataFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadCurDayDataFile   (Load disk data file and populate entry tables.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +24: arg_4 (via 28(A5))
;   stack +28: arg_5 (via 32(A5))
;   stack +32: arg_6 (via 36(A5))
;   stack +36: arg_7 (via 40(A5))
;   stack +37: arg_8 (via 41(A5))
;   stack +40: arg_9 (via 44(A5))
;   stack +61: arg_10 (via 65(A5))
;   stack +92: arg_11 (via 96(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer/03B2/03B6, _GROUP_AH_JMPTBL_ESQ_WildcardMatch,
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory, _GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults,
;   _COI_EnsureAnimObjectAllocated, _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, _GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket, _GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _ESQPARS_ReplaceOwnedString
; READS:
;   _CTASKS_PATH_CURDAY_DAT, _Global_PTR_WORK_BUFFER, _DISKIO_CurrentDriveRevisionIndex, _WDISP_WeatherStatusTextPtr, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryEntryPtrTable/2236
; WRITES:
;   _TEXTDISP_PrimaryGroupCode/2231/2238, _TEXTDISP_PrimaryGroupRecordChecksum/2248/224A-224C, _TEXTDISP_AliasPtrTable tables, _WDISP_WeatherStatusTextPtr
; DESC:
;   Parses the on-disk data file, allocates per-entry structures, and fills
;   the in-memory tables with parsed records.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadCurDayDataFile:
    LINK.W  A5,#-76
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D7

.loc_0498:
    MOVEQ   #21,D0
    CMP.W   D0,D7
    BGE.S   .loc_0499

    LEA     _ESQ_STR_B,A0
    ADDA.W  D7,A0
    MOVE.B  (A0),-65(A5,D7.W)
    ADDQ.W  #1,D7
    BRA.S   .loc_0498

.loc_0499:
    PEA     _CTASKS_PATH_CURDAY_DAT
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_049A

    CLR.W   _DST_PrimaryCountdown
    PEA     -65(A5)
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049A:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,-40(A5)
    MOVE.L  _Global_PTR_WORK_BUFFER,-16(A5)
    MOVEQ   #0,D7

    ; Consume header bytes into a local buffer.
.loc_049B:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BLE.S   .loc_049C

    MOVEQ   #21,D1
    CMP.W   D1,D7
    BGE.S   .loc_049C

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0)+,-65(A5,D7.W)
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    ADDQ.W  #1,D7
    BRA.S   .loc_049B

.loc_049C:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_DST_PrimaryCountdown
    PEA     -65(A5)
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(PC)

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_049D

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     520.W
    PEA     _Global_STR_DISKIO2_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049D:
    MOVEA.L D0,A0
    LEA     _DISKIO_ErrorMessageScratch,A1

    ; Copy NUL-terminated identifier string.
.loc_049E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_049E

    PEA     _DISKIO2_STR_DREV_1
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_049F

    MOVE.W  #1,_DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #40,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_049F:
    PEA     _DISKIO2_STR_DREV_2
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A0

    MOVE.W  #2,_DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #41,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_04A0:
    PEA     _DISKIO2_STR_DREV_3
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A1

    MOVE.W  #3,_DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #46,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A1:
    PEA     _DISKIO2_STR_DREV_4
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A2

    MOVE.W  #4,_DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A2:
    PEA     _DISKIO2_STR_DREV_5
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A3

    MOVE.W  #5,_DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A3:
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     561.W
    PEA     _Global_STR_DISKIO2_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A4:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A5

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     570.W
    PEA     _Global_STR_DISKIO2_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A5:
    MOVEA.L D0,A0
    LEA     _WDISP_WeatherStatusLabelBuffer,A1

.loc_04A6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04A6

    MOVE.W  _DISKIO_CurrentDriveRevisionIndex,D0
    TST.W   D0
    BLE.S   .loc_04A8

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A7

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     588.W
    PEA     _Global_STR_DISKIO2_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A7:
    MOVE.L  _WDISP_WeatherStatusTextPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_WDISP_WeatherStatusTextPtr

.loc_04A8:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  D1,-41(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04BC

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-44(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,_TEXTDISP_PrimaryGroupRecordChecksum
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_PrimaryGroupPresentFlag
    MOVE.W  #1,_TEXTDISP_GroupMutationState
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_MaxEntryTitleLength
    CLR.L   -36(A5)
    MOVE.L  D0,D7

.loc_04A9:
    ; Allocate and populate each entry record.
    CMP.W   -44(A5),D7
    BGE.W   .loc_04BD

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     634.W
    PEA     _Global_STR_DISKIO2_C_8
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04AA

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    BRA.W   .loc_04BD

.loc_04AA:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     640.W
    PEA     _Global_STR_DISKIO2_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04AB

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     644.W
    PEA     _Global_STR_DISKIO2_C_10
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04BD

.loc_04AB:
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(PC)

    MOVE.L  A3,(A7)
    JSR     _COI_EnsureAnimObjectAllocated(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04AC:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -32(A5),D0
    BGE.S   .loc_04AD

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04AC

.loc_04AD:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    LEA     1(A3),A0
    MOVEA.L A0,A1

.loc_04AE:
    TST.B   (A1)+
    BNE.S   .loc_04AE

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.W  _TEXTDISP_MaxEntryTitleLength,D0
    CMP.W   D0,D5
    BLE.S   .loc_04AF

    MOVE.W  D5,_TEXTDISP_MaxEntryTitleLength

.loc_04AF:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B0

    MOVE.L  A0,-36(A5)
    BRA.W   .loc_04BD

.loc_04B0:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04B1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04B1

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04B2:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04B9

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,_DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04B5

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04B3

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04B3:
    CMP.W   D0,D5
    BGE.S   .loc_04B4

    BRA.W   .loc_04B8

.loc_04B4:
    MOVE.W  #(-1),-28(A5)

.loc_04B5:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,7(A2,D5.W)
    CMPI.W  #1,_DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04B6

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

.loc_04B6:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B7

    MOVE.L  A0,-36(A5)
    BRA.S   .loc_04B9

.loc_04B7:
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
    BEQ.S   .loc_04B8

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04B8:
    ADDQ.W  #1,D5
    BRA.W   .loc_04B2

.loc_04B9:
    CMPI.W  #4,_DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04BA

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04BA

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04BA:
    MOVEQ   #-1,D0
    CMP.L   -36(A5),D0
    BNE.S   .loc_04BB

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     736.W
    PEA     _Global_STR_DISKIO2_C_11
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     737.W
    PEA     _Global_STR_DISKIO2_C_12
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04BD

.loc_04BB:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04A9

.loc_04BC:
    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)

.loc_04BD:
    MOVE.B  -41(A5),_TEXTDISP_PrimaryGroupHeaderCode
    MOVE.L  D7,D0
    MOVE.W  D0,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     764.W
    PEA     _Global_STR_DISKIO2_C_13
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -41(A5),D0
    MOVE.L  D0,(A7)
    JSR     _COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04BE

    MOVE.B  #$1,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  -41(A5),_CTASKS_PendingPrimaryOiDiskId
    BRA.S   .loc_04BF

.loc_04BE:
    MOVEQ   #0,D0
    MOVE.B  D0,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  D0,_CTASKS_PendingPrimaryOiDiskId

.loc_04BF:
    MOVE.L  -36(A5),D0

.loc_04C0:
    MOVEM.L -96(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======