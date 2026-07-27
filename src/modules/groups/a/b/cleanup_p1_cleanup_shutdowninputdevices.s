    XDEF    _CLEANUP_ShutdownInputDevices



; IORequest: https://github.com/prb28/vscode-amiga-assembly/blob/master/docs/libs/exec/_0094.md

; struct IORequest {
;     struct Message {
;         struct Node {
;             struct  Node *ln_Succ;        /* Pointer to next (successor) -- bytes 0-3 */
;             struct  Node *ln_Pred;        /* Pointer to previous (predecessor) - bytes 4-7 */
;             UBYTE   ln_Type;              /* http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node0091.html#line43 - byte 8 */
;             BYTE    ln_Pri;               /* Priority, for sorting - byte 9 */
;             char    *ln_Name;             /* ID string, null terminated - byte 10 */
;         };                                /* Note: word aligned - null byte 11? */
;         struct  MsgPort *mn_ReplyPort;    /* message reply port - bytes 12-15 */
;         UWORD   mn_Length;                /* total message length, in bytes - bytes 16-17 */
;     }                                     /* (include the size of the Message structure in the length) */
;     struct  Device  *io_Device;           /* device node pointer - bytes 18-21 */
;     struct  Unit    *io_Unit;             /* unit (driver private) - bytes 22-25 */
;     UWORD   io_Command;                   /* device command - bytes 26-27 */
;     UBYTE   io_Flags;                     /* byte 28 */
;     BYTE    io_Error;                     /* error or warning num - byte 29 */
; }

;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ShutdownInputDevices
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A0-A1/A6
; CALLS:
;   _LVODoIO, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOCloseDevice,
;   _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, _GROUP_AB_JMPTBL_IOSTDREQ_Free
; READS:
;   _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, _Global_REF_DATA_INPUT_BUFFER,
;   _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE, _Global_REF_INPUTDEVICE_MSGPORT,
;   _Global_REF_CONSOLEDEVICE_MSGPORT, AbsExecBase, _Global_STR_CLEANUP_C_5
; WRITES:
;   IOStdReq input fields (io_Command/io_Data)
; DESC:
;   Flushes and closes input/console devices, frees the input buffer, and
;   releases the associated msg ports and IO request blocks.
;------------------------------------------------------------------------------
; Tears down console/input devices opened during startup, including msg ports.
_CLEANUP_ShutdownInputDevices:
    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.W  #10,28(A0)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.L  _Global_REF_DATA_INPUT_BUFFER,40(A0)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1

    MOVEA.L AbsExecBase,A6
    JSR     _LVODoIO(A6)

    PEA     Struct_InputEvent_Size.W
    MOVE.L  _Global_REF_DATA_INPUT_BUFFER,-(A7)
    PEA     127.W
    PEA     _Global_STR_CLEANUP_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVEA.L _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A1
    JSR     _LVOCloseDevice(A6)

    MOVE.L  _Global_REF_INPUTDEVICE_MSGPORT,(A7)
    JSR     _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  _Global_REF_CONSOLEDEVICE_MSGPORT,(A7)
    JSR     _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,(A7)
    JSR     _GROUP_AB_JMPTBL_IOSTDREQ_Free(PC)

    MOVE.L  _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,(A7)
    JSR     _GROUP_AB_JMPTBL_IOSTDREQ_Free(PC)

    LEA     16(A7),A7
    RTS

;!======