;------------------------------------------------------------------------------
; FUNC: GCOMMAND_FindPathSeparator   (Return a pointer to the final path separator (':' or '/') in the buffer.)
; ARGS:
;   stack +4: pathPtr (via 8(A5))
; RET:
;   D0: pointer to char after final ':' or '/', else start of string
; CLOBBERS:
;   D0/D1/D7/A0/A3/A5
; CALLS:
;   (none)
; READS:
;   bytes from pathPtr
; WRITES:
;   -4(A5) temporary cursor
; DESC:
;   Return a pointer to the final path separator (':' or '/') in the buffer.
; NOTES:
;   Scans to NUL, then walks backward until a separator is found.
;------------------------------------------------------------------------------
GCOMMAND_FindPathSeparator:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0

.lab_0D5A:
    TST.B   (A0)+
    BNE.S   .lab_0D5A

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D7
    TST.L   D7
    BEQ.S   .lab_0D5F

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    SUBQ.L  #1,A0
    MOVE.L  A0,-4(A5)

.lab_0D5B:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #':',D1
    CMP.B   D1,D0
    BEQ.S   .lab_0D5C

    MOVEQ   #'/',D1
    CMP.B   D1,D0
    BNE.S   .lab_0D5D

.lab_0D5C:
    ADDQ.L  #1,-4(A5)
    BRA.S   .return

.lab_0D5D:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .lab_0D5E

    SUBQ.L  #1,-4(A5)

.lab_0D5E:
    SUBQ.L  #1,D7
    BNE.S   .lab_0D5B

    BRA.S   .return

.lab_0D5F:
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_CopyGfxToWorkIfAvailable   (CopyGfxToWorkIfAvailableuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, D6-D7, A0-A6
; CALLS:
;   dos.library Lock/UnLock, GROUP_AT_JMPTBL_DOS_SystemTagList, GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0, GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1
; READS:
;   DATA_GCOMMAND_PATH_GFX_COLON_1F9E, DATA_GCOMMAND_STR_WORK_COLON_1F9F, DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS_1FA0, DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON__1FA1
; WRITES:
;   DATA_GCOMMAND_BSS_WORD_1FA3
; DESC:
;   Verifies GFX:/WORK: assigns and issues COPY commands to stage graphics.
; NOTES:
;   Uses shell command strings (COPY >NIL: ...) and leaves early if assigns missing.
;------------------------------------------------------------------------------
GCOMMAND_CopyGfxToWorkIfAvailable:
    MOVEM.L D2/D6-D7,-(A7)
    MOVEQ   #0,D7
    MOVEQ   #0,D6
    LEA     DATA_GCOMMAND_PATH_GFX_COLON_1F9E,A0
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
    LEA     DATA_GCOMMAND_STR_WORK_COLON_1F9F,A0
    MOVE.L  A0,D1
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #0,D7
    CLR.L   -(A7)
    PEA     DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS_1FA0
    JSR     GROUP_AT_JMPTBL_DOS_SystemTagList(PC)

    MOVE.L  D0,D6
    CLR.L   (A7)
    PEA     DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON__1FA1
    JSR     GROUP_AT_JMPTBL_DOS_SystemTagList(PC)

    MOVE.L  D0,D6

    JSR     GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    JSR     GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
