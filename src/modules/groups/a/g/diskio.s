;------------------------------------------------------------------------------
; FUNC: DISKIO_OpenFileWithBuffer   (Open file and initialize I/O buffer??)
; ARGS:
;   stack +16: filePathPtr (A3)
;   stack +20: accessMode (D7)
; RET:
;   D0: file handle or 0 on failure
; CLOBBERS:
;   D0/D6-D7/A3
; CALLS:
;   LAB_0466, UNKNOWN2B_OpenFileWithAccessMode, MEMORY_AllocateMemory
; READS:
;   DISKIO_OpenCount, LAB_1F45, DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize
; WRITES:
;   DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase, DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag, DISKIO_OpenCount, LAB_1F45, DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr, DISKIO_BufferState+Struct_DiskIoBufferState__Remaining, DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45
; DESC:
;   Opens a file and allocates a global buffer used by disk I/O helpers.
; NOTES:
;   Early-exits if DISKIO_OpenCount is non-zero (already active). On first open, saves
;   LAB_1F45 into DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45 and forces LAB_1F45 = $0100. Buffer size is DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize.
;------------------------------------------------------------------------------
DISKIO_OpenFileWithBuffer:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVE.L,2,D7

    MOVEQ   #0,D6
    JSR     LAB_0466(PC)

    TST.L   DISKIO_OpenCount
    BNE.S   .return

    CLR.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_0398

    TST.L   DISKIO_OpenCount
    BNE.S   .LAB_0397

    MOVE.W  LAB_1F45,DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45

.LAB_0397:
    ADDQ.L  #1,DISKIO_OpenCount
    MOVE.W  #$100,LAB_1F45

    PEA     (MEMF_PUBLIC).W
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    PEA     286.W
    PEA     GLOB_STR_DISKIO_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    MOVE.L  D0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D0,DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase

.LAB_0398:
    JSR     LAB_0466(PC)

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_039A:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    JSR     LAB_0466(PC)

    TST.L   D7
    BEQ.S   LAB_039D

    CLR.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D0
    SUB.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   LAB_039B

    MOVE.L  D7,D1
    MOVE.L  D6,D3
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    CMP.L   D3,D0

LAB_039B:
    JSR     LAB_0466(PC)

    MOVE.L  D7,-(A7)
    JSR     LAB_0394(PC)

    ADDQ.W  #4,A7

LAB_039C:
    JSR     LAB_0466(PC)

    MOVEQ   #5,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODelay(A6)

    JSR     LAB_0466(PC)

    TST.W   LAB_1B8A
    BEQ.S   LAB_039C

    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,-(A7)
    PEA     353.W
    PEA     GLOB_STR_DISKIO_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    JSR     LAB_0466(PC)

    LEA     16(A7),A7

LAB_039D:
    MOVE.L  DISKIO_OpenCount,D0
    TST.L   D0
    BLE.S   LAB_039E

    SUBQ.L  #1,DISKIO_OpenCount

LAB_039E:
    TST.L   DISKIO_OpenCount
    BNE.S   LAB_039F

    TST.W   LAB_2263
    BNE.S   LAB_039F

    MOVE.W  DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45,LAB_1F45

LAB_039F:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

LAB_03A0:
    MOVEM.L D2-D7/A3,-(A7)

    SetOffsetForStack 7
    UseStackLong    MOVE.L,1,D7     ; Value LAB_21BE
    UseStackLong    MOVEA.L,2,A3    ; Address LAB_1DC8
    UseStackLong    MOVE.L,3,D6     ; 21

    MOVE.L  D6,D5
    MOVE.L  D6,D4
    MOVE.L  A3,D0
    BEQ.S   LAB_03A1

    TST.L   D6
    BEQ.S   LAB_03A1

    MOVEQ   #1,D0
    CMP.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag,D0
    BEQ.S   LAB_03A1

    TST.L   D7
    BNE.S   LAB_03A2

LAB_03A1:
    MOVEQ   #0,D0
    BRA.S   LAB_03A8

LAB_03A2:
    JSR     LAB_0466(PC)

LAB_03A3:
    MOVEA.L DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr,A0
    MOVE.B  (A3)+,(A0)+
    MOVE.L  A0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    SUBQ.L  #1,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    SUBQ.L  #1,D6
    MOVE.L  A0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    TST.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BEQ.S   LAB_03A4

    TST.L   D6
    BNE.S   LAB_03A3

