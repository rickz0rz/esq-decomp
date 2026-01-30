;!======
; The content above or below belongs in its own file... need to determine which
;!======

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_MapKeycodeToPreset   (Interpret a keyboard scan code and map it to a preset palette index.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Interpret a keyboard scan code and map it to a preset palette index.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Interpret a keyboard scan code and map it to a preset palette index.
GCOMMAND_MapKeycodeToPreset:
LAB_0D66:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    ANDI.B  #$30,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D67

    MOVE.L  LAB_1BCA,D6
    BRA.S   LAB_0D69

LAB_0D67:
    MOVE.L  D7,D0
    ANDI.B  #$20,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D68

    BSR.W   GCOMMAND_GetBannerChar

    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D1
    CMP.W   D0,D1
    BNE.S   LAB_0D69

    MOVE.L  LAB_1BCA,D6
    BRA.S   LAB_0D69

LAB_0D68:
    MOVE.L  D7,D0
    ANDI.B  #$40,D0
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D69

    MOVEQ   #-1,D6

LAB_0D69:
    LEA     LAB_1F48,A0
    ADDA.W  LAB_2309,A0
    MOVE.B  D6,(A0)
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ApplyHighlightFlag   (Update all banner layout rows to reflect the current highlight flag.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Update all banner layout rows to reflect the current highlight flag.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Update all banner layout rows to reflect the current highlight flag.
GCOMMAND_ApplyHighlightFlag:
LAB_0D6A:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    TST.W   GCOMMAND_HighlightFlag
    BEQ.S   LAB_0D6B

    MOVEQ   #2,D0
    BRA.S   LAB_0D6C

LAB_0D6B:
    MOVEQ   #0,D0

LAB_0D6C:
    MOVE.L  D0,D7
    MOVE.L  #LAB_1E25,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #LAB_1E54,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #LAB_1E2B,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D1
    AND.W   114(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D1
    AND.W   726(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D0
    AND.W   114(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D0
    AND.W   726(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_EnableHighlight   (??)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------

GCOMMAND_EnableHighlight:
LAB_0D6D:
    MOVE.W  #1,GCOMMAND_HighlightFlag
    BSR.W   GCOMMAND_ApplyHighlightFlag

    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_DisableHighlight   (??)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------

GCOMMAND_DisableHighlight:
LAB_0D6E:
    CLR.W   GCOMMAND_HighlightFlag
    BSR.W   GCOMMAND_ApplyHighlightFlag

    RTS

;!======

    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  A3,-(A7)
    PEA     LAB_1FAA
    JSR     LAB_0F02(PC)

    PEA     LAB_1FAB
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D7

LAB_0D6F:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D72

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D7,-(A7)
    PEA     LAB_1FAC
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D6

LAB_0D70:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D71

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
    PEA     LAB_1FAD
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    BRA.S   LAB_0D70

LAB_0D71:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D6F

LAB_0D72:
    PEA     LAB_1FAE
    JSR     LAB_0F02(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SetPresetEntry   (Update the preset table entry for row D7 with the supplied value D6.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Update the preset table entry for row D7 with the supplied value D6.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Update the preset table entry for row D7 with the supplied value D6.
GCOMMAND_SetPresetEntry:
LAB_0D73:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6
    TST.L   D7
    BLE.S   LAB_0D74

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D74

    TST.L   D6
    BMI.S   LAB_0D74

    CMPI.L  #$1000,D6
    BGE.S   LAB_0D74

    MOVE.L  D7,D0
    ASL.L   #7,D0
    LEA     LAB_22F5,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,(A0)

LAB_0D74:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ExpandPresetBlock   (Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.
GCOMMAND_ExpandPresetBlock:
LAB_0D75:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #4,D7

LAB_0D76:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D79

    MOVEQ   #0,D5
    MOVEQ   #0,D6

LAB_0D77:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.S   LAB_0D78

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
    BRA.S   LAB_0D77

LAB_0D78:
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_0D76

LAB_0D79:
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ValidatePresetTable   (ValidatePresetTable??)
; ARGS:
;   stack +4: presetTable (base pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1, A3, A6
; CALLS:
;   LAB_0DA2, _LVODisable, _LVOEnable
; READS:
;   [presetTable], LAB_22F4
; WRITES:
;   LAB_1FA3, LAB_22F4
; DESC:
;   Validates preset table values and, if needed, copies defaults and resets
;   associated state.
; NOTES:
;   Value ranges are inferred (1..$40 and 0..$1000 checks).
;------------------------------------------------------------------------------
GCOMMAND_ValidatePresetTable:
LAB_0D7A:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #1,D5
    MOVEQ   #0,D7

LAB_0D7B:
    TST.L   D5
    BEQ.S   LAB_0D82

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D82

    MOVE.L  D7,D0
    ADD.L   D0,D0
    CMPI.W  #1,0(A3,D0.L)
    BLE.S   LAB_0D7C

    CMPI.W  #$40,0(A3,D0.L)
    BGT.S   LAB_0D7C

    MOVEQ   #1,D0
    BRA.S   LAB_0D7D

LAB_0D7C:
    MOVEQ   #0,D0

LAB_0D7D:
    MOVE.L  D0,D5
    MOVEQ   #0,D6

LAB_0D7E:
    TST.L   D5
    BEQ.S   LAB_0D81

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D81

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D1
    ADD.L   D1,D1
    ADDA.L  D1,A0
    CMPI.W  #0,32(A0)
    BCS.S   LAB_0D7F

    MOVEA.L A3,A0
    ADDA.L  D0,A0
    ADDA.L  D1,A0
    CMPI.W  #$1000,32(A0)
    BCC.S   LAB_0D7F

    MOVEQ   #1,D0
    BRA.S   LAB_0D80

LAB_0D7F:
    MOVEQ   #0,D0

LAB_0D80:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_0D7E

LAB_0D81:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D7B

LAB_0D82:
    TST.L   D5
    BEQ.S   LAB_0D83

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEA.L A3,A0
    LEA     LAB_22F4,A1
    MOVE.L  #$820,D0
    JSR     _LVOCopyMem(A6)

    MOVE.W  #1,LAB_1FA3
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0DA2

    LEA     16(A7),A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

LAB_0D83:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_InitPresetTableFromPalette   (InitPresetTableFromPalette??)
; ARGS:
;   stack +4: presetTable (base pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   JMP_TBL_LAB_1A06_6
; READS:
;   LAB_1FA2
; WRITES:
;   [presetTable]
; DESC:
;   Fills preset table entries using palette data in LAB_1FA2.
; NOTES:
;   Uses a helper at LAB_1A06 to compute palette index; layout inferred.
;------------------------------------------------------------------------------
GCOMMAND_InitPresetTableFromPalette:
LAB_0D84:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVEQ   #0,D7

LAB_0D85:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D88

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  #16,0(A3,D0.L)
    MOVEQ   #0,D6

LAB_0D86:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D87

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
    JSR     JMP_TBL_LAB_1A06_6(PC)

    LEA     LAB_1FA2,A1
    ADDA.L  D0,A1
    MOVE.L  16(A7),D0
    ADDA.L  D0,A1
    MOVE.W  (A1),32(A0)
    ADDQ.L  #1,D6
    BRA.S   LAB_0D86

LAB_0D87:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D85

LAB_0D88:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_InitPresetDefaults   (InitPresetDefaults??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   GCOMMAND_InitPresetTableFromPalette
; READS:
;   LAB_22F4
; WRITES:
;   LAB_22F4
; DESC:
;   Initializes the default preset table at LAB_22F4.
; NOTES:
;   Wrapper around GCOMMAND_InitPresetTableFromPalette.
;------------------------------------------------------------------------------
GCOMMAND_InitPresetDefaults:
LAB_0D89:
    PEA     LAB_22F4
    BSR.S   GCOMMAND_InitPresetTableFromPalette

    ADDQ.W  #4,A7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ComputePresetIncrement   (ComputePresetIncrement??)
; ARGS:
;   stack +4: presetIndex (0..15)
;   stack +8: span (value > 4 to enable scaling)
; RET:
;   D0: scaled increment (0 when out of range)
; CLOBBERS:
;   D0-D7
; CALLS:
;   JMP_TBL_LAB_1A06_6, JMP_TBL_LAB_1A07_3
; READS:
;   LAB_22F4
; WRITES:
;   (none)
; DESC:
;   Computes a scaled increment based on a preset table entry and span.
; NOTES:
;   Returns 0 when presetIndex is out of range or span <= 4.
;------------------------------------------------------------------------------
GCOMMAND_ComputePresetIncrement:
LAB_0D8A:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D0
    MOVE.L  D0,-12(A5)
    TST.L   D7
    BMI.S   .return

    MOVEQ   #16,D1
    CMP.L   D1,D7
    BGE.S   .return

    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   .return

    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     LAB_22F4,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    MOVE.L  D1,D5
    SUBQ.L  #1,D5
    MOVE.L  D6,D4
    SUBQ.L  #5,D4
    BLE.S   .set_zero

    MOVE.L  D5,D0
    MOVE.L  #1000,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVE.L  D4,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    BRA.S   .store_result

.set_zero:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,-12(A5)

.return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdatePresetEntryCache   (UpdatePresetEntryCache??)
; ARGS:
;   stack +4: presetRecord (struct pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   GCOMMAND_ComputePresetIncrement
; READS:
;   32(A3), 36(A3), 55(A3)
; WRITES:
;   36(A3)..
; DESC:
;   Computes four cached values from presetRecord fields via GCOMMAND_ComputePresetIncrement.
; NOTES:
;   Field layout is inferred; cache is written starting at offset 36.
;------------------------------------------------------------------------------
GCOMMAND_UpdatePresetEntryCache:
LAB_0D8E:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  32(A3),D6
    TST.L   D6
    BMI.S   LAB_0D90

    MOVEQ   #0,D7
    LEA     36(A3),A0
    LEA     55(A3),A1
    MOVE.L  A0,-8(A5)
    MOVE.L  A1,-16(A5)

LAB_0D8F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D90

    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_ComputePresetIncrement

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    ADDQ.L  #4,-8(A5)
    ADDQ.L  #1,-16(A5)
    BRA.S   LAB_0D8F

LAB_0D90:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ResetPresetWorkTables   (ResetPresetWorkTables??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   LAB_22F6..LAB_22FC, LAB_1FA3
; DESC:
;   Clears the preset work tables and resets the pending flag.
; NOTES:
;   Each table entry is 24 bytes; the first longword is set to index+4.
;------------------------------------------------------------------------------
GCOMMAND_ResetPresetWorkTables:
LAB_0D91:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #LAB_22F6,-8(A5)

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,4(A0)
    MOVE.L  D0,8(A0)
    MOVE.L  D0,12(A0)
    MOVE.L  D0,16(A0)
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-8(A5)
    BRA.S   .entry_loop

.done:
    CLR.W   LAB_1FA3
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_InitPresetWorkEntry   (InitPresetWorkEntry??)
; ARGS:
;   stack +4: entryPtr (work entry)
;   stack +8: presetIndex
;   stack +12: span
;   stack +16: baseValue
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0, A3
; CALLS:
;   GCOMMAND_SetPresetEntry
; READS:
;   LAB_22F4
; WRITES:
;   [entryPtr]
; DESC:
;   Initializes a preset work entry based on index/span parameters.
; NOTES:
;   If index is invalid, forces entry index to 6 and updates the preset table.
;------------------------------------------------------------------------------
GCOMMAND_InitPresetWorkEntry:
LAB_0D94:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    TST.L   D7
    BMI.S   .invalid_index

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .invalid_index

    MOVE.L  D7,(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,16(A3)
    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   .span_small

    MOVE.L  D5,12(A3)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     LAB_22F4,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,4(A3)
    MOVEQ   #2,D1
    MOVE.L  D1,20(A3)
    MOVEQ   #1,D1
    MOVE.L  D1,8(A3)
    BRA.S   .done

.span_small:
    TST.L   D6
    BMI.S   .done

    MOVE.L  D0,12(A3)
    MOVE.L  D0,4(A3)
    MOVE.L  D0,20(A3)
    MOVE.L  D0,8(A3)
    BRA.S   .done

.invalid_index:
    MOVEQ   #6,D0
    MOVE.L  D0,(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,12(A3)
    MOVE.L  D1,4(A3)
    MOVE.L  D1,20(A3)
    MOVE.L  D1,8(A3)
    PEA     1365.W
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadPresetWorkEntries   (LoadPresetWorkEntries??)
; ARGS:
;   stack +4: presetRecord
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0, A3
; CALLS:
;   GCOMMAND_InitPresetWorkEntry
; READS:
;   32(A3), 36(A3), 55(A3)
; WRITES:
;   LAB_22F6..LAB_22FC
; DESC:
;   Seeds the preset work tables using the current preset record fields.
; NOTES:
;   Writes four entries into the LAB_22F6 block (stride 24 bytes).
;------------------------------------------------------------------------------
GCOMMAND_LoadPresetWorkEntries:
LAB_0D98:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    LEA     LAB_22F6,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  55(A3,D7.L),D0
    MOVE.L  D7,D1
    ASL.L   #2,D1
    MOVE.L  36(A3,D1.L),-(A7)
    MOVE.L  32(A3),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   GCOMMAND_InitPresetWorkEntry

    LEA     16(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .entry_loop

.done:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_TickPresetWorkEntries   (TickPresetWorkEntries??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   LAB_22F6..LAB_22FC
; WRITES:
;   LAB_22F6..LAB_22FC
; DESC:
;   Advances preset work entry accumulators and clamps them to bounds.
; NOTES:
;   Accumulator 16(A0) uses 1000 as the carry threshold.
;------------------------------------------------------------------------------
GCOMMAND_TickPresetWorkEntries:
LAB_0D9B:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #LAB_22F6,-4(A5)

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVEA.L -4(A5),A0
    TST.L   20(A0)
    BEQ.S   .maybe_advance

    SUBQ.L  #1,20(A0)
    BRA.S   .next_entry

.maybe_advance:
    MOVE.L  12(A0),D0
    TST.L   D0
    BLE.S   .next_entry

    MOVE.L  8(A0),D1
    CMP.L   4(A0),D1
    BGE.S   .next_entry

    ADD.L   D0,16(A0)

.carry_loop:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),D0
    CMPI.L  #1000,D0
    BLT.S   .check_bounds

    ADDQ.L  #1,8(A0)
    SUBI.L  #1000,16(A0)
    BRA.S   .carry_loop

.check_bounds:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),D0
    MOVE.L  8(A0),D1
    CMP.L   D0,D1
    BLE.S   .next_entry

    CLR.L   12(A0)
    MOVE.L  4(A0),8(A0)

.next_entry:
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-4(A5)
    BRA.S   .entry_loop

.done:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerBounds   (Cache banner geometry parameters used by the display routines.)
; ARGS:
;   stack +4: left
;   stack +8: top
;   stack +12: right
;   stack +16: bottom
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A6
; CALLS:
;   GCOMMAND_ComputePresetIncrement, _LVODisable, _LVOEnable
; READS:
;   LAB_2263
; WRITES:
;   LAB_22FF, LAB_2300, LAB_2301, LAB_2302,
;   LAB_2303..LAB_2306, LAB_1FA4
; DESC:
;   Cache banner geometry parameters used by the display routines.
; NOTES:
;   Sets LAB_1FA4 to request a banner-table rebuild on the next tick.
;------------------------------------------------------------------------------

; Cache banner geometry parameters used by the display routines.
GCOMMAND_UpdateBannerBounds:
LAB_0DA2:
    LINK.W  A5,#-4
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.L  20(A5),D4
    MOVE.L  D7,LAB_22FF
    MOVE.L  D6,LAB_2300
    MOVE.L  D5,LAB_2301
    MOVE.L  D4,LAB_2302
    TST.W   LAB_2263
    BEQ.S   .use_zero

    MOVEQ   #0,D0
    BRA.S   .seed_base

.use_zero:
    MOVEQ   #17,D0

.seed_base:
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,LAB_2303
    MOVE.L  -4(A5),(A7)
    MOVE.L  D6,-(A7)
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,LAB_2304
    MOVE.L  -4(A5),(A7)
    MOVE.L  D5,-(A7)
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,LAB_2305
    MOVE.L  -4(A5),(A7)
    MOVE.L  D4,-(A7)
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,LAB_2306
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #1,LAB_1FA4
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D4-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_RebuildBannerTablesFromBounds   (RebuildBannerTablesFromBounds??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   GCOMMAND_InitPresetWorkEntry, GCOMMAND_TickPresetWorkEntries
; READS:
;   LAB_22FF..LAB_2306, LAB_22F5..LAB_22FD, LAB_1DE0..LAB_1DE3, LAB_2263
; WRITES:
;   LAB_22F6..LAB_22FC, LAB_1E2B, LAB_1E58
; DESC:
;   Rebuilds banner tables from the cached bounds and preset definitions.
; NOTES:
;   Uses LAB_1DE0..LAB_1DE3 as fallback values when preset tables are negative.
;------------------------------------------------------------------------------
GCOMMAND_RebuildBannerTablesFromBounds:
LAB_0DA5:
    LINK.W  A5,#-24
    MOVEM.L D2/D6-D7/A2-A3,-(A7)
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEA.L -4(A5),A0
    ADDA.W  #$80,A0
    MOVEA.L -8(A5),A1
    ADDA.W  #$80,A1
    MOVE.L  A0,-12(A5)
    MOVE.L  A1,-16(A5)
    TST.W   LAB_2263
    BEQ.S   .use_zero

    MOVEQ   #0,D0
    BRA.S   .seed_entries

.use_zero:
    MOVEQ   #17,D0

.seed_entries:
    MOVE.L  D0,D6
    MOVE.L  LAB_2303,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_22FF,-(A7)
    PEA     LAB_22F6
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  LAB_2304,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2300,-(A7)
    PEA     LAB_22F8
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  LAB_2305,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2301,-(A7)
    PEA     LAB_22FA
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  LAB_2306,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2302,-(A7)
    PEA     LAB_22FC
    BSR.W   GCOMMAND_InitPresetWorkEntry

    LEA     52(A7),A7
    MOVEQ   #0,D7

.row_loop:
    MOVEQ   #17,D0
    CMP.L   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22F7,D1
    TST.L   D1
    BPL.S   .use_preset0

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE0,D2
    BRA.S   .store_entry0

.use_preset0:
    MOVE.L  LAB_22F6,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    ADD.L   D1,D1
    ADDA.L  D1,A1
    MOVEQ   #0,D1
    MOVE.W  (A1),D1
    MOVE.L  D1,D2

.store_entry0:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,6(A0,D0.L)
    MOVEA.L -16(A5),A1
    MOVE.W  D2,6(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22F9,D1
    TST.L   D1
    BPL.S   .use_preset1

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE1,D2
    BRA.S   .store_entry1

.use_preset1:
    MOVE.L  LAB_22F8,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

.store_entry1:
    MOVE.W  D2,10(A0,D0.L)
    MOVE.W  D2,10(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22FB,D1
    TST.L   D1
    BPL.S   .use_preset2

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE2,D2
    BRA.S   .store_entry2

.use_preset2:
    MOVE.L  LAB_22FA,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

.store_entry2:
    MOVE.W  D2,14(A0,D0.L)
    MOVE.W  D2,14(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22FD,D1
    TST.L   D1
    BPL.S   .use_preset3

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE3,D2
    BRA.S   .store_entry3

.use_preset3:
    MOVE.L  LAB_22FC,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A0
    ADDA.L  D2,A0
    ADD.L   D1,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.W  (A0),D1
    MOVE.L  D1,D2

.store_entry3:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,18(A0,D0.L)
    MOVE.W  D2,18(A1,D0.L)
    BSR.W   GCOMMAND_TickPresetWorkEntries

    ADDQ.L  #1,D7
    BRA.W   .row_loop

.done:
    CLR.W   LAB_1FA4
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_GetBannerChar   (Return the current banner character stored at LAB_1E2B.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Return the current banner character stored at LAB_1E2B.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Return the current banner character stored at LAB_1E2B.
GCOMMAND_GetBannerChar:
LAB_0DB2:
    LINK.W  A5,#-4
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerRowPointers   (UpdateBannerRowPointers??)
; ARGS:
;   stack +4: tablePtr (banner table base)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, D6-D7, A0-A1, A3
; CALLS:
;   (none)
; READS:
;   LAB_230B, LAB_230C
; WRITES:
;   [tablePtr + index*32 + $2FA], [tablePtr + index*32 + $2FE]
; DESC:
;   Updates pointer words in the banner table based on current/previous indices.
; NOTES:
;   Special-cases LAB_230B == 97 to use the tail entry at offset 3876.
;------------------------------------------------------------------------------
GCOMMAND_UpdateBannerRowPointers:
LAB_0DB3:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  LAB_230B,D0
    MOVE.L  LAB_230C,D1
    CMP.L   D0,D1
    BEQ.W   .return

    ASL.L   #5,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D2
    CLR.W   D2
    SWAP    D2
    MOVE.L  D2,D7
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D0
    MOVE.L  #$ffff,D2
    AND.L   D2,D0
    MOVE.L  D0,D6
    ASL.L   #5,D1
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    CLR.W   D0
    SWAP    D0
    MOVE.L  D1,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D0,0(A3,D3.L)
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    AND.L   D2,D0
    MOVE.L  D1,D3
    ADDI.L  #$2fe,D3
    MOVE.W  D0,0(A3,D3.L)
    MOVE.L  LAB_230B,D0
    MOVEQ   #97,D1
    CMP.L   D1,D0
    BNE.S   .store_prev_ptr

    ASL.L   #5,D0
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.L  D0,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D1,0(A3,D3.L)
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    ANDI.L  #$ffff,D1
    MOVE.L  D0,D2
    ADDI.L  #$2fe,D2
    MOVE.W  D1,0(A3,D2.L)
    BRA.S   .return

.store_prev_ptr:
    ASL.L   #5,D0
    MOVE.L  D0,D1
    ADDI.L  #$2fa,D1
    MOVE.W  D7,0(A3,D1.L)
    MOVE.L  D0,D1
    ADDI.L  #$2fe,D1
    MOVE.W  D6,0(A3,D1.L)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_BuildBannerRow   (BuildBannerRow??)
; ARGS:
;   stack +4: bitmapPtr
;   stack +8: tablePtr (banner table base)
;   stack +12: rowIndex (or 0 for fallback)
;   stack +16: fallbackIndex
;   stack +20: baseOffset
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A6
; CALLS:
;   GCOMMAND_UpdateBannerRowPointers
; READS:
;   LAB_22F6..LAB_22FD, LAB_1FA5
; WRITES:
;   [tablePtr + offsets], LAB_1FA5?
; DESC:
;   Writes banner row pointer fields and color values into the table.
; NOTES:
;   Uses rowIndex when > 0, otherwise fallbackIndex. Row stride is 32 bytes.
;------------------------------------------------------------------------------
GCOMMAND_BuildBannerRow:
LAB_0DB6:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEA.L A2,A0
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,730(A0)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D0
    MOVE.L  #$ffff,D1
    AND.L   D1,D0
    MOVE.W  D0,734(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.L  8(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,694(A0)
    MOVE.L  12(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,702(A0)
    MOVE.L  16(A3),D0
    ADD.L   D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,706(A0)
    MOVEM.L A0,-4(A5)
    TST.L   D7
    BLE.S   .use_fallback_index

    MOVE.L  D7,D0
    BRA.S   .index_ready

.use_fallback_index:
    MOVE.L  D6,D0

.index_ready:
    MOVE.L  D0,D4
    SUBQ.L  #1,D4
    TST.W   LAB_1FA5
    BEQ.S   .write_from_tables

    TST.L   D4
    BLE.W   .write_defaults

.write_from_tables:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.L  LAB_22F6,D0
    ASL.L   #7,D0
    LEA     LAB_22F5,A1
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22F7,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22F8,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22F9,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22FA,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22FB,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22FC,D0
    ASL.L   #7,D0
    ADDA.L  D0,A1
    MOVE.L  LAB_22FD,D0
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVE.W  (A1),(A6)
    MOVE.L  A6,-12(A5)
    BRA.S   .update_row_ptrs

.write_defaults:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.W  #$f0,D0
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)

.update_row_ptrs:
    MOVE.L  -4(A5),-(A7)
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    MOVEM.L -44(A5),D2/D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ClearBannerQueue   (ClearBannerQueue??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D7, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   LAB_1F41, LAB_1F48
; DESC:
;   Clears the banner queue buffer and resets the queue state.
; NOTES:
;   Zeros 98 bytes in LAB_1F48 and sets LAB_1F41 to -1.
;------------------------------------------------------------------------------
GCOMMAND_ClearBannerQueue:
LAB_0DBC:
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),LAB_1F41
    MOVEQ   #0,D7

.clear_loop:
    MOVEQ   #98,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     LAB_1F48,A0
    ADDA.L  D7,A0
    CLR.B   (A0)
    ADDQ.L  #1,D7
    BRA.S   .clear_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D6-D7,-(A7)
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEQ   #0,D7

LAB_0DBF:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.W   LAB_0DC0

    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    ADDQ.L  #1,D7
    BRA.W   LAB_0DBF

LAB_0DC0:
    MOVE.L  LAB_1FA8,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEM.L (A7)+,D2-D3/D6-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ConsumeBannerQueueEntry   (ConsumeBannerQueueEntry??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1
; CALLS:
;   (none)
; READS:
;   LAB_230A, LAB_1F48, LAB_1F56
; WRITES:
;   LAB_1F41, LAB_1F45, LAB_1DEE, LAB_1FA9, LAB_1E89, LAB_1F48
; DESC:
;   Consumes the current banner queue entry and updates highlight flags.
; NOTES:
;   Recognizes 0xFF and 0xFE as control bytes with special handling.
;------------------------------------------------------------------------------
GCOMMAND_ConsumeBannerQueueEntry:
LAB_0DC1:
    MOVE.L  D2,-(A7)
    LEA     LAB_1F48,A0
    MOVE.W  LAB_230A,D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    TST.B   (A1)
    BEQ.S   .clear_entry

    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   .check_0xfe

    MOVE.W  LAB_1F56,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_1F41
    MOVEQ   #1,D2
    MOVE.B  D2,LAB_1DEE
    BRA.S   .clear_entry

.check_0xfe:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #127,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .store_value

    MOVE.W  #$101,LAB_1F45
    BRA.S   .clear_entry

.store_value:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVE.W  D1,LAB_1F45

.clear_entry:
    ADDA.W  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.W  LAB_1F41,D1
    BLT.S   .return

    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,LAB_1F41
    MOVE.B  #$2,LAB_1FA9
    TST.W   D2
    BPL.S   .return

    MOVE.B  D0,LAB_1DEE
    MOVE.B  #$1,LAB_1E89

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_RefreshBannerTables   (RefreshBannerTables??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1
; CALLS:
;   GCOMMAND_BuildBannerRow
; READS:
;   LAB_2307, LAB_2308, LAB_1FA8, LAB_221C..LAB_221E, LAB_1E2B, LAB_1E58
; WRITES:
;   LAB_1F2F, LAB_1F31, LAB_1F33
; DESC:
;   Rebuilds banner rows for both tables and refreshes row pointer globals.
; NOTES:
;   Uses LAB_2307 as the active row index and LAB_1FA8 as the base offset.
;------------------------------------------------------------------------------
GCOMMAND_RefreshBannerTables:
LAB_0DC6:
    MOVE.L  LAB_2307,-(A7)
    PEA     98.W
    MOVE.L  LAB_1FA8,-(A7)
    PEA     LAB_1E2B
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   GCOMMAND_BuildBannerRow

    MOVEQ   #88,D0
    ADD.L   LAB_2307,D0
    MOVE.L  D0,(A7)
    PEA     98.W
    MOVE.L  LAB_1FA8,-(A7)
    PEA     LAB_1E58
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   GCOMMAND_BuildBannerRow

    LEA     36(A7),A7
    MOVE.L  LAB_2308,D0
    MOVEA.L LAB_221C,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F2F
    MOVEA.L LAB_221D,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F31
    MOVEA.L LAB_221E,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F33
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ServiceHighlightMessages   (ServiceHighlightMessages??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1, A6
; CALLS:
;   _LVOGetMsg, _LVOReplyMsg, GCOMMAND_LoadPresetWorkEntries,
;   GCOMMAND_RefreshBannerTables, GCOMMAND_ConsumeBannerQueueEntry,
;   GCOMMAND_ResetPresetWorkTables, GCOMMAND_TickPresetWorkEntries,
;   LAB_0C93, LAB_0C97, GCOMMAND_MapKeycodeToPreset
; READS:
;   LAB_1FA6, LAB_1FA3, LAB_1DC5, LAB_230D..LAB_230F
; WRITES:
;   LAB_1FA6, LAB_230D..LAB_230F, message fields at 20/24/28/32/52/54(A0)
; DESC:
;   Polls the highlight message port, processes active messages, and updates
;   banner/preset state each tick.
; NOTES:
;   Replies to messages when their countdown at 52(A0) reaches zero.
;------------------------------------------------------------------------------
GCOMMAND_ServiceHighlightMessages:
LAB_0DC7:
    TST.L   LAB_1FA6
    BNE.S   .update_tables

    MOVEA.L LAB_1DC5,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,LAB_1FA6
    TST.L   D0
    BEQ.S   .update_tables

    MOVEA.L D0,A0
    MOVE.L  32(A0),D1
    TST.L   D1
    BMI.S   .maybe_store_msg

    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_LoadPresetWorkEntries

    ADDQ.W  #4,A7

.maybe_store_msg:
    MOVEA.L LAB_1FA6,A0
    MOVE.L  20(A0),LAB_230D
    MOVE.L  24(A0),LAB_230E
    MOVE.L  28(A0),LAB_230F
    MOVE.B  54(A0),D0
    TST.B   D0
    BEQ.S   .update_tables

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   GCOMMAND_MapKeycodeToPreset

    ADDQ.W  #4,A7
    MOVEA.L LAB_1FA6,A0
    CLR.B   54(A0)

.update_tables:
    BSR.W   GCOMMAND_RefreshBannerTables

    BSR.W   GCOMMAND_ConsumeBannerQueueEntry

    TST.L   LAB_1FA6
    BEQ.W   .no_active_msg

    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .handle_active_msg

    JSR     LAB_0C97(PC)

    BRA.S   .check_countdown

.handle_active_msg:
    TST.W   LAB_1FA3
    BEQ.S   .tick_active_msg

    BSR.W   GCOMMAND_ResetPresetWorkTables

.tick_active_msg:
    BSR.W   GCOMMAND_TickPresetWorkEntries

    MOVEA.L LAB_1FA6,A1
    JSR     LAB_0C93(PC)

    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVEA.L LAB_1FA6,A0
    MOVE.W  D1,52(A0)

.check_countdown:
    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .return

    MOVE.L  LAB_230D,20(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230E,24(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230F,28(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.W  D1,52(A0)
    CLR.L   32(A0)
    MOVEA.L LAB_1FA6,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOReplyMsg(A6)

    CLR.L   LAB_1FA6
    BRA.S   .return

.no_active_msg:
    JSR     LAB_0C97(PC)

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_TickHighlightState   (TickHighlightState??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A4
; CALLS:
;   GCOMMAND_RebuildBannerTablesFromBounds, GCOMMAND_ServiceHighlightMessages
; READS:
;   LAB_1FA4, LAB_1FA7, LAB_1FA8, LAB_2307, LAB_2312, LAB_230A, LAB_230C
; WRITES:
;   LAB_1FA8, LAB_2307, LAB_2311, LAB_2309, LAB_230A, LAB_230B, LAB_230C
; DESC:
;   Advances highlight/cycle counters and updates related globals.
; NOTES:
;   Counter wrap thresholds inferred from constants (98, 88, 32).
;------------------------------------------------------------------------------
GCOMMAND_TickHighlightState:
LAB_0DCF:
    MOVEM.L D2/A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    TST.W   LAB_1FA4
    BEQ.S   .skip_rebuild

    BSR.W   GCOMMAND_RebuildBannerTablesFromBounds

.skip_rebuild:
    ADDQ.L  #1,LAB_1FA8
    MOVE.L  LAB_2307,LAB_2308
    MOVEQ   #98,D0
    CMP.L   LAB_1FA8,D0
    BNE.S   .advance_indices

    MOVEQ   #0,D1
    MOVE.L  D1,LAB_1FA8
    MOVE.L  LAB_1FA7,D2
    MOVE.L  D2,LAB_2307
    MOVE.L  LAB_2312,D2
    MOVE.L  D2,LAB_2311
    BRA.S   .update_counters

.advance_indices:
    MOVEQ   #88,D1
    ADD.L   D1,D1
    ADD.L   D1,LAB_2307
    MOVEQ   #32,D1
    ADD.L   D1,LAB_2311

.update_counters:
    MOVE.W  LAB_230A,D1
    MOVE.W  D1,LAB_2309
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,LAB_230A
    BGE.S   .maybe_reset_slot

    MOVE.W  #$61,LAB_230A

.maybe_reset_slot:
    MOVE.L  LAB_230C,D1
    MOVE.L  D1,LAB_230B
    ADDQ.L  #1,LAB_230C
    CMP.L   LAB_230C,D0
    BNE.S   .service_messages

    CLR.L   LAB_230C

.service_messages:
    BSR.W   GCOMMAND_ServiceHighlightMessages

    MOVEM.L (A7)+,D2/A4
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ResetHighlightMessages   (ResetHighlightMessages??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   LAB_1FA6, LAB_230D, LAB_230E, LAB_230F
; WRITES:
;   LAB_22A6.., LAB_1FA6
; DESC:
;   Clears pending highlight message records and resets message state.
; NOTES:
;   Writes into a sequence of structs starting at LAB_22A6.
;------------------------------------------------------------------------------
GCOMMAND_ResetHighlightMessages:
LAB_0DD5:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)

    TST.L   LAB_1FA6
    BEQ.S   .clear_message_slots

    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230D,20(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230E,24(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230F,28(A0)

.clear_message_slots:
    MOVEQ   #0,D7
    MOVE.L  #LAB_22A6,-4(A5)

.slot_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .clear_queue

    MOVEA.L -4(A5),A0
    CLR.W   52(A0)
    CLR.B   54(A0)
    ADDQ.L  #1,D7
    MOVEQ   #80,D0
    ADD.L   D0,D0
    ADD.L   D0,-4(A5)
    BRA.S   .slot_loop

.clear_queue:
    MOVEQ   #98,D0
    MOVEQ   #0,D1
    LEA     LAB_1F48,A0

.queue_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.queue_loop

    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_BuildBannerBlock   (BuildBannerBlock??)
; ARGS:
;   stack +4: outPtr
;   stack +8: count
;   stack +12: srcPtr
;   stack +16: argByte0
;   stack +20: argWord0
;   stack +24: argByte1
; RET:
;   D0: outPtr after last entry
; CLOBBERS:
;   D0-D7, A0-A3, A6
; CALLS:
;   GCOMMAND_ComputePresetIncrement, GCOMMAND_InitPresetWorkEntry,
;   GCOMMAND_TickPresetWorkEntries
; READS:
;   LAB_2263, LAB_22F5..LAB_22FD, LAB_1DE0..LAB_1DE3
; WRITES:
;   [outPtr] (writes 32-byte entries)
; DESC:
;   Emits a block of banner/copper entries using preset tables and source bytes.
; NOTES:
;   Entry count comes from stack +8; uses LAB_2263 to optionally force count=0.
;------------------------------------------------------------------------------
GCOMMAND_BuildBannerBlock:
LAB_0DDA:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.B  23(A5),D6
    MOVE.W  26(A5),D5
    MOVE.B  31(A5),D4
    MOVE.L  A3,-4(A5)
    TST.W   LAB_2263
    BEQ.S   .use_count

    MOVEQ   #0,D0
    BRA.S   .seed_tables

.use_count:
    MOVE.L  D7,D0

.seed_tables:
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-12(A5)
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    CLR.L   -(A7)
    PEA     LAB_22F6
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     5.W
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     5.W
    PEA     LAB_22F8
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     6.W
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     6.W
    PEA     LAB_22FA
    BSR.W   GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     7.W
    BSR.W   GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     7.W
    PEA     LAB_22FC
    BSR.W   GCOMMAND_InitPresetWorkEntry

    LEA     68(A7),A7
    CLR.L   -8(A5)

.emit_loop:
    MOVE.L  -8(A5),D0
    CMP.L   D7,D0
    BGE.W   .done

    MOVE.B  (A2),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    ADD.B   D4,(A2)
    MOVE.B  D6,1(A0)
    MOVE.W  D5,2(A0)
    MOVE.W  #$188,4(A0)
    MOVE.L  LAB_22F7,D0
    TST.L   D0
    BPL.S   .use_preset0

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE0,D1
    BRA.S   .store_preset0

.use_preset0:
    MOVE.L  LAB_22F6,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset0:
    MOVE.W  D1,6(A0)
    MOVE.W  #$18a,8(A0)
    MOVE.L  LAB_22F9,D0
    TST.L   D0
    BPL.S   .use_preset1

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE1,D1
    BRA.S   .store_preset1

.use_preset1:
    MOVE.L  LAB_22F8,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset1:
    MOVE.W  D1,10(A0)
    MOVE.W  #$18c,12(A0)
    MOVE.L  LAB_22FB,D0
    TST.L   D0
    BPL.S   .use_preset2

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE2,D1
    BRA.S   .store_preset2

.use_preset2:
    MOVE.L  LAB_22FA,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset2:
    MOVE.W  D1,14(A0)
    MOVE.W  #$18e,16(A0)
    MOVE.L  LAB_22FD,D0
    TST.L   D0
    BPL.S   .use_preset3

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE3,D1
    BRA.S   .store_preset3

.use_preset3:
    MOVE.L  LAB_22FC,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    ADDA.L  D1,A1
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVE.L  D0,D1

.store_preset3:
    MOVE.W  D1,18(A0)
    MOVE.W  #$84,20(A0)
    LEA     32(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$86,24(A0)
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,26(A0)
    MOVE.W  #$8a,28(A0)
    CLR.W   30(A0)
    BSR.W   GCOMMAND_TickPresetWorkEntries

    ADDQ.L  #1,-8(A5)
    MOVEQ   #32,D0
    ADD.L   D0,-4(A5)
    BRA.W   .emit_loop

.done:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_CopyImageDataToBitmap   (CopyImageDataToBitmap??)
; ARGS:
;   stack +4: bitmapPtr
;   stack +8: tablePtr
;   stack +12: length
;   stack +16: baseOffset
;   stack +20: argWord0
;   stack +24: argByte0
; RET:
;   D0: tablePtr (echoed)
; CLOBBERS:
;   D0-D7, A0-A3, A6
; CALLS:
;   GCOMMAND_BuildBannerBlock
; READS:
;   LAB_2229, [A3+8/12/16]
; WRITES:
;   [tablePtr] (copper list entries)
; DESC:
;   Emits a banner copper-list block into tablePtr using source offsets.
; NOTES:
;   Argument layout inferred from call sites; exact semantics still TBD.
;------------------------------------------------------------------------------
GCOMMAND_CopyImageDataToBitmap:
COPY_IMAGE_DATA_TO_BITMAP:
    LINK.W  A5,#-4
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3
    UseLinkStackLong    MOVEA.L,2,A2
    UseLinkStackLong    MOVE.L,3,D7
    UseLinkStackLong    MOVE.L,4,D6
    MOVE.W  30(A5),D5
    MOVE.B  35(A5),D4

    MOVE.L  A2,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$8e,(A0)
    MOVE.B  #$d9,1(A0)
    MOVE.W  #$fffe,2(A0)
    MOVE.W  #$92,4(A0)
    MOVE.W  #$30,6(A0)
    MOVE.W  #$94,8(A0)
    MOVE.W  #$d8,10(A0)
    MOVE.W  #$8e,12(A0)
    MOVE.W  #$1769,14(A0)
    MOVE.W  #$90,16(A0)
    MOVE.W  #$ffc5,18(A0)
    MOVE.W  #$108,20(A0)
    MOVEQ   #88,D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$10a,24(A0)
    MOVE.W  D0,26(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,28(A0)
    MOVE.W  #$9306,30(A0)
    MOVE.W  #$102,32(A0)
    MOVEQ   #0,D1
    MOVE.W  D1,34(A0)
    MOVE.W  #$182,D2
    MOVE.W  D2,36(A0)
    MOVEQ   #3,D3
    MOVE.W  D3,38(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,40(A0)
    MOVE.L  LAB_2229,D0
    MOVE.L  D0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,42(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,44(A0)
    MOVE.L  LAB_2229,D1
    MOVE.L  #$ffff,D0
    AND.L   D0,D1
    MOVE.W  D1,46(A0)
    MOVE.W  #$180,48(A0)
    MOVE.W  D3,50(A0)
    MOVE.W  D2,52(A0)
    MOVE.W  D3,54(A0)
    MOVE.W  #$184,56(A0)
    MOVE.W  #$111,58(A0)
    MOVE.W  #$186,60(A0)
    MOVE.W  #$cc0,62(A0)
    MOVE.W  #$188,64(A0)
    MOVE.W  #$512,66(A0)
    MOVE.W  #$18a,68(A0)
    MOVE.W  #$16a,70(A0)
    MOVE.W  #$18c,72(A0)
    MOVE.W  #$555,74(A0)
    MOVE.W  #$18e,76(A0)
    MOVE.W  D3,78(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D1
    MOVE.B  D1,80(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,81(A0)
    MOVE.W  D5,82(A0)
    MOVE.W  #$e0,84(A0)
    MOVE.L  8(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,86(A0)
    MOVE.W  #$e2,88(A0)
    MOVE.L  8(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,90(A0)
    MOVE.W  #$e4,92(A0)
    MOVE.L  12(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,94(A0)
    MOVE.W  #$e6,96(A0)
    MOVE.L  12(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,98(A0)
    MOVE.W  #$e8,100(A0)
    MOVE.L  16(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,102(A0)
    MOVE.W  #$ea,104(A0)
    MOVE.L  16(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,106(A0)
    MOVE.W  D2,108(A0)
    MOVE.W  #$aaa,110(A0)
    MOVE.W  #$100,112(A0)
    MOVE.W  #$b306,114(A0)
    MOVE.W  #$84,116(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,118(A0)
    MOVE.W  #$86,120(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,122(A0)
    MOVE.W  #$8a,124(A0)
    CLR.W   126(A0)
    LEA     128(A0),A6
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  A1,-(A7)
    PEA     17.W
    MOVE.L  A6,-(A7)
    BSR.W   GCOMMAND_BuildBannerBlock

    LEA     24(A7),A7
    MOVEA.L 24(A5),A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,672(A0)
    MOVEA.L 24(A5),A1
    ADD.B   D4,(A1)
    MOVE.B  #$d9,673(A0)
    MOVE.W  D5,674(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,676(A0)
    MOVE.W  #$9306,678(A0)
    MOVE.W  #$182,D1
    MOVE.W  D1,680(A0)
    MOVE.W  #3,682(A0)
    MOVE.W  #$e0,D2
    MOVE.W  D2,684(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  D3,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,686(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,688(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  #$ffff,D1
    AND.L   D1,D3
    MOVE.W  D3,690(A0)
    MOVE.W  #$e4,692(A0)
    MOVE.L  12(A3),D3
    MOVE.L  D3,D0
    ADD.L   D6,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,694(A0)
    MOVE.W  #$e6,696(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.W  #$e8,700(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D3
    ADD.L   D6,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,702(A0)
    MOVE.W  #$ea,704(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,706(A0)
    MOVE.B  (A1),D0
    MOVE.B  D0,708(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,709(A0)
    MOVE.W  D5,710(A0)
    MOVE.W  D2,712(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D6,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.W  #$e2,716(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.W  #$182,720(A0)
    MOVE.W  #$aaa,722(A0)
    MOVE.W  #$100,724(A0)
    MOVE.W  #$b306,726(A0)
    MOVE.W  #$84,728(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,730(A0)
    MOVE.W  #$86,732(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,734(A0)
    MOVE.W  #$8a,736(A0)
    CLR.W   738(A0)
    LEA     740(A0),A1
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  24(A5),-(A7)
    PEA     98.W
    MOVE.L  A1,-(A7)
    BSR.W   GCOMMAND_BuildBannerBlock

    MOVE.L  D6,(A7)
    PEA     98.W
    CLR.L   -(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   GCOMMAND_BuildBannerRow

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.B  #$80,3916(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,3917(A0)
    MOVE.W  #$80fe,3918(A0)
    MOVE.W  #$100,3920(A0)
    MOVE.W  #$9306,3922(A0)
    MOVE.W  #$182,3924(A0)
    MOVE.W  #3,3926(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,3928(A0)
    MOVE.L  LAB_2229,D2
    MOVE.L  D2,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,3930(A0)
    MOVE.W  #$e2,D2
    MOVE.W  D2,3932(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  #$ffff,D2
    AND.L   D2,D3
    MOVE.W  D3,3934(A0)
    MOVEQ   #-1,D3
    MOVE.B  D3,3936(A0)
    MOVE.B  D3,3937(A0)
    MOVE.W  #$fffe,3938(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D3
    MOVE.B  D3,3876(A0)
    ADD.B   D4,(A1)
    MOVE.B  D0,3877(A0)
    MOVE.W  D5,3878(A0)
    MOVE.W  D1,3880(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3882(A0)
    MOVE.W  #$e2,3884(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3886(A0)
    MOVE.W  #$e4,3888(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3890(A0)
    MOVE.W  #$e6,3892(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3894(A0)
    MOVE.W  #$e8,3896(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3898(A0)
    MOVE.W  #$ea,3900(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3902(A0)
    MOVE.W  #$84,3904(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,3906(A0)
    MOVE.W  #$86,3908(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,3910(A0)
    MOVE.W  #$8a,3912(A0)
    CLR.W   3914(A0)

    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_BuildBannerTables   (BuildBannerTables??)
; ARGS:
;   stack +8: arg0 (byte, low byte used)
;   stack +12: arg1 (word, low word used)
;   stack +16: arg2 (byte, low byte used)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A6
; CALLS:
;   _LVODisable, _LVOEnable, GCOMMAND_ResetPresetWorkTables,
;   GCOMMAND_ClearBannerQueue, GCOMMAND_CopyImageDataToBitmap
; READS:
;   LAB_1FA7, LAB_2312, GLOB_REF_696_400_BITMAP
; WRITES:
;   LAB_1FA8, LAB_2307, LAB_2308, LAB_2309..LAB_230C, LAB_2311, LAB_1D31, LAB_1F45
; DESC:
;   Resets banner-related globals and rebuilds the banner tables into the bitmap.
; NOTES:
;   Argument bytes/words are forwarded into GCOMMAND_CopyImageDataToBitmap calls.
;------------------------------------------------------------------------------
GCOMMAND_BuildBannerTables:
LAB_0DE8:
    LINK.W  A5,#-4
    MOVEM.L D2/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  14(A5),D6
    MOVE.B  19(A5),D5
    MOVE.B  D7,-1(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    BSR.W   GCOMMAND_ResetPresetWorkTables

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1FA8
    MOVE.L  D0,LAB_2308
    MOVE.L  LAB_1FA7,D0
    MOVE.L  D0,LAB_2307
    MOVE.L  LAB_2312,LAB_2311
    MOVEQ   #97,D0
    MOVE.W  D0,LAB_2309
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_230A
    MOVEQ   #84,D0
    MOVE.L  D0,LAB_230B
    MOVEQ   #85,D0
    MOVE.L  D0,LAB_230C
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -1(A5)
    MOVE.L  LAB_2307,-(A7)
    PEA     2992.W
    PEA     LAB_1E2B
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   GCOMMAND_CopyImageDataToBitmap

    MOVE.B  D7,-1(A5)
    MOVEQ   #88,D0
    ADD.L   LAB_2307,D0
    MOVEQ   #0,D1
    MOVE.W  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D5,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  D0,-(A7)
    PEA     3080.W
    PEA     LAB_1E58
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   GCOMMAND_CopyImageDataToBitmap

    BSR.W   GCOMMAND_ClearBannerQueue

    MOVE.W  #1,LAB_1D31
    MOVE.W  #$100,LAB_1F45
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D2/D5-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ResetBannerFadeState   (ResetBannerFadeState??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, A7
; CALLS:
;   GCOMMAND_BuildBannerTables
; READS:
;   LAB_1FAF
; WRITES:
;   LAB_1FAF, LAB_2310, LAB_2312
; DESC:
;   Resets banner fade parameters when the pending flag is set.
; NOTES:
;   Initializes LAB_2310/LAB_2312 with fixed offsets after calling
;   GCOMMAND_BuildBannerTables.
;------------------------------------------------------------------------------
GCOMMAND_ResetBannerFadeState:
LAB_0DE9:
    TST.W   LAB_1FAF
    BEQ.S   LAB_0DEA

    CLR.W   LAB_1FAF
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   GCOMMAND_BuildBannerTables

    LEA     12(A7),A7
    MOVEQ   #64,D0
    ADD.L   D0,D0
    MOVE.L  D0,LAB_2310
    ADDI.L  #$264,D0
    MOVE.L  D0,LAB_2312

LAB_0DEA:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_AddBannerTableByteDelta   (AddBannerTableByteDelta??)
; ARGS:
;   stack +4: tablePtr
;   stack +8: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D7, A3
; CALLS:
;   (none)
; READS:
;   [tablePtr]
; WRITES:
;   [tablePtr]
; DESC:
;   Adds a signed byte delta to the first byte of a banner table.
; NOTES:
;   Used by GCOMMAND_AdjustBannerCopperOffset to bias banner data in-place.
;------------------------------------------------------------------------------
GCOMMAND_AddBannerTableByteDelta:
LAB_0DEB:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  19(A7),D7
    ADD.B   D7,(A3)
    MOVEM.L (A7)+,D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerOffset   (UpdateBannerOffset??)
; ARGS:
;   stack +8: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7
; CALLS:
;   GCOMMAND_UpdateBannerRowPointers
; READS:
;   LAB_230C
; WRITES:
;   LAB_230B, LAB_230C, LAB_1E2B, LAB_1E58
; DESC:
;   Applies a signed delta to LAB_230C, wrapping it into 0..97, then updates
;   banner tables via GCOMMAND_UpdateBannerRowPointers.
; NOTES:
;   Skips all work when delta is zero.
;------------------------------------------------------------------------------
GCOMMAND_UpdateBannerOffset:
LAB_0DEC:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    TST.B   D7
    BEQ.S   LAB_0DF0

    MOVE.L  LAB_230C,D0
    MOVE.L  D0,LAB_230B
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    SUB.L   D1,LAB_230C

LAB_0DED:
    MOVE.L  LAB_230C,D0
    MOVEQ   #98,D1
    CMP.L   D1,D0
    BLT.S   LAB_0DEE

    MOVEQ   #98,D1
    SUB.L   D1,LAB_230C
    BRA.S   LAB_0DED

LAB_0DEE:
    MOVE.L  LAB_230C,D0
    TST.L   D0
    BPL.S   LAB_0DEF

    MOVEQ   #98,D1
    ADD.L   D1,LAB_230C
    BRA.S   LAB_0DEE

LAB_0DEF:
    PEA     LAB_1E2B
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    PEA     LAB_1E58
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    ADDQ.W  #8,A7

LAB_0DF0:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_AdjustBannerCopperOffset   (AdjustBannerCopperOffset??)
; ARGS:
;   stack +4: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7, A0
; CALLS:
;   GCOMMAND_AddBannerTableByteDelta, GCOMMAND_UpdateBannerOffset
; READS:
;   LAB_1E2B
; WRITES:
;   LAB_1E2B, LAB_1E58
; DESC:
;   Applies a signed offset to banner tables when in range.
; NOTES:
;   Uses GCOMMAND_AddBannerTableByteDelta/GCOMMAND_UpdateBannerOffset helpers
;   to update the banner data.
;------------------------------------------------------------------------------
GCOMMAND_AdjustBannerCopperOffset:
LAB_0DF1:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVE.B  11(A5),D7
    LEA     LAB_1E2B,A0
    MOVE.L  A0,-4(A5)
    TST.B   D7
    BEQ.S   LAB_0DF2

    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #65,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BLT.S   LAB_0DF2

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   GCOMMAND_AddBannerTableByteDelta

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_1E58
    BSR.W   GCOMMAND_AddBannerTableByteDelta

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    BSR.W   GCOMMAND_UpdateBannerOffset

    LEA     12(A7),A7

LAB_0DF2:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SeedBannerDefaults   (Reset banner buffers to the default values embedded in the binary.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, A0
; CALLS:
;   GCOMMAND_BuildBannerTables
; READS:
;   (none)
; WRITES:
;   LAB_1E2B, LAB_1E58
; DESC:
;   Reset banner buffers to the default values embedded in the binary.
; NOTES:
;   Seeds both tables with fixed sentinel bytes and invokes GCOMMAND_BuildBannerTables.
;------------------------------------------------------------------------------

; Reset banner buffers to the default values embedded in the binary.
GCOMMAND_SeedBannerDefaults:
LAB_0DF3:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)
    PEA     1.W
    MOVE.L  #$fffe,-(A7)
    PEA     32.W
    BSR.W   GCOMMAND_BuildBannerTables

    MOVE.L  #LAB_1E2B,-4(A5)
    MOVEQ   #31,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D1
    MOVE.B  D1,1(A0)
    MOVEQ   #-2,D2
    MOVE.W  D2,2(A0)
    MOVEQ   #-8,D3
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVE.L  #LAB_1E58,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVE.B  D1,1(A0)
    MOVE.W  D2,2(A0)
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SeedBannerFromPrefs   (Seed banner buffers using values read from preferences.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   GCOMMAND_BuildBannerTables
; READS:
;   GLOB_REF_WORD_HEX_CODE_8E
; WRITES:
;   LAB_1E2B, LAB_1E58
; DESC:
;   Seed banner buffers using values read from preferences.
; NOTES:
;   Seeds the leading bytes from GLOB_REF_WORD_HEX_CODE_8E and applies defaults.
;------------------------------------------------------------------------------

; Seed banner buffers using values read from preferences.
GCOMMAND_SeedBannerFromPrefs:
LAB_0DF4:
    LINK.W  A5,#-4
    MOVE.L  D2,-(A7)
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   GCOMMAND_BuildBannerTables

    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,1(A0)
    MOVEQ   #-2,D1
    MOVE.W  D1,2(A0)
    MOVE.L  #LAB_1E58,-4(A5)
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D2
    MOVEA.L -4(A5),A0
    MOVE.B  D2,(A0)
    MOVE.B  D0,1(A0)
    MOVE.W  D1,2(A0)
    MOVE.L  -8(A5),D2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
