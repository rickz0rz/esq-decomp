;!======

;------------------------------------------------------------------------------
; FUNC: KYBD_InitializeInputDevices   (InitializeInputDevices)
; ARGS:
;   (none)
; RET:
;   D0: none (result codes ignored)
; CLOBBERS:
;   D0-D1/A0-A1/A6
; CALLS:
;   exec.library OpenDevice, exec.library DoIO
;   JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_3, JMP_TBL_ALLOCATE_IOSTDREQ, JMP_TBL_ALLOCATE_MEMORY_3
; READS:
;   GLOB_STR_INPUTDEVICE, GLOB_STR_CONSOLEDEVICE, GLOB_STR_INPUT_DEVICE, GLOB_STR_CONSOLE_DEVICE
; WRITES:
;   GLOB_REF_INPUTDEVICE_MSGPORT, GLOB_REF_CONSOLEDEVICE_MSGPORT
;   GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE
;   GLOB_REF_DATA_INPUT_BUFFER, LAB_231E, LAB_231B, LAB_231C
; DESC:
;   Allocates message ports and IOStdReqs, opens input/console devices,
;   and initializes the input event buffer for keyboard handling.
; NOTES:
;   Uses a 22-byte buffer and sets IOStdReq io_Command = 9 before DoIO.
;------------------------------------------------------------------------------
; Allocate message ports/IORequests and open console/input devices for keyboard handling.
KYBD_InitializeInputDevices:
    JSR     LAB_0E02(PC)

    CLR.L   -(A7)

    PEA     GLOB_STR_INPUTDEVICE
    JSR     JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_3(PC)

    MOVE.L  D0,GLOB_REF_INPUTDEVICE_MSGPORT

    MOVE.L  D0,(A7)
    JSR     JMP_TBL_ALLOCATE_IOSTDREQ(PC)

    MOVE.L  D0,GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE

    CLR.L   (A7)

    PEA     GLOB_STR_CONSOLEDEVICE
    JSR     JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_3(PC)

    MOVE.L  D0,GLOB_REF_CONSOLEDEVICE_MSGPORT

    MOVE.L  D0,(A7)
    JSR     JMP_TBL_ALLOCATE_IOSTDREQ(PC)

    MOVE.L  D0,GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE

    LEA     GLOB_STR_INPUT_DEVICE,A0
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1
    MOVE.L  D0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    LEA     GLOB_STR_CONSOLE_DEVICE,A0
    MOVEQ   #-1,D0
    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A1
    MOVEQ   #0,D1
    JSR     _LVOOpenDevice(A6)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A0
    MOVE.L  20(A0),LAB_231E

    ; 22 bytes
    PEA     (MEMF_PUBLIC).W
    PEA     22.W
    PEA     121.W
    PEA     GLOB_STR_KYBD_C
    JSR     JMP_TBL_ALLOCATE_MEMORY_3(PC)

    LEA     28(A7),A7
    MOVE.L  D0,GLOB_REF_DATA_INPUT_BUFFER

    MOVEA.L D0,A0
    MOVE.L  #LAB_231F,14(A0)
    LEA     LAB_0E03(PC),A0
    MOVEA.L GLOB_REF_DATA_INPUT_BUFFER,A1
    MOVE.L  A0,18(A1)
    MOVE.B  #$33,9(A1)
    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.W  #9,Struct_IOStdReq__io_Command(A0)
    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.L  GLOB_REF_DATA_INPUT_BUFFER,Struct_IOStdReq__io_Data(A0)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1 ; IORequest struct
    MOVEA.L AbsExecBase,A6
    JSR     _LVODoIO(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_231B
    MOVE.L  D0,LAB_231C
    RTS

;!======

JMP_TBL_ALLOCATE_IOSTDREQ:
    JMP     ALLOCATE_IOSTDREQ

JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_3:
    JMP     SETUP_SIGNAL_AND_MSGPORT

LAB_0E02:
    JMP     LAB_03CF

LAB_0E03:
    JMP     ESQ_InvokeGcommandInit

LAB_0E04:
    JMP     LAB_1ADD

;!======

    ; Alignment
    MOVEQ   #97,D0

;!======

;------------------------------------------------------------------------------
; FUNC: KYBD_UpdateHighlightState   (UpdateHighlightState)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   (none)
; READS:
;   LAB_1BC4, LAB_2251, LAB_2270
; WRITES:
;   WDISP_HighlightActive, WDISP_HighlightIndex, [A3] fields
; DESC:
;   Clears highlight state and walks banner rectangles to mark the active one.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46) via compare against 46.
;------------------------------------------------------------------------------
; Mark banner rectangles that should be highlighted based on the current cursor slot.
KYBD_UpdateHighlightState:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,WDISP_HighlightIndex
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0E08

    MOVEQ   #0,D7

.LAB_0E06:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .LAB_0E08

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    CLR.W   4(A3)
    MOVE.W  LAB_2270,D0
    MOVE.W  (A3),D1
    CMP.W   D0,D1
    BGT.S   .LAB_0E07

    MOVE.W  2(A3),D1
    CMP.W   D0,D1
    BLT.S   .LAB_0E07

    TST.L   6(A3)
    BEQ.S   .LAB_0E07

    MOVEQ   #1,D0
    MOVE.W  D0,4(A3)
    MOVE.W  D0,WDISP_HighlightActive

.LAB_0E07:
    ADDQ.L  #1,D7
    BRA.S   .LAB_0E06

.LAB_0E08:
    MOVEM.L (A7)+,D7/A3
    RTS