LAB_03A4:
    JSR     LAB_0466(PC)

    TST.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BNE.S   LAB_03A6

    MOVE.L  D7,D1
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D5
    CMP.L   D3,D5
    BEQ.S   LAB_03A5

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    BRA.S   LAB_03A7

LAB_03A5:
    MOVE.L  D4,D5
    MOVE.L  D2,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D3,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    JSR     LAB_0466(PC)

LAB_03A6:
    TST.L   D6
    BNE.S   LAB_03A2

LAB_03A7:
    MOVE.L  D5,D0

LAB_03A8:
    MOVEM.L (A7)+,D2-D7/A3
    RTS

;!======

LAB_03A9:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6

    MOVE.L  D6,-(A7)
    PEA     GLOB_STR_PERCENT_LD
    PEA     -10(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -10(A5),A0
    MOVEA.L A0,A1

.LAB_03AA:
    TST.B   (A1)+
    BNE.S   .LAB_03AA

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_03A0

    MOVEM.L -20(A5),D6-D7
    UNLK    A5
    RTS

;!======

DISKIO_GetFilesizeFromHandle:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    ; Jump to the end of the file.
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_END),D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOSeek(A6)

    ; Seek to the current (end) of the file
    ; so that the oldPosition is set in D0
    MOVE.L  D7,D1
    MOVE.L  D2,D3   ; D2 is 0, so this is OFFSET_CURRENT
    JSR     _LVOSeek(A6)

    ; Copy the oldPosition to D6 then seek to the beginning
    ; of the file again.
    MOVE.L  D0,D6
    MOVE.L  D7,D1
    MOVEQ   #(OFFSET_BEGINNING),D3
    JSR     _LVOSeek(A6)

    ; Return the total size of the file in D0
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

; Load a file into memory?
LAB_03AC:
    MOVEM.L D2-D3/D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3

    ; Open the filename in A3
    PEA     (MODE_OLDFILE).W
    MOVE.L  A3,-(A7)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7

    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .successfullyOpenedFile

    MOVEQ   #-1,D0
    BRA.W   .return

.successfullyOpenedFile:
    MOVE.L  D7,-(A7)
    BSR.S   DISKIO_GetFilesizeFromHandle

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BGT.S   .LAB_03AE

    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_03AE:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     472.W
    PEA     GLOB_STR_DISKIO_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_21BC
    TST.L   D0
    BNE.S   .LAB_03AF

    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_03AF:
    MOVE.L  D7,D1
    MOVE.L  LAB_21BC,D2
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D1
    CMP.L   D1,D0
    BEQ.S   .LAB_03B0

    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_21BC,-(A7)
    PEA     492.W
    PEA     GLOB_STR_DISKIO_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_03B0:
    MOVE.L  D7,D1
    JSR     _LVOClose(A6)

    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0

.return:
    MOVEM.L (A7)+,D2-D3/D7/A3
    RTS

;!======

LAB_03B2:
    LINK.W  A5,#-4
    MOVE.L  LAB_21BC,-4(A5)

LAB_03B3:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   LAB_03B4

    MOVEA.L LAB_21BC,A0
    MOVE.B  (A0)+,D0
    MOVE.L  A0,LAB_21BC
    TST.B   D0
    BNE.S   LAB_03B3

LAB_03B4:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   LAB_03B5

    MOVEA.W #$ffff,A0
    MOVE.L  A0,-4(A5)

LAB_03B5:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS

;!======

LAB_03B6:
    LINK.W  A5,#-4

    BSR.S   LAB_03B2

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-4(A5)
    CMP.L   A0,D0
    BNE.S   .LAB_03B7

    MOVE.L  A0,D0
    BRA.S   .return

.LAB_03B7:
    MOVE.L  D0,-(A7)
    JSR     LAB_0468(PC)

.return:
    UNLK    A5
    RTS

;!======

LAB_03B9:
    LINK.W  A5,#-4
    MOVE.L  LAB_21BC,-4(A5)

LAB_03BA:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   LAB_03BB

    MOVEA.L LAB_21BC,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   LAB_03BB

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   LAB_03BB

    ADDQ.L  #1,LAB_21BC
    BRA.S   LAB_03BA

