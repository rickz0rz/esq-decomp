;!======

LAB_0386:
    LINK.W  A5,#-4
    MOVE.L  A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #4,D0
    BNE.S   LAB_0387

    MOVE.L  LAB_1B20,-4(A5)
    BRA.S   LAB_038A

LAB_0387:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   LAB_0388

    MOVE.L  LAB_1B21,-4(A5)
    BRA.S   LAB_038A

LAB_0388:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BEQ.S   LAB_0389

    MOVE.W  LAB_1B84,D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BNE.S   LAB_038A

LAB_0389:
    MOVE.L  LAB_1B24,-4(A5)

LAB_038A:
    TST.L   BRUSH_LoadInProgressFlag      ; defer cleanup until brush list mutations finish
    BNE.S   LAB_038A

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0395(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #4,D0
    BNE.S   LAB_038B

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1B20
    BRA.S   LAB_038D

LAB_038B:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   LAB_038C

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1B21
    BRA.S   LAB_038D

LAB_038C:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BNE.S   LAB_038D

    CLR.L   LAB_1B24

LAB_038D:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.W  #1,LAB_1B83
    CLR.W   LAB_1B84
    PEA     14.W
    MOVE.L  GLOB_REF_LIST_IFF_TASK_PROC,-(A7)
    PEA     127.W
    PEA     GLOB_STR_CTASKS_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEA.L -8(A5),A4
    UNLK    A5
    RTS

;!======

LAB_038E:
    LINK.W  A5,#-4
    MOVEM.L D2-D4,-(A7)

LAB_038F:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    LEA     GLOB_STR_IFF_TASK_1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-4(A5)
    JSR     _LVOPermit(A6)

    TST.L   -4(A5)
    BNE.S   LAB_038F

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B83
    MOVE.W  LAB_1B84,D1
    SUBQ.W  #6,D1
    BEQ.S   LAB_0391

    MOVE.W  LAB_22C0,D1
    BEQ.S   LAB_0390

    MOVE.W  #4,LAB_1B84
    BRA.S   LAB_0391

LAB_0390:
    MOVE.W  #5,LAB_1B84

LAB_0391:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     159.W
    PEA     GLOB_STR_CTASKS_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    MOVE.L  D0,GLOB_REF_LIST_IFF_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     LAB_0386(PC),A0
    MOVEA.L GLOB_REF_LIST_IFF_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)

    MOVEA.L GLOB_REF_LIST_IFF_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,LAB_21B6
    MOVE.L  D0,D3
    LEA     GLOB_STR_IFF_TASK_2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,LAB_21B7
    MOVEM.L -16(A5),D2-D4
    UNLK    A5
    RTS

;!======

; End the CLOSE_TASK task.
LAB_0392:
    MOVE.L  A4,-(A7)

    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    TST.L   LAB_1B8B
    BEQ.S   .LAB_0393

    MOVE.L  LAB_1B8B,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1B8B

.LAB_0393:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     14.W
    MOVE.L  GLOB_REF_LIST_CLOSE_TASK_PROC,-(A7)
    PEA     194.W
    PEA     GLOB_STR_CTASKS_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.W  #1,LAB_1B8A

    MOVEA.L (A7)+,A4
    RTS

;!======

; Start the CLOSE_TASK task
LAB_0394:
    MOVEM.L D2-D4/D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    CLR.W   LAB_1B8A
    MOVE.L  D7,LAB_1B8B

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     203.W
    PEA     GLOB_STR_CTASKS_C_4
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_LIST_CLOSE_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     LAB_0392(PC),A0
    MOVEA.L GLOB_REF_LIST_CLOSE_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)
    MOVEA.L GLOB_REF_LIST_CLOSE_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,LAB_21B9
    MOVE.L  D0,D3

    LEA     GLOB_STR_CLOSE_TASK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,LAB_21BA
    MOVEM.L (A7)+,D2-D4/D7
    RTS

;!======

    ; Alignment
    DC.W    $0000

;!======

LAB_0395:
    JMP     GCOMMAND_SaveBrushResult

    MOVEQ   #97,D0
    RTS

;!======

    ; Alignment
    DC.W    $0000
