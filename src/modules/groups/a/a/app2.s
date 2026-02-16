; Rename this file to its proper purpose.

;------------------------------------------------------------------------------
; FUNC: ESQ_StoreCtrlSampleEntry   (StoreCtrlSampleEntryuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   DATA_COMMON_BSS_LONG_1B04, ED_StateRingWriteIndex
; WRITES:
;   ED_StateRingTable, ED_StateRingWriteIndex
; DESC:
;   Copies a null-terminated byte sequence from DATA_COMMON_BSS_LONG_1B04 into the current
;   5-byte slot of ED_StateRingTable, then advances the slot index.
; NOTES:
;   Slot index wraps at 20 entries. Entry size includes the terminator.
;------------------------------------------------------------------------------
ESQ_StoreCtrlSampleEntry:
    MOVEM.L D0-D1/A0-A1,-(A7)

    LEA     ED_StateRingTable,A0
    MOVE.L  ED_StateRingWriteIndex,D0
    MOVE.W  D0,D1
    MULS    #5,D1
    ADDA.W  D1,A0
    LEA     DATA_COMMON_BSS_LONG_1B04,A1

.lab_0051:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .lab_0051

    ADDQ.L  #1,D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BLT.S   .return

    MOVEQ   #0,D0

.return:
    MOVE.L  D0,ED_StateRingWriteIndex
    MOVEM.L (A7)+,D0-D1/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_Default   (SetCopperEffectDefault)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   (none)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Loads a default effect parameter pair (0/$3F) and updates copper tables.
; NOTES:
;   Likely tied to a highlight/flash effect; exact purpose unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_Default:
    MOVE.B  #0,D0
    MOVE.B  #$3f,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_Custom   (SetCopperEffectCustom)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   DATA_COMMON_STR_VALUE_1B05, CIAB_PRA
; WRITES:
;   CIAB_PRA, DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Forces CIAB_PRA bits 6/7 high, uses DATA_COMMON_STR_VALUE_1B05 as a parameter, and updates
;   the copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_Custom:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  DATA_COMMON_STR_VALUE_1B05,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_AllOn   (SetCopperEffectAllOn)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Clears CIAB_PRA bits 6/7, sets both parameters to $3F, and updates the
;   copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_AllOn:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BCLR    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #$3f,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_OffDisableHighlight   (SetCopperEffectOffDisableHighlight)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams, GCOMMAND_DisableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Sets CIAB_PRA bits to 01, clears both parameters, updates copper tables,
;   and disables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_OffDisableHighlight:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #0,D0
    MOVE.B  #0,D1
    JSR     ESQ_SetCopperEffectParams

    JSR     GCOMMAND_DisableHighlight

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_OnEnableHighlight   (SetCopperEffectOnEnableHighlight)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams, GCOMMAND_EnableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Sets CIAB_PRA bits to 11, loads parameters ($3F/0), updates copper tables,
;   and enables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_OnEnableHighlight:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #0,D1
    JSR     ESQ_SetCopperEffectParams

    JSR     GCOMMAND_EnableHighlight

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffectParams   (SetCopperEffectParams)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   ESQ_UpdateCopperListsFromParams
; READS:
;   (none)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Stores the effect parameters and regenerates the copper tables.
; NOTES:
;   Parameters are packed into DATA_COMMON_BSS_WORD_1B00..DATA_COMMON_BSS_BYTE_1B02 for ESQ_UpdateCopperListsFromParams.
;------------------------------------------------------------------------------
ESQ_SetCopperEffectParams:
    MOVE.B  D0,DATA_COMMON_BSS_BYTE_1B01
    MOVE.B  D1,DATA_COMMON_BSS_BYTE_1B02
    MOVE.W  #5,DATA_COMMON_BSS_WORD_1B00
    JSR     ESQ_UpdateCopperListsFromParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_UpdateCopperListsFromParams   (UpdateCopperListsFromParams)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D4, A0-A1, A6
; CALLS:
;   (none)
; READS:
;   DATA_COMMON_BSS_WORD_1B00, DATA_COMMON_BSS_BYTE_1B01, DATA_COMMON_BSS_BYTE_1B02, DATA_ESQ_BSS_LONG_1E25
; WRITES:
;   DATA_ESQ_CONST_LONG_1E22, DATA_ESQ_CONST_LONG_1E51
; DESC:
;   Expands packed effect parameters into copper list words for two tables.
; NOTES:
;   Writes 16 entries (DBF runs D4+1 iterations). Exact effect semantics unknown.
;------------------------------------------------------------------------------
ESQ_UpdateCopperListsFromParams:
    LEA     DATA_ESQ_BSS_LONG_1E25,A0
    MOVE.W  26(A0),D1
    MOVE.L  DATA_COMMON_BSS_WORD_1B00,D0
    LEA     DATA_ESQ_CONST_LONG_1E22,A0
    LEA     DATA_ESQ_CONST_LONG_1E51,A1
    ADDQ.L  #6,A0
    ADDQ.L  #6,A1
    ADD.B   D0,D0
    ADD.B   D0,D0
    ADD.W   D0,D0
    ADD.W   D0,D0
    SWAP    D0
    TST.B   D0
    BNE.S   .normalize_seed

    MOVEQ   #0,D0

.normalize_seed:
    ROL.L   #5,D0
    MOVEM.L D2-D4/A6,-(A7)
    MOVEA.W #$100,A6
    MOVE.W  D1,D3
    BCLR    #8,D3
    MOVEQ   #15,D4

.write_copper_loop:
    MOVE.W  A6,D2
    AND.W   D0,D2
    OR.W    D3,D2
    MOVE.W  D2,(A0)
    MOVE.W  D2,(A1)
    MOVE.W  D2,4(A0)
    MOVE.W  D2,4(A1)
    MOVE.W  D2,136(A0)
    MOVE.W  D2,136(A1)
    MOVE.W  D2,140(A0)
    MOVE.W  D2,140(A1)
    ADDQ.L  #8,A0
    ADDQ.L  #8,A1
    ROL.L   #1,D0
    DBF     D4,.write_copper_loop

    MOVE.W  D1,(A0)
    MOVE.W  D1,(A1)
    MOVE.W  D1,136(A0)
    MOVE.W  D1,136(A1)
    MOVEM.L (A7)+,D2-D4/A6
    MOVEQ   #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp   (NoOpStub)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ClearCopperListFlags   (ClearCopperListFlagsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   ESQ_CopperListBannerA, ESQ_CopperListBannerB
; DESC:
;   Clears the lead bytes of two copper list tables.
; NOTES:
;   Exact meaning of the cleared bytes is unknown.
;------------------------------------------------------------------------------
    MOVE.B  #0,D0
    MOVE.B  D0,ESQ_CopperListBannerA
    MOVE.B  D0,ESQ_CopperListBannerB
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_MoveCopperEntryTowardStart   (MoveCopperEntryTowardStartuncertain)
; ARGS:
;   stack +4: dstIndex (entry index, masked to 0..31)
;   stack +8: srcIndex (entry index, masked to 0..31)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Moves an entry toward the start of the table by shifting intervening
;   entries down and inserting the original value at dstIndex.
; NOTES:
;   Table entries are 4 bytes wide; the secondary table mirrors part of the range.
;------------------------------------------------------------------------------
ESQ_MoveCopperEntryTowardStart:
    MOVE.L  4(A7),D1
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D2
    ANDI.W  #$1f,D2
    ANDI.W  #$1f,D1
    LSL.W   #2,D1
    LSL.W   #2,D2
    LEA     ESQ_CopperStatusDigitsA,A1
    LEA     ESQ_CopperStatusDigitsB,A0
    ADDI.W  #0,D1
    ADDI.W  #0,D2
    MOVE.W  #$1c,D4
    MOVE.W  D2,D3
    SUBI.W  #4,D3
    MOVE.W  0(A1,D2.W),D0

.shift_down_loop:
    CMP.W   D1,D2
    BMI.W   .insert_entry

    MOVE.W  0(A1,D3.W),0(A1,D2.W)
    CMP.W   D2,D4
    BMI.W   .copy_secondary_if_in_range

    MOVE.W  0(A1,D3.W),0(A0,D2.W)

.copy_secondary_if_in_range:
    SUBI.W  #4,D2
    SUBI.W  #4,D3
    BRA.S   .shift_down_loop

.insert_entry:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D2,D4
    BMI.W   .return

    BEQ.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_MoveCopperEntryTowardEnd   (MoveCopperEntryTowardEnduncertain)
; ARGS:
;   stack +4: srcIndex (entry index, masked to 0..31)
;   stack +8: dstIndex (entry index, masked to 0..31)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Moves an entry toward the end of the table by shifting intervening
;   entries up and inserting the original value at dstIndex.
; NOTES:
;   Table entries are 4 bytes wide; the secondary table mirrors part of the range.
;------------------------------------------------------------------------------
ESQ_MoveCopperEntryTowardEnd:
    MOVE.L  4(A7),D1
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D2
    ANDI.W  #$1f,D2
    ANDI.W  #$1f,D1
    LSL.W   #2,D1
    LSL.W   #2,D2
    LEA     ESQ_CopperStatusDigitsA,A1
    LEA     ESQ_CopperStatusDigitsB,A0
    ADDI.W  #0,D1
    ADDI.W  #0,D2
    MOVE.W  #$20,D4
    MOVEQ   #4,D3
    ADD.W   D1,D3
    MOVE.W  0(A1,D1.W),D0

.shift_up_loop:
    CMP.W   D2,D1
    BPL.W   .insert_entry

    MOVE.W  0(A1,D3.W),0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .copy_secondary_if_in_range

    MOVE.W  0(A1,D3.W),0(A0,D1.W)

.copy_secondary_if_in_range:
    ADDI.W  #4,D1
    ADDI.W  #4,D3
    BRA.S   .shift_up_loop

.insert_entry:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsPrimary   (DecCopperListsPrimaryuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   ESQ_DecColorStep
; READS:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Decrements color components for entries in the primary copper lists.
; NOTES:
;   Updates the first 8 entries in both lists, then the next 24 entries only
;   in ESQ_CopperStatusDigitsA.
;------------------------------------------------------------------------------
ESQ_DecCopperListsPrimary:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     ESQ_CopperStatusDigitsA,A2
    LEA     ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_006A   (NoOpStub_006A)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp_006A:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsAltSkipIndex4   (DecCopperListsAltSkipIndex4uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   ESQ_DecColorStep
; READS:
;   DATA_ESQ_CONST_LONG_1E2E, DATA_ESQ_CONST_LONG_1E5B
; WRITES:
;   DATA_ESQ_CONST_LONG_1E2E, DATA_ESQ_CONST_LONG_1E5B
; DESC:
;   Decrements color components for entries in the alternate copper lists,
;   skipping the entry at byte offset 4.
; NOTES:
;   Skips when D5 == 4.
;------------------------------------------------------------------------------
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     DATA_ESQ_CONST_LONG_1E2E,A2
    LEA     DATA_ESQ_CONST_LONG_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_loop:
    CMPI.W  #4,D5
    BEQ.W   .skip_index4

    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecColorStep   (DecColorStepuncertain)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
; RET:
;   D0.w: color value with each non-zero component decremented by 1
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Decrements each non-zero 4-bit color component by one step.
; NOTES:
;   Assumes packed 0RGB format; component layout is inferred.
;------------------------------------------------------------------------------
ESQ_DecColorStep:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    TST.W   D1
    BEQ.S   .green_check

    SUBI.W  #$100,D1

.green_check:
    TST.W   D2
    BEQ.S   .blue_check

    SUBI.W  #16,D2

.blue_check:
    TST.W   D0
    BEQ.S   .combine_components

    SUBI.W  #1,D0

.combine_components:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsTowardsTargets   (IncCopperListsTowardsTargetsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D6, A1-A3
; CALLS:
;   ESQ_BumpColorTowardTargets
; READS:
;   WDISP_PaletteTriplesRBase, ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Adjusts copper list colors based on a per-entry target table.
; NOTES:
;   Uses WDISP_PaletteTriplesRBase as a 3-byte-per-entry target stream.
;------------------------------------------------------------------------------
ESQ_IncCopperListsTowardsTargets:
    MOVEM.L D2-D6/A2-A3,-(A7)
    LEA     WDISP_PaletteTriplesRBase,A1
    LEA     ESQ_CopperStatusDigitsA,A2
    LEA     ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D6/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_0074   (NoOpStub_0074)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp_0074:
    RTS

;!======

; Orphaned helper? No known callers; only referenced internally.
;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsAltSkipIndex4   (IncCopperListsAltSkipIndex4uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A1-A3
; CALLS:
;   ESQ_BumpColorTowardTargets
; READS:
;   DATA_ESQ_CONST_LONG_1E2E, DATA_ESQ_CONST_LONG_1E5B
; WRITES:
;   DATA_ESQ_CONST_LONG_1E2E, DATA_ESQ_CONST_LONG_1E5B
; DESC:
;   Adjusts alternate copper list colors based on the target stream,
;   skipping the entry at byte offset 4.
; NOTES:
;   This block is currently marked unreachable.
;------------------------------------------------------------------------------
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     DATA_ESQ_CONST_LONG_1E2E,A2
    LEA     DATA_ESQ_CONST_LONG_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_loop:
    CMPI.W  #4,D5
    BEQ.W   .skip_index4

    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_BumpColorTowardTargets   (BumpColorTowardTargetsuncertain)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
;   A1: pointer to 3-byte target stream (advances by 3)
; RET:
;   D0.w: adjusted color value
; CLOBBERS:
;   D0-D3, A1
; CALLS:
;   (none)
; READS:
;   (A1)+
; WRITES:
;   (none)
; DESC:
;   Adjusts each color component based on a per-component target byte.
; NOTES:
;   Component layout and adjustment direction are inferred.
;------------------------------------------------------------------------------
ESQ_BumpColorTowardTargets:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #8,D3
    CMP.W   D3,D1
    BEQ.S   .after_red

    ADDI.W  #$100,D1

.after_red:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #4,D3
    CMP.W   D3,D2
    BEQ.S   .after_green

    ADDI.W  #16,D2

.after_green:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    CMP.W   D3,D0
    BEQ.S   .return

    ADDI.W  #1,D0

.return:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TickClockAndFlagEvents   (Tick clock and emit boundary event code)
; ARGS:
;   stack +4: timePtr (struct with date/time fields)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D4
; CALLS:
;   ESQ_UpdateMonthDayFromDayOfYear
; READS:
;   DATA_COMMON_BSS_WORD_1B09, DATA_COMMON_BSS_WORD_1B0A, DATA_COMMON_BSS_WORD_1B0B, DATA_COMMON_BSS_WORD_1B0C
; WRITES:
;   [timePtr] fields (0,2,4,6,8,10,12,16,18,20)
; DESC:
;   Advances the time structure by one second and returns a status/event code
;   for notable boundaries (minute/half-hour/hour/day changes).
; NOTES:
;   Field meanings are inferred; 18(A0) is treated as an AM/PM sign flag.
;------------------------------------------------------------------------------
ESQ_TickClockAndFlagEvents:
    MOVEA.L 4(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,D2
    MOVE.L  D0,D4
    MOVEQ   #1,D1
    MOVEQ   #60,D3
    MOVE.W  12(A0),D0
    CMP.W   D3,D0
    BLT.W   .return

    SUB.W   D3,12(A0)
    MOVEQ   #1,D4
    MOVE.W  10(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,10(A0)
    CMPI.W  #$1e,D0
    BNE.W   .check_minute_flags

    MOVEQ   #2,D4
    BRA.W   .return

.check_minute_flags:
    CMP.W   D3,D0
    BGE.W   .hour_rollover

    CMP.W   DATA_COMMON_BSS_WORD_1B0C,D0
    BEQ.W   .minute_trigger_5

    CMP.W   DATA_COMMON_BSS_WORD_1B0B,D0
    BNE.W   .check_minute_20_or_50

.minute_trigger_5:
    MOVEQ   #5,D4
    BRA.W   .return

.check_minute_20_or_50:
    CMPI.W  #20,D0
    BEQ.W   .minute_trigger_4

    CMPI.W  #$32,D0
    BNE.W   .check_minute_special_3

.minute_trigger_4:
    MOVEQ   #4,D4
    BRA.W   .return

.check_minute_special_3:
    CMP.W   DATA_COMMON_BSS_WORD_1B09,D0
    BEQ.W   .minute_trigger_3

    CMP.W   DATA_COMMON_BSS_WORD_1B0A,D0
    BNE.W   .return

.minute_trigger_3:
    MOVEQ   #3,D4
    BRA.W   .return

.hour_rollover:
    MOVE.W  D2,10(A0)
    MOVEQ   #2,D4
    MOVE.W  8(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,8(A0)
    MOVEQ   #12,D3
    CMP.W   D3,D0
    BLT.W   .return

    BEQ.S   .toggle_am_pm

    MOVE.W  D1,8(A0)
    BRA.W   .return

.toggle_am_pm:
    EORI.W   #$ffff,18(A0)
    BMI.W   .return

    MOVE.W  0(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,0(A0)
    MOVEQ   #7,D3
    CMP.W   D3,D0
    BNE.S   .wrap_weekday

    MOVE.W  D2,0(A0)

.wrap_weekday:
    MOVE.W  16(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,16(A0)
    MOVE.W  #$16e,D3
    TST.W   20(A0)
    BEQ.S   .day_of_year_check

    ADD.W   D1,D3

.day_of_year_check:
    CMP.W   D3,D0
    BLT.S   .update_month_day

    MOVE.W  6(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,6(A0)
    MOVE.W  D1,16(A0)
    MOVEQ   #0,D1
    ANDI.W  #3,D0
    BNE.S   .update_leap_flag

    MOVE.W  #(-1),D1

.update_leap_flag:
    MOVE.W  D1,20(A0)

.update_month_day:
    JSR     ESQ_UpdateMonthDayFromDayOfYear

.return:
    MOVE.W  D4,D0
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

; Unreachable Code?
    MOVEA.L 4(A7),A0

;------------------------------------------------------------------------------
; FUNC: ESQ_UpdateMonthDayFromDayOfYear   (UpdateMonthDayFromDayOfYearuncertain)
; ARGS:
;   stack +4: timePtr (struct with day-of-year fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   DATA_COMMON_CONST_LONG_1B1D
; WRITES:
;   2(A0), 4(A0)
; DESC:
;   Converts day-of-year to month index and day-of-month fields.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
ESQ_UpdateMonthDayFromDayOfYear:
    MOVE.L  D2,-(A7)
    MOVE.W  16(A0),D0
    MOVEQ   #0,D2
    LEA     DATA_COMMON_CONST_LONG_1B1D,A1
    TST.W   20(A0)
    BEQ.S   .scan_months

    ADDA.L  #$18,A1

.scan_months:
    MOVE.W  (A1)+,D1
    CMP.W   D1,D0
    BLE.S   .return

    SUB.W   D1,D0
    ADDQ.W  #1,D2
    BRA.S   .scan_months

.return:
    MOVE.W  D2,2(A0)
    MOVE.W  D0,4(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CalcDayOfYearFromMonthDay   (CalcDayOfYearFromMonthDayuncertain)
; ARGS:
;   stack +4: timePtr (struct with month/day fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   DATA_COMMON_CONST_LONG_1B1D
; WRITES:
;   16(A0)
; DESC:
;   Converts month index and day-of-month into day-of-year.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
ESQ_CalcDayOfYearFromMonthDay:
    MOVEA.L 4(A7),A0
    MOVE.W  2(A0),D1
    MOVEQ   #0,D0
    LEA     DATA_COMMON_CONST_LONG_1B1D,A1
    DBF     D1,.month_loop

    BRA.S   .return

.month_loop:
    TST.W   20(A0)
    BEQ.S   .select_table

    ADDA.L  #$18,A1

.select_table:
    ADD.W   (A1)+,D0
    DBF     D1,.select_table

.return:
    ADD.W   4(A0),D0
    MOVE.W  D0,16(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_FormatTimeStamp   (FormatTimeStampuncertain)
; ARGS:
;   stack +4: outBuf (expects at least 12 bytes)
;   stack +8: timePtr (struct with time fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1
; CALLS:
;   (none)
; READS:
;   8(A1), 10(A1), 12(A1), 18(A1)
; WRITES:
;   outBuf (null-terminated string)
; DESC:
;   Formats "hh:mm:ss AM/PM" into the output buffer.
; NOTES:
;   Writes the string backward from outBuf+$0B. Uses 18(A1) sign for AM/PM.
;------------------------------------------------------------------------------
ESQ_FormatTimeStamp:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  D2,-(A7)
    ADDA.L  #$b,A0
    MOVE.B  #0,(A0)
    MOVE.B  #'M',-(A0)
    TST.W   18(A1)
    BPL.S   .set_am

    MOVE.B  #'P',-(A0)
    BRA.S   .after_ampm

.set_am:
    MOVE.B  #'A',-(A0)

.after_ampm:
    MOVE.B  #' ',-(A0)
    MOVE.W  12(A1),D2
    EXT.L   D2
    DIVS    #10,D2
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  10(A1),D1
    EXT.L   D1
    DIVS    #10,D1
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  8(A1),D0
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    ADDI.B  #'0',D0
    MOVE.B  D0,-(A0)
    SWAP    D0
    TST.B   D0
    BEQ.S   .leading_space

    ADDI.B  #'0',D0
    BRA.S   .return

.leading_space:
    MOVE.B  #' ',D0

.return:
    MOVE.B  D0,-(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_GetHalfHourSlotIndex   (GetHalfHourSlotIndexuncertain)
; ARGS:
;   stack +4: timePtr (struct with time fields)
; RET:
;   D0: slot index (mapped through DATA_COMMON_CONST_LONG_1B1E)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   8(A0), 10(A0), 18(A0), DATA_COMMON_CONST_LONG_1B1E
; WRITES:
;   (none)
; DESC:
;   Computes a half-hour slot for the time and returns a lookup-mapped value.
; NOTES:
;   Slot = hour*2 (+1 if minutes >= 30), with 12-hour and AM/PM handling.
;------------------------------------------------------------------------------
ESQ_GetHalfHourSlotIndex:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVEQ   #12,D1
    MOVE.W  8(A0),D0
    TST.W   18(A0)
    BPL.S   .normalize_midnight

    ADD.W   D1,D0
    BRA.S   .wrap_24h

.normalize_midnight:
    CMP.W   D1,D0
    BNE.S   .wrap_24h

    MOVEQ   #0,D0

.wrap_24h:
    MOVEQ   #24,D1
    CMP.W   D1,D0
    BEQ.S   .maybe_add_half

    ADD.W   D0,D0

.maybe_add_half:
    MOVE.W  10(A0),D2
    MOVEQ   #30,D1
    CMP.W   D1,D2
    BLT.S   .return

    ADDQ.W  #1,D0

.return:
    LEA     DATA_COMMON_CONST_LONG_1B1E,A1
    MOVE.B  0(A1,D0.W),D0
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ClampBannerCharRange   (ClampBannerCharRangeuncertain)
; ARGS:
;   stack +4: value0
;   stack +8: value1
;   stack +12: value2
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   WDISP_BannerCharRangeStart, DATA_WDISP_BSS_WORD_2280
; DESC:
;   Normalizes values into a bounded A..C/I range and writes two globals.
; NOTES:
;   Heavily context-dependent; likely relates to banner character bounds.
;------------------------------------------------------------------------------
ESQ_ClampBannerCharRange:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEA.L 12(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  A0,D2
    MOVEQ   #65,D3
    CMP.W   D3,D1
    BLT.S   .force_low_char

    MOVEQ   #67,D3
    CMP.W   D3,D1
    BLT.S   .force_high_char

.force_low_char:
    MOVEQ   #65,D1

.force_high_char:
    MOVEQ   #65,D3
    CMP.W   D3,D2
    BLT.S   .force_second_default

    MOVEQ   #73,D3
    CMP.W   D3,D2
    BLE.S   .normalize_chars

.force_second_default:
    MOVEQ   #69,D2

.normalize_chars:
    MOVEQ   #65,D3
    SUB.W   D3,D1
    SUB.W   D3,D2
    ADDQ.W  #1,D2
    MOVEQ   #48,D4
    MOVE.W  D0,D3
    TST.W   D1
    BEQ.S   .wrap_first_char

    SUB.W   D1,D0
    CMPI.W  #1,D0
    BGE.S   .wrap_first_char

    ADD.W   D4,D0

.wrap_first_char:
    ADD.W   D2,D3
    CMP.W   D4,D3
    BLE.S   .return

    SUB.W   D4,D3

.return:
    MOVE.W  D0,WDISP_BannerCharRangeStart
    MOVE.W  D3,DATA_WDISP_BSS_WORD_2280
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_AdvanceBannerCharIndex   (AdvanceBannerCharIndexuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3
; CALLS:
;   (none)
; READS:
;   WDISP_BannerCharIndex, WDISP_BannerCharPhaseShift, WDISP_BannerCharRangeStart, DATA_WDISP_BSS_WORD_2280, DATA_COMMON_BSS_LONG_1B08
; WRITES:
;   DATA_WDISP_BSS_WORD_2256, WDISP_BannerCharIndex, DATA_WDISP_BSS_WORD_2273, DATA_COMMON_BSS_LONG_1B08
; DESC:
;   Advances a cycling index in the 1..48 range and applies a step offset.
; NOTES:
;   If DATA_COMMON_BSS_LONG_1B08 is non-zero, forces a reset path and clears the flag.
;   Also resets when the index matches DATA_WDISP_BSS_WORD_2280, using WDISP_BannerCharRangeStart as the base.
;------------------------------------------------------------------------------
    MOVEM.L D2-D3,-(A7)
    MOVE.W  WDISP_BannerCharIndex,D0
    MOVEQ   #1,D2
    ADD.W   D2,D0
    MOVEQ   #48,D3
    CMP.W   D3,D0
    BLE.S   .lab_00A1

    MOVE.W  D2,D0

.lab_00A1:
    TST.W   DATA_COMMON_BSS_LONG_1B08
    BEQ.S   .lab_00A2

    MOVE.W  #0,DATA_COMMON_BSS_LONG_1B08
    BRA.S   .lab_00A3

.lab_00A2:
    MOVE.W  DATA_WDISP_BSS_WORD_2280,D1
    CMP.W   D1,D0
    BNE.S   .lab_00A4

.lab_00A3:
    MOVE.W  D2,DATA_WDISP_BSS_WORD_2256
    MOVE.W  WDISP_BannerCharRangeStart,D0

.lab_00A4:
    MOVE.W  D0,WDISP_BannerCharIndex
    MOVE.W  WDISP_BannerCharPhaseShift,D1
    BEQ.S   ESQ_AdvanceBannerCharIndex_Return

    ADD.W   D1,D0
    ADD.W   D1,D0
    CMP.W   D2,D0
    BGE.S   .lab_00A5

    ADD.W   D3,D0
    BRA.S   ESQ_AdvanceBannerCharIndex_Return

.lab_00A5:
    CMP.W   D3,D0
    BLE.S   ESQ_AdvanceBannerCharIndex_Return

    SUB.W   D3,D0

;------------------------------------------------------------------------------
; FUNC: ESQ_AdvanceBannerCharIndex_Return   (Routine at ESQ_AdvanceBannerCharIndex_Return)
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
;   DATA_WDISP_BSS_WORD_2273
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQ_AdvanceBannerCharIndex_Return:
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2273
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_AdjustBracketedHourInString   (AdjustBracketedHourInStringuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr]
; DESC:
;   Scans for bracketed hour fields, replaces '['/']' with '(' / ')' and
;   optionally offsets the hour value, wrapping it into 1..12.
; NOTES:
;   Only adjusts when hourOffset != 0; parsing assumes two-digit hours with
;   a possible leading space.
;------------------------------------------------------------------------------
ESQ_AdjustBracketedHourInString:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D4

.scan_for_left_bracket:
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  D0,D2
    MOVEQ   #'[',D3

.find_left_bracket:
    MOVE.B  (A0)+,D2
    BEQ.W   .return

    CMP.B   D3,D2
    BNE.S   .find_left_bracket

    SUBQ.W  #1,A0
    MOVEQ   #'(',D3
    MOVE.B  D3,(A0)+
    TST.B   D4
    BEQ.S   .scan_for_right_bracket

    MOVE.B  (A0)+,D1
    CMPI.B  #' ',D1
    BEQ.S   .parse_second_digit

    MOVEQ   #10,D0

.parse_second_digit:
    MOVE.B  (A0)+,D1
    SUBI.B  #$30,D1
    ADD.B   D1,D0
    MOVEQ   #12,D1
    ADD.B   D4,D0
    CMPI.B  #$1,D0
    BGE.S   .wrap_hour_range

    ADD.B   D1,D0
    BRA.S   .emit_hour

.wrap_hour_range:
    CMP.B   D1,D0
    BLE.S   .emit_hour

    SUB.B   D1,D0
    BRA.S   .wrap_hour_range

.emit_hour:
    MOVEQ   #10,D1
    MOVEQ   #32,D2
    MOVEA.L A0,A1
    CMP.B   D1,D0
    BLT.S   .write_hour_digits

    SUB.B   D1,D0
    MOVEQ   #49,D2

.write_hour_digits:
    ADDI.B  #48,D0
    MOVE.B  D0,-(A1)
    MOVE.B  D2,-(A1)

.scan_for_right_bracket:
    MOVEQ   #']',D3

.find_right_bracket:
    MOVE.B  (A0)+,D2
    BEQ.S   .return

    CMP.B   D3,D2
    BNE.S   .find_right_bracket

    SUBQ.W  #1,A0
    MOVEQ   #')',D3
    MOVE.B  D3,(A0)+
    BRA.S   .scan_for_left_bracket

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

; int32_t test_bit_1based(const uint8_t *base, uint32_t bit_index)
; {
;     uint32_t n = bit_index - 1;          // 1-based -> 0-based
;     uint32_t byte_i = (n & 0xFFFF) >> 3; // because LSR.W
;     uint32_t bit_i  = n & 7;
;     return (base[byte_i] & (1u << bit_i)) ? -1 : 0;
; }
;------------------------------------------------------------------------------
; FUNC: ESQ_TestBit1Based   (TestBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   D0: -1 if bit is set, 0 if clear
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   (none)
; DESC:
;   Tests a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
ESQ_TestBit1Based:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BTST    D1,0(A0,D0.W)
    SNE     D0
    EXT.W   D0
    EXT.L   D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetBit1Based   (SetBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   [base]
; DESC:
;   Sets a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
ESQ_SetBit1Based:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BSET    D1,0(A0,D0.W)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReverseBitsIn6Bytes   (ReverseBitsIn6Bytesuncertain)
; ARGS:
;   stack +4: dst (6 bytes)
;   stack +8: src (6 bytes)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Copies six bytes, bit-reversing each non-0/0xFF byte.
; NOTES:
;   Preserves 0x00 and 0xFF without reversal.
;------------------------------------------------------------------------------
ESQ_ReverseBitsIn6Bytes:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #5,D0

.copy_loop:
    MOVE.B  (A1)+,D4
    BEQ.S   .store_byte

    CMPI.B  #$ff,D4
    BEQ.S   .store_byte

    MOVEQ   #0,D3
    MOVE.L  D3,D1
    MOVE.B  D4,D1
    MOVE.L  D3,D4
    MOVEQ   #7,D2

.reverse_loop:
    BTST    D2,D1
    BEQ.S   .next_bit

    BSET    D3,D4

.next_bit:
    ADDQ.W  #1,D3
    DBF     D2,.reverse_loop

.store_byte:
    MOVE.B  D4,(A0)+
    DBF     D0,.copy_loop

    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_GenerateXorChecksumByte   (GenerateXorChecksumByteuncertain)
; ARGS:
;   stack +4: seed (initial byte, low 8 bits used)
;   stack +8: src (byte buffer)
;   stack +12: length (bytes)
; RET:
;   D0: checksum byte (low 8 bits)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   ESQIFF_RecordChecksumByte, ESQIFF_UseCachedChecksumFlag
; WRITES:
;   (none)
; DESC:
;   Computes an XOR checksum over a buffer, seeded by an inverted byte.
; NOTES:
;   If ESQIFF_UseCachedChecksumFlag is non-zero, returns ESQIFF_RecordChecksumByte instead of computing.
;------------------------------------------------------------------------------
ESQ_GenerateXorChecksumByte:
    MOVEQ   #0,D0
    MOVE.B  ESQIFF_RecordChecksumByte,D0
    TST.B   ESQIFF_UseCachedChecksumFlag
    BNE.S   .return

    MOVE.L  4(A7),D0
    MOVEA.L 8(A7),A0
    MOVE.L  12(A7),D1
    MOVE.L  D2,-(A7)
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    EORI.B  #$ff,D0
    MOVEQ   #0,D1

.xor_loop:
    MOVE.B  (A0)+,D1
    EOR.B   D1,D0
    DBF     D2,.xor_loop

    ANDI.L  #$ff,D0
    MOVE.L  (A7)+,D2

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TerminateAfterSecondQuote   (TerminateAfterSecondQuoteuncertain)
; ARGS:
;   stack +4: textPtr
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr] (writes a null byte)
; DESC:
;   Scans for the second double-quote and writes a terminator after it.
; NOTES:
;   No callers found via static search; may be reached via computed jump.
;------------------------------------------------------------------------------
ESQ_TerminateAfterSecondQuote:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,D1
    MOVEQ   #34,D2

.find_first_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_first_quote

.find_second_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_second_quote

    MOVE.B  D0,(A0)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_WildcardMatch   (WildcardMatchuncertain)
; ARGS:
;   stack +4: str
;   stack +8: pattern
; RET:
;   D0.b: 0 if match, 1 if mismatch
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   [str], [pattern]
; WRITES:
;   (none)
; DESC:
;   Compares a string against a pattern supporting '*' and '?' wildcards.
; NOTES:
;   Returns mismatch on null pointers. '*' short-circuits to match.
;------------------------------------------------------------------------------
ESQ_WildcardMatch:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    CMPA.L  #0,A0
    BEQ.S   .mismatch

    CMPA.L  #0,A1
    BEQ.S   .mismatch

    MOVEQ   #0,D0

.match_loop:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #'*',D1
    BEQ.S   .match

    TST.B   D0
    BEQ.S   .check_end

    CMPI.B  #'?',D1
    BEQ.S   .match_loop

    SUB.B   D1,D0
    BEQ.S   .match_loop

.mismatch:
    MOVE.B  #$1,D0
    RTS

.check_end:
    TST.B   D1
    BNE.S   .mismatch

.match:
    MOVE.B  #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_FindSubstringCaseFold   (FindSubstringCaseFolduncertain)
; ARGS:
;   stack +4: haystack
;   stack +8: needle
; RET:
;   D0: pointer to match (or 0 if not found)
; CLOBBERS:
;   D0-D2, A0-A3
; CALLS:
;   (none)
; READS:
;   [haystack], [needle]
; WRITES:
;   (none)
; DESC:
;   Searches for needle inside haystack with ASCII case folding.
; NOTES:
;   Case fold uses BCHG #5 (ASCII letter case bit).
;------------------------------------------------------------------------------
ESQ_FindSubstringCaseFold:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)

    MOVEQ   #0,D0
    TST.B   (A1)
    BEQ.S   .return

    MOVEA.L A0,A3
    MOVEA.L A1,A2

.search_loop:
    TST.B   (A0)
    BNE.S   .compare_loop

    TST.B   (A2)
    BNE.S   .return

.found:
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,A2-A3
    RTS

.compare_loop:
    TST.B   (A2)
    BEQ.S   .found

    MOVE.B  (A0)+,D1
    CMP.B   (A2),D1
    BNE.S   .try_case_fold

    TST.B   (A2)+
    BRA.S   .search_loop

.try_case_fold:
    BCHG    #5,D1
    CMP.B   (A2),D1
    BNE.S   .reset_search

    TST.B   (A2)+
    BRA.S   .search_loop

.reset_search:
    MOVE.L  A2,D2
    CMPA.L  D2,A1
    BEQ.S   .restart_from_next

    MOVE.L  A0,D1
    SUBI.L  #$1,D1
    MOVEA.L D1,A0

.restart_from_next:
    MOVEA.L A0,A3
    MOVEA.L A1,A2
    BRA.S   .search_loop

;------------------------------------------------------------------------------
; FUNC: ESQ_WriteDecFixedWidth   (WriteDecFixedWidthuncertain)
; ARGS:
;   stack +4: outBuf
;   stack +8: value
;   stack +12: digits
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   outBuf
; DESC:
;   Writes a fixed-width decimal string into outBuf.
; NOTES:
;   Writes digits right-to-left and terminates with null at outBuf+digits.
;------------------------------------------------------------------------------
ESQ_WriteDecFixedWidth:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVE.L  12(A7),D1
    ADDA.L  D1,A0
    MOVE.B  #0,(A0)
    SUBQ.W  #1,D1

.emit_digit_loop:
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    MOVE.B  D0,-(A0)
    ADDI.B  #$30,(A0)
    SWAP    D0
    DBF     D1,.emit_digit_loop

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_PackBitsDecode   (PackBitsDecodeuncertain)
; ARGS:
;   stack +4: src
;   stack +8: dst
;   stack +12: dstLen
; RET:
;   D0: src pointer after decoding
; CLOBBERS:
;   D0-D1, D6-D7, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Decodes PackBits-style RLE from src into dst.
; NOTES:
;   Positive counts copy literal bytes; negative counts repeat next byte.
;------------------------------------------------------------------------------
ESQ_PackBitsDecode:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0

    MOVEQ   #0,D1
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)

.decode_loop:
    CMP.W   D0,D1
    BGE.W   .done

    MOVE.B  (A0)+,D7
    TST.B   D7
    BMI.W   .repeat_run

    ADDQ.B  #1,D7

.copy_literals:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  (A0)+,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .copy_literals

.repeat_run:
    EXT.W   D7
    EXT.L   D7
    CMPI.L  #$ff,D7
    BEQ.S   .decode_loop

    NEG.L   D7
    ADDQ.L  #1,D7
    MOVE.B  (A0)+,D6

.repeat_byte:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  D6,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .repeat_byte

.done:
    MOVE.L  A0,D0
    MOVE.L  (A7)+,D6
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TickGlobalCounters
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   ESQ_ColdReboot, ESQSHARED4_TickCopperAndBannerTransitions, ESQIFF_ServicePendingCopperPaletteMoves
; READS:
;   ESQ_GlobalTickCounter, ESQ_TickModulo60Counter, DATA_WDISP_BSS_LONG_2325, Global_RefreshTickCounter, DATA_WDISP_BSS_WORD_22A5, WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; WRITES:
;   ESQ_GlobalTickCounter, ESQ_TickModulo60Counter, CLEANUP_PendingAlertFlag, DATA_WDISP_BSS_LONG_2325, Global_RefreshTickCounter, DATA_WDISP_BSS_WORD_22A5, TEXTDISP_DeferredActionArmed,
;   DATA_COMMON_BSS_WORD_1B11..DATA_COMMON_BSS_LONG_1B18
; DESC:
;   Increments global timing counters, performs periodic resets, and updates
;   accumulator fields with saturation flags.
; NOTES:
;   Triggers ESQ_ColdReboot when ESQ_GlobalTickCounter reaches $5460.
;------------------------------------------------------------------------------
ESQ_TickGlobalCounters:
    MOVE.W  ESQ_GlobalTickCounter,D0
    ADDQ.W  #1,D0
    CMPI.W  #$5460,D0
    BNE.S   .after_reboot_check

    JSR     ESQ_ColdReboot

.after_reboot_check:
    MOVE.W  D0,ESQ_GlobalTickCounter
    JSR     ESQSHARED4_TickCopperAndBannerTransitions

    MOVE.W  ESQ_TickModulo60Counter,D0
    ADDQ.W  #1,D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BNE.W   .store_tick_counter

    MOVE.W  D0,CLEANUP_PendingAlertFlag
    MOVE.W  DATA_WDISP_BSS_LONG_2325,D0
    BMI.W   .after_decrement_2325

    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_WDISP_BSS_LONG_2325

.after_decrement_2325:
    MOVE.W  Global_RefreshTickCounter,D0
    BMI.W   .after_increment_234A

    ADDQ.W  #1,D0
    MOVE.W  D0,Global_RefreshTickCounter

.after_increment_234A:
    MOVE.W  DATA_WDISP_BSS_WORD_22A5,D0
    BMI.W   .after_decay_22A5

    BEQ.W   .after_decay_22A5

    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_WDISP_BSS_WORD_22A5
    BNE.W   .after_decay_22A5

    MOVE.W  #1,TEXTDISP_DeferredActionArmed

.after_decay_22A5:
    LEA     DATA_COMMON_BSS_LONG_1B06,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    LEA     DATA_COMMON_BSS_LONG_1B07,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    MOVEQ   #0,D0

.store_tick_counter:
    MOVE.W  D0,ESQ_TickModulo60Counter
    TST.W   WDISP_AccumulatorCaptureActive
    BEQ.W   .after_accumulators

    MOVE.W  DATA_COMMON_BSS_WORD_1B0D,D0
    BEQ.S   .after_accum_1b11

    MOVE.W  DATA_COMMON_BSS_WORD_1B11,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b11_saturate

    MOVE.W  #1,DATA_COMMON_BSS_WORD_1B15
    MOVEQ   #0,D1

.after_accum_1b11_saturate:
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B11

.after_accum_1b11:
    MOVE.W  DATA_COMMON_BSS_WORD_1B0E,D0
    BEQ.S   .after_accum_1b12

    MOVE.W  DATA_COMMON_BSS_WORD_1B12,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b12_saturate

    MOVE.W  #1,DATA_COMMON_BSS_WORD_1B16
    MOVEQ   #0,D1

.after_accum_1b12_saturate:
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B12

.after_accum_1b12:
    MOVE.W  DATA_COMMON_BSS_WORD_1B0F,D0
    BEQ.S   .after_accum_1b13

    MOVE.W  DATA_COMMON_BSS_WORD_1B13,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b13_saturate

    MOVE.W  #1,DATA_COMMON_BSS_WORD_1B17
    MOVEQ   #0,D1

.after_accum_1b13_saturate:
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B13

.after_accum_1b13:
    MOVE.W  DATA_COMMON_BSS_WORD_1B10,D0
    BEQ.S   .after_accumulators

    MOVE.W  DATA_COMMON_BSS_WORD_1B14,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b14_saturate

    MOVE.W  #1,DATA_COMMON_BSS_LONG_1B18
    MOVEQ   #0,D1

.after_accum_1b14_saturate:
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B14

.after_accumulators:
    TST.W   WDISP_AccumulatorFlushPending
    BEQ.W   .return

    JSR     ESQIFF_ServicePendingCopperPaletteMoves

.return:
    MOVEQ   #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SeedMinuteEventThresholds   (SeedMinuteEventThresholdsuncertain)
; ARGS:
;   stack +4: baseMinute
;   stack +8: baseOffset
; RET:
;   (none)
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B09, DATA_COMMON_BSS_WORD_1B0A, DATA_COMMON_BSS_WORD_1B0B, DATA_COMMON_BSS_WORD_1B0C
; DESC:
;   Computes minute thresholds based on two base values.
; NOTES:
;   Stores (60-base), (30-base), (baseOffset), (baseOffset+30).
;------------------------------------------------------------------------------
ESQ_SeedMinuteEventThresholds:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEQ   #60,D2
    SUB.W   D0,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0A
    MOVEQ   #30,D2
    SUB.W   D0,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B09
    MOVEQ   #0,D2
    ADD.W   D1,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0C
    MOVEQ   #30,D2
    ADD.W   D1,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0B
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ColdReboot   (ColdRebootOrSupervisoruncertain)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   A6
; CALLS:
;   exec.library ColdReboot, exec.library Supervisor
; READS:
;   AbsExecBase, ExecBase+20 (version)
; WRITES:
;   (none)
; DESC:
;   Performs a cold reboot via Exec when available; otherwise uses Supervisor.
; NOTES:
;   Branches to a Supervisor-mode reset path on older Exec versions (< $24).
;------------------------------------------------------------------------------
ESQ_ColdReboot:
    MOVEA.L AbsExecBase,A6
    CMPI.W  #$24,20(A6)
    BLT.S   ESQ_ColdRebootViaSupervisor

    JMP     _LVOColdReboot(A6)

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ColdRebootViaSupervisor   (ColdRebootViaSupervisoruncertain)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   A5/A6
; CALLS:
;   exec.library Supervisor
; READS:
;   AbsExecBase, ExecBase+20 (version)
; WRITES:
;   (none)
; DESC:
;   Falls back to a Supervisor-mode reboot path on older Exec versions.
; NOTES:
;   Loads the supervisor entry address into A5 and calls _LVOSupervisor.
;------------------------------------------------------------------------------
ESQ_ColdRebootViaSupervisor:
    LEA     ESQ_SupervisorColdReboot(PC),A5
    JSR     _LVOSupervisor(A6)

;!======

    ; Alignment
    ALIGN_WORD
