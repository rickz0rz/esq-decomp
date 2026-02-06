;------------------------------------------------------------------------------
; FUNC: CLEANUP_ClearVertbInterruptServer
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVORemIntServer, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB, AbsExecBase, GLOB_STR_CLEANUP_C_1
; WRITES:
;   (none)
; DESC:
;   Removes the INTB_VERTB interrupt server and frees its interrupt structure.
; NOTES:
;   - Deallocates the struct via GROUP_AG_JMPTBL_MEMORY_DeallocateMemory.
;------------------------------------------------------------------------------
CLEANUP_ClearVertbInterruptServer:
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVORemIntServer(A6)

    PEA     Struct_Interrupt_Size.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,-(A7)
    PEA     57.W
    PEA     GLOB_STR_CLEANUP_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ClearAud1InterruptVector
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOSetIntVector, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
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
CLEANUP_ClearAud1InterruptVector:
    MOVE.W  #$100,INTENA
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L GLOB_REF_INTB_AUD1_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    PEA     22.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,-(A7)
    PEA     74.W
    PEA     GLOB_STR_CLEANUP_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ClearRbfInterruptAndSerial
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOCloseDevice, GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField,
;   _LVOSetIntVector, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   LAB_2211_SERIAL_PORT_MAYBE, DATA_WDISP_BSS_LONG_2212, GLOB_REF_INTB_RBF_INTERRUPT,
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
CLEANUP_ClearRbfInterruptAndSerial:
    MOVE.W  #$800,INTENA
    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVE.L  DATA_WDISP_BSS_LONG_2212,-(A7)
    JSR     GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  LAB_2211_SERIAL_PORT_MAYBE,(A7)
    JSR     GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(PC)

    MOVEQ   #INTB_RBF,D0
    MOVEA.L GLOB_REF_INTB_RBF_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  #64000,(A7)
    MOVE.L  GLOB_REF_INTB_RBF_64K_BUFFER,-(A7)
    PEA     113.W
    PEA     GLOB_STR_CLEANUP_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     22.W
    MOVE.L  GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,-(A7)
    PEA     118.W
    PEA     GLOB_STR_CLEANUP_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
; FUNC: CLEANUP_ShutdownInputDevices
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A0-A1/A6
; CALLS:
;   _LVODoIO, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOCloseDevice,
;   GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, GROUP_AB_JMPTBL_IOSTDREQ_Free
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
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVEA.L GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,A1
    JSR     _LVOCloseDevice(A6)

    MOVE.L  GLOB_REF_INPUTDEVICE_MSGPORT,(A7)
    JSR     GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  GLOB_REF_CONSOLEDEVICE_MSGPORT,(A7)
    JSR     GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  GLOB_REF_IOSTDREQ_STRUCT_INPUT_DEVICE,(A7)
    JSR     GROUP_AB_JMPTBL_IOSTDREQ_Free(PC)

    MOVE.L  GLOB_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE,(A7)
    JSR     GROUP_AB_JMPTBL_IOSTDREQ_Free(PC)

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ReleaseDisplayResources
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A1/A6
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster,
;   _LVOCloseFont, _LVOCloseLibrary
; READS:
;   GLOB_REF_96_BYTES_ALLOCATED, GLOB_REF_RASTPORT_1, DATA_WDISP_BSS_LONG_2220, DATA_WDISP_BSS_LONG_221A,
;   DATA_WDISP_BSS_LONG_221C, DATA_WDISP_BSS_LONG_2224, WDISP_BannerWorkRasterPtr, GLOB_HANDLE_PREVUE_FONT,
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
CLEANUP_ReleaseDisplayResources:
    MOVE.L  D7,-(A7)

    PEA     96.W
    MOVE.L  GLOB_REF_96_BYTES_ALLOCATED,-(A7)
    PEA     148.W
    PEA     GLOB_STR_CLEANUP_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     100.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    PEA     152.W
    PEA     GLOB_STR_CLEANUP_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    MOVEQ   #0,D7

.freeRaster_set1_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_2220,A0
    ADDA.L  D0,A0
    PEA     2.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     160.W
    PEA     GLOB_STR_CLEANUP_C_8
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set1_loop

.after_raster_set1:
    MOVEQ   #0,D7

.freeRaster_set2_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set2

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     DATA_WDISP_BSS_LONG_221A,A0
    ADDA.L  D1,A0
    PEA     240.W
    PEA     352.W
    MOVE.L  (A0),-(A7)
    PEA     169.W
    PEA     GLOB_STR_CLEANUP_C_9
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set2_loop

.after_raster_set2:
    MOVEQ   #0,D7

.freeRaster_set3_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_221C,A0
    ADDA.L  D0,A0
    PEA     509.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     178.W
    PEA     GLOB_STR_CLEANUP_C_10
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set3_loop

.after_raster_set3:
    MOVEQ   #3,D7

.freeRaster_set4_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_2224,A0
    ADDA.L  D0,A0
    PEA     241.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     187.W
    PEA     GLOB_STR_CLEANUP_C_11
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set4_loop

