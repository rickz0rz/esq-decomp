    XDEF    _TEXTDISP_HandleScriptCommand


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_HandleScriptCommand   (Dispatch text display command)
; ARGS:
;   stack +11: cmdChar (D7)
;   stack +15: modeChar (D6)
;   stack +16: argPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TEXTDISP_BuildNowShowingStatusLine, _TEXTDISP_BuildEntryPairStatusLine,
;   _TEXTDISP_SetEntryTextFields, _TEXTDISP_FilterAndSelectEntry,
;   _TEXTDISP_DrawHighlightFrame, _MEMORY_AllocateMemory, _MEMORY_DeallocateMemory
; READS:
;   _TEXTDISP_CommandBufferPtr, _TEXTDISP_PrimaryFirstMatchIndex/2361/2364
; WRITES:
;   _TEXTDISP_LastDispatchMatchIndex/214A/214B/235D
; DESC:
;   Handles a script opcode by updating text display state and SourceCfg data.
; NOTES:
;   Command cases inferred from constants (0x43/0x4A/0x52 etc).
;   case 'C' uses -200(A5) as a command scratch buffer for "xx%s".
;------------------------------------------------------------------------------
_TEXTDISP_HandleScriptCommand:

.commandScratchBuffer = -200

    LINK.W  A5,#-208
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEQ   #1,D5
    MOVEQ   #1,D4
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    ADDQ.W  #1,D0
    BEQ.W   .finalize

    SUBI.W  #$43,D0
    BEQ.S   .handle_cmd_C

    SUBQ.W  #7,D0
    BEQ.W   .handle_cmd_J

    SUBI.W  #10,D0
    BEQ.W   .handle_cmd_source_cfg

    BRA.W   .finalize

.handle_cmd_C:
    MOVE.L  A3,-(A7)
    PEA     _TEXTDISP_CommandPrefixFormat
    ; 200-byte local target; source text comes from script argument pointer.
    ; Provenance: A3 is typically _SCRIPT_CommandTextPtr (legacy _SCRIPT_CommandTextPtr), populated from
    ; _SCRIPT_CTRL_CMD_BUFFER payload bytes in _SCRIPT_HandleBrushCommand.
    ; Budget note for .commandScratchBuffer (200 bytes incl NUL):
    ; "xx%s" => 3 + len(arg), so payload must stay <= 197 bytes.
    ; CTRL packet path enforces _SCRIPT_CTRL_READ_INDEX <= 198 before dispatch.
    PEA     .commandScratchBuffer(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A3,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     20(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .handle_cmd_C_success

    MOVE.W  _TEXTDISP_ActiveGroupId,_TEXTDISP_StatusGroupId
    MOVE.W  _TEXTDISP_CurrentMatchIndex,_TEXTDISP_LastDispatchMatchIndex
    BSR.W   _SCRIPT_GetBannerCharOrFallback

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,_TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_success:
    MOVE.W  _TEXTDISP_PrimaryFirstMatchIndex,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt1

    MOVE.W  #1,_TEXTDISP_StatusGroupId
    MOVE.W  _TEXTDISP_PrimaryFirstMatchIndex,_TEXTDISP_LastDispatchMatchIndex
    MOVEQ   #-1,D0
    MOVE.W  D0,_TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt1:
    MOVE.W  _TEXTDISP_SecondaryFirstMatchIndex,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt2

    CLR.W   _TEXTDISP_StatusGroupId
    MOVE.W  _TEXTDISP_SecondaryFirstMatchIndex,_TEXTDISP_LastDispatchMatchIndex
    MOVEQ   #-1,D0
    MOVE.W  D0,_TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt2:
    MOVEQ   #-1,D0
    MOVE.W  D0,_TEXTDISP_LastDispatchGroupId
    MOVE.W  D0,_TEXTDISP_LastDispatchMatchIndex
    MOVE.W  D0,_TEXTDISP_StatusGroupId

.dispatch_update:
    MOVE.W  _TEXTDISP_StatusGroupId,D0
    EXT.L   D0
    MOVE.W  _TEXTDISP_LastDispatchMatchIndex,D1
    EXT.L   D1
    MOVE.W  _TEXTDISP_LastDispatchGroupId,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_BuildNowShowingStatusLine

    BSR.W   _SCRIPT_ResetBannerCharDefaults

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   .finalize

.handle_cmd_J:
    MOVE.W  _TEXTDISP_StatusGroupId,D0
    EXT.L   D0
    MOVE.W  _TEXTDISP_LastDispatchMatchIndex,D1
    EXT.L   D1
    MOVE.W  _TEXTDISP_LastDispatchGroupId,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_BuildEntryPairStatusLine

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   .finalize

.handle_cmd_source_cfg:
    MOVEQ   #70,D0
    CMP.B   D0,D7
    BNE.S   .apply_source_cfg

    TST.L   _TEXTDISP_CommandBufferPtr
    BNE.S   .init_source_cfg

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     732.W
    PEA     1084.W
    PEA     _Global_STR_TEXTDISP_C_1
    JSR     _MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_TEXTDISP_CommandBufferPtr

.init_source_cfg:
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A3,-(A7)
    MOVE.L  _TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   _TEXTDISP_SetEntryTextFields

    PEA     70.W
    MOVE.L  _TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   _TEXTDISP_FilterAndSelectEntry

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .apply_source_cfg

    TST.L   _TEXTDISP_CommandBufferPtr
    BEQ.S   .apply_source_cfg

    MOVEA.L _TEXTDISP_CommandBufferPtr,A0
    ADDA.W  #$dc,A0
    LEA     _TEXTDISP_DefaultSpacePad,A1

.copy_default_cfg:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_default_cfg

.apply_source_cfg:
    MOVE.L  _TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   _TEXTDISP_DrawHighlightFrame

    PEA     88.W
    MOVE.L  _TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   _TEXTDISP_FilterAndSelectEntry

    LEA     12(A7),A7
    MOVEQ   #0,D4

.finalize:
    TST.L   D5
    BEQ.S   .cleanup_if_needed

    MOVE.W  #(-1),_TEXTDISP_LastDispatchMatchIndex
    MOVE.W  #$31,_TEXTDISP_LastDispatchGroupId

.cleanup_if_needed:
    TST.L   D4
    BEQ.S   .return

    CLR.L   -(A7)
    CLR.L   -(A7)
    BSR.W   _TEXTDISP_FilterAndSelectEntry

    ADDQ.W  #8,A7
    TST.L   _TEXTDISP_CommandBufferPtr
    BEQ.S   .return

    PEA     732.W
    MOVE.L  _TEXTDISP_CommandBufferPtr,-(A7)
    PEA     1106.W
    PEA     _Global_STR_TEXTDISP_C_2
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _TEXTDISP_CommandBufferPtr

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======