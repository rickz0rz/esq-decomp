    XDEF    _ESQDISP_QueueHighlightDrawMessage


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_QueueHighlightDrawMessage   (Prepare highlight-draw message and enqueue to port)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode, _LVOInitRastPort, _LVOPutMsg, _LVOSetDrMd, _LVOSetFont
; READS:
;   AbsExecBase, _Global_HANDLE_PREVUEC_FONT, _Global_REF_GRAPHICS_LIBRARY, _ESQ_HighlightMsgPort, _ESQ_HighlightReplyPort
; WRITES:
;   highlight message header/rastport fields at A3, message flags via A3+112 target
; DESC:
;   Populates message metadata and embedded RastPort state, validates selection
;   parameters, then posts the message to _ESQ_HighlightMsgPort.
; NOTES:
;   Uses _ESQ_HighlightReplyPort as reply target for async highlight processing.
;------------------------------------------------------------------------------
_ESQDISP_QueueHighlightDrawMessage:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.B  #$5,8(A3)
    MOVE.W  #$a0,18(A3)
    MOVE.L  _ESQ_HighlightReplyPort,14(A3)
    MOVE.L  8(A2),20(A3)
    MOVE.L  12(A2),24(A3)
    MOVE.L  16(A2),28(A3)
    CLR.W   52(A3)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    CLR.L   32(A3)
    MOVE.L  A3,(A7)
    BSR.S   _ESQDISP_InitHighlightMessagePattern

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVE.L  A2,64(A3)
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  112(A3),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    MOVEA.L A3,A1
    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======