;!======

;------------------------------------------------------------------------------
; FUNC: CLEAR_INTERRUPT_INTB_VERTB   (ClearVertbInterruptServer??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVORemIntServer, JMP_TBL_DEALLOCATE_MEMORY_1
; READS:
;   GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB, AbsExecBase, GLOB_STR_CLEANUP_C_1
; WRITES:
;   (none)
; DESC:
;   Removes the INTB_VERTB interrupt server and frees its interrupt structure.
; NOTES:
;   - Deallocates the struct via JMP_TBL_DEALLOCATE_MEMORY_1.
;------------------------------------------------------------------------------
CLEAR_INTERRUPT_INTB_VERTB:
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVORemIntServer(A6)

    PEA     Struct_Interrupt_Size.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,-(A7)
    PEA     57.W
    PEA     GLOB_STR_CLEANUP_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEAR_INTERRUPT_INTB_AUD1   (ClearAud1InterruptVector??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOSetIntVector, JMP_TBL_DEALLOCATE_MEMORY_1
; READS:
;   GLOB_REF_INTB_AUD1_INTERRUPT, GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,
;   AbsExecBase, GLOB_STR_CLEANUP_C_2
; WRITES:
;   INTENA
; DESC:
;   Restores the AUD1 interrupt vector and frees its interrupt structure.
; NOTES:
;   - Disables INTB_AUD1 in INTENA before restoring the vector.
;------------------------------------------------------------------------------
CLEAR_INTERRUPT_INTB_AUD1:
    MOVE.W  #$100,INTENA
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L GLOB_REF_INTB_AUD1_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    PEA     22.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,-(A7)
    PEA     74.W
    PEA     GLOB_STR_CLEANUP_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEAR_INTERRUPT_INTB_RBF   (ClearRbfInterruptAndSerial??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOCloseDevice, JMP_TBL_CLEANUP_SIGNAL_AND_MSGPORT, LAB_0467,
;   _LVOSetIntVector, JMP_TBL_DEALLOCATE_MEMORY_1
; READS:
;   LAB_2211_SERIAL_PORT_MAYBE, LAB_2212, GLOB_REF_INTB_RBF_INTERRUPT,
;   GLOB_REF_INTB_RBF_64K_BUFFER, GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,
;   AbsExecBase, GLOB_STR_CLEANUP_C_3, GLOB_STR_CLEANUP_C_4
; WRITES:
;   INTENA
; DESC:
;   Closes the serial device, restores the INTB_RBF interrupt vector, and
;   frees the RBF interrupt buffer/structure.
; NOTES:
;   - Signals the serial msg port before closing/freeing resources.
;------------------------------------------------------------------------------
CLEAR_INTERRUPT_INTB_RBF:
    MOVE.W  #$800,INTENA
    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVE.L  LAB_2212,-(A7)
    JSR     JMP_TBL_CLEANUP_SIGNAL_AND_MSGPORT(PC)

    MOVE.L  LAB_2211_SERIAL_PORT_MAYBE,(A7)
    JSR     LAB_0467(PC)

    MOVEQ   #INTB_RBF,D0
    MOVEA.L GLOB_REF_INTB_RBF_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  #64000,(A7)
    MOVE.L  GLOB_REF_INTB_RBF_64K_BUFFER,-(A7)
    PEA     113.W
    PEA     GLOB_STR_CLEANUP_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    PEA     22.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,-(A7)
    PEA     118.W
    PEA     GLOB_STR_CLEANUP_C_4
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     32(A7),A7

    RTS

;!======

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
; FUNC: CLEANUP_ShutdownInputDevices   (ShutdownInputDevices)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A0-A1/A6
; CALLS:
;   _LVODoIO, JMP_TBL_DEALLOCATE_MEMORY_1, _LVOCloseDevice,
;   JMP_TBL_CLEANUP_SIGNAL_AND_MSGPORT, JMP_TBL_LAB_19F7
; READS:
;   GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, GLOB_REF_DATA_INPUT_BUFFER,
;   GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE, GLOB_REF_INPUTDEVICE_MSGPORT,
;   GLOB_REF_CONSOLEDEVICE_MSGPORT, AbsExecBase, GLOB_STR_CLEANUP_C_5
; WRITES:
;   IOStdReq input fields (io_Command/io_Data)
; DESC:
;   Flushes and closes input/console devices, frees the input buffer, and
;   releases the associated msg ports and IO request blocks.
;------------------------------------------------------------------------------
; Tears down console/input devices opened during startup, including msg ports.
CLEANUP_ShutdownInputDevices:
LAB_01AC:
    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.W  #10,28(A0)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A0
    MOVE.L  GLOB_REF_DATA_INPUT_BUFFER,40(A0)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1

    MOVEA.L AbsExecBase,A6
    JSR     _LVODoIO(A6)

    PEA     Struct_InputEvent_Size.W
    MOVE.L  GLOB_REF_DATA_INPUT_BUFFER,-(A7)
    PEA     127.W
    PEA     GLOB_STR_CLEANUP_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A1
    JSR     _LVOCloseDevice(A6)

    MOVE.L  GLOB_REF_INPUTDEVICE_MSGPORT,(A7)
    JSR     JMP_TBL_CLEANUP_SIGNAL_AND_MSGPORT(PC)

    MOVE.L  GLOB_REF_CONSOLEDEVICE_MSGPORT,(A7)
    JSR     JMP_TBL_CLEANUP_SIGNAL_AND_MSGPORT(PC)

    MOVE.L  GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,(A7)
    JSR     JMP_TBL_LAB_19F7(PC)

    MOVE.L  GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,(A7)
    JSR     JMP_TBL_LAB_19F7(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEAR_RASTPORT_1   (ReleaseDisplayResources??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A1/A6
; CALLS:
;   JMP_TBL_DEALLOCATE_MEMORY_1, JMP_TBL_FREE_RASTER,
;   _LVOCloseFont, _LVOCloseLibrary
; READS:
;   GLOB_REF_96_BYTES_ALLOCATED, GLOB_REF_RASTPORT_1, LAB_2220, LAB_221A,
;   LAB_221C, LAB_2224, LAB_2229, GLOB_HANDLE_PREVUE_FONT,
;   GLOB_HANDLE_TOPAZ_FONT, GLOB_HANDLE_H26F_FONT, GLOB_HANDLE_PREVUEC_FONT,
;   GLOB_REF_UTILITY_LIBRARY, GLOB_REF_DISKFONT_LIBRARY,
;   GLOB_REF_DOS_LIBRARY, GLOB_REF_INTUITION_LIBRARY, GLOB_REF_GRAPHICS_LIBRARY,
;   GLOB_STR_CLEANUP_C_6, GLOB_STR_CLEANUP_C_7, GLOB_STR_CLEANUP_C_8,
;   GLOB_STR_CLEANUP_C_9, GLOB_STR_CLEANUP_C_10, GLOB_STR_CLEANUP_C_11,
;   GLOB_STR_CLEANUP_C_12
; WRITES:
;   (none)
; DESC:
;   Frees rastport memory, raster allocations, and closes font/library handles.
; NOTES:
;   - Iterates over multiple raster pointer tables to free each entry.
;------------------------------------------------------------------------------
CLEAR_RASTPORT_1:
    MOVE.L  D7,-(A7)

    PEA     96.W
    MOVE.L  GLOB_REF_96_BYTES_ALLOCATED,-(A7)
    PEA     148.W
    PEA     GLOB_STR_CLEANUP_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    PEA     100.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    PEA     152.W
    PEA     GLOB_STR_CLEANUP_C_7
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     32(A7),A7
    MOVEQ   #0,D7

.free_raster_set1_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2220,A0
    ADDA.L  D0,A0
    PEA     2.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     160.W
    PEA     GLOB_STR_CLEANUP_C_8
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .free_raster_set1_loop

.after_raster_set1:
    MOVEQ   #0,D7

.free_raster_set2_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set2

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     LAB_221A,A0
    ADDA.L  D1,A0
    PEA     240.W
    PEA     352.W
    MOVE.L  (A0),-(A7)
    PEA     169.W
    PEA     GLOB_STR_CLEANUP_C_9
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .free_raster_set2_loop

.after_raster_set2:
    MOVEQ   #0,D7

.free_raster_set3_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_221C,A0
    ADDA.L  D0,A0
    PEA     509.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     178.W
    PEA     GLOB_STR_CLEANUP_C_10
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .free_raster_set3_loop

.after_raster_set3:
    MOVEQ   #3,D7

.free_raster_set4_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2224,A0
    ADDA.L  D0,A0
    PEA     241.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     187.W
    PEA     GLOB_STR_CLEANUP_C_11
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .free_raster_set4_loop

.after_raster_set4:
    PEA     15.W
    PEA     696.W
    MOVE.L  LAB_2229,-(A7)
    PEA     200.W
    PEA     GLOB_STR_CLEANUP_C_12
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7

    TST.L   GLOB_HANDLE_PREVUE_FONT
    BEQ.S   .closeTopazFont

    MOVEA.L GLOB_HANDLE_PREVUE_FONT,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeTopazFont:
    TST.L   GLOB_HANDLE_TOPAZ_FONT
    BEQ.S   .closeH26fFont

    MOVEA.L GLOB_HANDLE_TOPAZ_FONT,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeH26fFont:
    TST.L   GLOB_HANDLE_H26F_FONT
    BEQ.S   .closePrevueCFont

    MOVEA.L GLOB_HANDLE_H26F_FONT,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closePrevueCFont:
    TST.L   GLOB_HANDLE_PREVUEC_FONT
    BEQ.S   .closeUtilityLibrary

    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeUtilityLibrary:
    TST.L   GLOB_REF_UTILITY_LIBRARY
    BEQ.S   .closeDiskfontLibrary

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseLibrary(A6)

.closeDiskfontLibrary:
    MOVEA.L GLOB_REF_DISKFONT_LIBRARY,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L GLOB_REF_DOS_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ShutdownSystem   (ShutdownSystem)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A6
; CALLS:
;   _LVOForbid, LOCAVAIL_FreeResourceChain, BRUSH_FreeBrushList,
;   CLEAR_INTERRUPT_INTB_VERTB, CLEAR_INTERRUPT_INTB_AUD1,
;   CLEAR_INTERRUPT_INTB_RBF, JMP_TBL_DEALLOCATE_MEMORY_1,
;   CLEANUP_ShutdownInputDevices, CLEAR_RASTPORT_1, LAB_01C4, LAB_054A,
;   JMP_TBL_LAB_0AC8, LAB_01C3, JMP_TBL_LAB_0B38, JMP_TBL_LAB_0966,
;   _LVOSetFunction, _LVOVBeamPos, LAB_01C5, _LVOPermit
; READS:
;   LAB_2321, LAB_2324, LAB_1ED1, LAB_1ED2, LAB_1ED3, LAB_1ED4, LAB_229A,
;   LAB_1DC5, LAB_1DC6, LAB_22A7, LAB_222B, LAB_1DD9, LAB_1DEC, LAB_1DC7,
;   LAB_222C, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_INTUITION_LIBRARY,
;   GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST, GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT,
;   AbsExecBase, GLOB_STR_CLEANUP_C_13, GLOB_STR_CLEANUP_C_14, GLOB_STR_CLEANUP_C_15,
;   GLOB_STR_CLEANUP_C_16
; WRITES:
;   LAB_1DD9, LAB_1DEC
; DESC:
;   Global shutdown: forbids task switches, releases resources, restores patched
;   system vectors, and re-enables multitasking.
; NOTES:
;   - Frees raster tables via nested loops over LAB_22A7 entries.
;------------------------------------------------------------------------------
; Global shutdown sequence: stop interrupts, free rsrcs, reset display.
CLEANUP_ShutdownSystem:
LAB_01BB:
    MOVEM.L D6-D7,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     LAB_2321
    JSR     LAB_01C7(PC)

    PEA     LAB_2324
    JSR     LAB_01C7(PC)

    CLR.L   (A7)
    PEA     LAB_1ED1
    JSR     BRUSH_FreeBrushList(PC)      ; release primary brush list

    CLR.L   (A7)
    PEA     LAB_1ED2
    JSR     BRUSH_FreeBrushList(PC)      ; release alternate brush buckets

    CLR.L   (A7)
    PEA     LAB_1ED3
    JSR     BRUSH_FreeBrushList(PC)

    CLR.L   (A7)
    PEA     LAB_1ED4
    JSR     BRUSH_FreeBrushList(PC)

    BSR.W   CLEAR_INTERRUPT_INTB_VERTB

    BSR.W   CLEAR_INTERRUPT_INTB_AUD1

    BSR.W   CLEAR_INTERRUPT_INTB_RBF

    PEA     9000.W
    MOVE.L  LAB_229A,-(A7)
    PEA     260.W
    PEA     GLOB_STR_CLEANUP_C_13
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    BSR.W   CLEANUP_ShutdownInputDevices

    BSR.W   CLEAR_RASTPORT_1

    JSR     LAB_01C4(PC)

    JSR     LAB_054A(PC)

    PEA     1.W
    JSR     JMP_TBL_LAB_0AC8(PC)

    PEA     2.W
    JSR     JMP_TBL_LAB_0AC8(PC)

    JSR     LAB_01C3(PC)

    PEA     2.W
    JSR     JMP_TBL_LAB_0B38(PC)

    PEA     1.W
    JSR     JMP_TBL_LAB_0B38(PC)

    JSR     JMP_TBL_LAB_0966(PC)

    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
    MOVE.L  38(A0),COP1LCH
    JSR     LAB_01C6(PC)

    PEA     34.W
    MOVE.L  LAB_1DC5,-(A7)
    PEA     318.W
    PEA     GLOB_STR_CLEANUP_C_14
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     72(A7),A7

    PEA     34.W
    MOVE.L  LAB_1DC6,-(A7)
    PEA     319.W
    PEA     GLOB_STR_CLEANUP_C_15
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

    MOVEQ   #0,D6

.free_raster_rows_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_raster_table

    MOVEQ   #0,D7

.free_raster_cols_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .next_raster_row

    MOVE.L  D6,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_22A7,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_222B,D0
    MOVE.L  D0,-(A7)
    PEA     696.W
    MOVE.L  8(A0),-(A7)
    PEA     329.W
    PEA     GLOB_STR_CLEANUP_C_16
    JSR     JMP_TBL_FREE_RASTER(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .free_raster_cols_loop

.next_raster_row:
    ADDQ.L  #1,D6
    BRA.S   .free_raster_rows_loop

.after_raster_table:
    MOVE.L  LAB_1DD9,-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,LAB_1DD9
    MOVE.L  LAB_1DEC,(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DEC

    ; this must be restoring functions that were hijacked?
    ; ...the other use of this stores D0 and this doesn't.

    ; Overriding the AutoRequest function in intuition.library
    ; to point to GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST
    MOVEA.L GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST,A0
    MOVE.L  A0,D0
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVOAutoRequest,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetFunction(A6)

    ; Overriding the ItemAddress function in intuition.library
    ; to point to GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT
    MOVEA.L GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT,A0
    MOVE.L  A0,D0
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVODisplayAlert,A0
    JSR     _LVOSetFunction(A6)

    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A6
    JSR     _LVOVBeamPos(A6)

    TST.L   LAB_1DC7
    BEQ.S   .after_optional_restore

    MOVEA.L LAB_222C,A0
    MOVE.L  LAB_1DC7,184(A0)

.after_optional_restore:
    JSR     LAB_01C5(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

JMP_TBL_LAB_0B38:
    JMP     LAB_0B38

JMP_TBL_LAB_0966:
    JMP     LAB_0966

LAB_01C3:
    JMP     DEALLOC_ADS_AND_LOGO_LST_DATA

LAB_01C4:
    JMP     LAB_0E0C

LAB_01C5:
    JMP     LAB_1908

LAB_01C6:
    JMP     LAB_0FA7

LAB_01C7:
    JMP     LOCAVAIL_FreeResourceChain

JMP_TBL_FREE_RASTER:
    JMP     FREE_RASTER

JMP_TBL_LAB_19F7:
    JMP     LAB_19F7

JMP_TBL_LAB_0AC8:
    JMP     LAB_0AC8

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
