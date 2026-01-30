;!======

LAB_1498:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStackAfterLink 4,4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.W  .stackOffsetBytes+10(A7),D7
    MOVE.W  .stackOffsetBytes+14(A7),D6
    MOVEQ   #0,D5

.LAB_1499:
    CMP.W   D6,D5
    BGE.S   .return

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D1,-(A7)
    PEA     394.W
    PEA     GLOB_STR_SCRIPT_C_1
    MOVE.L  D0,32(A7)
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  16(A7),D1
    MOVE.L  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   .LAB_1499

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_149B:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6

    MOVEQ   #0,D5

.LAB_149C:
    CMP.W   D6,D5
    BGE.S   .return

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  0(A3,D0.L),-(A7)
    PEA     405.W
    PEA     GLOB_STR_SCRIPT_C_2
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   0(A3,D0.L)
    ADDQ.W  #1,D5
    BRA.S   .LAB_149C

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_149E
    LINK.W  A5,#-12
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  26(A5),D6
    MOVE.B  31(A5),D5

    MOVEQ   #0,D0
    MOVE.W  D0,-6(A5)
    MOVE.W  D0,-10(A5)

.LAB_149F:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .LAB_14A0

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),0(A2,D1.L)
    ADDQ.W  #1,-6(A5)
    BRA.S   .LAB_149F

.LAB_14A0:
    MOVEQ   #0,D0
    MOVE.W  D0,-8(A5)
    MOVE.W  D0,-4(A5)

.LAB_14A1:
    MOVE.W  -4(A5),D0
    MOVE.B  0(A3,D0.W),-1(A5)
    MOVE.B  -1(A5),D1
    CMP.B   D5,D1
    BEQ.S   .LAB_14A5

    CMP.W   D6,D0
    BGE.S   .LAB_14A5

    MOVE.W  -8(A5),-6(A5)

.LAB_14A2:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .LAB_14A4

    MOVE.B  -1(A5),D1
    MOVEA.L 20(A5),A0
    CMP.B   0(A0,D0.W),D1
    BNE.S   .LAB_14A3

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -4(A5),D0
    MOVE.L  D0,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,0(A2,D1.L)
    CLR.B   0(A3,D0.W)
    ADDQ.W  #1,-8(A5)
    MOVE.W  D0,-10(A5)
    BRA.S   .LAB_14A4

.LAB_14A3:
    ADDQ.W  #1,-6(A5)
    BRA.S   .LAB_14A2

.LAB_14A4:
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -2(A2,D0.L),D1
    BNE.S   .LAB_14A5

    ADDQ.W  #1,-4(A5)
    BRA.S   .LAB_14A1

.LAB_14A5:
    TST.W   -10(A5)
    BNE.S   .LAB_14A6

    MOVE.W  -4(A5),-10(A5)

.LAB_14A6:
    TST.W   34(A5)
    BEQ.S   .return

    CLR.W   -6(A5)

.LAB_14A7:
    MOVE.W  -6(A5),D0
    CMP.W   D7,D0
    BGE.S   .return

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVEQ   #-1,D0
    CMP.W   0(A2,D1.L),D0
    BNE.S   .LAB_14A8

    MOVE.W  -10(A5),0(A2,D1.L)

.LAB_14A8:
    ADDQ.W  #1,-6(A5)
    BRA.S   .LAB_14A7

.return:
    MOVE.W  -4(A5),D0

    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    RTS
    DC.W    $0000

;!======

GROUPD_JMP_TBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

LAB_14AB:
    JMP     LAB_03A0

LAB_14AC:
    JMP     LAB_039A

GROUPD_JMP_TBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

JMP_TBL_DISKIO_OpenFileWithBuffer_2:
    JMP     DISKIO_OpenFileWithBuffer

;======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000