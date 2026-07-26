    XDEF    P_TYPE_AllocateEntry
    XDEF    P_TYPE_FreeEntry


;------------------------------------------------------------------------------
; FUNC: P_TYPE_AllocateEntry   (AllocateEntryuncertain)
; ARGS:
;   stack +8: typeByte (byte)
;   stack +12: length (long)
;   stack +16: dataPtr (byte *)
; RET:
;   D0: pointer to entry struct, or 0 on failure
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_AllocateMemory, SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   dataPtr
; WRITES:
;   allocated entry fields
; DESC:
;   Allocates an entry structure and optionally copies data into a payload buffer.
; NOTES:
;   Payload is only allocated when the input length matches the source string length.
;------------------------------------------------------------------------------
P_TYPE_AllocateEntry:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    CLR.L   -4(A5)
    TST.L   D6
    BLE.W   .branch_1361

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     10.W
    PEA     47.W
    PEA     Global_STR_P_TYPE_C_1
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .branch_1361

    MOVEA.L D0,A0
    MOVE.B  D7,(A0)
    MOVE.L  D6,2(A0)
    MOVEA.L A3,A0

.if_ne_135C:
    TST.B   (A0)+
    BNE.S   .if_ne_135C

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    CMPA.L  D6,A0
    BNE.S   .if_ne_135D

    MOVE.L  D6,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D1,-(A7)
    PEA     58.W
    PEA     Global_STR_P_TYPE_C_2
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    BRA.S   .skip_135E

.if_ne_135D:
    SUBA.L  A0,A0
    MOVEA.L D0,A1
    MOVE.L  A0,6(A1)

.skip_135E:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   .if_eq_1360

    MOVEQ   #0,D5

.loop_135F:
    CMP.L   D6,D5
    BGE.S   .branch_1361

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  0(A3,D5.L),D0
    MOVE.B  D0,(A0)
    ADDQ.L  #1,D5
    BRA.S   .loop_135F

.if_eq_1360:
    PEA     10.W
    MOVE.L  -4(A5),-(A7)
    PEA     77.W
    PEA     Global_STR_P_TYPE_C_3
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)

.branch_1361:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_FreeEntry   (Free entry struct and optional payload buffer)
; ARGS:
;   stack +8: entryPtr (struct PTypeEntry *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_P_TYPE_C_4, Global_STR_P_TYPE_C_5
; WRITES:
;   (none observed)
; DESC:
;   Frees payload buffer at +6 (if non-null) and then frees the 10-byte entry.
; NOTES:
;   Safe to call with null entry pointer.
;------------------------------------------------------------------------------
P_TYPE_FreeEntry:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return_1364

    TST.L   6(A3)
    BEQ.S   .if_eq_1363

    MOVE.L  2(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     92.W
    PEA     Global_STR_P_TYPE_C_4
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.if_eq_1363:
    PEA     10.W
    MOVE.L  A3,-(A7)
    PEA     95.W
    PEA     Global_STR_P_TYPE_C_5
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_1364:
    MOVEA.L (A7)+,A3
    RTS

;!======
