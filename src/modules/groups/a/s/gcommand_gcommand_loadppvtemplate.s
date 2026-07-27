    XDEF    _GCOMMAND_LoadPPVTemplate

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadPPVTemplate   (Load the PPV table template into the workspace buffers.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +64: arg_5 (via 68(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave, _GCOMMAND_PpvTemplateFieldSeparatorByteStorage, _GCOMMAND_DigitalPpvEnabledFlag, MODE_NEWFILE, copy_template_loop, return
; WRITES:
;   (none observed)
; DESC:
;   Load the PPV table template into the workspace buffers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_GCOMMAND_LoadPPVTemplate:
    LINK.W  A5,#-68
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return

    LEA     _GCOMMAND_DigitalPpvEnabledFlag,A0
    LEA     -68(A5),A1
    MOVEQ   #13,D0

    ; Copy file buffer template onto stack request block.
.copy_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_template_loop
    MOVE.L  -20(A5),-8(A5)
    MOVE.L  -24(A5),-12(A5)
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-24(A5)
    PEA     56.W
    PEA     -68(A5)
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-20(A5)
    MOVE.L  -12(A5),-24(A5)

    ; Find first NUL terminator to size the first string.
.scan_first_nul:
    TST.B   (A0)+
    BNE.S   .scan_first_nul

    SUBQ.L  #1,A0
    SUBA.L  -20(A5),A0
    MOVE.L  A0,(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,(A7)
    PEA     _GCOMMAND_PpvTemplateFieldSeparatorByteStorage
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -24(A5),A0

    ; Find second NUL terminator to size the second string.
.scan_second_nul:
    TST.B   (A0)+
    BNE.S   .scan_second_nul

    SUBQ.L  #1,A0
    SUBA.L  -24(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -24(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     36(A7),A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======