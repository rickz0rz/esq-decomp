    XDEF    _GCOMMAND_ResetHighlightMessages

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ResetHighlightMessages   (Clear active/highlight message slots and restore saved fields)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_ActiveMsgSavedField20, _GCOMMAND_ActiveMsgSavedField24, _GCOMMAND_ActiveMsgSavedField28
; WRITES:
;   _GCOMMAND_HighlightMessageSlotTable.., _GCOMMAND_ActiveHighlightMsgPtr
; DESC:
;   Clears pending highlight message records and resets message state.
; NOTES:
;   Writes into a sequence of structs starting at _GCOMMAND_HighlightMessageSlotTable.
;------------------------------------------------------------------------------
_GCOMMAND_ResetHighlightMessages:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)

    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BEQ.S   .clear_message_slots

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField20,20(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField24,24(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField28,28(A0)

.clear_message_slots:
    MOVEQ   #0,D7
    MOVE.L  #_GCOMMAND_HighlightMessageSlotTable,-4(A5)

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
    LEA     _ESQPARS2_BannerQueueBuffer,A0

.queue_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.queue_loop

    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======