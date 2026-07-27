    XDEF    _TEXTDISP_BuildChannelLabel


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_BuildChannelLabel   (Build \"On Channel\" label)
; ARGS:
;   stack +10: includeOnPrefix (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _STRING_AppendAtNull
; READS:
;   _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ActiveGroupId
; WRITES:
;   _TEXTDISP_ChannelLabelBufferTerminatorByte, _TEXTDISP_ChannelLabelBuffer, _TEXTDISP_ChannelLabelReadyFlag
; DESC:
;   Builds _TEXTDISP_ChannelLabelBuffer as \"On Channel <name>\" and sets _TEXTDISP_ChannelLabelReadyFlag when valid.
; NOTES:
;   Uses group 1/2 based on _TEXTDISP_ActiveGroupId.
;------------------------------------------------------------------------------
_TEXTDISP_BuildChannelLabel:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .select_group

    MOVEQ   #1,D1
    BRA.S   .dispatch_group

.select_group:
    MOVEQ   #2,D1

.dispatch_group:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .clear_name

    LEA     1(A3),A0
    LEA     -17(A5),A1

.copy_entry_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_name

    BRA.S   .measure_name

.clear_name:
    CLR.B   -17(A5)

.measure_name:
    LEA     -17(A5),A0
    MOVEA.L A0,A1

.measure_loop:
    TST.B   (A1)+
    BNE.S   .measure_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    CLR.L   _TEXTDISP_ChannelLabelReadyFlag
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   .return

    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #32,D1
    CMP.B   -19(A5,D0.L),D1
    BEQ.S   .return

    TST.W   D7
    BEQ.S   .append_channel_prefix

    PEA     _Global_STR_ALIGNED_ON
    PEA     _TEXTDISP_ChannelLabelBuffer
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_channel_prefix:
    PEA     _Global_STR_ALIGNED_CHANNEL_1
    PEA     _TEXTDISP_ChannelLabelBuffer
    JSR     _STRING_AppendAtNull(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     _TEXTDISP_ChannelLabelBuffer
    JSR     _STRING_AppendAtNull(PC)

    LEA     12(A7),A7
    LEA     _TEXTDISP_ChannelLabelBuffer,A0
    MOVEA.L A0,A1

.finalize_label:
    TST.B   (A1)+
    BNE.S   .finalize_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    LEA     _TEXTDISP_ChannelLabelBufferTerminatorByte,A0
    ADDA.L  D0,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,_TEXTDISP_ChannelLabelReadyFlag

.return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======