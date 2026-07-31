    XDEF    _BRUSH_SelectBrushSlot
    XDEF    BRUSH_SelectBrushSlot_Return


; Evaluate the tile slot a brush should occupy, adjusting bounds and offsets.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_SelectBrushSlot   (Routine at _BRUSH_SelectBrushSlot)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +28: arg_7 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   BRUSH_SelectBrushSlot_Return, branch_12, lab_012E
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_SelectBrushSlot:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 28(A5),A2

    MOVE.L  A3,D0
    BEQ.W   BRUSH_SelectBrushSlot_Return

    MOVE.L  D5,D0
    SUB.L   D7,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  348(A3),D2
    CMP.L   D1,D2
    BLE.S   .lab_0128

    MOVE.L  D7,-4(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   .lab_0124

    MOVE.L  D2,D4
    SUB.L   D0,D4
    SUBQ.L  #1,D4
    MOVE.L  D4,-20(A5)
    BRA.W   .lab_012E

.lab_0124:
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BNE.S   .lab_0127

    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   .lab_0125

    ADDQ.L  #1,D4

.lab_0125:
    ASR.L   #1,D4
    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .lab_0126

    ADDQ.L  #1,D1

.lab_0126:
    ASR.L   #1,D1
    SUB.L   D1,D4
    MOVE.L  D4,-20(A5)
    BRA.S   .lab_012E

.lab_0127:
    MOVE.L  340(A3),D4
    MOVE.L  D4,-20(A5)
    BRA.S   .lab_012E

.lab_0128:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    CMP.L   D0,D2
    BGE.S   .lab_012D

    MOVE.L  340(A3),D0
    MOVE.L  D0,-20(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   .lab_0129

    MOVE.L  D5,D4
    SUB.L   D2,D4
    ADDQ.L  #1,D4
    MOVE.L  D4,-4(A5)
    BRA.S   .lab_012E

.lab_0129:
    SUBQ.L  #1,D1
    BNE.S   .lab_012C

    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .branch

    ADDQ.L  #1,D1

.branch:
    ASR.L   #1,D1
    ADD.L   D7,D1
    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   .branch_1

    ADDQ.L  #1,D4

.branch_1:
    ASR.L   #1,D4
    SUB.L   D4,D1
    MOVE.L  D1,-4(A5)
    BRA.S   .lab_012E

.lab_012C:
    MOVE.L  D7,-4(A5)
    BRA.S   .lab_012E

.lab_012D:
    MOVE.L  340(A3),D0
    MOVE.L  D7,D1
    MOVE.L  D0,-20(A5)
    MOVE.L  D1,-4(A5)

.lab_012E:
    MOVE.L  24(A5),D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  352(A3),D4
    CMP.L   D3,D4
    BLE.S   .branch_6

    MOVE.L  D6,-8(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   .branch_2

    MOVE.L  D4,D0
    SUB.L   D1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-24(A5)
    BRA.W   .branch_12

.branch_2:
    MOVEQ   #1,D1
    CMP.L   D1,D3
    BNE.S   .branch_5

    MOVE.L  D4,D3
    TST.L   D3
    BPL.S   .branch_3

    ADDQ.L  #1,D3

.branch_3:
    ASR.L   #1,D3
    MOVE.L  D0,D4
    SUB.L   D6,D4
    ADDQ.L  #1,D4
    TST.L   D4
    BPL.S   .branch_4

    ADDQ.L  #1,D4

.branch_4:
    ASR.L   #1,D4
    SUB.L   D4,D3
    MOVE.L  D3,-24(A5)
    BRA.S   .branch_12

.branch_5:
    MOVE.L  344(A3),D2
    MOVE.L  D2,-24(A5)
    BRA.S   .branch_12

.branch_6:
    MOVE.L  D0,D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    CMP.L   D1,D4
    BGE.S   .branch_11

    MOVE.L  344(A3),D1
    MOVE.L  D1,-24(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   .branch_7

    MOVE.L  D0,D1
    SUB.L   D4,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-8(A5)
    BRA.S   .branch_12

.branch_7:
    SUBQ.L  #1,D3
    BNE.S   .branch_10

    MOVE.L  D0,D3
    SUB.L   D6,D3
    ADDQ.L  #1,D3
    TST.L   D3
    BPL.S   .branch_8

    ADDQ.L  #1,D3

.branch_8:
    ASR.L   #1,D3
    ADD.L   D6,D3
    MOVE.L  D4,D2
    TST.L   D2
    BPL.S   .branch_9

    ADDQ.L  #1,D2

.branch_9:
    ASR.L   #1,D2
    SUB.L   D2,D3
    MOVE.L  D3,-8(A5)
    BRA.S   .branch_12

.branch_10:
    MOVE.L  D6,-8(A5)
    BRA.S   .branch_12

.branch_11:
    MOVE.L  344(A3),D1
    MOVE.L  D6,D3
    MOVE.L  D1,-24(A5)
    MOVE.L  D3,-8(A5)

.branch_12:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    MOVE.L  348(A3),D1
    CMP.L   D1,D0
    BLE.S   .branch_13

    MOVE.L  D1,D0

.branch_13:
    MOVE.L  24(A5),D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    MOVEM.L D0,-12(A5)
    MOVE.L  352(A3),D2
    CMP.L   D2,D1
    BLE.S   .branch_14

    MOVE.L  D2,D1

.branch_14:
    LEA     136(A3),A0
    MOVE.L  D1,-16(A5)
    MOVE.L  32(A5),D2
    TST.L   D2
    BGT.S   .branch_15

    MOVE.L  -24(A5),D2

.branch_15:
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

;------------------------------------------------------------------------------
; FUNC: BRUSH_SelectBrushSlot_Return   (Routine at BRUSH_SelectBrushSlot_Return)
; ARGS:
;   stack +52: arg_1 (via 56(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
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
BRUSH_SelectBrushSlot_Return:
    MOVEM.L -56(A5),D2-D7/A2-A3
    UNLK    A5
    RTS

;!======