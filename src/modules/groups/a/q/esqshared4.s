    ; Dead code
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  DATA_WDISP_BSS_WORD_226D,D0
    JSR     ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,DATA_ESQPARS2_BSS_LONG_1F46
    MOVE.W  #0,DATA_ESQPARS2_BSS_WORD_1F3D
    MOVE.W  #0,DATA_ESQPARS2_BSS_LONG_1F3E
    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    JSR     ESQSHARED4_ApplyBannerColorStep

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    ; Dead code.
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  DATA_WDISP_BSS_WORD_226D,D0
    JSR     ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,DATA_ESQPARS2_BSS_LONG_1F46
    MOVE.W  #1,DATA_ESQPARS2_BSS_WORD_1F3D
    JSR     ESQSHARED4_ResetBannerColorToStart

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ResetBannerColorSweepState   (Routine at ESQSHARED4_ResetBannerColorSweepState)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQSHARED4_ResetBannerColorToStart
; READS:
;   Global_REF_WORD_HEX_CODE_8E, f5, f6
; WRITES:
;   DATA_ESQ_CONST_LONG_1E4E, DATA_ESQ_CONST_LONG_1E7B, DATA_ESQPARS2_BSS_WORD_1F3D, DATA_ESQPARS2_BSS_WORD_1F42, DATA_ESQPARS2_BSS_LONG_1F46
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ResetBannerColorSweepState:
    MOVEQ   #0,D0
    MOVE.B  #$f6,DATA_ESQ_CONST_LONG_1E4E
    MOVE.B  #$f6,DATA_ESQ_CONST_LONG_1E7B
    MOVE.W  #$f5,D0
    ADD.W   Global_REF_WORD_HEX_CODE_8E,D0
    SUBI.W  #$80,D0
    MOVE.W  D0,DATA_ESQPARS2_BSS_WORD_1F42
    MOVE.W  #$62,DATA_ESQPARS2_BSS_LONG_1F46
    MOVE.W  #1,DATA_ESQPARS2_BSS_WORD_1F3D
    JSR     ESQSHARED4_ResetBannerColorToStart

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_InitializeBannerCopperSystem   (InitializeBannerCopperSystem)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A7/D0/D1
; CALLS:
;   ESQSHARED4_ResetBannerColorSweepState, ESQSHARED4_SetupBannerPlanePointerWords, ESQSHARED4_SnapshotDisplayBufferBases
; READS:
;   CIAB_PRA, Global_REF_WORD_HEX_CODE_8E
; WRITES:
;   ESQ_CopperListBannerA, ESQ_CopperListBannerB, DATA_ESQPARS2_BSS_WORD_1F3B, DATA_ESQPARS2_BSS_WORD_1F3F, ESQPARS2_StateIndex, DATA_ESQPARS2_BSS_WORD_1F43, DATA_ESQPARS2_BSS_WORD_1F44, ESQPARS2_ReadModeFlags
; DESC:
;   Initializes banner copper-state globals, snapshots display buffer bases,
;   seeds banner plane pointer words, and enables CIAB PRA control bits.
; NOTES:
;   Sets baseline read/state flags used by subsequent banner color/plane updates.
;------------------------------------------------------------------------------
ESQSHARED4_InitializeBannerCopperSystem:
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  #$62,D0
    MOVE.W  D0,DATA_ESQPARS2_BSS_WORD_1F43
    SUBQ.W  #2,D0
    MOVE.W  D0,DATA_ESQPARS2_BSS_WORD_1F44
    MOVE.W  #5,ESQPARS2_ReadModeFlags
    MOVE.W  #2,ESQPARS2_StateIndex
    MOVE.W  #10,DATA_ESQPARS2_BSS_WORD_1F3F
    JSR     ESQSHARED4_SnapshotDisplayBufferBases

    JSR     ESQSHARED4_ResetBannerColorSweepState(PC)

    JSR     ESQSHARED4_SetupBannerPlanePointerWords

    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    MOVE.B  D1,(A1)
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    MOVE.B  D0,ESQ_CopperListBannerA
    MOVE.B  D0,ESQ_CopperListBannerB
    MOVE.W  #1,DATA_ESQPARS2_BSS_WORD_1F3B
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetupBannerPlanePointerWords   (Routine at ESQSHARED4_SetupBannerPlanePointerWords)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A3/A4/A7/D0/D2
; CALLS:
;   ESQSHARED4_SetBannerColorBaseAndLimit
; READS:
;   DATA_ESQPARS2_BSS_WORD_1F2F, DATA_ESQPARS2_BSS_LONG_1F38, DATA_ESQPARS2_BSS_LONG_1F49, DATA_ESQPARS2_BSS_WORD_1F4A, ESQSHARED_BannerRowScratchRasterBase0, ESQSHARED_BannerRowScratchRasterBase1, ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   DATA_ESQ_CONST_LONG_1E30, DATA_ESQ_CONST_LONG_1E31, DATA_ESQ_CONST_LONG_1E32, DATA_ESQ_CONST_LONG_1E33, DATA_ESQ_CONST_LONG_1E34, DATA_ESQ_CONST_LONG_1E35, DATA_ESQ_CONST_LONG_1E3B, DATA_ESQ_CONST_LONG_1E3C, DATA_ESQ_CONST_LONG_1E3D, DATA_ESQ_CONST_LONG_1E3E, DATA_ESQ_CONST_LONG_1E3F, DATA_ESQ_CONST_LONG_1E40, DATA_ESQ_CONST_LONG_1E47, DATA_ESQ_CONST_LONG_1E48, DATA_ESQ_CONST_LONG_1E49, DATA_ESQ_CONST_LONG_1E4A, DATA_ESQ_CONST_LONG_1E4B, DATA_ESQ_BSS_WORD_1E4C, DATA_ESQ_CONST_LONG_1E5D, DATA_ESQ_CONST_LONG_1E5E, DATA_ESQ_CONST_LONG_1E5F, DATA_ESQ_CONST_LONG_1E60, DATA_ESQ_CONST_LONG_1E61, DATA_ESQ_CONST_LONG_1E62, DATA_ESQ_CONST_LONG_1E68, DATA_ESQ_CONST_LONG_1E69, DATA_ESQ_CONST_LONG_1E6A, DATA_ESQ_CONST_LONG_1E6B, DATA_ESQ_CONST_LONG_1E6C, DATA_ESQ_CONST_LONG_1E6D, DATA_ESQ_CONST_LONG_1E74, DATA_ESQ_CONST_LONG_1E75, DATA_ESQ_CONST_LONG_1E76, DATA_ESQ_CONST_LONG_1E77, DATA_ESQ_CONST_LONG_1E78, DATA_ESQ_BSS_WORD_1E79, DATA_ESQPARS2_BSS_LONG_1F39, DATA_ESQPARS2_BSS_LONG_1F3A
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetupBannerPlanePointerWords:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     DATA_ESQPARS2_BSS_WORD_1F2F,A1
    LEA     ESQSHARED_BannerRowScratchRasterBase0,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E31
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E30
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E5E
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E5D
    LEA     DATA_ESQPARS2_BSS_LONG_1F38,A4
    LEA     DATA_ESQPARS2_BSS_WORD_1F2F,A1
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,(A4)+
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E3C
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E48
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E3B
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E47
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E69
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E75
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E68
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E74
    LEA     ESQSHARED_BannerRowScratchRasterBase1,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E33
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E32
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E60
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E5F
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,DATA_ESQPARS2_BSS_LONG_1F39
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E3E
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E4A
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E3D
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E49
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6B
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E77
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6A
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E76
    LEA     ESQSHARED_BannerRowScratchRasterBase2,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E35
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E34
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E62
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E61
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)
    MOVE.L  A2,DATA_ESQPARS2_BSS_LONG_1F3A
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E40
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E4C
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E3F
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E4B
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6D
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E79
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6C
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E78
    MOVE.W  DATA_ESQPARS2_BSS_LONG_1F49,D0
    BSR.W   ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    MOVEQ   #0,D0
    MOVE.W  DATA_ESQPARS2_BSS_WORD_1F4A,D0
    BSR.W   ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetBannerColorBaseAndLimit   (Routine at ESQSHARED4_SetBannerColorBaseAndLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D1
; CALLS:
;   (none)
; READS:
;   d9
; WRITES:
;   DATA_ESQ_BSS_BYTE_1E45, DATA_ESQ_CONST_BYTE_1E46, DATA_ESQ_BSS_BYTE_1E72, DATA_ESQ_CONST_BYTE_1E73, DATA_ESQPARS2_BSS_WORD_1F4A
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetBannerColorBaseAndLimit:
    MOVE.W  D0,DATA_ESQPARS2_BSS_WORD_1F4A
    MOVE.W  #$d9,D1
    MOVE.B  D0,DATA_ESQ_BSS_BYTE_1E45
    MOVE.B  D0,DATA_ESQ_BSS_BYTE_1E72
    MOVE.B  D1,DATA_ESQ_CONST_BYTE_1E46
    MOVE.B  D1,DATA_ESQ_CONST_BYTE_1E73
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_BindAndClearBannerWorkRaster   (Routine at ESQSHARED4_BindAndClearBannerWorkRaster)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0
; CALLS:
;   ESQSHARED4_ClearBannerWorkRasterWithOnes
; READS:
;   WDISP_BannerWorkRasterPtr
; WRITES:
;   DATA_ESQ_CONST_LONG_1E2C, DATA_ESQ_CONST_LONG_1E2D, DATA_ESQ_CONST_LONG_1E38, DATA_ESQ_BSS_WORD_1E39, DATA_ESQ_CONST_LONG_1E4F, DATA_ESQ_CONST_LONG_1E50, DATA_ESQ_CONST_LONG_1E59, DATA_ESQ_CONST_LONG_1E5A, DATA_ESQ_CONST_LONG_1E65, DATA_ESQ_BSS_WORD_1E66, DATA_ESQ_CONST_LONG_1E7C, DATA_ESQ_CONST_LONG_1E7D
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_BindAndClearBannerWorkRaster:
    MOVEM.L D0/A0-A1,-(A7)

    LEA     WDISP_BannerWorkRasterPtr,A0
    MOVEA.L (A0),A1
    LEA (A1),A1
    MOVE.L  A1,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E2D
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E39
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E50
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E5A
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E66
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E7D
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E2C
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E38
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E4F
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E59
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E65
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E7C
    JSR     ESQSHARED4_ClearBannerWorkRasterWithOnes

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ClearBannerWorkRasterWithOnes   (Routine at ESQSHARED4_ClearBannerWorkRasterWithOnes)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/D1
; CALLS:
;   (none)
; READS:
;   LAB_0C7F, WDISP_BannerWorkRasterPtr, ffffffff
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ClearBannerWorkRasterWithOnes:
    LEA     WDISP_BannerWorkRasterPtr,A1
    MOVEA.L (A1),A0
    LEA (A0),A0
    MOVE.L  #$149,D1

.lab_0C7F:
    MOVE.L  #$ffffffff,(A0)+
    DBF     D1,.lab_0C7F
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ProgramDisplayWindowAndCopper   (Routine at ESQSHARED4_ProgramDisplayWindowAndCopper)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/D0
; CALLS:
;   ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; READS:
;   BLTDDAT, COPJMP1, DDFSTOP_WIDE, DDFSTRT_WIDE, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E4D, DATA_ESQ_CONST_LONG_1E51, DATA_ESQ_CONST_LONG_1E7A, VPOSR, ffc5
; WRITES:
;   BLTDDAT, BPL1MOD, BPL2MOD, COP1LCH, DDFSTOP, DDFSTRT, DIWSTOP, DIWSTRT, DMACON, DATA_ESQ_CONST_LONG_1E23, DATA_ESQ_BSS_WORD_1E24, DATA_ESQ_CONST_LONG_1E41, DATA_ESQ_CONST_LONG_1E42, DATA_ESQ_CONST_LONG_1E52, DATA_ESQ_BSS_WORD_1E53, DATA_ESQ_CONST_LONG_1E6E, DATA_ESQ_CONST_LONG_1E6F
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ProgramDisplayWindowAndCopper:
    LEA     BLTDDAT,A0
    MOVE.W  #$1761,(DIWSTRT-BLTDDAT)(A0)    ; $17, $61  -> 23, 97
    MOVE.W  #$ffc5,(DIWSTOP-BLTDDAT)(A0)    ; $ff, $c5  -> 255, 197
    MOVE.W  #DDFSTRT_WIDE,(DDFSTRT-BLTDDAT)(A0)
    MOVE.W  #DDFSTOP_WIDE,(DDFSTOP-BLTDDAT)(A0)
    ; $58 = 88
    ; 88 * 8 = 704
    ; SCREEN_WIDTH_BYTES	equ (320/8)
    ; SCREEN_BIT_DEPTH	equ 5
    ; BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
    ; how is this calculated?
    MOVE.W  #$58,(BPL1MOD-BLTDDAT)(A0)
    MOVE.W  #$58,(BPL2MOD-BLTDDAT)(A0)
    JSR     ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

    LEA     DATA_ESQ_CONST_LONG_1E51,A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E24
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E23
    LEA     DATA_ESQ_CONST_LONG_1E22,A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1E53
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E52
    LEA     DATA_ESQ_CONST_LONG_1E4D,A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E42
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E41
    LEA     DATA_ESQ_CONST_LONG_1E7A,A2
    MOVE.L  A2,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6F
    SWAP    D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E6E
    LEA     DATA_ESQ_CONST_LONG_1E51,A2
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C81

    LEA     DATA_ESQ_CONST_LONG_1E22,A2

.lab_0C81:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.W  (COPJMP1-BLTDDAT)(A0),D0
    MOVE.W  #$20,(DMACON-BLTDDAT)(A0)
    MOVE.W  #$8180,(DMACON-BLTDDAT)(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_TickCopperAndBannerTransitions   (Routine at ESQSHARED4_TickCopperAndBannerTransitions)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A7/D0/D1
; CALLS:
;   GCOMMAND_TickHighlightState, ESQSHARED4_ProgramDisplayWindowAndCopper, ESQSHARED4_BlitBannerRowsForActiveField, SCRIPT_UpdateBannerCharTransition
; READS:
;   BLTDDAT, LAB_0C85, LAB_0C86, LAB_0C87, LAB_0C89, LAB_0C8A, LAB_0C8B, DATA_ED2_BSS_WORD_1D31, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E3B, DATA_ESQ_CONST_LONG_1E3C, DATA_ESQ_CONST_LONG_1E3D, DATA_ESQ_CONST_LONG_1E3E, DATA_ESQ_CONST_LONG_1E3F, DATA_ESQ_CONST_LONG_1E40, DATA_ESQ_CONST_LONG_1E51, DATA_ESQPARS2_BSS_WORD_1F3B, ESQPARS2_StateIndex, ESQPARS2_ReadModeFlags, DATA_GCOMMAND_BSS_WORD_1FA9, SCRIPT_BannerTransitionActive, VPOSR, b0
; WRITES:
;   BLTDDAT, COP1LCH, DATA_ESQ_CONST_LONG_1E3B, DATA_ESQ_CONST_LONG_1E3C, DATA_ESQ_CONST_LONG_1E3D, DATA_ESQ_CONST_LONG_1E3E, DATA_ESQ_CONST_LONG_1E3F, DATA_ESQ_CONST_LONG_1E40, DATA_ESQ_CONST_LONG_1E68, DATA_ESQ_CONST_LONG_1E69, DATA_ESQ_CONST_LONG_1E6A, DATA_ESQ_CONST_LONG_1E6B, DATA_ESQ_CONST_LONG_1E6C, DATA_ESQ_CONST_LONG_1E6D, DATA_ESQPARS2_BSS_WORD_1F2F, DATA_ESQPARS2_BSS_WORD_1F30, DATA_ESQPARS2_BSS_WORD_1F31, DATA_ESQPARS2_BSS_WORD_1F32, DATA_ESQPARS2_BSS_WORD_1F33, DATA_ESQPARS2_BSS_WORD_1F34, DATA_ESQPARS2_BSS_WORD_1F3B, DATA_ESQPARS2_BSS_WORD_1F3F, ESQPARS2_ReadModeFlags, DATA_ESQPARS2_BSS_LONG_1F51, DATA_GCOMMAND_BSS_WORD_1FA9
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_TickCopperAndBannerTransitions:
    MOVEM.L D0-D3/A0-A6,-(A7)

    LEA     BLTDDAT,A0
    LEA     DATA_ESQ_CONST_LONG_1E22,A2
    MOVEQ   #1,D1
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C83            ; BPL = checks to see if bit 15 is set (LOF), if it is jump to LAB_0C83

    LEA     DATA_ESQ_CONST_LONG_1E51,A2
    MOVEQ   #0,D1

.lab_0C83:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.L  D1,DATA_ESQPARS2_BSS_LONG_1F51
    TST.W   DATA_ESQPARS2_BSS_WORD_1F3B
    BEQ.S   .lab_0C84

    JSR     ESQSHARED4_ProgramDisplayWindowAndCopper(PC)

    MOVE.W  #0,DATA_ESQPARS2_BSS_WORD_1F3B
    BRA.W   .lab_0C8B

.lab_0C84:
    JSR     SCRIPT_UpdateBannerCharTransition

    TST.W   SCRIPT_BannerTransitionActive
    BNE.W   .lab_0C8B

    TST.B   DATA_GCOMMAND_BSS_WORD_1FA9
    BNE.W   .lab_0C8A

    CMPI.W  #$200,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C85

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C89

.lab_0C85:
    CMPI.W  #$102,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C86

    BRA.W   .lab_0C8B

.lab_0C86:
    CMPI.W  #$101,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C87

    BRA.W   .lab_0C8B

.lab_0C87:
    CMPI.W  #$100,ESQPARS2_ReadModeFlags
    BEQ.W   .lab_0C8B

    TST.W   ESQPARS2_ReadModeFlags
    BMI.S   .lab_0C88

    MOVEQ   #1,D0
    SUB.W   D0,ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C8B

.lab_0C88:
    SUBQ.W  #1,DATA_ESQPARS2_BSS_WORD_1F3F
    BPL.S   .lab_0C8B

.lab_0C89:
    MOVE.W  ESQPARS2_StateIndex,DATA_ESQPARS2_BSS_WORD_1F3F
    TST.W   DATA_ED2_BSS_WORD_1D31
    BEQ.S   .lab_0C8B

    JSR     GCOMMAND_TickHighlightState

    BRA.S   .lab_0C8B

.lab_0C8A:
    SUBQ.B  #1,DATA_GCOMMAND_BSS_WORD_1FA9
    SUBQ.W  #1,DATA_ESQPARS2_BSS_WORD_1F3F
    JSR     ESQSHARED4_BlitBannerRowsForActiveField

.lab_0C8B:
    MOVEM.L (A7)+,D0-D3/A0-A6
    RTS

;!======

    MOVE.W  DATA_ESQ_CONST_LONG_1E3C,DATA_ESQPARS2_BSS_WORD_1F30
    MOVE.W  DATA_ESQ_CONST_LONG_1E3B,DATA_ESQPARS2_BSS_WORD_1F2F
    MOVE.W  DATA_ESQ_CONST_LONG_1E3E,DATA_ESQPARS2_BSS_WORD_1F32
    MOVE.W  DATA_ESQ_CONST_LONG_1E3D,DATA_ESQPARS2_BSS_WORD_1F31
    MOVE.W  DATA_ESQ_CONST_LONG_1E40,DATA_ESQPARS2_BSS_WORD_1F34
    MOVE.W  DATA_ESQ_CONST_LONG_1E3F,DATA_ESQPARS2_BSS_WORD_1F33
    RTS

;!======

    MOVE.L  #$b0,D1
    MOVEQ   #1,D0
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E3C
    BCC.S   .lab_0C8C

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E3B

.lab_0C8C:
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E3E
    BCC.S   .lab_0C8D

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E3D

.lab_0C8D:
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E40
    BCC.S   .lab_0C8E

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E3F

.lab_0C8E:
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E69
    BCC.S   .lab_0C8F

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E68

.lab_0C8F:
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E6B
    BCC.S   .lab_0C90

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E6A

.lab_0C90:
    ADD.W   D1,DATA_ESQ_CONST_LONG_1E6D
    BCC.S   .lab_0C91

    ADD.W   D0,DATA_ESQ_CONST_LONG_1E6C

.lab_0C91:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SnapshotDisplayBufferBases   (Routine at ESQSHARED4_SnapshotDisplayBufferBases)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A7
; CALLS:
;   (none)
; READS:
;   ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2
; WRITES:
;   DATA_ESQPARS2_BSS_LONG_1F35, DATA_ESQPARS2_BSS_LONG_1F36, DATA_ESQPARS2_BSS_LONG_1F37
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SnapshotDisplayBufferBases:
    MOVE.L  A1,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVE.L  (A1),DATA_ESQPARS2_BSS_LONG_1F35
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVE.L  (A1),DATA_ESQPARS2_BSS_LONG_1F36
    LEA     ESQSHARED_LivePlaneBase2,A1
    MOVE.L  (A1),DATA_ESQPARS2_BSS_LONG_1F37
    MOVEA.L (A7)+,A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyPlanesFromContextToSnapshot   (Routine at ESQSHARED4_CopyPlanesFromContextToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   DATA_ESQPARS2_BSS_WORD_1F2F, lab_0C94, lab_0C95, lab_0C96
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyPlanesFromContextToSnapshot:
    MOVEM.L D1/A1-A4,-(A7)
    LEA     20(A1),A1
    LEA     DATA_ESQPARS2_BSS_WORD_1F2F,A2
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C94:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C94
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C95:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C95
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C96:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C96
    MOVE.L  A3,(A1)+
    MOVEM.L (A7)+,D1/A1-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyLivePlanesToSnapshot   (Routine at ESQSHARED4_CopyLivePlanesToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   DATA_ESQPARS2_BSS_WORD_1F2F, ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2, lab_0C98, lab_0C99
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyLivePlanesToSnapshot:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVEA.L (A1),A3
    LEA     DATA_ESQPARS2_BSS_WORD_1F2F,A2
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C98:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C98
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C99:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C99
    LEA     ESQSHARED_LivePlaneBase2,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyLongwordBlockDbfLoop   (Routine at ESQSHARED4_CopyLongwordBlockDbfLoop)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
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
ESQSHARED4_CopyLongwordBlockDbfLoop:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,ESQSHARED4_CopyLongwordBlockDbfLoop
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ComputeBannerRowBlitGeometry   (Routine at ESQSHARED4_ComputeBannerRowBlitGeometry)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   DATA_ESQPARS2_CONST_LONG_1F52, DATA_ESQPARS2_CONST_WORD_1F53, DATA_ESQPARS2_CONST_WORD_1F54
; WRITES:
;   DATA_ESQPARS2_BSS_WORD_1F4B, DATA_ESQPARS2_BSS_LONG_1F4C, DATA_ESQPARS2_BSS_LONG_1F4D, ESQSHARED_BlitAddressOffset, DATA_ESQPARS2_CONST_WORD_1F55
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ComputeBannerRowBlitGeometry:
    MOVE.L  DATA_ESQPARS2_CONST_LONG_1F52,D0
    MULU    #$58,D0
    MOVE.L  D0,DATA_ESQPARS2_BSS_LONG_1F4C
    CLR.L   D0
    MOVE.W  DATA_ESQPARS2_CONST_WORD_1F53,D0
    LSR.W   #3,D0
    MOVE.L  D0,DATA_ESQPARS2_BSS_LONG_1F4D
    ADDI.L  #$58,D0
    MOVE.L  D0,ESQSHARED_BlitAddressOffset
    MOVE.W  DATA_ESQPARS2_CONST_WORD_1F54,D0
    LSR.W   #5,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_ESQPARS2_BSS_WORD_1F4B
    MOVE.W  #$22,D0
    LSR.W   #1,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_ESQPARS2_CONST_WORD_1F55
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyInterleavedRowWordsFromOffset   (Routine at ESQSHARED4_CopyInterleavedRowWordsFromOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0
; CALLS:
;   (none)
; READS:
;   DATA_WDISP_BSS_LONG_2310, DATA_WDISP_BSS_LONG_2311
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyInterleavedRowWordsFromOffset:
    MOVEM.L D0/A0-A2,-(A7)
    MOVEA.L A0,A1
    ADDA.L  DATA_WDISP_BSS_LONG_2310,A1
    MOVEA.L A1,A2
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    MOVEA.L A0,A2
    ADDA.L  DATA_WDISP_BSS_LONG_2311,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    MOVEM.L (A7)+,D0/A0-A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyBannerRowsWithByteOffset   (Routine at ESQSHARED4_CopyBannerRowsWithByteOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0/D1
; CALLS:
;   (none)
; READS:
;   DATA_ESQPARS2_BSS_LONG_1F4E, DATA_ESQPARS2_BSS_LONG_1F4F, ESQSHARED_BlitAddressOffset, GCOMMAND_BannerRowByteOffsetCurrent, b0
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyBannerRowsWithByteOffset:
    MOVEM.L D0-D1/A0-A2,-(A7)
    MOVE.L  DATA_ESQPARS2_BSS_LONG_1F4E,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A1,A2
    ADDA.L  #$b0,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,D1
    ADD.L   DATA_ESQPARS2_BSS_LONG_1F4F,D1
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVEM.L (A7)+,D0-D1/A0-A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_BlitBannerRowsForActiveField   (Routine at ESQSHARED4_BlitBannerRowsForActiveField)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   ESQSHARED4_CopyInterleavedRowWordsFromOffset, ESQSHARED4_CopyBannerRowsWithByteOffset
; READS:
;   ESQ_CopperListBannerA, ESQ_CopperListBannerB, DATA_ESQPARS2_BSS_LONG_1F4C, DATA_ESQPARS2_BSS_LONG_1F4D, DATA_ESQPARS2_BSS_LONG_1F51, ESQSHARED_BannerRowScratchRasterBase0, ESQSHARED_BannerRowScratchRasterBase1, ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   DATA_ESQPARS2_BSS_LONG_1F4E, DATA_ESQPARS2_BSS_LONG_1F4F
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_BlitBannerRowsForActiveField:
    MOVEM.L D0/A0-A1,-(A7)
    MOVE.L  DATA_ESQPARS2_BSS_LONG_1F4C,D1
    MOVE.L  DATA_ESQPARS2_BSS_LONG_1F4D,D0
    TST.L   DATA_ESQPARS2_BSS_LONG_1F51
    BNE.S   .lab_0C9F

    ADDI.L  #$58,D0
    LEA     ESQ_CopperListBannerA,A0
    BRA.S   .lab_0CA0

.lab_0C9F:
    LEA     ESQ_CopperListBannerB,A0

.lab_0CA0:
    MOVE.L  D0,DATA_ESQPARS2_BSS_LONG_1F4F
    ADD.L   D0,D1
    MOVE.L  D1,DATA_ESQPARS2_BSS_LONG_1F4E
    JSR     ESQSHARED4_CopyInterleavedRowWordsFromOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase0,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase1,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase2,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_LoadCopperColorWordsFromNibbleTable   (Routine at ESQSHARED4_LoadCopperColorWordsFromNibbleTable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A4/D3/D4
; CALLS:
;   ESQSHARED4_DecodeRgbNibbleTriplet
; READS:
;   DATA_ESQ_CONST_LONG_1E36, DATA_ESQ_CONST_LONG_1E43, DATA_ESQ_CONST_WORD_1E44, DATA_ESQ_CONST_LONG_1E63, DATA_ESQ_CONST_LONG_1E70, DATA_ESQ_CONST_WORD_1E71, lab_0CA2, lab_0CA3, lab_0CA4, lab_0CA5
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_LoadCopperColorWordsFromNibbleTable:
    MOVEQ   #7,D4

.lab_0CA2:
    JSR     ESQSHARED4_DecodeRgbNibbleTriplet

    CMPI.W  #4,D3
    BEQ.W   .lab_0CA3

    CMPI.W  #$1c,D3
    BEQ.W   .lab_0CA4

    MOVE.W  D0,0(A2,D3.W)
    MOVE.W  D0,0(A3,D3.W)
    BRA.W   .lab_0CA5

.lab_0CA3:
    LEA     DATA_ESQ_CONST_LONG_1E36,A4
    MOVE.W  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E63,A4
    MOVE.W  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E43,A4
    MOVE.W  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E70,A4
    MOVE.W  D0,(A4)
    BRA.W   .lab_0CA5

.lab_0CA4:
    LEA     DATA_ESQ_CONST_WORD_1E44,A4
    MOVE.W  D0,(A4)
    LEA     DATA_ESQ_CONST_WORD_1E71,A4
    MOVE.W  D0,(A4)

.lab_0CA5:
    ADDQ.W  #4,D3
    DBF     D4,.lab_0CA2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_DecodeRgbNibbleTriplet   (Routine at ESQSHARED4_DecodeRgbNibbleTriplet)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1/D2
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
ESQSHARED4_DecodeRgbNibbleTriplet:
    MOVE.B  (A1)+,D2
    MOVE.B  (A1)+,D1
    MOVE.B  (A1)+,D0
    ANDI.W  #15,D2
    ANDI.W  #15,D1
    ANDI.W  #15,D0
    LSL.W   #8,D2
    LSL.W   #4,D1
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Routine at ESQSHARED4_LoadDefaultPaletteToCopper_NoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A3/A7/D0/D3
; CALLS:
;   ESQSHARED4_LoadCopperColorWordsFromNibbleTable
; READS:
;   DATA_ESQ_BSS_BYTE_1DE0, DATA_ESQ_CONST_LONG_1E2E, DATA_ESQ_CONST_LONG_1E5B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    RTS

;!======

    MOVEM.L D0-D4/A0-A4,-(A7)
    LEA     DATA_ESQ_CONST_LONG_1E2E,A2
    LEA     DATA_ESQ_CONST_LONG_1E5B,A3
    MOVE.W  #0,D3
    LEA     DATA_ESQ_BSS_BYTE_1DE0,A1
    JSR     ESQSHARED4_LoadCopperColorWordsFromNibbleTable(PC)

    MOVEM.L (A7)+,D0-D4/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetBannerCopperColorAndThreshold   (Routine at ESQSHARED4_SetBannerCopperColorAndThreshold)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   ESQ_NoOp
; READS:
;   ESQSHARED4_ApplyBannerColorStep, ESQ_CopperListBannerA, DATA_ESQ_CONST_LONG_1E2F, DATA_ESQ_CONST_LONG_1E37, DATA_ESQ_CONST_LONG_1E3A, ESQ_CopperListBannerB, DATA_ESQ_CONST_LONG_1E5C, DATA_ESQ_CONST_LONG_1E64, DATA_ESQ_CONST_LONG_1E67, DATA_ESQPARS2_BSS_LONG_1F49, DATA_ESQPARS2_BSS_WORD_1F4A, f6, ff, lab_0CA9, lab_0CAA, lab_0CAB
; WRITES:
;   DATA_ESQPARS2_BSS_WORD_1F3D, DATA_ESQPARS2_BSS_LONG_1F46, DATA_ESQPARS2_BSS_LONG_1F49
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetBannerCopperColorAndThreshold:
    MOVE.B  D0,(A4)
    LEA     ESQ_CopperListBannerB,A4
    MOVE.B  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E2F,A4
    ADDI.B  #$1,D0
    MOVE.B  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E5C,A4
    MOVE.B  D0,(A4)
    ADDI.B  #$11,D0
    LEA     DATA_ESQ_CONST_LONG_1E37,A4
    MOVE.B  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E64,A4
    MOVE.B  D0,(A4)
    ADDQ.W  #1,D0
    LEA     DATA_ESQ_CONST_LONG_1E3A,A4
    MOVE.B  D0,(A4)
    LEA     DATA_ESQ_CONST_LONG_1E67,A4
    MOVE.B  D0,(A4)
    ANDI.W  #$ff,D0
    MOVE.W  D0,DATA_ESQPARS2_BSS_LONG_1F49
    RTS

;!======

    LEA     DATA_ESQPARS2_BSS_WORD_1F4A,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   DATA_ESQPARS2_BSS_LONG_1F49,D0
    BPL.W   .lab_0CA9

    RTS

;!======

.lab_0CA9:
    SUBI.W  #1,DATA_ESQPARS2_BSS_WORD_1F3D
    BNE.W   .lab_0CAA

    BRA.W   .lab_0CAB

.lab_0CAA:
    BPL.W   .lab_0CAB

    MOVE.W  #0,DATA_ESQPARS2_BSS_WORD_1F3D
    JSR     ESQ_NoOp

.lab_0CAB:
    SUBI.W  #1,DATA_ESQPARS2_BSS_LONG_1F46
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    ADDQ.W  #1,D0
    CMPI.B  #$f6,D0
    BNE.W   ESQSHARED4_ApplyBannerColorStep

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ResetBannerColorToStart   (Routine at ESQSHARED4_ResetBannerColorToStart)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   (none)
; READS:
;   ESQ_CopperListBannerA
; WRITES:
;   DATA_ESQPARS2_BSS_LONG_1F46
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ResetBannerColorToStart:
    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  #$62,DATA_ESQPARS2_BSS_LONG_1F46
    MOVE.W  #$19,D0

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ApplyBannerColorStep   (Routine at ESQSHARED4_ApplyBannerColorStep)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1/D2
; CALLS:
;   ESQ_NoOp, ESQSHARED4_BindAndClearBannerWorkRaster, ESQSHARED4_SetBannerCopperColorAndThreshold
; READS:
;   ESQ_CopperListBannerA, DATA_ESQ_CONST_LONG_1E3C, DATA_ESQ_CONST_LONG_1E48, DATA_ESQ_CONST_LONG_1E69, DATA_ESQ_CONST_LONG_1E75, DATA_ESQPARS2_BSS_LONG_1F49, DATA_ESQPARS2_BSS_WORD_1F4A, f6, lab_0CAE, lab_0CAF, lab_0CB0
; WRITES:
;   DATA_ESQ_BSS_BYTE_1E45, DATA_ESQ_BSS_BYTE_1E72, DATA_ESQPARS2_BSS_LONG_1F3E, DATA_ESQPARS2_BSS_LONG_1F46, DATA_ESQPARS2_BSS_WORD_1F47
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ApplyBannerColorStep:
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVE.W  #$58,D1
    JSR     ESQSHARED4_BindAndClearBannerWorkRaster(PC)

    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

    LEA     DATA_ESQPARS2_BSS_WORD_1F4A,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   DATA_ESQPARS2_BSS_LONG_1F49,D0
    BPL.W   .lab_0CAE

    RTS

;!======

.lab_0CAE:
    SUBI.W  #1,DATA_ESQPARS2_BSS_LONG_1F3E
    BNE.W   .lab_0CAF

    BRA.W   .lab_0CB0

.lab_0CAF:
    BPL.W   .lab_0CB0

    MOVE.W  #0,DATA_ESQPARS2_BSS_LONG_1F3E
    JSR     ESQ_NoOp

.lab_0CB0:
    ADDI.W  #1,DATA_ESQPARS2_BSS_LONG_1F46
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    SUBQ.W  #1,D0
    BRA.S   ESQSHARED4_ApplyBannerColorStep

    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  #$62,DATA_ESQPARS2_BSS_LONG_1F46
    MOVE.W  #$19,D0
    BRA.W   ESQSHARED4_ApplyBannerColorStep

    RTS

;!======

    MOVEM.L D0-D1/A2,-(A7)
    MOVE.W  DATA_ESQ_CONST_LONG_1E48,D0
    MOVE.W  DATA_ESQ_CONST_LONG_1E3C,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB1

    MOVE.W  DATA_ESQPARS2_BSS_WORD_1F4A,D0
    CMPI.W  #$f6,D0
    BLT.S   .lab_0CB2

.lab_0CB1:
    MOVE.W  #$8a,DATA_ESQ_BSS_BYTE_1E45
    MOVE.W  #$8a,DATA_ESQPARS2_BSS_WORD_1F47

.lab_0CB2:
    MOVE.W  DATA_ESQ_CONST_LONG_1E75,D0
    MOVE.W  DATA_ESQ_CONST_LONG_1E69,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB3

    MOVE.W  DATA_ESQPARS2_BSS_WORD_1F4A,D0
    CMPI.W  #$f6,D0
    BLT.S   ESQSHARED4_ApplyBannerColorStep_Return

.lab_0CB3:
    MOVE.W  #$8a,DATA_ESQ_BSS_BYTE_1E72
    MOVE.W  #$8a,DATA_ESQPARS2_BSS_WORD_1F47

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ApplyBannerColorStep_Return   (Routine at ESQSHARED4_ApplyBannerColorStep_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
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
ESQSHARED4_ApplyBannerColorStep_Return:
    MOVEM.L (A7)+,D0-D1/A2
    RTS

;!======

    ; Alignment
    ALIGN_WORD
