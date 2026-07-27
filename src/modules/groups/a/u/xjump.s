    XDEF    _GROUP_AU_JMPTBL_BRUSH_AppendBrushNode
    XDEF    _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList

;------------------------------------------------------------------------------
; FUNC: _GROUP_AU_JMPTBL_BRUSH_AppendBrushNode   (JumpStub_BRUSH_AppendBrushNode)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   BRUSH_AppendBrushNode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to BRUSH_AppendBrushNode.
;------------------------------------------------------------------------------
_GROUP_AU_JMPTBL_BRUSH_AppendBrushNode:
    JMP     BRUSH_AppendBrushNode

;------------------------------------------------------------------------------
; FUNC: _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList   (JumpStub_BRUSH_PopulateBrushList)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to BRUSH_PopulateBrushList.
;------------------------------------------------------------------------------
_GROUP_AU_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList
