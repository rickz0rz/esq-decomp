    XDEF    _GCOMMAND_ServiceHighlightMessages

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ServiceHighlightMessages   (Poll/process highlight messages and drive banner updates)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1, A6
; CALLS:
;   _LVOGetMsg, _LVOReplyMsg, _GCOMMAND_LoadPresetWorkEntries,
;   _GCOMMAND_RefreshBannerTables, _GCOMMAND_ConsumeBannerQueueEntry,
;   _GCOMMAND_ResetPresetWorkTables, _GCOMMAND_TickPresetWorkEntries,
;   _ESQSHARED4_CopyPlanesFromContextToSnapshot, _ESQSHARED4_CopyLivePlanesToSnapshot, _GCOMMAND_MapKeycodeToPreset
; READS:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_PresetWorkResetPendingFlag, _ESQ_HighlightMsgPort, _GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28
; WRITES:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28, message fields at 20/24/28/32/52/54(A0)
; DESC:
;   Polls the highlight message port, processes active messages, and updates
;   banner/preset state each tick.
; NOTES:
;   Replies to messages when their countdown at 52(A0) reaches zero.
;   Message layout (inferred): +20/+24/+28 saved longs, +32 preset record ptr,
;   +52 countdown, +54 keycode/preset trigger byte.
;------------------------------------------------------------------------------
_GCOMMAND_ServiceHighlightMessages:
    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BNE.S   .update_tables

    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,_GCOMMAND_ActiveHighlightMsgPtr
    TST.L   D0
    BEQ.S   .update_tables

    MOVEA.L D0,A0
    MOVE.L  32(A0),D1                     ; A0+32 = preset record ptr (or -1)
    TST.L   D1
    BMI.S   .maybe_store_msg

    MOVE.L  D0,-(A7)
    BSR.W   _GCOMMAND_LoadPresetWorkEntries

    ADDQ.W  #4,A7

.maybe_store_msg:
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  20(A0),_GCOMMAND_ActiveMsgSavedField20 ; A0+20 = saved field 0
    MOVE.L  24(A0),_GCOMMAND_ActiveMsgSavedField24 ; A0+24 = saved field 1
    MOVE.L  28(A0),_GCOMMAND_ActiveMsgSavedField28 ; A0+28 = saved field 2
    MOVE.B  54(A0),D0                       ; A0+54 = keycode/preset trigger
    TST.B   D0
    BEQ.S   .update_tables

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _GCOMMAND_MapKeycodeToPreset

    ADDQ.W  #4,A7
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    CLR.B   54(A0)

.update_tables:
    BSR.W   _GCOMMAND_RefreshBannerTables

    BSR.W   _GCOMMAND_ConsumeBannerQueueEntry

    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BEQ.W   .no_active_msg

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .handle_active_msg

    JSR     _ESQSHARED4_CopyLivePlanesToSnapshot(PC)

    BRA.S   .check_countdown

.handle_active_msg:
    TST.W   _GCOMMAND_PresetWorkResetPendingFlag
    BEQ.S   .tick_active_msg

    BSR.W   _GCOMMAND_ResetPresetWorkTables

.tick_active_msg:
    BSR.W   _GCOMMAND_TickPresetWorkEntries

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A1
    JSR     _ESQSHARED4_CopyPlanesFromContextToSnapshot(PC)

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  D1,52(A0)                       ; A0+52 = countdown ticks

.check_countdown:
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .return

    MOVE.L  _GCOMMAND_ActiveMsgSavedField20,20(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField24,24(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField28,28(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  D1,52(A0)                       ; A0+52 = countdown reset to 0
    CLR.L   32(A0)                          ; A0+32 = clear preset record ptr
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOReplyMsg(A6)

    CLR.L   _GCOMMAND_ActiveHighlightMsgPtr
    BRA.S   .return

.no_active_msg:
    JSR     _ESQSHARED4_CopyLivePlanesToSnapshot(PC)

.return:
    RTS

;!======