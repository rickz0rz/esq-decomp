    XDEF    ESQIFF_HandleBrushIniReloadHotkey
    XDEF    _ESQIFF_JMPTBL_BRUSH_AllocBrushNode
    XDEF    ESQIFF_JMPTBL_BRUSH_CloneBrushRecord
    XDEF    _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate
    XDEF    _ESQIFF_JMPTBL_BRUSH_FindType3Brush
    XDEF    _ESQIFF_JMPTBL_BRUSH_FreeBrushList
    XDEF    ESQIFF_JMPTBL_BRUSH_PopBrushHead
    XDEF    _ESQIFF_JMPTBL_BRUSH_PopulateBrushList
    XDEF    _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel
    XDEF    ESQIFF_JMPTBL_BRUSH_SelectBrushSlot
    XDEF    ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess
    XDEF    _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle
    XDEF    _ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle
    XDEF    _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle
    XDEF    _ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary
    XDEF    _ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets
    XDEF    _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd
    XDEF    _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp
    XDEF    _ESQIFF_JMPTBL_ESQ_NoOp_006A
    XDEF    _ESQIFF_JMPTBL_ESQ_NoOp_0074
    XDEF    ESQIFF_JMPTBL_MATH_DivS32
    XDEF    ESQIFF_JMPTBL_MATH_Mulu32
    XDEF    _ESQIFF_JMPTBL_MEMORY_AllocateMemory
    XDEF    _ESQIFF_JMPTBL_MEMORY_DeallocateMemory
    XDEF    _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
    XDEF    ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled
    XDEF    ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition
    XDEF    ESQIFF_JMPTBL_STRING_CompareN
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCase
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCaseN
    XDEF    ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner
    XDEF    ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard
    XDEF    ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode
    XDEF    _ESQIFF_JMPTBL_DOS_OpenFileWithMode


;------------------------------------------------------------------------------
; FUNC: ESQIFF_HandleBrushIniReloadHotkey   (Handle brush.ini reload hotkey and refresh brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, _ESQIFF_JMPTBL_BRUSH_FindType3Brush, _ESQIFF_JMPTBL_BRUSH_FreeBrushList, _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel, _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle, _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle, _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   _BRUSH_SelectedNode, _Global_STR_DF0_BRUSH_INI_2, _PARSEINI_ParsedDescriptorListHead, _ESQIFF_BrushIniListHead, _ESQIFF_TAG_DT, _ESQIFF_TAG_DITHER
; WRITES:
;   _BRUSH_SelectedNode, _ESQFUNC_FallbackType3BrushNode
; DESC:
;   On hotkey `'a'`, refreshes brush.ini data, rebuilds brush lists, selects
;   preferred brush tags, and updates cached type-3 brush pointer.
; NOTES:
;   Calls disk refresh/reset helpers before and after parse/rebuild sequence.
;------------------------------------------------------------------------------
ESQIFF_HandleBrushIniReloadHotkey:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(PC)

    CLR.L   -(A7)
    PEA     _ESQIFF_BrushIniListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     _Global_STR_DF0_BRUSH_INI_2
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     _ESQIFF_BrushIniListHead
    MOVE.L  _PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     _ESQIFF_TAG_DT
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     24(A7),A7
    TST.L   _BRUSH_SelectedNode
    BNE.S   .ensure_type3_brush_cache

    PEA     _ESQIFF_BrushIniListHead
    PEA     _ESQIFF_TAG_DITHER
    JSR     _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_BRUSH_SelectedNode

.ensure_type3_brush_cache:
    PEA     _ESQIFF_BrushIniListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,_ESQFUNC_FallbackType3BrushNode
    JSR     _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment bytes
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCase   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCase:
    JMP     _STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     _TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_GetFilesizeFromHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle:
    JMP     _DISKIO_GetFilesizeFromHandle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_DivS32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_DivS32:
    JMP     _MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_FindEntryIndexByWildcard
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard:
    JMP     TEXTDISP_FindEntryIndexByWildcard

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareN:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_NoOp
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp:
    JMP     _ESQ_NoOp

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_DrawChannelBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_MoveCopperEntryTowardStart
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart:
    JMP     _ESQ_MoveCopperEntryTowardStart

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_MEMORY_DeallocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_DeallocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ForceUiRefreshIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle:
    JMP     _DISKIO_ForceUiRefreshIfIdle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_CloneBrushRecord   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_CloneBrushRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_CloneBrushRecord:
    JMP     BRUSH_CloneBrushRecord

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_MoveCopperEntryTowardEnd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd:
    JMP     _ESQ_MoveCopperEntryTowardEnd

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FindBrushByPredicate
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     _BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_FreeBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_FreeBrushList:
    JMP     _BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_FindType3Brush   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FindType3Brush
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_FindType3Brush:
    JMP     _BRUSH_FindType3Brush

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopBrushHead   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_PopBrushHead
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopBrushHead:
    JMP     _BRUSH_PopBrushHead

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_AllocBrushNode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_NoOp_006A   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_006A
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_NoOp_006A:
    JMP     ESQ_NoOp_006A

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_ValidateSelectionCode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode:
    JMP     _NEWGRID_ValidateSelectionCode

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_PopulateBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_NoOp_0074   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_0074
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_NoOp_0074:
    JMP     ESQ_NoOp_0074

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCaseN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareNoCaseN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCaseN:
    JMP     _STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_AssertCtrlLineIfEnabled
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled:
    JMP     _SCRIPT_AssertCtrlLineIfEnabled

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_BeginBannerCharTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition:
    JMP     SCRIPT_BeginBannerCharTransition

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_MEMORY_AllocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_AllocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_MEMORY_AllocateMemory:
    JMP     _MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CTASKS_StartIffTaskProcess
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess:
    JMP     _CTASKS_StartIffTaskProcess

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_DOS_OpenFileWithMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DOS_OpenFileWithMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_DOS_OpenFileWithMode:
    JMP     DOS_OpenFileWithMode

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_IncCopperListsTowardsTargets
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets:
    JMP     ESQ_IncCopperListsTowardsTargets

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_DecCopperListsPrimary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary:
    JMP     ESQ_DecCopperListsPrimary

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushSlot   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushSlot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushByLabel
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel:
    JMP     BRUSH_SelectBrushByLabel

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_Mulu32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_Mulu32:
    JMP     _MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ResetCtrlInputStateIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle:
    JMP     _DISKIO_ResetCtrlInputStateIfIdle
