    XDEF    LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    LOCAVAIL_LoadAvailabilityDataFile
    XDEF    _LOCAVAIL_SaveAvailabilityDataFile
    XDEF    LOCAVAIL_ComputeFilterOffsetForEntry_Return
    XDEF    LOCAVAIL_LoadAvailabilityDataFile_Return
    XDEF    LOCAVAIL_SaveAvailabilityDataFile_Return


;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ComputeFilterOffsetForEntry   (Routine at LOCAVAIL_ComputeFilterOffsetForEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +24: arg_5 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask, LOCAVAIL_MapFilterTokenCharToClass, _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_ComputeFilterOffsetForEntry_Return, _ESQIFF_GAdsBrushListCount, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _LOCAVAIL_FilterStep, LOCAVAIL_FilterPrevClassId, LOCAVAIL_STR_YYLLZ_FilterGateCheck, WDISP_HighlightActive, lab_0F3E, lab_0F43, lab_0F4B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_ComputeFilterOffsetForEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    CLR.L   -28(A5)
    MOVE.L  D0,-20(A5)
    TST.L   _LOCAVAIL_FilterStep
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    CMP.L   LOCAVAIL_FilterPrevClassId,D0
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    MOVEQ   #0,D7

.lab_0F3E:
    TST.B   (A3)
    BEQ.W   .lab_0F43

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LOCAVAIL_MapFilterTokenCharToClass

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D6

.lab_0F3F:
    TST.L   D5
    BEQ.S   .lab_0F41

    CMP.L   2(A2),D6
    BGE.S   .lab_0F41

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    CMP.L   D1,D0
    BNE.S   .lab_0F40

    MOVE.L  6(A0),-28(A5)
    MOVE.L  A0,-24(A5)
    BRA.S   .lab_0F41

.lab_0F40:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F3F

.lab_0F41:
    TST.L   D5
    BEQ.S   .lab_0F42

    TST.L   -24(A5)
    BEQ.S   .lab_0F42

    SUBQ.L  #1,D5
    MOVEA.L -24(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D5
    BGE.S   .lab_0F42

    MOVEA.L -28(A5),A0
    TST.B   0(A0,D5.L)
    BEQ.S   .lab_0F42

    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .lab_0F43

    CMP.L   -20(A5),D0
    BNE.S   .lab_0F43

    MOVE.L  D6,D4
    MOVE.L  D5,-20(A5)
    BRA.S   .lab_0F43

.lab_0F42:
    ADDQ.L  #1,D7
    ADDQ.L  #1,A3
    BRA.W   .lab_0F3E

.lab_0F43:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BEQ.W   .lab_0F4B

    MOVE.L  -20(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .lab_0F4B

    MOVE.L  D4,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVEA.L 6(A0),A1
    MOVEQ   #0,D0
    MOVE.L  -20(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-24(A5)
    MOVE.L  A1,-28(A5)
    SUBQ.W  #1,D0
    BEQ.S   .lab_0F44

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F46

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F48

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F49

    BRA.S   .lab_0F4A

.lab_0F44:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_STR_YYLLZ_FilterGateCheck
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0F45

    JSR     GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BNE.S   .lab_0F4B

.lab_0F45:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F46:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F47

    TST.L   _ESQIFF_GAdsBrushListCount
    BNE.S   .lab_0F4B

.lab_0F47:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F48:
    TST.W   WDISP_HighlightActive
    BNE.S   .lab_0F4B

    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F49:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F4A:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)

.lab_0F4B:
    MOVE.L  D4,8(A2)
    MOVE.L  -20(A5),12(A2)

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ComputeFilterOffsetForEntry_Return   (Return tail for filter-offset computation)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for early-reject and computed-offset paths.
;------------------------------------------------------------------------------
LOCAVAIL_ComputeFilterOffsetForEntry_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_SaveAvailabilityDataFile   (Routine at _LOCAVAIL_SaveAvailabilityDataFile)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +143: arg_3 (via 147(A5))
;   stack +144: arg_4 (via 148(A5))
;   stack +150: arg_5 (via 154(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, GROUP_AY_JMPTBL_DISKIO_WriteDecimalField, _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_TAG_UVGTI, LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save, LOCAVAIL_STR_LA_VER_1_COLON_CURDAY, LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY, MODE_NEWFILE, lab_0F4E, lab_0F4F, lab_0F52, lab_0F54, lab_0F54_0008, lab_0F5A, lab_0F5B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_SaveAvailabilityDataFile:
    LINK.W  A5,#-160
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    LEA     LOCAVAIL_TAG_UVGTI,A0
    LEA     -154(A5),A1
    MOVEQ   #5,D0

.lab_0F4E:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.lab_0F4E
    PEA     MODE_NEWFILE.W
    PEA     LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BEQ.W   .lab_0F5B

    MOVE.L  A3,-4(A5)
    LEA     LOCAVAIL_STR_LA_VER_1_COLON_CURDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)

.lab_0F4F:
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F50:
    TST.B   (A1)+
    BNE.S   .lab_0F50

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  2(A0),(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    MOVE.B  D0,-148(A5)
    CLR.B   -147(A5)
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F51:
    TST.B   (A1)+
    BNE.S   .lab_0F51

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

.lab_0F52:
    MOVEA.L -4(A5),A0
    CMP.L   2(A0),D7
    BGE.W   .lab_0F5A

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A1
    MOVEA.L 20(A1),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

.lab_0F53:
    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.S   .lab_0F58

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    CMPI.W  #5,D0
    BCC.S   .lab_0F56

    ADD.W   D0,D0
    MOVE.W  .lab_0F54(PC,D0.W),D0
    JMP     .lab_0F54+2(PC,D0.W)

; switch/jumptable
.lab_0F54:
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2

.lab_0F54_0008:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVEA.L -8(A5),A6
    MOVEA.L 6(A6),A1
    ADDA.L  D6,A1
    MOVEQ   #0,D0
    MOVE.B  (A1),D0
    LEA     -154(A5),A1
    ADDA.W  D0,A1
    MOVE.B  (A1),(A0)
    BRA.S   .lab_0F57

.lab_0F56:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVE.B  -154(A5),(A0)

.lab_0F57:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F53

.lab_0F58:
    LEA     -148(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    CLR.B   (A1)
    MOVEA.L A0,A1

.lab_0F59:
    TST.B   (A1)+
    BNE.S   .lab_0F59

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .lab_0F52

.lab_0F5A:
    MOVE.L  A2,-4(A5)
    SUBA.L  A2,A2
    LEA     LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)
    TST.L   -4(A5)
    BNE.W   .lab_0F4F

    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    ADDQ.W  #4,A7
    BRA.S   LOCAVAIL_SaveAvailabilityDataFile_Return

.lab_0F5B:
    MOVEQ   #0,D5

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SaveAvailabilityDataFile_Return   (Routine at LOCAVAIL_SaveAvailabilityDataFile_Return)
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
LOCAVAIL_SaveAvailabilityDataFile_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_LoadAvailabilityDataFile   (Routine at LOCAVAIL_LoadAvailabilityDataFile)
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
;   _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer, GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer, GROUP_AY_JMPTBL_STRING_CompareNoCaseN, _LOCAVAIL_ResetFilterStateStruct, _LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_AllocNodeArraysForState, _LOCAVAIL_FreeResourceChain, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, Global_STR_LOCAVAIL_C_7, Global_STR_LOCAVAIL_C_8, LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load, LOCAVAIL_STR_LA_VER, _Global_PTR_WORK_BUFFER, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, MEMF_CLEAR, MEMF_PUBLIC, e11, ffff, lab_0F5E, lab_0F5F, lab_0F60, lab_0F67, lab_0F68, lab_0F69, lab_0F6A, lab_0F6B, lab_0F6C, lab_0F6D, lab_0F6E, lab_0F73, lab_0F74
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_LoadAvailabilityDataFile:
    LINK.W  A5,#-52
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    CLR.L   -48(A5)
    MOVEQ   #0,D4
    PEA     LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load
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
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

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
    PEA     LOCAVAIL_STR_LA_VER
    MOVE.L  -44(A5),-(A7)
    JSR     GROUP_AY_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .lab_0F73

    PEA     -24(A5)
    BSR.W   _LOCAVAIL_ResetFilterStateStruct

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,-24(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D0,-22(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    MOVE.B  D1,-18(A5)
    PEA     -24(A5)
    MOVE.L  D0,-44(A5)
    BSR.W   LOCAVAIL_AllocNodeArraysForState

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
    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_0F6B

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   .lab_0F6B

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    TST.W   D0
    BLE.W   .lab_0F6A

    CMPI.W  #$e11,D0
    BGE.W   .lab_0F6A

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

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
    PEA     Global_STR_LOCAVAIL_C_7
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   .lab_0F68

    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

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
    PEA     Global_STR_LOCAVAIL_C_8
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