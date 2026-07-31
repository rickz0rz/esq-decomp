    XDEF    _TEXTDISP_DrawChannelBanner


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_DrawChannelBanner   (Draw banner with channel label)
; ARGS:
;   stack +10: mode (word)
;   stack +14: drawMode (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TEXTDISP_BuildEntryShortName,
;   _TEXTDISP_BuildChannelLabel, _LVOSetDrMd, _TLIBA1_DrawFormattedTextBlock, _TEXTDISP_DrawInsetRectFrame
; READS:
;   _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ActiveGroupId, _WDISP_DisplayContextBase
; WRITES:
;   _TEXTDISP_EntryShortNameScratch, _TEXTDISP_LinePenOverrideEnabledFlag, _TEXTDISP_LinePenOverrideStateWord
; DESC:
;   Builds banner text and draws it in the selected rastport.
; NOTES:
;   Uses _TEXTDISP_ActiveGroupId to switch between group 1/2 layouts.
;------------------------------------------------------------------------------
_TEXTDISP_DrawChannelBanner:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .select_group2

    MOVEQ   #1,D1
    BRA.S   .dispatch_group

.select_group2:
    MOVEQ   #2,D1

.dispatch_group:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     _TEXTDISP_EntryShortNameScratch
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   _TEXTDISP_BuildEntryShortName

    LEA     _TEXTDISP_EntryShortNameScratch,A0
    LEA     _TEXTDISP_ChannelLabelBuffer,A1

.copy_short_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_short_name

    PEA     1.W
    BSR.W   _TEXTDISP_BuildChannelLabel

    LEA     20(A7),A7
    CLR.W   _TEXTDISP_LinePenOverrideStateWord
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .select_rast

    MOVEA.L _Global_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .init_rect

.select_rast:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.init_rect:
    MOVE.W  #1,_TEXTDISP_LinePenOverrideEnabledFlag
    MOVEQ   #0,D5
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D5
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .trim_and_draw

    TST.L   D5
    BPL.S   .adjust_half_width

    ADDQ.L  #1,D5

.adjust_half_width:
    ASR.L   #1,D5

.trim_and_draw:
    MOVE.L  D5,-(A7)
    PEA     _TEXTDISP_ChannelLabelBuffer
    BSR.W   _TEXTDISP_TrimTextToPixelWidth

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TEXTDISP_ChannelLabelBuffer
    BSR.W   _TEXTDISP_DrawInsetRectFrame

    LEA     12(A7),A7
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .set_drawmode_normal

    MOVEA.L _Global_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .return

.set_drawmode_normal:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.return:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======