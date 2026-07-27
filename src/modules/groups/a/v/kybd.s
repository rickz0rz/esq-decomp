    XDEF    _KYBD_InitializeInputDevices

;------------------------------------------------------------------------------
; FUNC: _KYBD_InitializeInputDevices   (InitializeInputDevices)
; ARGS:
;   (none)
; RET:
;   D0: none (result codes ignored)
; CLOBBERS:
;   D0-D1/A0-A1/A6
; CALLS:
;   exec.library OpenDevice, exec.library DoIO
;   _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal, _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq, _NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_INPUTDEVICE, _Global_STR_CONSOLEDEVICE, _Global_STR_INPUT_DEVICE, _Global_STR_CONSOLE_DEVICE
; WRITES:
;   _Global_REF_INPUTDEVICE_MSGPORT, _Global_REF_CONSOLEDEVICE_MSGPORT
;   _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE
;   _Global_REF_DATA_INPUT_BUFFER, _INPUTDEVICE_LibraryBaseFromConsoleIo, _ED_StateRingWriteIndex, _ED_StateRingIndex
; DESC:
;   Allocates message ports and IOStdReqs, opens input/console devices,
;   and initializes the input event buffer for keyboard handling.
; NOTES:
;   Uses a 22-byte buffer and sets IOStdReq io_Command = 9 before DoIO.
;------------------------------------------------------------------------------
_KYBD_InitializeInputDevices:
    JSR     _GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

    CLR.L   -(A7)

    PEA     _Global_STR_INPUTDEVICE
    JSR     _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    MOVE.L  D0,_Global_REF_INPUTDEVICE_MSGPORT

    MOVE.L  D0,(A7)
    JSR     _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(PC)

    MOVE.L  D0,_Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE

    CLR.L   (A7)

    PEA     _Global_STR_CONSOLEDEVICE
    JSR     _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    MOVE.L  D0,_Global_REF_CONSOLEDEVICE_MSGPORT

    MOVE.L  D0,(A7)
    JSR     _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(PC)

    MOVE.L  D0,_Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE

    LEA     _Global_STR_INPUT_DEVICE,A0
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1
    MOVE.L  D0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    LEA     _Global_STR_CONSOLE_DEVICE,A0
    MOVEQ   #-1,D0
    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A1
    MOVEQ   #0,D1
    JSR     _LVOOpenDevice(A6)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A0
    MOVE.L  20(A0),_INPUTDEVICE_LibraryBaseFromConsoleIo

    ; 22 bytes
    PEA     (MEMF_PUBLIC).W
    PEA     22.W
    PEA     121.W
    PEA     _Global_STR_KYBD_C
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,_Global_REF_DATA_INPUT_BUFFER

    MOVEA.L D0,A0
    MOVE.L  #_INPUTDEVICE_HandlerUserDataLong,14(A0)
    LEA     _GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(PC),A0
    MOVEA.L _Global_REF_DATA_INPUT_BUFFER,A1
    MOVE.L  A0,18(A1)
    MOVE.B  #$33,9(A1)
    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.W  #9,Struct_IOStdReq__io_Command(A0)
    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.L  _Global_REF_DATA_INPUT_BUFFER,Struct_IOStdReq__io_Data(A0)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1 ; IORequest struct
    MOVEA.L AbsExecBase,A6
    JSR     _LVODoIO(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,_ED_StateRingWriteIndex
    MOVE.L  D0,_ED_StateRingIndex
    RTS