.after_raster_set4:
    PEA     15.W
    PEA     696.W
    MOVE.L  WDISP_BannerWorkRasterPtr,-(A7)
    PEA     200.W
    PEA     GLOB_STR_CLEANUP_C_12
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

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
; FUNC: CLEANUP_ShutdownSystem
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A6
; CALLS:
;   _LVOForbid, LOCAVAIL_FreeResourceChain, BRUSH_FreeBrushList,
;   CLEANUP_ClearVertbInterruptServer, CLEANUP_ClearAud1InterruptVector,
;   CLEANUP_ClearRbfInterruptAndSerial, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory,
;   CLEANUP_ShutdownInputDevices, CLEANUP_ReleaseDisplayResources, GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries, GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers,
;   GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode, GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData, GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings, GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers,
;   _LVOSetFunction, _LVOVBeamPos, GROUP_AB_JMPTBL_UNKNOWN2A_Stub0, _LVOPermit
; READS:
;   LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState, ESQIFF_BrushIniListHead, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, ESQFUNC_PwBrushListHead, ESQIFF_RecordBufferPtr,
;   ESQ_HighlightMsgPort, ESQ_HighlightReplyPort, DATA_WDISP_BSS_LONG_22A7, DATA_WDISP_BSS_WORD_222B, WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusOverlayTextPtr, DATA_ESQ_BSS_LONG_1DC7,
;   DATA_WDISP_BSS_LONG_222C, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_INTUITION_LIBRARY,
;   GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST, GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT,
;   AbsExecBase, GLOB_STR_CLEANUP_C_13, GLOB_STR_CLEANUP_C_14, GLOB_STR_CLEANUP_C_15,
;   GLOB_STR_CLEANUP_C_16
; WRITES:
;   WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusOverlayTextPtr
; DESC:
;   Global shutdown: forbids task switches, releases resources, restores patched
;   system vectors, and re-enables multitasking.
; NOTES:
;   - Frees raster tables via nested loops over DATA_WDISP_BSS_LONG_22A7 entries.
;------------------------------------------------------------------------------
; Global shutdown sequence: stop interrupts, free rsrcs, reset display.
CLEANUP_ShutdownSystem:
    MOVEM.L D6-D7,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(PC)

    PEA     LOCAVAIL_SecondaryFilterState
    JSR     GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(PC)

    CLR.L   (A7)
    PEA     ESQIFF_BrushIniListHead
    JSR     BRUSH_FreeBrushList(PC)      ; release primary brush list

    CLR.L   (A7)
    PEA     ESQIFF_GAdsBrushListHead
    JSR     BRUSH_FreeBrushList(PC)      ; release alternate brush buckets

    CLR.L   (A7)
    PEA     ESQIFF_LogoBrushListHead
    JSR     BRUSH_FreeBrushList(PC)

    CLR.L   (A7)
    PEA     ESQFUNC_PwBrushListHead
    JSR     BRUSH_FreeBrushList(PC)

    BSR.W   CLEANUP_ClearVertbInterruptServer

    BSR.W   CLEANUP_ClearAud1InterruptVector

    BSR.W   CLEANUP_ClearRbfInterruptAndSerial

    PEA     9000.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    PEA     260.W
    PEA     GLOB_STR_CLEANUP_C_13
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    BSR.W   CLEANUP_ShutdownInputDevices

    BSR.W   CLEANUP_ReleaseDisplayResources
M
    JSR     GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(PC)

    JSR     GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(PC)

    PEA     1.W
    JSR     GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(PC)

    PEA     2.W
    JSR     GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(PC)

    JSR     GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(PC)

    PEA     2.W
    JSR     GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    PEA     1.W
    JSR     GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    JSR     GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(PC)

    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
    MOVE.L  38(A0),COP1LCH
    JSR     GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(PC)

    PEA     34.W
    MOVE.L  ESQ_HighlightMsgPort,-(A7)
    PEA     318.W
    PEA     GLOB_STR_CLEANUP_C_14
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     72(A7),A7

    PEA     34.W
    MOVE.L  ESQ_HighlightReplyPort,-(A7)
    PEA     319.W
    PEA     GLOB_STR_CLEANUP_C_15
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

    MOVEQ   #0,D6

.freeRaster_rows_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_raster_table

    MOVEQ   #0,D7

.freeRaster_cols_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .next_raster_row

    MOVE.L  D6,D0
    MOVEQ   #40,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     DATA_WDISP_BSS_LONG_22A7,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  DATA_WDISP_BSS_WORD_222B,D0
    MOVE.L  D0,-(A7)
    PEA     696.W
    MOVE.L  8(A0),-(A7)
    PEA     329.W
    PEA     GLOB_STR_CLEANUP_C_16
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_cols_loop

.next_raster_row:
    ADDQ.L  #1,D6
    BRA.S   .freeRaster_rows_loop

.after_raster_table:
    MOVE.L  WDISP_WeatherStatusTextPtr,-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,WDISP_WeatherStatusTextPtr
    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_WeatherStatusOverlayTextPtr

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

    TST.L   DATA_ESQ_BSS_LONG_1DC7
    BEQ.S   .after_optional_restore

    MOVEA.L DATA_WDISP_BSS_LONG_222C,A0
    MOVE.L  DATA_ESQ_BSS_LONG_1DC7,184(A0)

.after_optional_restore:
    JSR     GROUP_AB_JMPTBL_UNKNOWN2A_Stub0(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
