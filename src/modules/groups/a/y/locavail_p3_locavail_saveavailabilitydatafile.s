    XDEF    _LOCAVAIL_SaveAvailabilityDataFile
    XDEF    LOCAVAIL_SaveAvailabilityDataFile_Return


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_SaveAvailabilityDataFile   (Routine at _LOCAVAIL_SaveAvailabilityDataFile)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +143: arg_3 (via 147(A5))
;   stack +144: arg_4 (via 148(A5))
;   stack +150: arg_5 (via 154(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField, _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   _LOCAVAIL_TAG_UVGTI, _LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save, _LOCAVAIL_STR_LA_VER_1_COLON_CURDAY, _LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY, MODE_NEWFILE, lab_0F4E, lab_0F4F, lab_0F52, lab_0F54, lab_0F54_0008, lab_0F5A, lab_0F5B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_SaveAvailabilityDataFile:
    LINK.W  A5,#-160
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    LEA     _LOCAVAIL_TAG_UVGTI,A0
    LEA     -154(A5),A1
    MOVEQ   #5,D0

.lab_0F4E:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.lab_0F4E
    PEA     MODE_NEWFILE.W
    PEA     _LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save
    JSR     _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BEQ.W   .lab_0F5B

    MOVE.L  A3,-4(A5)
    LEA     _LOCAVAIL_STR_LA_VER_1_COLON_CURDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)

.lab_0F4F:
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F50:
    TST.B   (A1)+
    BNE.S   .lab_0F50

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  2(A0),(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    MOVE.B  D0,-148(A5)
    CLR.B   -147(A5)
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F51:
    TST.B   (A1)+
    BNE.S   .lab_0F51

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

.lab_0F52:
    MOVEA.L -4(A5),A0
    CMP.L   2(A0),D7
    BGE.W   .lab_0F5A

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A1
    MOVEA.L 20(A1),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

.lab_0F53:
    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.S   .lab_0F58

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    CMPI.W  #5,D0
    BCC.S   .lab_0F56

    ADD.W   D0,D0
    MOVE.W  .lab_0F54(PC,D0.W),D0
    JMP     .lab_0F54+2(PC,D0.W)

; switch/jumptable
.lab_0F54:
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2

.lab_0F54_0008:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVEA.L -8(A5),A6
    MOVEA.L 6(A6),A1
    ADDA.L  D6,A1
    MOVEQ   #0,D0
    MOVE.B  (A1),D0
    LEA     -154(A5),A1
    ADDA.W  D0,A1
    MOVE.B  (A1),(A0)
    BRA.S   .lab_0F57

.lab_0F56:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVE.B  -154(A5),(A0)

.lab_0F57:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F53

.lab_0F58:
    LEA     -148(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    CLR.B   (A1)
    MOVEA.L A0,A1

.lab_0F59:
    TST.B   (A1)+
    BNE.S   .lab_0F59

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .lab_0F52

.lab_0F5A:
    MOVE.L  A2,-4(A5)
    SUBA.L  A2,A2
    LEA     _LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)
    TST.L   -4(A5)
    BNE.W   .lab_0F4F

    MOVE.L  D4,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    ADDQ.W  #4,A7
    BRA.S   LOCAVAIL_SaveAvailabilityDataFile_Return

.lab_0F5B:
    MOVEQ   #0,D5

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SaveAvailabilityDataFile_Return   (Routine at LOCAVAIL_SaveAvailabilityDataFile_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_SaveAvailabilityDataFile_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======