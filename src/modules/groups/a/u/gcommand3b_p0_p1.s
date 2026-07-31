    XDEF    _GCOMMAND_InitPresetTableFromPalette
    XDEF    GCOMMAND_InitPresetTableFromPalette_Return

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
;   _GCOMMAND_PresetSeedPackedWordTable
; WRITES:
;   [presetTable]
; DESC:
;   Fills preset table entries using seed words in _GCOMMAND_PresetSeedPackedWordTable.
; NOTES:
;   Table layout used here is:
;     presetTable + (row*2)                      = rowCount (initialized to 16)
;     presetTable + 32 + (row*128) + (col*2)     = value word
;   with row in 0..15 and col in 0..15 for this initializer pass.
;   Source lookup uses _GCOMMAND_PresetSeedPackedWordTable with base index (row*62)+col.
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

    LEA     _GCOMMAND_PresetSeedPackedWordTable,A1
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