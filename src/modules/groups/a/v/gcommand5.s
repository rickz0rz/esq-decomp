;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ProcessCtrlCommand   (ProcessCtrlCommand??)
; ARGS:
;   stack +4: cmdPtr
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D7, A3-A4
; CALLS:
;   GROUP_AV_JMPTBL_EXEC_CallVector_48
; READS:
;   4(A3), LAB_231B, LAB_231D
; WRITES:
;   LAB_231B, LAB_1FB0
; DESC:
;   Handles control commands, updating the circular ctrl buffer index.
; NOTES:
;   When command type is 1, compares against LAB_231D entry via GROUP_AV_JMPTBL_EXEC_CallVector_48.
;   Command types 15/16 set LAB_1FB0.
;------------------------------------------------------------------------------
GCOMMAND_ProcessCtrlCommand:
LAB_0DFB:
    LINK.W  A5,#-4
    MOVEM.L D7/A3-A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEA.L 8(A5),A3
    MOVEQ   #1,D0
    CMP.B   4(A3),D0
    BNE.S   .check_special_types

    MOVE.L  LAB_231B,D0
    LSL.L   #2,D0
    ADD.L   LAB_231B,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    CLR.L   -(A7)
    PEA     5.W
    MOVE.L  A0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AV_JMPTBL_EXEC_CallVector_48(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    TST.L   D7
    BLE.S   .return

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .return

    ADDQ.L  #1,LAB_231B
    CMPI.L  #$14,LAB_231B
    BLT.S   .return

    CLR.L   LAB_231B
    BRA.S   .return

.check_special_types:
    MOVE.B  4(A3),D0
    MOVEQ   #16,D1
    CMP.B   D1,D0
    BNE.S   .check_type_15

    MOVEQ   #1,D1
    MOVE.W  D1,LAB_1FB0
    BRA.S   .return

.check_type_15:
    MOVEQ   #15,D1
    CMP.B   D1,D0
    BNE.S   .return

    MOVE.W  #1,LAB_1FB0

.return:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,D7/A3-A4
    UNLK    A5
    RTS
