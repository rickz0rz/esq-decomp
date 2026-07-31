    XDEF    GCOMMAND_ExpandPresetBlock
    XDEF    _GCOMMAND_InitPresetTableFromPalette
    XDEF    GCOMMAND_SetPresetEntry
    XDEF    GCOMMAND_ValidatePresetTable
    XDEF    GCOMMAND_ExpandPresetBlock_Return
    XDEF    GCOMMAND_InitPresetTableFromPalette_Return
    XDEF    GCOMMAND_SetPresetEntry_Return
    XDEF    GCOMMAND_ValidatePresetTable_Return


    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  A3,-(A7)
    PEA     GCOMMAND_FMT_PCT_S_COLON
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     GCOMMAND_STR_GRADIENT
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D7

.lab_0D6F:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .lab_0D72

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D7,-(A7)
    PEA     GCOMMAND_FMT_COLOR_PCT_D_PCT_D
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D6

.lab_0D70:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   .lab_0D71

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  32(A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    PEA     GCOMMAND_FMT_PCT_D_PCT_03X
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    BRA.S   .lab_0D70

.lab_0D71:
    ADDQ.L  #1,D7
    BRA.S   .lab_0D6F

.lab_0D72:
    PEA     GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SetPresetEntry   (Update the preset table entry for row D7 with the supplied value D6.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   GCOMMAND_PresetValueTable
; WRITES:
;   (none observed)
; DESC:
;   Update the preset table entry for row D7 with the supplied value D6.
; NOTES:
;   Guarded to rows `1..15` and values `0..$0FFF`.
;------------------------------------------------------------------------------

; Update the preset table entry for row D7 with the supplied value D6.
GCOMMAND_SetPresetEntry:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6
    TST.L   D7
    BLE.S   GCOMMAND_SetPresetEntry_Return

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_SetPresetEntry_Return

    TST.L   D6
    BMI.S   GCOMMAND_SetPresetEntry_Return

    CMPI.L  #$1000,D6
    BGE.S   GCOMMAND_SetPresetEntry_Return

    MOVE.L  D7,D0
    ASL.L   #7,D0
    LEA     GCOMMAND_PresetValueTable,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,(A0)

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SetPresetEntry_Return   (Routine at GCOMMAND_SetPresetEntry_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
GCOMMAND_SetPresetEntry_Return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ExpandPresetBlock   (Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.
; NOTES:
;   Treats high/low nibbles as decimal digits per byte to build row values.
;------------------------------------------------------------------------------
GCOMMAND_ExpandPresetBlock:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #4,D7

.lab_0D76:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_ExpandPresetBlock_Return

    MOVEQ   #0,D5
    MOVEQ   #0,D6

.lab_0D77:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.S   .lab_0D78

    MOVE.L  D7,D1
    LSL.L   #2,D1
    SUB.L   D7,D1
    ADD.L   D6,D1
    MOVEQ   #2,D0
    SUB.L   D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D2
    MOVE.B  0(A3,D1.L),D2
    ASL.L   D0,D2
    MOVEQ   #15,D1
    ASL.L   D0,D1
    AND.L   D1,D2
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    ADD.L   D2,D0
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_0D77

.lab_0D78:
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .lab_0D76

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ExpandPresetBlock_Return   (Routine at GCOMMAND_ExpandPresetBlock_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
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
GCOMMAND_ExpandPresetBlock_Return:
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ValidatePresetTable   (Validate preset table and repair from defaults)
; ARGS:
;   stack +4: presetTable (base pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1, A3, A6
; CALLS:
;   GCOMMAND_UpdateBannerBounds, _LVODisable, _LVOEnable
; READS:
;   [presetTable], _GCOMMAND_DefaultPresetTable
; WRITES:
;   _GCOMMAND_PresetWorkResetPendingFlag, _GCOMMAND_DefaultPresetTable
; DESC:
;   Validates preset table values and, if needed, copies defaults and resets
;   associated state.
; NOTES:
;   Value ranges are inferred (1..$40 and 0..$1000 checks).
;------------------------------------------------------------------------------
GCOMMAND_ValidatePresetTable:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #1,D5
    MOVEQ   #0,D7

.lab_0D7B:
    TST.L   D5
    BEQ.S   .lab_0D82

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .lab_0D82

    MOVE.L  D7,D0
    ADD.L   D0,D0
    CMPI.W  #1,0(A3,D0.L)
    BLE.S   .lab_0D7C

    CMPI.W  #$40,0(A3,D0.L)
    BGT.S   .lab_0D7C

    MOVEQ   #1,D0
    BRA.S   .lab_0D7D

.lab_0D7C:
    MOVEQ   #0,D0

.lab_0D7D:
    MOVE.L  D0,D5
    MOVEQ   #0,D6

.lab_0D7E:
    TST.L   D5
    BEQ.S   .lab_0D81

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   .lab_0D81

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D1
    ADD.L   D1,D1
    ADDA.L  D1,A0
    CMPI.W  #0,32(A0)
    BCS.S   .lab_0D7F

    MOVEA.L A3,A0
    ADDA.L  D0,A0
    ADDA.L  D1,A0
    CMPI.W  #$1000,32(A0)
    BCC.S   .lab_0D7F

    MOVEQ   #1,D0
    BRA.S   .lab_0D80

.lab_0D7F:
    MOVEQ   #0,D0

.lab_0D80:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_0D7E

.lab_0D81:
    ADDQ.L  #1,D7
    BRA.S   .lab_0D7B

.lab_0D82:
    TST.L   D5
    BEQ.S   GCOMMAND_ValidatePresetTable_Return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEA.L A3,A0
    LEA     _GCOMMAND_DefaultPresetTable,A1
    MOVE.L  #$820,D0
    JSR     _LVOCopyMem(A6)

    MOVE.W  #1,_GCOMMAND_PresetWorkResetPendingFlag
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_UpdateBannerBounds

    LEA     16(A7),A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ValidatePresetTable_Return   (Routine at GCOMMAND_ValidatePresetTable_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
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
GCOMMAND_ValidatePresetTable_Return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_InitPresetTableFromPalette   (InitPresetTableFromPalette)
; ARGS:
;   stack +4: presetTable (base pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   GCOMMAND_PresetSeedPackedWordTable
; WRITES:
;   [presetTable]
; DESC:
;   Fills preset table entries using seed words in GCOMMAND_PresetSeedPackedWordTable.
; NOTES:
;   Table layout used here is:
;     presetTable + (row*2)                      = rowCount (initialized to 16)
;     presetTable + 32 + (row*128) + (col*2)     = value word
;   with row in 0..15 and col in 0..15 for this initializer pass.
;   Source lookup uses GCOMMAND_PresetSeedPackedWordTable with base index (row*62)+col.
;   The destination table can be either _GCOMMAND_DefaultPresetTable or
;   _GCOMMAND_GradientPresetTable (parse-time staging path).
;------------------------------------------------------------------------------
_GCOMMAND_InitPresetTableFromPalette:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVEQ   #0,D7

.lab_0D85:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_InitPresetTableFromPalette_Return

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  #16,0(A3,D0.L)
    MOVEQ   #0,D6

.lab_0D86:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   .lab_0D87

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.L  D0,16(A7)
    MOVE.L  D7,D0
    MOVEQ   #62,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    LEA     GCOMMAND_PresetSeedPackedWordTable,A1
    ADDA.L  D0,A1
    MOVE.L  16(A7),D0
    ADDA.L  D0,A1
    MOVE.W  (A1),32(A0)
    ADDQ.L  #1,D6
    BRA.S   .lab_0D86

.lab_0D87:
    ADDQ.L  #1,D7
    BRA.S   .lab_0D85

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_InitPresetTableFromPalette_Return   (Routine at GCOMMAND_InitPresetTableFromPalette_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
GCOMMAND_InitPresetTableFromPalette_Return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======