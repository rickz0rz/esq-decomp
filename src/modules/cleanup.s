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

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ProcessAlerts   (ProcessAlerts??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen, LAB_0464, LAB_007B,
;   CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled, CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout,
;   LAB_0546, CLEANUP_JMP_TBL_DST_UpdateBannerQueue, CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner,
;   CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc, CLEANUP_JMP_TBL_DST_RefreshBannerBuffer,
;   LAB_055F, CLEANUP_DrawGridTimeBanner, CLEANUP_DrawClockBanner,
;   CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers, CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine,
;   CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN, CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen,
;   _LVOSetAPen, JMP_TBL_LAB_1A07_1
; READS:
;   LAB_2264, CLEANUP_AlertProcessingFlag, LAB_1DEF, LAB_2263,
;   CLEANUP_AlertCooldownTicks, LAB_1FE7, LAB_2325, LAB_223A, LAB_2274,
;   LAB_22A5, BRUSH_PendingAlertCode, LAB_227F, CLEANUP_BannerTickCounter,
;   LAB_2196, LAB_21DF, LAB_1DD5, LAB_1DD4, LAB_1D13, LAB_2270,
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   CLEANUP_AlertProcessingFlag, CLEANUP_AlertCooldownTicks, LAB_1FE7,
;   LAB_2325, LAB_2264, LAB_22A5, BRUSH_PendingAlertCode, LAB_227F,
;   CLEANUP_BannerTickCounter, LAB_2196, LAB_1E85, LAB_1B08,
;   LAB_226F, LAB_2280
; DESC:
;   Processes pending alert state, advances the alert/badge state machine,
;   handles brush alerts, updates banner timers, and redraws the banner/clock.
; NOTES:
;   - Uses LAB_1FE7 as a multi-step alert state (2 → 3 → 4).
;   - Clears the one-shot pending flag (LAB_2264) after processing.
;------------------------------------------------------------------------------
; Process pending alert/notification state and update on-screen banners.
CLEANUP_ProcessAlerts:
    MOVEM.L D2/D7,-(A7)
    TST.W   LAB_2264
    BEQ.W   .return_status

    TST.L   CLEANUP_AlertProcessingFlag
    BNE.W   .return_status

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertProcessingFlag
    TST.B   LAB_1DEF
    BEQ.S   .update_alert_state

    TST.W   LAB_2263
    BNE.S   .update_alert_state

    SUBQ.L  #1,CLEANUP_AlertCooldownTicks
    BGT.S   .update_alert_state

    JSR     CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertCooldownTicks

.update_alert_state:
    MOVEQ   #2,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   .check_state_three

    MOVE.W  LAB_2325,D0
    BGT.S   .after_state_update

    MOVE.L  D0,D1
    ADDI.W  #10,D1
    MOVE.W  D1,LAB_2325
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_1FE7
    BRA.S   .after_state_update

.check_state_three:
    MOVEQ   #3,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   .after_state_update

    MOVE.W  LAB_2325,D0
    BGT.S   .after_state_update

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1FE7
    JSR     LAB_0464(PC)

.after_state_update:
    CLR.W   LAB_2264
    PEA     LAB_223A
    JSR     LAB_007B(PC)

    MOVE.L  D0,D7
    EXT.L   D7
    PEA     LAB_2274
    JSR     LAB_007B(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_22A5,D0
    BLT.S   .update_banner_queue

    MOVEQ   #11,D1
    CMP.W   D1,D0
    BGE.S   .update_banner_queue

    JSR     CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled(PC)

    MOVE.W  LAB_22A5,D0
    BNE.S   .update_banner_queue

    MOVE.W  #(-1),LAB_22A5

.update_banner_queue:
    JSR     CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout(PC)

    MOVEQ   #1,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; brush loader flagged \"category 1\" alert
    BNE.S   .handle_brush_alert_code1

    PEA     3.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code1:
    MOVEQ   #2,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; same, but for wider-than-allowed brushes
    BNE.S   .handle_brush_alert_code2

    PEA     4.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code2:
    MOVEQ   #3,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; or for taller-than-allowed brushes
    BNE.S   .handle_brush_alert_code3

    PEA     5.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code3:
    TST.L   D7
    BEQ.S   .after_banner_poll

    MOVE.B  LAB_227F,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .decrement_banner_counter

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_227F

.decrement_banner_counter:
    SUBQ.L  #1,CLEANUP_BannerTickCounter
    BNE.S   .poll_banner_event

    MOVEQ   #60,D0
    MOVE.L  D0,CLEANUP_BannerTickCounter
    MOVE.B  LAB_2196,D0
    CMP.B   D1,D0
    BLS.S   .poll_banner_event

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_2196

.poll_banner_event:
    PEA     LAB_21DF
    JSR     CLEANUP_JMP_TBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .after_banner_poll

    PEA     1.W
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.after_banner_poll:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .handle_alert_type2

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .handle_alert_type2

    CLR.W   LAB_1E85
    CLR.L   -(A7)
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.W  #1,LAB_1E85

.handle_alert_type2:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .check_alert_type5_or_type2

    MOVEQ   #5,D2
    CMP.L   D2,D7
    BEQ.S   .handle_alert_type5_or_type2

.check_alert_type5_or_type2:
    CMP.B   D1,D0
    BEQ.S   .init_alert_counters

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .init_alert_counters

.handle_alert_type5_or_type2:
    JSR     CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc(PC)

    JSR     CLEANUP_JMP_TBL_DST_RefreshBannerBuffer(PC)

    CLR.L   -(A7)
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.init_alert_counters:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .advance_alert_counters

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BNE.S   .advance_alert_counters

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_1B08
    MOVE.W  LAB_2270,D1
    ADDQ.W  #1,D1
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    MOVE.W  D0,LAB_226F
    MOVE.W  LAB_2270,D0
    ADDQ.W  #2,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_055F(PC)

    LEA     24(A7),A7
    MOVE.W  D0,LAB_2280

.advance_alert_counters:
    MOVE.B  LAB_1DD4,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_banner

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .draw_banner

    MOVE.W  LAB_226F,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_226F
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  D0,LAB_226F
    MOVE.W  LAB_2280,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2280
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  D0,LAB_2280

.draw_banner:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    TST.W   LAB_2263
    BEQ.S   .draw_clock_banner

    BSR.W   CLEANUP_DrawGridTimeBanner

    BRA.S   .after_banner_draw

.draw_clock_banner:
    BSR.W   CLEANUP_DrawClockBanner

.after_banner_draw:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .update_grid_flash

    MOVEQ   #0,D1
    MOVE.W  LAB_2270,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    SUBQ.L  #1,D1
    BNE.S   .maybe_clear_brush_alert

    CLR.L   BRUSH_PendingAlertCode

.maybe_clear_brush_alert:
    MOVE.W  LAB_226F,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers(PC)

    ADDQ.W  #4,A7

.update_grid_flash:
    JSR     CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine(PC)

    MOVE.B  LAB_1D13,D0
    SUBQ.B  #8,D0
    BNE.S   .check_grid_flash_alt

    JSR     CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN(PC)

    BRA.S   .finish

.check_grid_flash_alt:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #7,D0
    BNE.S   .finish

    JSR     CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen(PC)

.finish:
    CLR.L   CLEANUP_AlertProcessingFlag

.return_status:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockBanner   (DrawClockBanner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT, JMP_TBL_PRINTF_1, _LVOSetAPen,
;   _LVORectFill, _LVOMove, _LVOText, ESQ_DrawBevelFrameWithTopRight, LAB_026C
; READS:
;   LAB_2263, GLOB_REF_STR_USE_24_HR_CLOCK, GLOB_WORD_CURRENT_HOUR,
;   GLOB_WORD_USE_24_HR_FMT, GLOB_WORD_CURRENT_MINUTE, GLOB_WORD_CURRENT_SECOND,
;   GLOB_STR_EXTRA_TIME_FORMAT, GLOB_STR_GRID_TIME_FORMAT,
;   GLOB_REF_GRID_RASTPORT_MAYBE_1, LAB_232A, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -10(A5)
; DESC:
;   Formats the current time string and renders it into the top banner area.
; NOTES:
;   - Centers the rendered time based on the font metrics.
;------------------------------------------------------------------------------
; Render the top-of-screen clock/banner text.
CLEANUP_DrawClockBanner:
LAB_01E3:
    LINK.W  A5,#-12
    MOVEM.L D2-D3,-(A7)
    TST.W   LAB_2263
    BNE.W   .done

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .format_grid_time

    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_USE_24_HR_FMT,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_EXTRA_TIME_FORMAT
    PEA     -10(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     24(A7),A7
    BRA.S   .draw_banner

.format_grid_time:
    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_GRID_TIME_FORMAT
    PEA     -10(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     20(A7),A7

.draw_banner:
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #35,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    ADD.L   D2,D0
    MOVE.L  D0,D2
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #36,D0
    MOVEQ   #0,D1
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_text_y

    ADDQ.L  #1,D1

.center_text_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #44,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     -10(A5),A0

    MOVEA.L A0,A1

.measure_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     192.W
    MOVEQ   #34,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

.done:
    MOVEM.L -20(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_FormatClockFormatEntry   (FormatClockFormatEntry??)
; ARGS:
;   stack +4: slotIndex (0..48?) ??
;   stack +8: outText (char*)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D6-D7/A0-A3
; CALLS:
;   JMP_TBL_LAB_1A07_1, JMP_TBL_LAB_1A06_2
; READS:
;   LAB_1DD8, GLOB_REF_STR_CLOCK_FORMAT
; WRITES:
;   outText buffer (A3)
; DESC:
;   Copies a clock-format string for slotIndex into outText and optionally
;   adjusts two digit positions based on LAB_1DD8.
; NOTES:
;   - Wraps slotIndex by subtracting 48 until within range.
;------------------------------------------------------------------------------
CLEANUP_FormatClockFormatEntry:
LAB_01E9:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3

.wrap_slot_index_loop:
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .slot_index_ready

    SUB.L   D0,D7
    BRA.S   .wrap_slot_index_loop

.slot_index_ready:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D1,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

.copy_format_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_format_loop

    TST.L   D6
    BLE.S   .done

    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADD.L   D0,D6
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockFormatList   (DrawClockFormatList??)
; ARGS:
;   stack +4: baseSlotIndex ??
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   LAB_0211, _LVOSetAPen, _LVORectFill, JMP_TBL_LAB_1A06_2, ESQ_DrawBevelFrameWithTopRight,
;   CLEANUP_FormatClockFormatEntry, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   LAB_232A, LAB_232B, GLOB_REF_GRID_RASTPORT_MAYBE_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack text buffer at -89(A5)
; DESC:
;   Renders a multi-row list of clock-format strings starting at baseSlotIndex
;   into the grid rastport area.
; NOTES:
;   - Draws two rows in a loop, then renders the final row separately.
;------------------------------------------------------------------------------
CLEANUP_DrawClockFormatList:
LAB_01EE:
    LINK.W  A5,#-100
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0211(PC)

    LEA     16(A7),A7

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1

    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D6

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .final_row

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .row_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .row_index_ready

.row_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.row_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D2
    MOVE.W  LAB_232B,D2
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVE.L  D1,20(A7)
    MOVE.L  D2,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    ADD.L   D0,D1
    MOVEQ   #35,D0
    ADD.L   D0,D1
    PEA     33.W
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  32(A7),-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_row_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_row_text_x

    ADDQ.L  #1,D1

.center_row_text_x:
    ASR.L   #1,D1
    MOVE.L  20(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_row_text_y

    ADDQ.L  #1,D2

.center_row_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_row_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .row_loop

.final_row:
    MOVEQ   #2,D6
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .final_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .final_index_ready

.final_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.final_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,48(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  48(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_final_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,52(A7)
    MOVE.L  D1,48(A7)
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  52(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_final_text_x

    ADDQ.L  #1,D1

.center_final_text_x:
    ASR.L   #1,D1
    MOVE.L  48(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_final_text_y

    ADDQ.L  #1,D2

.center_final_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_final_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    MOVEM.L -120(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockFormatFrame   (DrawClockFormatFrame??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0
; CALLS:
;   LAB_026C
; READS:
;   LAB_232A, GLOB_REF_GRID_RASTPORT_MAYBE_1
; WRITES:
;   (none)
; DESC:
;   Draws the frame/box for the clock format list area.
; NOTES:
;   - Uses LAB_232A as a layout offset.
;------------------------------------------------------------------------------
CLEANUP_DrawClockFormatFrame:
LAB_01FD:
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.L  D0,D1
    MOVEQ   #36,D2
    ADD.L   D2,D1
    MOVEQ   #0,D3
    MOVE.W  D0,D3
    ADD.L   D2,D3
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  #660,D0
    SUB.L   D2,D0
    PEA     192.W
    MOVEQ   #34,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    LEA     36(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawGridTimeBanner   (DrawGridTimeBanner??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   ESQ_FormatTimeStamp, _LVOSetAPen, _LVOSetDrMd, _LVORectFill, _LVOTextLength,
;   _LVOMove, _LVOText, JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT, JMP_TBL_PRINTF_1,
;   LAB_026C
; READS:
;   LAB_2274, GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY,
;   GLOB_REF_STR_USE_24_HR_CLOCK, GLOB_WORD_CURRENT_HOUR, GLOB_WORD_USE_24_HR_FMT,
;   GLOB_WORD_CURRENT_MINUTE, GLOB_WORD_CURRENT_SECOND,
;   GLOB_STR_GRID_TIME_FORMAT_DUPLICATE, GLOB_STR_12_44_44_SINGLE_SPACE,
;   GLOB_STR_12_44_44_PM
; WRITES:
;   Stack buffers at -32(A5) and -23(A5)
; DESC:
;   Formats and renders the time banner into the main rastport, centered
;   based on measured text widths.
; NOTES:
;   - Draws an extra AM/PM suffix when using 12-hour format.
;------------------------------------------------------------------------------
CLEANUP_DrawGridTimeBanner:
LAB_01FE:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)
    MOVEQ   #0,D5
    PEA     LAB_2274
    PEA     -32(A5)
    JSR     ESQ_FormatTimeStamp(PC)

    ADDQ.W  #8,A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #40,D2
    NOT.B   D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.B  -23(A5),D4
    CLR.B   -23(A5)
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .measure_sample_width

    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_USE_24_HR_FMT,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_GRID_TIME_FORMAT_DUPLICATE
    PEA     -32(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     24(A7),A7

.measure_sample_width:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_SINGLE_SPACE,A0
    MOVEQ   #9,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .no_ampm_suffix

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_PM,A0
    MOVEQ   #11,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

    BRA.S   .center_time_text

.no_ampm_suffix:
    MOVE.L  D6,D5

.center_time_text:
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_time_x

    ADDQ.L  #1,D0

.center_time_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  24(A7),D1
    JSR     _LVOMove(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.time_text_len_loop:
    TST.B   (A1)+
    BNE.S   .time_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .done

    MOVE.B  D4,-23(A5)
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D1
    MOVEA.L A0,A1
    JSR     _LVOMove(A6)

    LEA     -23(A5),A0
    MOVEA.L A0,A1

.ampm_text_len_loop:
    TST.B   (A1)+
    BNE.S   .ampm_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

.done:
    MOVE.L  D7,D0
    ADDI.L  #448,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D1
    SUBQ.L  #2,D1
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D5,-(A7)
    PEA     40.W
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    MOVEM.L -64(A5),D2-D7
    UNLK    A5
    RTS

;!======

RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY:
;------------------------------------------------------------------------------
; FUNC: RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY   (RenderShortMonthShortDowDay)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   JMP_TBL_PRINTF_1, _LVOSetAPen, _LVOSetDrMd, _LVORectFill,
;   _LVOTextLength, _LVOMove, _LVOText, LAB_026C
; READS:
;   LAB_2274, LAB_2275, LAB_2276, GLOB_JMP_TBL_SHORT_DAYS_OF_WEEK,
;   GLOB_JMP_TBL_SHORT_MONTHS, GLOB_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED,
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -32(A5)
; DESC:
;   Formats and renders "Mon Jan 1" style text in the banner area.
; NOTES:
;   - Centers the string based on measured text width.
;------------------------------------------------------------------------------
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

    MOVE.W  LAB_2274,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0

    MOVE.W  LAB_2275,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1

    MOVE.W  LAB_2276,D0
    EXT.L   D0

    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     GLOB_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED
    PEA     -32(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     20(A7),A7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #40,D2
    NOT.B   D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.date_text_len_loop:
    TST.B   (A1)+
    BNE.S   .date_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_date_text_x

    ADDQ.L  #1,D0

.center_date_text_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,20(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  20(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     -32(A5),A0
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #2,D0
    PEA     192.W
    MOVE.L  D0,-(A7)
    PEA     208.W
    PEA     40.W
    PEA     44.W
    MOVE.L  A0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    MOVEM.L -56(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateBannerSegment   (DrawDateBannerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY,
;   ESQ_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the left banner segment containing the short date (day/month).
; NOTES:
;   - Temporarily swaps the rastport bitmap to GLOB_REF_696_400_BITMAP.
;------------------------------------------------------------------------------
CLEANUP_DrawDateBannerSegment:
LAB_0209:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

.rastPortBitmap = -4

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  Struct_RastPort__BitMap(A0),.rastPortBitmap(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,Struct_RastPort__BitMap(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  Struct_RastPort__Flags(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,Struct_RastPort__Flags(A0)
    MOVEA.L A0,A1
    MOVEQ   #40,D0
    MOVEQ   #34,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY

    PEA     67.W
    PEA     255.W
    PEA     34.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  .rastPortBitmap(A5),Struct_RastPort__BitMap(A0)

    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawBannerSpacerSegment   (DrawBannerSpacerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, ESQ_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears/draws the middle banner segment (no text).
;------------------------------------------------------------------------------
CLEANUP_DrawBannerSpacerSegment:
LAB_020A:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #256,D0
    MOVEQ   #34,D1
    MOVE.L  #447,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    PEA     34.W
    PEA     256.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawTimeBannerSegment   (DrawTimeBannerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, CLEANUP_DrawGridTimeBanner, ESQ_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the right banner segment containing the time string.
;------------------------------------------------------------------------------
CLEANUP_DrawTimeBannerSegment:
LAB_020B:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #448,D0
    MOVEQ   #34,D1
    MOVE.L  #663,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   CLEANUP_DrawGridTimeBanner

    PEA     67.W
    PEA     695.W
    PEA     34.W
    PEA     448.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQ_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateTimeBannerRow   (DrawDateTimeBannerRow??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, CLEANUP_DrawDateBannerSegment,
;   CLEANUP_DrawBannerSpacerSegment, CLEANUP_DrawTimeBannerSegment
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears the banner row and draws left date, middle spacer, and right time.
;------------------------------------------------------------------------------
CLEANUP_DrawDateTimeBannerRow:
LAB_020C:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEQ   #34,D1
    MOVE.L  #695,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   CLEANUP_DrawDateBannerSegment

    BSR.W   CLEANUP_DrawBannerSpacerSegment

    BSR.W   CLEANUP_DrawTimeBannerSegment

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc:
LAB_020D:
    JMP     PARSEINI_UpdateClockFromRtc

CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen:
LAB_020E:
    JMP     ESQFUNC_DrawDiagnosticsScreen

CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen:
LAB_020F:
    JMP     ESQFUNC_DrawMemoryStatusScreen

CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine:
LAB_0210:
    JMP     SCRIPT_UpdateCtrlStateMachine

CLEANUP_JMP_TBL_GCOMMAND_UpdateBannerBounds:
LAB_0211:
    JMP     GCOMMAND_UpdateBannerBounds

CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout:
LAB_0212:
    JMP     SCRIPT_UpdateCtrlLineTimeout

CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled:
LAB_0213:
    JMP     SCRIPT_ClearCtrlLineIfEnabled

CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers:
LAB_0214:
    JMP     ESQFUNC_PruneEntryTextPointers

CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner:
LAB_0215:
    JMP     ESQDISP_DrawStatusBanner

CLEANUP_JMP_TBL_DST_UpdateBannerQueue:
LAB_0216:
    JMP     DST_UpdateBannerQueue

CLEANUP_JMP_TBL_DST_RefreshBannerBuffer:
LAB_0217:
    JMP     DST_RefreshBannerBuffer

CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN:
LAB_0218:
    JMP     DRAW_ESC_MENU_VERSION_SCREEN

JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT:
    JMP     ADJUST_HOURS_TO_24_HR_FMT

;!======

    MOVEQ   #97,D0

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_RenderAlignedStatusScreen   (RenderAlignedStatusScreen??)
; ARGS:
;   stack +4: modeOrFlag?? (word; low word used)
;   stack +8: codeOrIndex?? (word; low word used)
;   stack +12: optionOrFlag?? (word; low word used)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A2/A6
; CALLS:
;   LAB_05C1, LAB_026E, LAB_055F, ESQ_SetCopperEffect_OffDisableHighlight, LAB_026D, _LVOSetRast,
;   LAB_0265, LAB_0273, LAB_0266, _LVOSetAPen, LAB_0268, ESQ_SetCopperEffect_OnEnableHighlight,
;   LAB_037F, LAB_026B, JMP_TBL_APPEND_DATA_AT_NULL_1, LAB_0267, LAB_0269,
;   LAB_026F, CLEANUP_BuildAlignedStatusLine, LAB_0271, LAB_0270, LAB_0272, LAB_0276,
;   _LVORectFill, LAB_026C, LAB_026A
; READS:
;   LAB_234B, LAB_234C, LAB_234D, LAB_234E, LAB_2364-LAB_236E,
;   LAB_2367, LAB_2368, LAB_2369, LAB_2373-LAB_2379, LAB_237A,
;   LAB_2236, LAB_236A, LAB_20ED, LAB_2153, LAB_2157, LAB_2158,
;   LAB_222D, LAB_2230, LAB_227C, LAB_1DDB, LAB_1DDC,
;   GLOB_REF_RASTPORT_2, GLOB_REF_GRAPHICS_LIBRARY,
;   GLOB_STR_ALIGNED_NOW_SHOWING, GLOB_STR_ALIGNED_NEXT_SHOWING,
;   GLOB_STR_ALIGNED_TODAY_AT, GLOB_STR_ALIGNED_TONIGHT_AT,
;   GLOB_STR_ALIGNED_TOMORROW_AT
; WRITES:
;   LAB_2259, LAB_2365, LAB_2366, LAB_2367, LAB_2368, LAB_2369,
;   LAB_236C, LAB_236D, LAB_236E, LAB_2373, LAB_2377
; DESC:
;   Builds and renders the aligned status banner text (now/next and time
;   phrases), updates alignment globals, and draws into rastport 2.
; NOTES:
;   - Uses several template buffers and tables to choose which status line
;     to render based on a code derived from LAB_234D/E.
;------------------------------------------------------------------------------
CLEANUP_RenderAlignedStatusScreen:
LAB_021A:
    LINK.W  A5,#-840
    MOVEM.L D2-D7/A2,-(A7)

    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.W  D7,LAB_2365
    CLR.B   -554(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22AB
    MOVE.W  D0,-40(A5)
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .use_secondary_template

    LEA     LAB_234B,A0
    LEA     -554(A5),A1

.copy_template_primary_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_primary_loop

    MOVE.W  LAB_234D,-38(A5)
    BRA.S   .backup_template_text

.use_secondary_template:
    LEA     LAB_234C,A0
    LEA     -554(A5),A1

.copy_template_secondary_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_secondary_loop

    MOVE.W  LAB_234E,-38(A5)

.backup_template_text:
    LEA     -554(A5),A0
    LEA     -754(A5),A1

.copy_template_backup_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_backup_loop

    TST.W   -38(A5)
    BNE.S   .normalize_template_code

    MOVEQ   #48,D0
    MOVE.W  D0,-38(A5)

.normalize_template_code:
    MOVE.W  -38(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B5C
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .maybe_format_alt_time_text

    CLR.B   LAB_2367
    MOVE.W  LAB_2368,D0
    EXT.L   D0
    MOVE.W  LAB_2369,D1
    EXT.L   D1
    CLR.L   -(A7)
    PEA     LAB_2367
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_026E(PC)

    LEA     16(A7),A7
    BRA.S   .dispatch_template_code

.maybe_format_alt_time_text:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .dispatch_template_code

    CLR.B   LAB_21B0
    MOVE.W  LAB_2368,D0
    EXT.L   D0
    MOVE.W  LAB_2369,D1
    EXT.L   D1
    PEA     1.W
    PEA     LAB_21B0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_026E(PC)

    LEA     16(A7),A7

.dispatch_template_code:
    MOVEQ   #69,D0
    CMP.W   -38(A5),D0
    BNE.W   .check_code_F

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    ADDA.L  D0,A0
    MOVE.W  (A0),-42(A5)
    CLR.W   -36(A5)

.scan_entry_loop:
    ADDQ.W  #1,-42(A5)
    MOVE.W  -42(A5),D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ADD.L   D1,D1
    LEA     LAB_236A,A0
    ADDA.L  D1,A0
    MOVE.W  D0,-42(A5)
    CMP.W   (A0),D0
    BEQ.S   .apply_entry_selection

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D1.L)
    BNE.S   .apply_entry_selection

    MOVE.W  -36(A5),D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   .apply_entry_selection

    ADDQ.W  #1,-36(A5)
    BRA.S   .scan_entry_loop

.apply_entry_selection:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  -42(A5),D0
    MOVE.W  (A1),D1
    CMP.W   D0,D1
    BNE.S   .store_entry_selection

    MOVE.W  LAB_236E,D1
    MOVE.W  LAB_2364,D2
    CMP.W   D2,D1
    BEQ.W   .done

.store_entry_selection:
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.W  D0,(A1)
    ADDA.L  D1,A0
    MOVE.W  (A0),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    LEA     -554(A5),A1

.copy_entry_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_title_loop

    MOVE.W  #2,-40(A5)
    BRA.W   .finalize_title_state

.check_code_F:
    MOVEQ   #70,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_G

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .fallback_title_buffer

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .fallback_title_buffer

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop

    BRA.S   .set_title_ready

.fallback_title_buffer:
    TST.L   LAB_1DDB
    BEQ.W   .done

    MOVEA.L LAB_1DDB,A0
    LEA     -554(A5),A1

.copy_fallback_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_fallback_title_loop

.set_title_ready:
    MOVE.W  #2,-40(A5)
    BRA.W   .finalize_title_state

.check_code_G:
    MOVEQ   #71,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_N

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .fallback_title_buffer_g

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .fallback_title_buffer_g

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop_g:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop_g

    BRA.S   .set_title_ready_g

.fallback_title_buffer_g:
    TST.L   LAB_1DDC
    BEQ.W   .done

    MOVEA.L LAB_1DDC,A0
    LEA     -554(A5),A1

.copy_fallback_title_loop_g:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_fallback_title_loop_g

.set_title_ready_g:
    MOVE.W  #2,-40(A5)
    BRA.S   .finalize_title_state

.check_code_N:
    MOVEQ   #78,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_O

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .done

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.W   .done

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop_n:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop_n

    MOVE.W  #2,-40(A5)
    BRA.S   .finalize_title_state

.check_code_O:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .finalize_title_state

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .done

    MOVE.B  LAB_21B0,D0
    TST.B   D0
    BEQ.W   .done

    LEA     LAB_21B0,A0
    LEA     -554(A5),A1

.copy_alt_title_loop_o:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_alt_title_loop_o

    MOVEQ   #2,D0
    MOVE.W  D0,-40(A5)

.finalize_title_state:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .sync_time_defaults

    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_2368
    MOVE.W  D0,LAB_2369

.sync_time_defaults:
    MOVEQ   #53,D0
    CMP.W   D0,D6
    BNE.S   .maybe_refresh_display

    JSR     ESQ_SetCopperEffect_OffDisableHighlight(PC)

.maybe_refresh_display:
    JSR     LAB_026D(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L LAB_2216,A2
    MOVEA.L 14(A2),A1
    MOVEQ   #0,D0
    MOVE.B  5(A1),D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    SUBQ.L  #1,D2
    MOVEA.L A0,A1
    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    TST.W   D7
    BNE.S   .alloc_rastport_primary

    MOVEQ   #1,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    BRA.S   .primary_rastport_ready

.alloc_rastport_primary:
    PEA     1.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216

.primary_rastport_ready:
    TST.W   D5
    BNE.S   .maybe_notify_timing

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    JSR     LAB_0273(PC)

    ADDQ.W  #4,A7

.maybe_notify_timing:
    TST.W   D7
    BNE.S   .alloc_rastport_secondary

    PEA     4.W
    CLR.L   -(A7)
    PEA     1.W
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     2.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7
    BRA.S   .after_secondary_alloc

.alloc_rastport_secondary:
    PEA     4.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     1.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7

.after_secondary_alloc:
    MOVEQ   #1,D0
    CMP.W   D0,D5
    BNE.S   .maybe_clear_rastport_secondary

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.maybe_clear_rastport_secondary:
    JSR     ESQ_NoOp(PC)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  LAB_2364,LAB_236E
    MOVEQ   #48,D0
    CMP.W   -38(A5),D0
    BNE.S   .handle_empty_template

    MOVE.B  -554(A5),D0
    TST.B   D0
    BNE.S   .handle_empty_template

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0268(PC)

    JSR     ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2366
    MOVE.W  LAB_2364,D1
    MOVE.W  D1,LAB_2368
    MOVEQ   #-1,D1
    MOVE.W  D1,LAB_2369
    BRA.W   .done

.handle_empty_template:
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .select_aligned_index

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,-36(A5)
    BRA.S   .check_aligned_index_valid

.select_aligned_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2373,D0
    MOVE.W  D0,-36(A5)

.check_aligned_index_valid:
    MOVE.W  -36(A5),D0
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   .reset_alignment_state

    MOVE.B  -554(A5),D1
    TST.B   D1
    BEQ.S   .reset_alignment_state

    MOVEQ   #1,D1
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  D0,LAB_2369
    MOVE.W  D1,-40(A5)
    BRA.S   .prepare_channel_line

.reset_alignment_state:
    MOVE.W  -40(A5),D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_channel_line

    CLR.B   LAB_2366
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  #(-1),LAB_2369

.prepare_channel_line:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .clear_channel_string

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_channel_format

    MOVEQ   #1,D1
    BRA.S   .format_channel_string

.select_channel_format:
    MOVEQ   #2,D1

.format_channel_string:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_037F(PC)

    PEA     LAB_236B
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     LAB_026B(PC)

    LEA     16(A7),A7
    LEA     LAB_236B,A0
    LEA     LAB_2259,A1

.copy_channel_string_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_channel_string_loop

    BRA.S   .append_optional_prefix

.clear_channel_string:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2259

.append_optional_prefix:
    MOVE.B  -554(A5),D0
    TST.B   D0
    BEQ.S   .append_template_text

    PEA     LAB_2158
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.append_template_text:
    PEA     -554(A5)
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.W   -40(A5),D0
    BNE.W   .check_template_fallback

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   .select_now_showing_index

    MOVEQ   #0,D0
    MOVE.B  LAB_2374,D0
    BRA.S   .after_now_showing_index

.select_now_showing_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2378,D0

.after_now_showing_index:
    TST.L   D0
    BEQ.S   .build_time_phrase

    LEA     GLOB_STR_ALIGNED_NOW_SHOWING,A0
    LEA     LAB_2366,A1

.copy_now_showing_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_now_showing_label_loop

    MOVE.B  LAB_2377,D0
    CMP.B   D1,D0
    BNE.S   .select_next_showing_index

    MOVEQ   #0,D0
    MOVE.B  LAB_2375,D0
    BRA.S   .after_next_showing_index

.select_next_showing_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2379,D0

.after_next_showing_index:
    TST.L   D0
    BEQ.W   .append_alignment_text

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     GLOB_STR_ALIGNED_NEXT_SHOWING,A0
    LEA     LAB_2366,A1

.copy_next_showing_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_next_showing_label_loop

    MOVE.W  -36(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     -834(A5)
    JSR     LAB_0269(PC)

    PEA     -834(A5)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     20(A7),A7
    BRA.W   .append_alignment_text

.build_time_phrase:
    MOVE.W  -36(A5),D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_time_table

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    BRA.S   .format_time_components

.select_time_table:
    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1

.format_time_components:
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -34(A5)
    JSR     LAB_0275(PC)

    PEA     -34(A5)
    JSR     LAB_0274(PC)

    LEA     16(A7),A7
    MOVE.W  -18(A5),D0
    MOVE.W  LAB_227C,D1
    CMP.W   D1,D0
    BEQ.S   .check_today_vs_tonight

    LEA     GLOB_STR_ALIGNED_TOMORROW_AT,A0
    LEA     LAB_2366,A1

.copy_tomorrow_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_tomorrow_label_loop

    BRA.S   .append_time_string

.check_today_vs_tonight:
    MOVE.W  -26(A5),D0
    MOVEQ   #17,D1
    CMP.W   D1,D0
    BLT.S   .copy_today_label

    CMP.W   D1,D0
    BNE.S   .copy_tonight_label

    MOVE.W  -24(A5),D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   .copy_tonight_label

.copy_today_label:
    LEA     GLOB_STR_ALIGNED_TODAY_AT,A0
    LEA     LAB_2366,A1

.copy_today_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_today_label_loop

    BRA.S   .append_time_string

.copy_tonight_label:
    LEA     GLOB_STR_ALIGNED_TONIGHT_AT,A0
    LEA     LAB_2366,A1

.copy_tonight_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_tonight_label_loop

.append_time_string:
    PEA     -34(A5)
    JSR     LAB_0267(PC)

    MOVE.W  -36(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     -834(A5)
    JSR     LAB_0269(PC)

    PEA     -834(A5)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     16(A7),A7

.append_alignment_text:
    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   .maybe_submit_record

.check_template_fallback:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .maybe_submit_record

    MOVE.W  -38(A5),D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   .check_template_range

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   .copy_template_label

.check_template_range:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   .maybe_submit_record

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   .maybe_submit_record

.copy_template_label:
    LEA     LAB_2157,A0
    LEA     LAB_2366,A1

.copy_template_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_label_loop

    MOVE.W  -38(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_20ED,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     16(A7),A7

.maybe_submit_record:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .prepare_output_record

    MOVE.W  -38(A5),D0
    MOVEQ   #70,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #71,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #78,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #79,D1
    CMP.W   D1,D0
    BNE.S   .render_output_text

.prepare_output_record:
    CLR.L   -(A7)
    JSR     LAB_026F(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2153,D0
    EXT.L   D0
    MOVE.W  LAB_2368,D1
    EXT.L   D1
    MOVE.W  LAB_2369,D2
    EXT.L   D2
    MOVEQ   #2,D3
    CMP.W   -40(A5),D3
    BNE.S   .select_output_mode

    MOVEQ   #1,D3
    BRA.S   .submit_output_record

.select_output_mode:
    MOVEQ   #0,D3

.submit_output_record:
    TST.L   LAB_237A
    SEQ     D4
    NEG.B   D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2259
    JSR     CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .render_output_text

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.render_output_text:
    MOVE.B  #$64,LAB_2377
    MOVE.B  #$31,LAB_2373
    CLR.W   LAB_236D

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,LAB_236C
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2259
    JSR     LAB_0271(PC)

    PEA     3.W
    PEA     LAB_2259
    JSR     LAB_0270(PC)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     2.W
    JSR     LAB_0272(PC)

    MOVE.L  D0,-4(A5)

    MOVEA.L D0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     2.W
    JSR     LAB_0276(PC)

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    TST.L   D1
    BPL.S   .center_output_rect

    ADDQ.L  #1,D1

.center_output_rect:
    ASR.L   #1,D1
    PEA     2.W
    MOVE.L  D1,56(A7)
    JSR     LAB_0276(PC)

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    SUBQ.L  #1,D1

    MOVE.L  D1,D3
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    MOVE.L  56(A7),D1
    MOVE.L  #703,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    JSR     ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A1
    MOVE.W  2(A1),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A1),D1
    SUBQ.L  #1,D1
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    PEA     GLOB_REF_320_240_BITMAP
    JSR     LAB_026C(PC)

    JSR     LAB_026A(PC)

.done:
    MOVEM.L -868(A5),D2-D7/A2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0265   (JumpStub_LAB_183E)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183E
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183E.
;------------------------------------------------------------------------------
LAB_0265:
    JMP     LAB_183E

;------------------------------------------------------------------------------
; FUNC: LAB_0266   (JumpStub_LAB_14B1)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_14B1
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_14B1.
;------------------------------------------------------------------------------
LAB_0266:
    JMP     LAB_14B1

;------------------------------------------------------------------------------
; FUNC: LAB_0267   (JumpStub_LAB_0668)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0668
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0668.
;------------------------------------------------------------------------------
LAB_0267:
    JMP     LAB_0668

;------------------------------------------------------------------------------
; FUNC: LAB_0268   (JumpStub_LAB_16E3)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16E3
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16E3.
;------------------------------------------------------------------------------
LAB_0268:
    JMP     LAB_16E3

;------------------------------------------------------------------------------
; FUNC: LAB_0269   (JumpStub_LAB_16ED)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16ED
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16ED.
;------------------------------------------------------------------------------
LAB_0269:
    JMP     LAB_16ED

;------------------------------------------------------------------------------
; FUNC: LAB_026A   (JumpStub_LAB_0A48)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0A48
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0A48.
;------------------------------------------------------------------------------
LAB_026A:
    JMP     LAB_0A48

;------------------------------------------------------------------------------
; FUNC: LAB_026B   (JumpStub_LAB_16D3)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16D3
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16D3.
;------------------------------------------------------------------------------
LAB_026B:
    JMP     LAB_16D3

;------------------------------------------------------------------------------
; FUNC: LAB_026C   (JumpStub_LAB_1ADA)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1ADA
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1ADA.
;------------------------------------------------------------------------------
LAB_026C:
    JMP     LAB_1ADA

;------------------------------------------------------------------------------
; FUNC: LAB_026D   (JumpStub_LAB_0A49)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0A49
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0A49.
;------------------------------------------------------------------------------
LAB_026D:
    JMP     LAB_0A49

;------------------------------------------------------------------------------
; FUNC: LAB_026E   (JumpStub_LAB_17A8)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_17A8
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_17A8.
;------------------------------------------------------------------------------
LAB_026E:
    JMP     LAB_17A8

;------------------------------------------------------------------------------
; FUNC: LAB_026F   (JumpStub_LAB_16D9)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16D9
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16D9.
;------------------------------------------------------------------------------
LAB_026F:
    JMP     LAB_16D9

;------------------------------------------------------------------------------
; FUNC: LAB_0270   (JumpStub_LAB_16CE)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16CE
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16CE.
;------------------------------------------------------------------------------
LAB_0270:
    JMP     LAB_16CE

;------------------------------------------------------------------------------
; FUNC: LAB_0271   (JumpStub_LAB_1755)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1755
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1755.
;------------------------------------------------------------------------------
LAB_0271:
    JMP     LAB_1755

;------------------------------------------------------------------------------
; FUNC: LAB_0272   (JumpStub_LAB_183D)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183D
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183D.
;------------------------------------------------------------------------------
LAB_0272:
    JMP     LAB_183D

;------------------------------------------------------------------------------
; FUNC: LAB_0273   (JumpStub_LAB_09C2)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_09C2
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_09C2.
;------------------------------------------------------------------------------
LAB_0273:
    JMP     LAB_09C2

;------------------------------------------------------------------------------
; FUNC: LAB_0274   (JumpStub_LAB_0665)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0665
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0665.
;------------------------------------------------------------------------------
LAB_0274:
    JMP     LAB_0665

;------------------------------------------------------------------------------
; FUNC: LAB_0275   (JumpStub_LAB_064E)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_064E
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_064E.
;------------------------------------------------------------------------------
LAB_0275:
    JMP     LAB_064E

;------------------------------------------------------------------------------
; FUNC: LAB_0276   (JumpStub_LAB_183B)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183B
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183B.
;------------------------------------------------------------------------------
LAB_0276:
    JMP     LAB_183B

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_TestEntryFlagYAndBit1   (TestEntryFlagYAndBit1??)
; ARGS:
;   stack +4: entryPtr (struct??)
;   stack +8: entryIndex (word)
;   stack +12: fieldOffset (long)
; RET:
;   D0: 0/1 result
; CLOBBERS:
;   D0-D1/D5-D7/A0-A3
; CALLS:
;   LAB_0347
; READS:
;   entryPtr+40 (bit 1), entry data at fieldOffset
; WRITES:
;   (none)
; DESC:
;   Looks up entry data for entryIndex and returns 1 if the selected byte
;   equals 'Y' and a flag bit is set in the entry.
; NOTES:
;   - Uses LAB_0347 to resolve the entry record.
;------------------------------------------------------------------------------
CLEANUP_TestEntryFlagYAndBit1:
LAB_0277:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .return_false

    TST.L   D6
    BMI.S   .return_false

    MOVEQ   #5,D1
    CMP.L   D1,D6
    BGT.S   .return_false

    MOVEQ   #89,D0
    MOVEA.L -4(A5),A0
    CMP.B   0(A0,D6.L),D0
    BNE.S   .return_false

    BTST    #1,40(A3)
    BEQ.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .done

.return_false:
    MOVEQ   #0,D0

.done:
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_UpdateEntryFlagBytes   (UpdateEntryFlagBytes??)
; ARGS:
;   stack +4: entryPtr (struct??)
;   stack +8: entryIndex (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A3
; CALLS:
;   LAB_0347, LAB_0380
; READS:
;   LAB_21A8, LAB_1B61
; WRITES:
;   LAB_21B1, LAB_21B2
; DESC:
;   Loads two flag bytes from the entry data and writes derived values into
;   LAB_21B1/LAB_21B2 using LAB_21A8 attribute bits.
; NOTES:
;   - Falls back to LAB_1B61 when the entry record is missing.
;------------------------------------------------------------------------------
CLEANUP_UpdateEntryFlagBytes:
LAB_027A:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BNE.S   .entry_ok

    LEA     LAB_1B61,A0
    LEA     -15(A5),A1

.copy_default_entry_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry_loop

    LEA     -15(A5),A0
    MOVE.L  A0,-4(A5)

.entry_ok:
    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag6

.entry_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag6:
    MOVE.B  D1,LAB_21B1
    MOVEA.L -4(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag7

.entry_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag7:
    MOVE.B  D1,LAB_21B2
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_BuildAlignedStatusLine   (BuildAlignedStatusLine??)
; ARGS:
;   stack +4: outText (char*)
;   stack +8: modeFlag (word)
;   stack +12: entryIndex (word)
;   stack +16: entrySubIndex (word)
;   stack +20: entryPtr (struct??)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_037F, CLEANUP_TestEntryFlagYAndBit1, LAB_0347,
;   JMP_TBL_PRINTF_1, JMP_TBL_APPEND_DATA_AT_NULL_1, LAB_0380
; READS:
;   LAB_1B62, LAB_1B63, LAB_1B64, LAB_21A8, LAB_2157
; WRITES:
;   LAB_21B3, LAB_21B4, LAB_1B5D
; DESC:
;   Builds an aligned status string into outText, optionally using entry data
;   and setting flag bytes for later rendering.
; NOTES:
;   - Uses LAB_0347 to resolve entry records and LAB_21A8 for attribute bits.
;------------------------------------------------------------------------------
CLEANUP_BuildAlignedStatusLine:
LAB_0281:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    CLR.L   -28(A5)
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   .use_format_b

    MOVEQ   #1,D1
    BRA.S   .format_selected

.use_format_b:
    MOVEQ   #2,D1

.format_selected:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_037F(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  24(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   CLEANUP_TestEntryFlagYAndBit1

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .skip_entry_text

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-28(A5)

.skip_entry_text:
    TST.L   -28(A5)
    BEQ.W   .clear_status_flag

    PEA     20.W
    MOVE.L  -28(A5),-(A7)
    PEA     19.W
    PEA     LAB_1B62
    PEA     -12(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     20(A7),A7
    TST.L   28(A5)
    BEQ.S   .append_default_prefix

    PEA     LAB_2157
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_entry_text

.append_default_prefix:
    PEA     LAB_1B63
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.append_entry_text:
    PEA     -12(A5)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0347

    LEA     20(A7),A7
    MOVE.L  D0,-32(A5)
    TST.L   D0
    BNE.S   .entry2_ok

    LEA     LAB_1B64,A0
    LEA     -23(A5),A1

.copy_default_entry2_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry2_loop

    LEA     -23(A5),A0
    MOVE.L  A0,-32(A5)

.entry2_ok:
    MOVEA.L -32(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag6

.entry2_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag6:
    MOVE.B  D1,LAB_21B3
    MOVEA.L -32(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag7

.entry2_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag7:
    MOVE.B  D1,LAB_21B4
    MOVE.B  #$1,LAB_1B5D
    BRA.S   .done

.clear_status_flag:
    CLR.B   LAB_1B5D

.done:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawInsetRectFrame   (DrawInsetRectFrame??)
; ARGS:
;   stack +4: rastPort (struct RastPort*)
;   stack +8: pen (byte)
;   stack +12: width (word)
;   stack +16: height (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOMove, _LVODraw
; READS:
;   rastPort fields (25/36/38/62 offsets)
; WRITES:
;   rastPort drawing
; DESC:
;   Draws a filled rectangle and multiple inset outline strokes.
; NOTES:
;   - Uses pen 1 and 2 to draw the inset border layers.
;------------------------------------------------------------------------------
CLEANUP_DrawInsetRectFrame:
LAB_028F:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    MOVE.B  25(A3),D4
    EXT.W   D4
    EXT.L   D4
    MOVE.W  36(A3),D0
    MOVE.W  38(A3),D1
    ADDQ.W  #2,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #2,D0
    MOVE.W  D1,-8(A5)
    SUB.W   62(A3),D1
    SUBQ.W  #1,D1
    ADDQ.W  #2,D6
    MOVE.L  D7,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.W  D0,-10(A5)
    MOVE.W  D1,-12(A5)

    MOVEA.L A3,A1
    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.W  -10(A5),D2
    EXT.L   D2
    MOVE.L  D6,D3
    EXT.L   D3
    ADD.L   D3,D2
    MOVE.W  -12(A5),D3
    EXT.L   D3
    MOVE.L  D2,36(A7)
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D3
    MOVEA.L A3,A1
    MOVE.L  36(A7),D2
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.W  -8(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_FormatEntryStringTokens   (FormatEntryStringTokens??)
; ARGS:
;   stack +4: outPtr1 (char**)
;   stack +8: outPtr2 (char**)
;   stack +12: inText (char*)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   LAB_05C1, LAB_0385
; READS:
;   LAB_1B65, LAB_1B66, LAB_1B67, LAB_21A8
; WRITES:
;   outPtr1/outPtr2 contents
; DESC:
;   Formats an input text string, applying a small token/jumptable filter,
;   and stores the results into two output buffers.
; NOTES:
;   - Uses a switch/jumptable to handle special token bytes.
;------------------------------------------------------------------------------
CLEANUP_FormatEntryStringTokens:
LAB_0290:
    LINK.W  A5,#-32
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   16(A5)
    BEQ.W   .empty_input

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.W   .empty_input

    PEA     58.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-26(A5)
    TST.L   D0
    BEQ.W   .empty_input

    LEA     LAB_1B65,A0
    LEA     -22(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)+
    CLR.B   (A1)
    LEA     LAB_1B66,A0
    LEA     -11(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVEQ   #0,D7

.scan_input_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_scan

    MOVEQ   #58,D0
    MOVEA.L 16(A5),A0
    CMP.B   0(A0,D7.L),D0
    BEQ.S   .after_scan

    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_input_loop

.after_scan:
    CLR.B   -11(A5,D7.L)
    MOVE.L  (A3),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A3)
    LEA     LAB_1B67,A0
    LEA     -11(A5),A1

.copy_suffix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix_loop

    ADDQ.L  #1,-26(A5)
    MOVEQ   #0,D7

.token_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.W   .commit_output

    MOVEA.L -26(A5),A0
    TST.B   0(A0,D7.L)
    BEQ.W   .commit_output

    MOVE.L  D7,D0
    CMPI.L  #$9,D0
    BCC.W   .next_token

    ADD.W   D0,D0
    MOVE.W  .token_table(PC,D0.W),D0
    JMP     .token_table+2(PC,D0.W)

; Switch case
.token_table:
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_pair_check-.token_table-2

.case_alpha_or_copy:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B68
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .use_default_char

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_raw_char

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_token_char

.copy_raw_char:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_token_char:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_flag7_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .use_default_char_flag7

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char_flag7:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_pair_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  1(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    BTST    #1,(A6)
    BEQ.S   .copy_pair_char1

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char1

.copy_pair_char1:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char1:
    MOVE.B  D0,-11(A5,D7.L)
    ADDQ.L  #1,D7
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_pair_char2

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char2

.copy_pair_char2:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char2:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.S   .next_token

.copy_default_pair:
    LEA     -11(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D7,A1
    MOVEA.L D7,A6
    ADDQ.L  #1,D7
    MOVE.L  A6,D0
    MOVE.B  -22(A5,D0.L),(A1)
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)

.next_token:
    ADDQ.L  #1,D7
    BRA.W   .token_loop

.commit_output:
    MOVE.L  (A2),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A2)
    BRA.S   .done

.empty_input:
    MOVE.L  (A3),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,(A3)
    MOVE.L  (A2),(A7)
    PEA     LAB_1B69
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  D0,(A2)

.done:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ParseAlignedListingBlock   (ParseAlignedListingBlock??)
; ARGS:
;   stack +4: dataPtr (char*)
; RET:
;   D0: status (0=ok, nonzero=error??)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   COI_CountEscape14BeforeNull, LAB_037D, ESQ_WildcardMatch, LAB_0468, LAB_0385,
;   CLEANUP_FormatEntryStringTokens, COI_AllocSubEntryTable, LAB_02D1, LAB_02D5
; READS:
;   LAB_222D-LAB_2235, LAB_2232, LAB_1B8F-LAB_1B92,
;   LAB_2233, LAB_2235, LAB_2236, LAB_20ED
; WRITES:
;   LAB_1B8F-LAB_1B92
; DESC:
;   Parses an aligned listing block from dataPtr, selecting candidate entries,
;   building entry structs, and allocating subentry tables.
; NOTES:
;   - Uses COI_CountEscape14BeforeNull to locate delimiter fields.
;------------------------------------------------------------------------------
CLEANUP_ParseAlignedListingBlock:
LAB_02A5:
    LINK.W  A5,#-128
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    CLR.B   -57(A5)
    MOVEQ   #0,D0
    MOVEQ   #22,D1
    MOVE.B  D1,-97(A5)
    MOVEQ   #23,D2
    MOVE.B  D2,-96(A5)
    MOVE.B  #$3,-95(A5)
    MOVE.B  #$4,-94(A5)
    MOVEQ   #16,D3
    MOVE.B  D3,-93(A5)
    MOVEQ   #5,D4
    MOVE.B  D4,-92(A5)
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    MOVE.L  D0,-62(A5)
    MOVEQ   #15,D0
    MOVE.B  D0,-91(A5)
    MOVEQ   #6,D0
    MOVE.B  D0,-90(A5)
    MOVEQ   #20,D0
    MOVE.B  D0,-89(A5)
    MOVE.B  D1,-125(A5)
    MOVE.B  D2,-124(A5)
    MOVE.B  D3,-123(A5)
    MOVE.B  D4,-122(A5)
    MOVE.B  #$f,-121(A5)
    MOVE.B  #$6,-120(A5)
    MOVE.B  D0,-119(A5)
    CLR.W   -32(A5)

.init_slot_table_loop:
    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.S   .after_slot_init

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),-52(A5,D1.L)
    ADDQ.W  #1,-32(A5)
    BRA.S   .init_slot_table_loop

.after_slot_init:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    ADDQ.L  #1,-66(A5)
    MOVE.B  LAB_222D,D1
    MOVE.B  D0,-57(A5)
    CMP.B   D0,D1
    BNE.S   .check_service_type_b

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   .check_service_type_b

    MOVE.W  LAB_222F,D5
    MOVE.B  D0,LAB_1B92
    MOVEQ   #1,D1
    MOVE.B  D1,LAB_1B90
    BRA.S   .skip_separator

.check_service_type_b:
    MOVE.B  LAB_2230,D1
    CMP.B   D0,D1
    BNE.S   .invalid_service_type

    MOVE.W  LAB_2231,D5
    MOVE.B  D0,LAB_1B91
    MOVE.B  #$1,LAB_1B8F
    BRA.S   .skip_separator

.invalid_service_type:
    MOVEQ   #1,D0
    BRA.W   .return_status

.skip_separator:
    MOVEQ   #49,D0
    MOVE.L  -66(A5),D1
    CMP.B   0(A3,D1.L),D0
    BNE.S   .parse_field_offsets

    ADDQ.L  #1,-66(A5)

.parse_field_offsets:
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   COI_CountEscape14BeforeNull

    EXT.L   D0
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D1
    ADDA.L  D1,A0
    MOVEQ   #0,D2
    MOVE.W  LAB_2232,D2
    SUB.L   D1,D2
    EXT.L   D2
    PEA     1.W
    CLR.L   -(A7)
    MOVE.L  D2,-(A7)
    PEA     -97(A5)
    PEA     9.W
    PEA     -88(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-62(A5)
    JSR     LAB_037D(PC)

    LEA     36(A7),A7
    EXT.L   D0
    MOVEQ   #0,D7
    CLR.W   -32(A5)
    MOVE.L  D0,-70(A5)

.scan_candidate_loop:
    CMP.W   D5,D7
    BGE.S   .after_candidate_scan

    CMPI.W  #10,-32(A5)
    BGE.S   .after_candidate_scan

    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .use_alt_entry_table

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .use_alt_entry_table

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .compare_candidate_entry

.use_alt_entry_table:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.compare_candidate_entry:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .store_candidate_slot

    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVE.W  D7,-52(A5,D0.L)
    ADDQ.W  #1,-32(A5)

.store_candidate_slot:
    ADDQ.W  #1,D7
    BRA.S   .scan_candidate_loop

.after_candidate_scan:
    MOVE.W  -52(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_first_entry

    MOVEQ   #2,D0
    BRA.W   .return_status

.select_first_entry:
    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .select_alt_entry

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .select_alt_entry

    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .populate_entry_fields

.select_alt_entry:
    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.populate_entry_fields:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_02D1

    MOVE.L  -4(A5),(A7)
    BSR.W   LAB_02D5

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -84(A5),A0
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVEA.W -82(A5),A2
    MOVE.L  A2,D0
    MOVE.B  0(A1,D0.W),(A0)
    MOVE.B  1(A1,D0.W),1(A0)
    MOVE.B  2(A1,D0.W),2(A0)
    CLR.B   3(A0)
    ADDA.W  -80(A5),A1
    MOVE.L  12(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -78(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -76(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,8(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -74(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    LEA     24(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  -62(A5),D0
    MOVE.W  D0,36(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -88(A5),A1
    TST.B   (A1)
    BEQ.S   .build_title_from_field

    LEA     24(A0),A2
    LEA     28(A0),A6
    MOVE.L  A1,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_title_format

.build_title_from_field:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     LAB_1B6A
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,28(A0)

.after_title_format:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -86(A5),A0
    TST.B   (A0)
    BEQ.S   .set_missing_extra

    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   .advance_entry_offset

.set_missing_extra:
    MOVEQ   #-1,D0
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)

.advance_entry_offset:
    MOVE.W  -74(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    TST.L   16(A0)
    BEQ.S   .alloc_subentry_table

    MOVEA.L -12(A5),A1
    MOVEA.L 16(A1),A0

.count_entry_text_loop:
    TST.B   (A0)+
    BNE.S   .count_entry_text_loop

    SUBQ.L  #1,A0
    SUBA.L  16(A1),A0
    MOVE.L  A0,D0
    ADD.L   D0,-66(A5)

.alloc_subentry_table:
    ADDQ.L  #1,-66(A5)
    MOVE.L  -4(A5),-(A7)
    BSR.W   COI_AllocSubEntryTable

    ADDQ.W  #4,A7
    MOVEQ   #0,D6

.subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D6
    BGE.W   .begin_merge

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEQ   #0,D0
    MOVE.L  -66(A5),D1
    MOVE.B  0(A3,D1.L),D0
    MOVEA.L -20(A5),A0
    MOVE.W  D0,(A0)
    ADDQ.L  #1,-66(A5)
    MOVEA.L A3,A1
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A1
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    SUB.L   D0,D1
    EXT.L   D1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     -125(A5)
    PEA     7.W
    PEA     -116(A5)
    MOVE.L  A1,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7
    MOVE.W  -112(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_title

    MOVEA.L -12(A5),A1
    MOVEA.L 12(A1),A0
    BRA.S   .store_subentry_title

.select_subentry_title:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -112(A5),A0

.store_subentry_title:
    MOVEA.L -20(A5),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.W  -110(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_desc

    MOVEA.L -12(A5),A2
    MOVEA.L 20(A2),A1
    BRA.S   .store_subentry_desc

.select_subentry_desc:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -110(A5),A1

.store_subentry_desc:
    MOVE.L  14(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.W  -108(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_alt

    MOVEA.L -12(A5),A2
    MOVEA.L 8(A2),A1
    BRA.S   .store_subentry_alt

.select_subentry_alt:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -108(A5),A1

.store_subentry_alt:
    MOVE.L  2(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -106(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_more

    MOVEA.L -12(A5),A2
    MOVEA.L 16(A2),A1
    BRA.S   .store_subentry_more

.select_subentry_more:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -106(A5),A1

.store_subentry_more:
    MOVE.L  10(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.W  -116(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .format_subentry_extra

    MOVE.L  18(A0),-(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  24(A1),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  28(A1),-(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,22(A0)
    BRA.S   .store_subentry_extra

.format_subentry_extra:
    LEA     18(A0),A1
    LEA     22(A0),A2
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -116(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7

.store_subentry_extra:
    MOVE.W  -114(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .load_subentry_icon

    MOVEA.L -12(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),26(A1)
    BRA.S   .advance_subentry_offset

.load_subentry_icon:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -114(A5),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,26(A0)

.advance_subentry_offset:
    MOVE.W  -104(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    ADDQ.W  #1,D6
    BRA.W   .subentry_loop

.begin_merge:
    MOVE.W  #1,-32(A5)

.merge_candidate_loop:
    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -52(A5,D0.L),D1
    BEQ.W   .return_success

    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.W   .return_success

    MOVE.B  LAB_222D,D1
    MOVE.B  -57(A5),D2
    CMP.B   D1,D2
    BNE.S   .select_merge_table

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   .select_merge_table

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2235,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .merge_entry_copy

.select_merge_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2233,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)

.merge_entry_copy:
    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L -8(A5),A0
    MOVE.L  48(A0),-16(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_02D1

    MOVE.L  -8(A5),(A7)
    BSR.W   LAB_02D5

    MOVEA.L -16(A5),A0
    MOVE.L  4(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.B  (A0),(A1)
    MOVE.B  1(A0),1(A1)
    MOVE.B  2(A0),2(A1)
    MOVE.B  3(A0),3(A1)
    MOVE.L  12(A1),(A7)
    MOVE.L  12(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.W  36(A0),36(A1)
    MOVE.L  24(A1),(A7)
    MOVE.L  24(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.L  -8(A5),(A7)
    BSR.W   COI_AllocSubEntryTable

    LEA     32(A7),A7
    MOVEQ   #0,D7

.merge_subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D7
    BGE.W   .merge_candidate_loop

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-24(A5)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.W  (A0),(A1)
    MOVE.L  6(A1),-(A7)
    MOVE.L  6(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     LAB_0385(PC)

    LEA     28(A7),A7
    MOVEA.L -24(A5),A0
    MOVE.L  D0,22(A0)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.L  26(A0),26(A1)
    ADDQ.W  #1,D7
    BRA.W   .merge_subentry_loop

.return_success:
    MOVEQ   #0,D0

.return_status:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS
