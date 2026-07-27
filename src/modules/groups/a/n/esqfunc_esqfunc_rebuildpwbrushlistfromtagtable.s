    XDEF    _ESQFUNC_RebuildPwBrushListFromTagTable


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_RebuildPwBrushListFromTagTable   (Rebuild PW brush descriptor/list chain from tag table)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_AllocBrushNode, _ESQIFF_JMPTBL_BRUSH_FreeBrushList, _ESQIFF_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   _ESQFUNC_PwBrushDescriptorHead, _ESQFUNC_PwBrushListHead, _ESQFUNC_BrushDescriptorTagStrings
; WRITES:
;   _ESQFUNC_PwBrushDescriptorHead
; DESC:
;   Frees existing PW brush list, allocates descriptor nodes from a 6-entry tag
;   table, assigns descriptor type bytes, and repopulates runtime brush list.
; NOTES:
;   Uses PC-relative jump-table switch on descriptor index.
;------------------------------------------------------------------------------
_ESQFUNC_RebuildPwBrushListFromTagTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    CLR.L   -4(A5)
    CLR.L   -(A7)
    PEA     _ESQFUNC_PwBrushListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D7

.loop_build_pw_brush_descriptors:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _ESQFUNC_BrushDescriptorTagStrings,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  (A0),-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   .link_pw_descriptor_or_advance

    ADD.W   D0,D0
    MOVE.W  .switch_pw_descriptor_type_case(PC,D0.W),D0
    JMP     .switch_pw_descriptor_type_case+2(PC,D0.W)

; switch/jumptable
.switch_pw_descriptor_type_case:
    DC.W    .set_pw_descriptor_type_08-.switch_pw_descriptor_type_case-2
	DC.W    .set_pw_descriptor_type_09_case1-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case2-.switch_pw_descriptor_type_case-2
	DC.W    .set_pw_descriptor_type_09_case3-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case4-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case5-.switch_pw_descriptor_type_case-2

.set_pw_descriptor_type_08:
    MOVEA.L -4(A5),A0
    MOVE.B  #$8,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case1:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case2:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case3:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case4:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case5:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)

.link_pw_descriptor_or_advance:
    TST.L   _ESQFUNC_PwBrushDescriptorHead
    BNE.S   .advance_pw_descriptor_index

    MOVE.L  -4(A5),_ESQFUNC_PwBrushDescriptorHead

.advance_pw_descriptor_index:
    ADDQ.L  #1,D7
    BRA.W   .loop_build_pw_brush_descriptors

.return:
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  _ESQFUNC_PwBrushDescriptorHead,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_PopulateBrushList(PC)

    CLR.L   _ESQFUNC_PwBrushDescriptorHead
    MOVE.L  -12(A5),D7
    UNLK    A5
    RTS

;!======