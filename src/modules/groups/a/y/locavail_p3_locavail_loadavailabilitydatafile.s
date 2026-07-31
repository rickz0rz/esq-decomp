    XDEF    _LOCAVAIL_LoadAvailabilityDataFile
    XDEF    LOCAVAIL_LoadAvailabilityDataFile_Return


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_LoadAvailabilityDataFile   (Routine at _LOCAVAIL_LoadAvailabilityDataFile)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +40: arg_7 (via 44(A5))
;   stack +44: arg_8 (via 48(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer, _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer, _GROUP_AY_JMPTBL_STRING_CompareNoCaseN, _LOCAVAIL_ResetFilterStateStruct, _LOCAVAIL_CopyFilterStateStructRetainRefs, _LOCAVAIL_AllocNodeArraysForState, _LOCAVAIL_FreeResourceChain, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_STR_LOCAVAIL_C_7, _Global_STR_LOCAVAIL_C_8, _LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load, _LOCAVAIL_STR_LA_VER, _Global_PTR_WORK_BUFFER, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, MEMF_CLEAR, MEMF_PUBLIC, e11, ffff, lab_0F5E, lab_0F5F, lab_0F60, lab_0F67, lab_0F68, lab_0F69, lab_0F6A, lab_0F6B, lab_0F6C, lab_0F6D, lab_0F6E, lab_0F73, lab_0F74
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_LoadAvailabilityDataFile:
    LINK.W  A5,#-52
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    CLR.L   -48(A5)
    MOVEQ   #0,D4
    PEA     _LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .lab_0F74

    MOVE.L  A3,-(A7)
    BSR.W   _LOCAVAIL_FreeResourceChain

    MOVE.B  _TEXTDISP_PrimaryGroupCode,(A3)
    MOVE.L  A2,(A7)
    BSR.W   _LOCAVAIL_FreeResourceChain

    MOVE.B  _TEXTDISP_SecondaryGroupCode,(A2)
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D4
    MOVE.L  _Global_PTR_WORK_BUFFER,-48(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.S   .lab_0F5E

    CLR.L   -44(A5)

.lab_0F5E:
    TST.L   D5
    BEQ.W   .lab_0F73

    TST.L   -44(A5)
    BEQ.W   .lab_0F73

    PEA     6.W
    PEA     _LOCAVAIL_STR_LA_VER
    MOVE.L  -44(A5),-(A7)
    JSR     _GROUP_AY_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .lab_0F73

    PEA     -24(A5)
    BSR.W   _LOCAVAIL_ResetFilterStateStruct

    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,-24(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D0,-22(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    MOVE.B  D1,-18(A5)
    PEA     -24(A5)
    MOVE.L  D0,-44(A5)
    BSR.W   _LOCAVAIL_AllocNodeArraysForState

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F6D

    MOVEQ   #0,D7

.lab_0F5F:
    TST.L   D5
    BEQ.W   .lab_0F6E

    CMP.L   -22(A5),D7
    BGE.W   .lab_0F6E

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-28(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_0F6B

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   .lab_0F6B

    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    TST.W   D0
    BLE.W   .lab_0F6A

    CMPI.W  #$e11,D0
    BGE.W   .lab_0F6A

    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   .lab_0F69

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   .lab_0F69

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     786.W
    PEA     _Global_STR_LOCAVAIL_C_7
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   .lab_0F68

    JSR     _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BEQ.W   .lab_0F67

    MOVEQ   #0,D6

.lab_0F60:
    TST.L   D5
    BEQ.W   .lab_0F6C

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   .lab_0F6C

    MOVEA.L -44(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    MOVE.L  A0,-44(A5)
    SUBI.W  #$47,D0
    BEQ.S   .lab_0F61

    SUBQ.W  #2,D0
    BEQ.S   .lab_0F63

    SUBI.W  #11,D0
    BEQ.S   .lab_0F62

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F64

    SUBQ.W  #1,D0
    BNE.S   .lab_0F65

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   .lab_0F66

.lab_0F61:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   .lab_0F66

.lab_0F62:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   .lab_0F66

.lab_0F63:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   .lab_0F66

.lab_0F64:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   .lab_0F66

.lab_0F65:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.lab_0F66:
    ADDQ.L  #1,D6
    BRA.W   .lab_0F60

.lab_0F67:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F68:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F69:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F6A:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F6B:
    MOVEQ   #0,D5

.lab_0F6C:
    ADDQ.L  #1,D7
    BRA.W   .lab_0F5F

.lab_0F6D:
    TST.L   -22(A5)
    BEQ.S   .lab_0F6E

    MOVEQ   #0,D5

.lab_0F6E:
    TST.L   D5
    BEQ.S   .lab_0F71

    MOVE.B  -24(A5),D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F6F

    PEA     -24(A5)
    MOVE.L  A3,-(A7)
    BSR.W   _LOCAVAIL_CopyFilterStateStructRetainRefs

    ADDQ.W  #8,A7
    BRA.S   .lab_0F72

.lab_0F6F:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F70

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_CopyFilterStateStructRetainRefs

    ADDQ.W  #8,A7
    BRA.S   .lab_0F72

.lab_0F70:
    PEA     -24(A5)
    BSR.W   _LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    BRA.S   .lab_0F72

.lab_0F71:
    PEA     -24(A5)
    BSR.W   _LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7

.lab_0F72:
    JSR     _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.W   .lab_0F5E

    CLR.L   -44(A5)
    BRA.W   .lab_0F5E

.lab_0F73:
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     897.W
    PEA     _Global_STR_LOCAVAIL_C_8
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.S   LOCAVAIL_LoadAvailabilityDataFile_Return

.lab_0F74:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  (A3),D1
    CMP.B   D0,D1
    BEQ.S   .branch

    MOVE.L  A3,-(A7)
    BSR.W   _LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,(A3)

.branch:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  (A2),D1
    CMP.B   D0,D1
    BEQ.S   .branch_1

    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    MOVE.B  _TEXTDISP_SecondaryGroupCode,(A2)

.branch_1:
    MOVEQ   #0,D5

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_LoadAvailabilityDataFile_Return   (Routine at LOCAVAIL_LoadAvailabilityDataFile_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_LoadAvailabilityDataFile_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======