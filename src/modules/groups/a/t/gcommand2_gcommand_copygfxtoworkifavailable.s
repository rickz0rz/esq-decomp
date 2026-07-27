    XDEF    _GCOMMAND_CopyGfxToWorkIfAvailable

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_CopyGfxToWorkIfAvailable   (CopyGfxToWorkIfAvailableuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, D6-D7, A0-A6
; CALLS:
;   dos.library Lock/UnLock, _GROUP_AT_JMPTBL_DOS_SystemTagList, _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0, _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1
; READS:
;   _GCOMMAND_PATH_GFX_COLON, _GCOMMAND_STR_WORK_COLON, _GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS, _GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_
; WRITES:
;   _GCOMMAND_PresetWorkResetPendingFlag
; DESC:
;   Verifies GFX:/WORK: assigns and issues COPY commands to stage graphics.
; NOTES:
;   Uses shell command strings (COPY >NIL: ...) and leaves early if assigns missing.
;------------------------------------------------------------------------------
_GCOMMAND_CopyGfxToWorkIfAvailable:
    MOVEM.L D2/D6-D7,-(A7)
    MOVEQ   #0,D7
    MOVEQ   #0,D6
    LEA     _GCOMMAND_PATH_GFX_COLON,A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #0,D7
    LEA     _GCOMMAND_STR_WORK_COLON,A0
    MOVE.L  A0,D1
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #0,D7
    CLR.L   -(A7)
    PEA     _GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS
    JSR     _GROUP_AT_JMPTBL_DOS_SystemTagList(PC)

    MOVE.L  D0,D6
    CLR.L   (A7)
    PEA     _GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_
    JSR     _GROUP_AT_JMPTBL_DOS_SystemTagList(PC)

    MOVE.L  D0,D6

    JSR     _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    JSR     _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======