LAB_03BB:
    MOVEA.L LAB_21BC,A0
    CLR.B   (A0)+
    MOVE.L  A0,LAB_21BC
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   LAB_03BC

    MOVEA.W #(-1),A0
    MOVE.L  A0,D0
    BRA.S   LAB_03BF

LAB_03BC:
    MOVEA.L LAB_21BC,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   LAB_03BD

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   LAB_03BE

LAB_03BD:
    ADDQ.L  #1,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    BRA.S   LAB_03BC

LAB_03BE:
    MOVE.L  -4(A5),D0

LAB_03BF:
    UNLK    A5
    RTS

;!======

LAB_03C0:
    LINK.W  A5,#-12
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     567.W
    PEA     GLOB_STR_DISKIO_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .LAB_03C2

    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .LAB_03C1

    MOVEA.L D2,A0
    MOVE.L  16(A0),D0
    MOVEQ   #100,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  12(A0),D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  20(A0),D0
    ADD.L   D0,D0
    MOVE.L  D0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize

.LAB_03C1:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     574.W
    PEA     GLOB_STR_DISKIO_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.LAB_03C2:
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_03C4:
    LINK.W  A5,#-12
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     593.W
    PEA     GLOB_STR_DISKIO_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .LAB_03C6

    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .LAB_03C5

    MOVEA.L D2,A0
    MOVE.L  (A0),D7

.LAB_03C5:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     599.W
    PEA     GLOB_STR_DISKIO_C_8
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.LAB_03C6:
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_03C8:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  LAB_1F45,LAB_21CB
    MOVE.W  #$100,LAB_1F45
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  A3,D2
    MOVE.L  D0,D3
    MOVE.L  LAB_21C5,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D6
    CMP.W   D7,D6
    MOVE.W  LAB_21CB,LAB_1F45
    CMP.W   D7,D6
    BEQ.S   .LAB_03C9

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_03C9:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======

LAB_03CB:
    TST.W   LAB_2263
    BNE.S   .return

    MOVE.W  #$100,LAB_1F45
    MOVE.W  #(-1),LAB_234A
    JSR     LAB_0464(PC)

.return:
    RTS

;!======

LAB_03CD:
    TST.W   LAB_2263
    BNE.S   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2284
    MOVE.W  D0,LAB_2282
    MOVE.W  D0,CTRL_H
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_234A
    MOVE.W  D0,LAB_1F45

.return:
    RTS

;!======

LAB_03CF:
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    CLR.L   -(A7)
    CLR.L   -(A7)
    JSR     GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    MOVE.L  D0,LAB_21CD
    PEA     56.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0463(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_21CE
    MOVEQ   #0,D7

.LAB_03D0:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.W   .LAB_03D7

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     LAB_2318,A0
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.L  D0,(A0)
    LEA     LAB_231A,A0
    ADDA.L  D1,A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    LEA     LAB_1BD7,A0
    MOVEA.L LAB_21CE,A1
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_03D1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2318,A0
    ADDA.L  D0,A0
    MOVE.L  #218,(A0)
    LEA     LAB_231A,A0
    ADDA.L  D0,A0
    MOVE.L  #223,(A0)
    BRA.W   .LAB_03D6

.LAB_03D1:
    MOVEA.L LAB_21CE,A0
    MOVE.W  #14,28(A0)
    MOVEA.L LAB_21CE,A1
    JSR     _LVODoIO(A6)

    MOVEA.L LAB_21CE,A0
    TST.B   31(A0)
    BEQ.S   .LAB_03D2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2318,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #113,D0
    ADD.L   D0,D0
    MOVE.L  D0,(A2)
    BRA.S   .LAB_03D3

.LAB_03D2:
    TST.L   32(A0)
    BEQ.S   .LAB_03D3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2318,A1
    ADDA.L  D0,A1
    MOVE.L  #$e2,(A1)

.LAB_03D3:
    MOVEA.L LAB_21CE,A0
    MOVE.W  #15,28(A0)
    MOVEA.L LAB_21CE,A1
    JSR     _LVODoIO(A6)

    MOVEA.L LAB_21CE,A0
    TST.B   31(A0)
    BEQ.S   .LAB_03D4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_231A,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D0
    NOT.B   D0
    MOVE.L  D0,(A1)
    BRA.S   .LAB_03D5

.LAB_03D4:
    TST.L   32(A0)
    BEQ.S   .LAB_03D5

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_231A,A0
    ADDA.L  D0,A0
    MOVE.L  #$df,(A0)

.LAB_03D5:
    MOVEA.L LAB_21CE,A1
    JSR     _LVOCloseDevice(A6)

.LAB_03D6:
    ADDQ.L  #1,D7
    BRA.W   .LAB_03D0

.LAB_03D7:
    MOVE.L  LAB_21CE,-(A7)
    JSR     LAB_0467(PC)

    MOVE.L  LAB_21CD,(A7)
    JSR     GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    ADDQ.W  #4,A7
    TST.W   LAB_1DE5
    BEQ.W   .return

    CLR.W   LAB_1FB0
    TST.L   LAB_2318
    BEQ.S   .LAB_03D8

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1BD5

.LAB_03D8:
    TST.L   LAB_2319
    BEQ.S   .LAB_03D9

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1BD6

.LAB_03D9:
    TST.L   LAB_1BD5
    BEQ.W   .LAB_03DA

    TST.L   LAB_2318
    BNE.W   .LAB_03DA

    MOVE.W  LAB_1F45,D5
    MOVE.W  #$100,LAB_1F45
    LEA     LAB_1BD8,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BD9,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDA,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDB,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDC,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDD,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDE,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BDF,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.W  D5,LAB_1F45
    MOVE.L  D2,LAB_1BD5

.LAB_03DA:
    TST.L   LAB_1BD6
    BEQ.S   .return

    TST.L   LAB_2319
    BNE.S   .return

    PEA     LAB_1BE0
    JSR     GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .LAB_03DB

    LEA     LAB_1BE1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.S   .LAB_03DC

.LAB_03DB:
    LEA     LAB_1BE2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.LAB_03DC:
    MOVE.L  D2,LAB_1BD6

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    RTS

;!======

LAB_03DE:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.W   LAB_2252
    BEQ.S   .return

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_1B99,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_03E0:
    LINK.W  A5,#-8
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVEQ   #0,D6
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA2
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA3
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA4
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA5
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BA6
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BA7
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA8
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03E1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BA9
    BRA.S   .LAB_03E2

.LAB_03E1:
    MOVEQ   #78,D0
    MOVE.B  D0,LAB_1BA9

.LAB_03E2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03E3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAA
    BRA.S   .LAB_03E4

.LAB_03E3:
    MOVE.B  #$41,LAB_1BAA

.LAB_03E4:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAB
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03E6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAC
    TST.B   D1
    BMI.S   .LAB_03E5

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .LAB_03E6

.LAB_03E5:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1BAC

.LAB_03E6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03E8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAD
    TST.B   D1
    BMI.S   .LAB_03E7

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .LAB_03E8

.LAB_03E7:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1BAD

.LAB_03E8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03E9

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAE
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03E9

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03E9

    MOVE.B  D0,LAB_1BAE

.LAB_03E9:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03EA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BAF
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EA

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03EA

    MOVE.B  D0,LAB_1BAF

.LAB_03EA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03EB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB0
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EB

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03EB

    MOVE.B  D2,LAB_1BB0

.LAB_03EB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03EC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB1
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03EC

    MOVE.B  D2,LAB_1BB1

.LAB_03EC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03ED

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB2
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03ED

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03ED

    MOVE.B  D0,LAB_1BB2

.LAB_03ED:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03EE

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB3
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EE

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EE

    MOVE.B  D0,LAB_1BB3

.LAB_03EE:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03EF

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB4
    MOVEQ   #76,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03EF

    MOVEQ   #83,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03EF

    MOVEQ   #86,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03EF

    MOVE.B  D0,LAB_1BB4

.LAB_03EF:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F0

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BB5

.LAB_03F0:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BB6

.LAB_03F1:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F2

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB7
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03F2

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03F2

    MOVE.B  D0,LAB_1BB7

.LAB_03F2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB8
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03F3

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03F3

    MOVE.B  D0,LAB_1BB8

.LAB_03F3:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F4

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BB9
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03F4

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03F4

    MOVE.B  D0,LAB_1BB9

.LAB_03F4:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F5

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BBA

.LAB_03F5:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BBB

.LAB_03F6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F7

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_1BBC

.LAB_03F7:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03F8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-5(A5)
    CLR.B   -4(A5)
    PEA     -7(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,LAB_1BBD

.LAB_03F8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03FA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVE.L  D1,LAB_1BBE
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BLT.S   .LAB_03F9

    MOVEQ   #9,D2
    CMP.L   D2,D1
    BLE.S   .LAB_03FA

.LAB_03F9:
    MOVE.L  D0,LAB_1BBE

.LAB_03FA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03FB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     BRUSH_SelectBrushByLabel(PC)

    ADDQ.W  #4,A7

.LAB_03FB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_03FC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BBF
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03FC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03FC

    MOVE.B  D0,LAB_1BBF

.LAB_03FC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0400

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,GLOB_REF_STR_USE_24_HR_CLOCK
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_03FD

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_03FD

    MOVE.B  D2,GLOB_REF_STR_USE_24_HR_CLOCK

.LAB_03FD:
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D1
    CMP.B   D0,D1
    BNE.S   .LAB_03FE

    LEA     GLOB_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .LAB_03FF

.LAB_03FE:
    LEA     GLOB_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.LAB_03FF:
    MOVE.L  A0,GLOB_REF_STR_CLOCK_FORMAT

.LAB_0400:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0401

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC1
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_0401

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_0401

    MOVE.B  D0,LAB_1BC1

.LAB_0401:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.W   .LAB_0409

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .LAB_0402

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .LAB_0403

.LAB_0402:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.LAB_0403:
    MOVEQ   #67,D1
    SUB.L   D1,D0
    BEQ.S   .LAB_0405

    SUBQ.L  #3,D0
    BEQ.S   .LAB_0404

    SUBQ.L  #2,D0
    BEQ.S   .LAB_0406

    SUBQ.L  #8,D0
    BEQ.S   .LAB_0406

    BRA.S   .LAB_0406

.LAB_0404:
    MOVE.W  #128,GLOB_REF_WORD_HEX_CODE_8E
    ADDQ.W  #1,D6
    BRA.S   .LAB_0407

.LAB_0405:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVE.W  D1,GLOB_REF_WORD_HEX_CODE_8E
    BRA.S   .LAB_0407

.LAB_0406:
    MOVE.W  #$8e,GLOB_REF_WORD_HEX_CODE_8E
    ADDQ.W  #1,D6

.LAB_0407:
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    CMPI.W  #128,D0
    BCS.S   .LAB_0408

    CMPI.W  #220,D0
    BLS.S   .LAB_0409

.LAB_0408:
    MOVE.W  #$8e,GLOB_REF_WORD_HEX_CODE_8E

.LAB_0409:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_040B

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,GLOB_REF_BYTE_NUMBER_OF_COLOR_PALETTES
    MOVEQ   #8,D0
    CMP.B   D0,D1
    BLT.S   .LAB_040A

    CMP.B   D0,D1
    BLE.S   .LAB_040B

.LAB_040A:
    MOVE.B  D0,GLOB_REF_BYTE_NUMBER_OF_COLOR_PALETTES

.LAB_040B:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_040F

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .LAB_040C

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .LAB_040D

.LAB_040C:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.LAB_040D:
    MOVE.B  D0,LAB_1BC4
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1BE3
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .LAB_040E

    MOVE.B  LAB_1BC4,D0
    TST.B   D0
    BNE.S   .LAB_040F

.LAB_040E:
    MOVEQ   #78,D0
    MOVE.B  D0,LAB_1BC4

.LAB_040F:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0410

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC5
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_0410

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_0410

    MOVE.B  D2,LAB_1BC5

.LAB_0410:
    MOVE.B  LAB_1BC5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0411

    BSR.W   LAB_0418

.LAB_0411:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0413

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC6
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     LAB_1BE4
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .LAB_0412

    MOVE.B  LAB_1BC6,D0
    TST.B   D0
    BNE.S   .LAB_0413

.LAB_0412:
    MOVEQ   #78,D0
    MOVE.B  D0,LAB_1BC6

.LAB_0413:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0415

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC7
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .LAB_0414

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_0414

    MOVE.B  D0,LAB_1BC7

.LAB_0414:
    MOVE.B  LAB_1BC7,D1
    CMP.B   D0,D1
    BEQ.S   .LAB_0415

    MOVE.B  D0,LAB_1BC7
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    MOVE.B  #$4e,LAB_1BC7

.LAB_0415:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .LAB_0416

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC8
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     LAB_1BE5
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_0416

    MOVE.B  #'N',LAB_1BC8

.LAB_0416:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .return

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,LAB_1BC9
    MOVEQ   #49,D0
    CMP.B   D0,D1
    BEQ.S   .return

    MOVEQ   #50,D2
    CMP.B   D2,D1
    BEQ.S   .return

    MOVE.B  D0,LAB_1BC9

.return:
    MOVE.B  LAB_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    JSR     LAB_046F(PC)

    MOVE.B  LAB_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_1BCA
    MOVEM.L -28(A5),D2/D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0418:
    MOVEM.L D2-D3,-(A7)
    TST.W   LAB_1BE6
    BNE.S   LAB_0419

    MOVE.W  #1,LAB_1BE6
    LEA     LAB_1BE7,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     LAB_1BE8,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

LAB_0419:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; perhaps dealing with loading or saving configuration?
LAB_041A:
    LINK.W  A5,#-212
    MOVEM.L D2-D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     GLOB_STR_DF0_CONFIG_DAT_1
    BSR.W   DISKIO_OpenFileWithBuffer

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   LAB_041B

    MOVEQ   #-1,D0
    BRA.W   LAB_041C

LAB_041B:
    MOVEQ   #67,D6
    MOVEQ   #0,D0
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D5
    MOVE.B  LAB_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  LAB_1BA3,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  LAB_1BA4,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  LAB_1BA5,D3
    EXT.W   D3
    EXT.L   D3
    MOVE.B  LAB_1BA6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,40(A7)
    MOVE.B  LAB_1BA7,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,44(A7)
    MOVE.B  LAB_1BA8,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,48(A7)
    MOVE.B  LAB_1BA9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,52(A7)
    MOVE.B  LAB_1BAA,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,56(A7)
    MOVE.B  LAB_1BAB,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,60(A7)
    MOVE.B  LAB_1BAC,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,64(A7)
    MOVE.B  LAB_1BAD,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,68(A7)
    MOVE.B  LAB_1BAE,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,72(A7)
    MOVE.B  LAB_1BAF,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,76(A7)
    MOVE.B  LAB_1BB0,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,80(A7)
    MOVE.B  LAB_1BB1,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,84(A7)
    MOVE.B  LAB_1BB2,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,88(A7)
    MOVE.B  LAB_1BB3,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,92(A7)
    MOVE.B  LAB_1BB4,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,96(A7)
    MOVE.B  LAB_1BB5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,100(A7)
    MOVE.B  LAB_1BB6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,104(A7)
    MOVE.B  LAB_1BB7,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,108(A7)
    MOVE.B  LAB_1BB8,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,112(A7)
    MOVE.B  LAB_1BB9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,116(A7)
    MOVE.B  LAB_1BBA,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,120(A7)
    MOVE.B  LAB_1BBB,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,124(A7)
    MOVE.B  LAB_1BBC,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,128(A7)
    MOVE.B  LAB_1BBF,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,132(A7)
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,136(A7)
    MOVE.B  LAB_1BC1,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,140(A7)
    MOVE.L  D6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,144(A7)
    MOVE.L  D5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,148(A7)
    MOVE.B  GLOB_REF_BYTE_NUMBER_OF_COLOR_PALETTES,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,152(A7)
    MOVE.B  LAB_1BC4,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,156(A7)
    MOVE.B  LAB_1BC5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,160(A7)
    MOVE.B  LAB_1BC6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,164(A7)
    MOVE.B  LAB_1BC7,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,168(A7)
    MOVE.B  LAB_1BC8,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,172(A7)
    MOVE.B  LAB_1BC9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    PEA     BRUSH_LabelScratch
    MOVE.L  LAB_1BBE,-(A7)
    MOVE.L  LAB_1BBD,-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_DEFAULT_CONFIG_FORMATTED
    PEA     -58(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     176(A7),A7
    PEA     52.W
    PEA     -58(A5)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_03A0

    MOVE.L  D7,(A7)
    BSR.W   LAB_039A

LAB_041C:
    MOVEM.L -236(A5),D2-D7
    UNLK    A5
    RTS

;!======

; Load the configuration
LAB_041D:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    PEA     GLOB_STR_DF0_CONFIG_DAT_2
    BSR.W   LAB_03AC

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .LAB_041E

    MOVEQ   #-1,D6
    BRA.S   .return

.LAB_041E:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   LAB_03E0

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1344.W
    PEA     GLOB_STR_DISKIO_C_9
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
