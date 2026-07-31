    XDEF    _GCOMMAND_LoadCommandFile

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadCommandFile   (Load a command definition from disk (_GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile) and copy it into the workspace.)
; ARGS:
;   (none)
; RET:
;   D0: status/value from final disk helper call
; CLOBBERS:
;   D0/D7/A0/A1/A5
; CALLS:
;   _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush
; READS:
;   MODE_NEWFILE, _GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile, _GCOMMAND_DigitalNicheEnabledFlag
; WRITES:
;   -40(A5)..-8(A5) request buffer locals
; DESC:
;   Load a command definition from disk (_GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile) and copy it into the workspace.
; NOTES:
;   Builds a 32-byte request block from _GCOMMAND_DigitalNicheEnabledFlag and performs two read-style helper calls.
;------------------------------------------------------------------------------
_GCOMMAND_LoadCommandFile:
    LINK.W  A5,#-40
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile
    JSR     _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    LEA     _GCOMMAND_DigitalNicheEnabledFlag,A0
    LEA     -40(A5),A1
    MOVEQ   #7,D0

    ; Copy command file IO template onto stack request block.
.copy_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_template_loop
    MOVE.L  -12(A5),-8(A5)
    CLR.L   -12(A5)
    PEA     32.W
    PEA     -40(A5)
    MOVE.L  D7,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)

    ; Find NUL terminator to size the command string.
.scan_string_end:
    TST.B   (A0)+
    BNE.S   .scan_string_end

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     20(A7),A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======