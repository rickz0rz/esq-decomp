;!======

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

.LAB_01AE:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .LAB_01AF

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
    BRA.S   .LAB_01AE

.LAB_01AF:
    MOVEQ   #0,D7

.LAB_01B0:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .LAB_01B1

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
    BRA.S   .LAB_01B0

.LAB_01B1:
    MOVEQ   #0,D7

.LAB_01B2:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .LAB_01B3

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
    BRA.S   .LAB_01B2

.LAB_01B3:
    MOVEQ   #3,D7

.LAB_01B4:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .LAB_01B5

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
    BRA.S   .LAB_01B4

.LAB_01B5:
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

.LAB_01BC:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .LAB_01BF

    MOVEQ   #0,D7

.LAB_01BD:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .LAB_01BE

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
    BRA.S   .LAB_01BD

.LAB_01BE:
    ADDQ.L  #1,D6
    BRA.S   .LAB_01BC

.LAB_01BF:
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
    BEQ.S   .LAB_01C0

    MOVEA.L LAB_222C,A0
    MOVE.L  LAB_1DC7,184(A0)

.LAB_01C0:
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

; Process pending alert/notification state and update on-screen banners.
CLEANUP_ProcessAlerts:
LAB_01CB:
    MOVEM.L D2/D7,-(A7)
    TST.W   LAB_2264
    BEQ.W   LAB_01E2

    TST.L   CLEANUP_AlertProcessingFlag
    BNE.W   LAB_01E2

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertProcessingFlag
    TST.B   LAB_1DEF
    BEQ.S   LAB_01CC

    TST.W   LAB_2263
    BNE.S   LAB_01CC

    SUBQ.L  #1,CLEANUP_AlertCooldownTicks
    BGT.S   LAB_01CC

    JSR     LAB_020E(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertCooldownTicks

LAB_01CC:
    MOVEQ   #2,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   LAB_01CD

    MOVE.W  LAB_2325,D0
    BGT.S   LAB_01CE

    MOVE.L  D0,D1
    ADDI.W  #10,D1
    MOVE.W  D1,LAB_2325
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_1FE7
    BRA.S   LAB_01CE

LAB_01CD:
    MOVEQ   #3,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   LAB_01CE

    MOVE.W  LAB_2325,D0
    BGT.S   LAB_01CE

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1FE7
    JSR     LAB_0464(PC)

LAB_01CE:
    CLR.W   LAB_2264
    PEA     LAB_223A
    JSR     LAB_007B(PC)

    MOVE.L  D0,D7
    EXT.L   D7
    PEA     LAB_2274
    JSR     LAB_007B(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_22A5,D0
    BLT.S   LAB_01CF

    MOVEQ   #11,D1
    CMP.W   D1,D0
    BGE.S   LAB_01CF

    JSR     LAB_0213(PC)

    MOVE.W  LAB_22A5,D0
    BNE.S   LAB_01CF

    MOVE.W  #(-1),LAB_22A5

LAB_01CF:
    JSR     LAB_0212(PC)

    MOVEQ   #1,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; brush loader flagged \"category 1\" alert
    BNE.S   LAB_01D0

    PEA     3.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

LAB_01D0:
    MOVEQ   #2,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; same, but for wider-than-allowed brushes
    BNE.S   LAB_01D1

    PEA     4.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

LAB_01D1:
    MOVEQ   #3,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; or for taller-than-allowed brushes
    BNE.S   LAB_01D2

    PEA     5.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

LAB_01D2:
    TST.L   D7
    BEQ.S   LAB_01D5

    MOVE.B  LAB_227F,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   LAB_01D3

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_227F

LAB_01D3:
    SUBQ.L  #1,CLEANUP_BannerTickCounter
    BNE.S   LAB_01D4

    MOVEQ   #60,D0
    MOVE.L  D0,CLEANUP_BannerTickCounter
    MOVE.B  LAB_2196,D0
    CMP.B   D1,D0
    BLS.S   LAB_01D4

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_2196

LAB_01D4:
    PEA     LAB_21DF
    JSR     LAB_0216(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_01D5

    PEA     1.W
    JSR     LAB_0215(PC)

    ADDQ.W  #4,A7

LAB_01D5:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_01D6

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   LAB_01D6

    CLR.W   LAB_1E85
    CLR.L   -(A7)
    JSR     LAB_0215(PC)

    ADDQ.W  #4,A7
    MOVE.W  #1,LAB_1E85

LAB_01D6:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_01D7

    MOVEQ   #5,D2
    CMP.L   D2,D7
    BEQ.S   LAB_01D8

LAB_01D7:
    CMP.B   D1,D0
    BEQ.S   LAB_01D9

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   LAB_01D9

LAB_01D8:
    JSR     LAB_020D(PC)

    JSR     LAB_0217(PC)

    CLR.L   -(A7)
    JSR     LAB_0215(PC)

    ADDQ.W  #4,A7

LAB_01D9:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_01DA

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BNE.S   LAB_01DA

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

LAB_01DA:
    MOVE.B  LAB_1DD4,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_01DB

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   LAB_01DB

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

LAB_01DB:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    TST.W   LAB_2263
    BEQ.S   LAB_01DC

    BSR.W   LAB_01FE

    BRA.S   LAB_01DD

LAB_01DC:
    BSR.W   CLEANUP_DrawClockBanner

LAB_01DD:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   LAB_01DF

    MOVEQ   #0,D1
    MOVE.W  LAB_2270,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    SUBQ.L  #1,D1
    BNE.S   LAB_01DE

    CLR.L   BRUSH_PendingAlertCode

LAB_01DE:
    MOVE.W  LAB_226F,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0214(PC)

    ADDQ.W  #4,A7

LAB_01DF:
    JSR     LAB_0210(PC)

    MOVE.B  LAB_1D13,D0
    SUBQ.B  #8,D0
    BNE.S   LAB_01E0

    JSR     LAB_0218(PC)

    BRA.S   LAB_01E1

LAB_01E0:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #7,D0
    BNE.S   LAB_01E1

    JSR     LAB_020F(PC)

LAB_01E1:
    CLR.L   CLEANUP_AlertProcessingFlag

LAB_01E2:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

; Render the top-of-screen clock/banner text.
CLEANUP_DrawClockBanner:
LAB_01E3:
    LINK.W  A5,#-12
    MOVEM.L D2-D3,-(A7)
    TST.W   LAB_2263
    BNE.W   LAB_01E8

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_01E4

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
    BRA.S   LAB_01E5

LAB_01E4:
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

LAB_01E5:
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
    JSR     LAB_00ED(PC)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_01E6

    ADDQ.L  #1,D1

LAB_01E6:
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

LAB_01E7:
    TST.B   (A1)+
    BNE.S   LAB_01E7

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

LAB_01E8:
    MOVEM.L -20(A5),D2-D3
    UNLK    A5
    RTS

;!======

LAB_01E9:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3

.LAB_01EA:
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .LAB_01EB

    SUB.L   D0,D7
    BRA.S   .LAB_01EA

.LAB_01EB:
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

.LAB_01EC:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_01EC

    TST.L   D6
    BLE.S   .LAB_01ED

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

.LAB_01ED:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

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

.LAB_01EF:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .LAB_01F6

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .LAB_01F0

    SUB.L   D1,D0
    BRA.S   .LAB_01F1

.LAB_01F0:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.LAB_01F1:
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
    JSR     LAB_00ED(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   LAB_01E9

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

.LAB_01F2:
    TST.B   (A1)+
    BNE.S   .LAB_01F2

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
    BPL.S   .LAB_01F3

    ADDQ.L  #1,D1

.LAB_01F3:
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
    BPL.S   .LAB_01F4

    ADDQ.L  #1,D2

.LAB_01F4:
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

.LAB_01F5:
    TST.B   (A1)+
    BNE.S   .LAB_01F5

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .LAB_01EF

.LAB_01F6:
    MOVEQ   #2,D6
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .LAB_01F7

    SUB.L   D1,D0
    BRA.S   .LAB_01F8

.LAB_01F7:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.LAB_01F8:
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
    JSR     LAB_00ED(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   LAB_01E9

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

.LAB_01F9:
    TST.B   (A1)+
    BNE.S   .LAB_01F9

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
    BPL.S   .LAB_01FA

    ADDQ.L  #1,D1

.LAB_01FA:
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
    BPL.S   .LAB_01FB

    ADDQ.L  #1,D2

.LAB_01FB:
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

.return:
    TST.B   (A1)+
    BNE.S   .return

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    MOVEM.L -120(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

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

LAB_01FE:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)
    MOVEQ   #0,D5
    PEA     LAB_2274
    PEA     -32(A5)
    JSR     LAB_0090(PC)

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
    BNE.S   .LAB_01FF

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

.LAB_01FF:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_SINGLE_SPACE,A0
    MOVEQ   #9,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0200

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_PM,A0
    MOVEQ   #11,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

    BRA.S   .LAB_0201

.LAB_0200:
    MOVE.L  D6,D5

.LAB_0201:
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .LAB_0202

    ADDQ.L  #1,D0

.LAB_0202:
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

.LAB_0203:
    TST.B   (A1)+
    BNE.S   .LAB_0203

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .return

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

.LAB_0204:
    TST.B   (A1)+
    BNE.S   .LAB_0204

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

.return:
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

.LAB_0207:
    TST.B   (A1)+
    BNE.S   .LAB_0207

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
    BPL.S   .LAB_0208

    ADDQ.L  #1,D0

.LAB_0208:
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
    JSR     LAB_00ED(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  .rastPortBitmap(A5),Struct_RastPort__BitMap(A0)

    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

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
    JSR     LAB_00ED(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

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

    BSR.W   LAB_01FE

    PEA     67.W
    PEA     695.W
    PEA     34.W
    PEA     448.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     LAB_00ED(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

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

    BSR.W   LAB_0209

    BSR.W   LAB_020A

    BSR.W   LAB_020B

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_020D:
    JMP     LAB_1470

LAB_020E:
    JMP     LAB_0999

LAB_020F:
    JMP     LAB_0991

LAB_0210:
    JMP     LAB_1571

LAB_0211:
    JMP     GCOMMAND_UpdateBannerBounds

LAB_0212:
    JMP     LAB_14BA

LAB_0213:
    JMP     LAB_14B6

LAB_0214:
    JMP     LAB_0981

LAB_0215:
    JMP     ESQDISP_DrawStatusBanner

LAB_0216:
    JMP     DST_UpdateBannerQueue

LAB_0217:
    JMP     DST_RefreshBannerBuffer

LAB_0218:
    JMP     DRAW_ESC_MENU_VERSION_SCREEN

JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT:
    JMP     ADJUST_HOURS_TO_24_HR_FMT

;!======

    MOVEQ   #97,D0

;!======

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
    BNE.S   .LAB_021C

    LEA     LAB_234B,A0
    LEA     -554(A5),A1

.LAB_021B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_021B

    MOVE.W  LAB_234D,-38(A5)
    BRA.S   .LAB_021E

.LAB_021C:
    LEA     LAB_234C,A0
    LEA     -554(A5),A1

.LAB_021D:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_021D

    MOVE.W  LAB_234E,-38(A5)

.LAB_021E:
    LEA     -554(A5),A0
    LEA     -754(A5),A1

.LAB_021F:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_021F

    TST.W   -38(A5)
    BNE.S   .LAB_0220

    MOVEQ   #48,D0
    MOVE.W  D0,-38(A5)

.LAB_0220:
    MOVE.W  -38(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B5C
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .LAB_0221

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
    BRA.S   .LAB_0222

.LAB_0221:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_0222

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

.LAB_0222:
    MOVEQ   #69,D0
    CMP.W   -38(A5),D0
    BNE.W   .LAB_0227

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

.LAB_0223:
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
    BEQ.S   .LAB_0224

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D1.L)
    BNE.S   .LAB_0224

    MOVE.W  -36(A5),D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   .LAB_0224

    ADDQ.W  #1,-36(A5)
    BRA.S   .LAB_0223

.LAB_0224:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  -42(A5),D0
    MOVE.W  (A1),D1
    CMP.W   D0,D1
    BNE.S   .LAB_0225

    MOVE.W  LAB_236E,D1
    MOVE.W  LAB_2364,D2
    CMP.W   D2,D1
    BEQ.W   .return

.LAB_0225:
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

.LAB_0226:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0226

    MOVE.W  #2,-40(A5)
    BRA.W   .LAB_0235

.LAB_0227:
    MOVEQ   #70,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_022C

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .LAB_0229

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .LAB_0229

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.LAB_0228:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0228

    BRA.S   .LAB_022B

.LAB_0229:
    TST.L   LAB_1DDB
    BEQ.W   .return

    MOVEA.L LAB_1DDB,A0
    LEA     -554(A5),A1

.LAB_022A:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_022A

.LAB_022B:
    MOVE.W  #2,-40(A5)
    BRA.W   .LAB_0235

.LAB_022C:
    MOVEQ   #71,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_0231

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .LAB_022E

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .LAB_022E

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.LAB_022D:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_022D

    BRA.S   .LAB_0230

.LAB_022E:
    TST.L   LAB_1DDC
    BEQ.W   .return

    MOVEA.L LAB_1DDC,A0
    LEA     -554(A5),A1

.LAB_022F:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_022F

.LAB_0230:
    MOVE.W  #2,-40(A5)
    BRA.S   .LAB_0235

.LAB_0231:
    MOVEQ   #78,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_0233

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .return

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.W   .return

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.LAB_0232:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0232

    MOVE.W  #2,-40(A5)
    BRA.S   .LAB_0235

.LAB_0233:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_0235

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .return

    MOVE.B  LAB_21B0,D0
    TST.B   D0
    BEQ.W   .return

    LEA     LAB_21B0,A0
    LEA     -554(A5),A1

.LAB_0234:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0234

    MOVEQ   #2,D0
    MOVE.W  D0,-40(A5)

.LAB_0235:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .LAB_0236

    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_2368
    MOVE.W  D0,LAB_2369

.LAB_0236:
    MOVEQ   #53,D0
    CMP.W   D0,D6
    BNE.S   .LAB_0237

    JSR     LAB_0056(PC)

.LAB_0237:
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
    BNE.S   .LAB_0238

    MOVEQ   #1,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    BRA.S   .LAB_0239

.LAB_0238:
    PEA     1.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216

.LAB_0239:
    TST.W   D5
    BNE.S   .LAB_023A

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    JSR     LAB_0273(PC)

    ADDQ.W  #4,A7

.LAB_023A:
    TST.W   D7
    BNE.S   .LAB_023B

    PEA     4.W
    CLR.L   -(A7)
    PEA     1.W
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     2.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7
    BRA.S   .LAB_023C

.LAB_023B:
    PEA     4.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     1.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7

.LAB_023C:
    MOVEQ   #1,D0
    CMP.W   D0,D5
    BNE.S   .LAB_023D

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.LAB_023D:
    JSR     LAB_005C(PC)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  LAB_2364,LAB_236E
    MOVEQ   #48,D0
    CMP.W   -38(A5),D0
    BNE.S   .LAB_023E

    MOVE.B  -554(A5),D0
    TST.B   D0
    BNE.S   .LAB_023E

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0268(PC)

    JSR     LAB_0057(PC)

    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2366
    MOVE.W  LAB_2364,D1
    MOVE.W  D1,LAB_2368
    MOVEQ   #-1,D1
    MOVE.W  D1,LAB_2369
    BRA.W   .return

.LAB_023E:
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_023F

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,-36(A5)
    BRA.S   .LAB_0240

.LAB_023F:
    MOVEQ   #0,D0
    MOVE.B  LAB_2373,D0
    MOVE.W  D0,-36(A5)

.LAB_0240:
    MOVE.W  -36(A5),D0
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   .LAB_0241

    MOVE.B  -554(A5),D1
    TST.B   D1
    BEQ.S   .LAB_0241

    MOVEQ   #1,D1
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  D0,LAB_2369
    MOVE.W  D1,-40(A5)
    BRA.S   .LAB_0242

.LAB_0241:
    MOVE.W  -40(A5),D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_0242

    CLR.B   LAB_2366
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  #(-1),LAB_2369

.LAB_0242:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .LAB_0246

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .LAB_0243

    MOVEQ   #1,D1
    BRA.S   .LAB_0244

.LAB_0243:
    MOVEQ   #2,D1

.LAB_0244:
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

.LAB_0245:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0245

    BRA.S   .LAB_0247

.LAB_0246:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2259

.LAB_0247:
    MOVE.B  -554(A5),D0
    TST.B   D0
    BEQ.S   .LAB_0248

    PEA     LAB_2158
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.LAB_0248:
    PEA     -554(A5)
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.W   -40(A5),D0
    BNE.W   .LAB_025A

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0249

    MOVEQ   #0,D0
    MOVE.B  LAB_2374,D0
    BRA.S   .LAB_024A

.LAB_0249:
    MOVEQ   #0,D0
    MOVE.B  LAB_2378,D0

.LAB_024A:
    TST.L   D0
    BEQ.S   .LAB_024F

    LEA     GLOB_STR_ALIGNED_NOW_SHOWING,A0
    LEA     LAB_2366,A1

.LAB_024B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_024B

    MOVE.B  LAB_2377,D0
    CMP.B   D1,D0
    BNE.S   .LAB_024C

    MOVEQ   #0,D0
    MOVE.B  LAB_2375,D0
    BRA.S   .LAB_024D

.LAB_024C:
    MOVEQ   #0,D0
    MOVE.B  LAB_2379,D0

.LAB_024D:
    TST.L   D0
    BEQ.W   .LAB_0259

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     GLOB_STR_ALIGNED_NEXT_SHOWING,A0
    LEA     LAB_2366,A1

.LAB_024E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_024E

    MOVE.W  -36(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     -834(A5)
    JSR     LAB_0269(PC)

    PEA     -834(A5)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     20(A7),A7
    BRA.W   .LAB_0259

.LAB_024F:
    MOVE.W  -36(A5),D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .LAB_0250

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    BRA.S   .LAB_0251

.LAB_0250:
    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1

.LAB_0251:
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
    BEQ.S   .LAB_0253

    LEA     GLOB_STR_ALIGNED_TOMORROW_AT,A0
    LEA     LAB_2366,A1

.LAB_0252:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0252

    BRA.S   .LAB_0258

.LAB_0253:
    MOVE.W  -26(A5),D0
    MOVEQ   #17,D1
    CMP.W   D1,D0
    BLT.S   .LAB_0254

    CMP.W   D1,D0
    BNE.S   .LAB_0256

    MOVE.W  -24(A5),D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   .LAB_0256

.LAB_0254:
    LEA     GLOB_STR_ALIGNED_TODAY_AT,A0
    LEA     LAB_2366,A1

.LAB_0255:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0255

    BRA.S   .LAB_0258

.LAB_0256:
    LEA     GLOB_STR_ALIGNED_TONIGHT_AT,A0
    LEA     LAB_2366,A1

.LAB_0257:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0257

.LAB_0258:
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

.LAB_0259:
    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_025E

.LAB_025A:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .LAB_025E

    MOVE.W  -38(A5),D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   .LAB_025B

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   .LAB_025C

.LAB_025B:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   .LAB_025E

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   .LAB_025E

.LAB_025C:
    LEA     LAB_2157,A0
    LEA     LAB_2366,A1

.LAB_025D:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_025D

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

.LAB_025E:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .LAB_025F

    MOVE.W  -38(A5),D0
    MOVEQ   #70,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_025F

    MOVEQ   #71,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_025F

    MOVEQ   #78,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_025F

    MOVEQ   #79,D1
    CMP.W   D1,D0
    BNE.S   .LAB_0262

.LAB_025F:
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
    BNE.S   .LAB_0260

    MOVEQ   #1,D3
    BRA.S   .LAB_0261

.LAB_0260:
    MOVEQ   #0,D3

.LAB_0261:
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
    JSR     LAB_0281(PC)

    LEA     24(A7),A7
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .LAB_0262

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.LAB_0262:
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
    BPL.S   .LAB_0263

    ADDQ.L  #1,D1

.LAB_0263:
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

    JSR     LAB_0057(PC)

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

.return:
    MOVEM.L -868(A5),D2-D7/A2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0265:
    JMP     LAB_183E

LAB_0266:
    JMP     LAB_14B1

LAB_0267:
    JMP     LAB_0668

LAB_0268:
    JMP     LAB_16E3

LAB_0269:
    JMP     LAB_16ED

LAB_026A:
    JMP     LAB_0A48

LAB_026B:
    JMP     LAB_16D3

LAB_026C:
    JMP     LAB_1ADA

LAB_026D:
    JMP     LAB_0A49

LAB_026E:
    JMP     LAB_17A8

LAB_026F:
    JMP     LAB_16D9

LAB_0270:
    JMP     LAB_16CE

LAB_0271:
    JMP     LAB_1755

LAB_0272:
    JMP     LAB_183D

LAB_0273:
    JMP     LAB_09C2

LAB_0274:
    JMP     LAB_0665

LAB_0275:
    JMP     LAB_064E

LAB_0276:
    JMP     LAB_183B

;!======

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
    BEQ.S   LAB_0278

    TST.L   D6
    BMI.S   LAB_0278

    MOVEQ   #5,D1
    CMP.L   D1,D6
    BGT.S   LAB_0278

    MOVEQ   #89,D0
    MOVEA.L -4(A5),A0
    CMP.B   0(A0,D6.L),D0
    BNE.S   LAB_0278

    BTST    #1,40(A3)
    BEQ.S   LAB_0278

    MOVEQ   #1,D0
    BRA.S   LAB_0279

LAB_0278:
    MOVEQ   #0,D0

LAB_0279:
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

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
    BNE.S   LAB_027C

    LEA     LAB_1B61,A0
    LEA     -15(A5),A1

LAB_027B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_027B

    LEA     -15(A5),A0
    MOVE.L  A0,-4(A5)

LAB_027C:
    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_027D

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_027E

LAB_027D:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_027E:
    MOVE.B  D1,LAB_21B1
    MOVEA.L -4(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_027F

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_0280

LAB_027F:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_0280:
    MOVE.B  D1,LAB_21B2
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

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
    BEQ.S   LAB_0282

    MOVEQ   #1,D1
    BRA.S   LAB_0283

LAB_0282:
    MOVEQ   #2,D1

LAB_0283:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_037F(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  24(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   LAB_0277

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_0284

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-28(A5)

LAB_0284:
    TST.L   -28(A5)
    BEQ.W   LAB_028D

    PEA     20.W
    MOVE.L  -28(A5),-(A7)
    PEA     19.W
    PEA     LAB_1B62
    PEA     -12(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     20(A7),A7
    TST.L   28(A5)
    BEQ.S   LAB_0285

    PEA     LAB_2157
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0286

LAB_0285:
    PEA     LAB_1B63
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

LAB_0286:
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
    BNE.S   LAB_0288

    LEA     LAB_1B64,A0
    LEA     -23(A5),A1

LAB_0287:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0287

    LEA     -23(A5),A0
    MOVE.L  A0,-32(A5)

LAB_0288:
    MOVEA.L -32(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_0289

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_028A

LAB_0289:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_028A:
    MOVE.B  D1,LAB_21B3
    MOVEA.L -32(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_028B

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_028C

LAB_028B:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_028C:
    MOVE.B  D1,LAB_21B4
    MOVE.B  #$1,LAB_1B5D
    BRA.S   LAB_028E

LAB_028D:
    CLR.B   LAB_1B5D

LAB_028E:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

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

LAB_0290:
    LINK.W  A5,#-32
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   16(A5)
    BEQ.W   LAB_02A3

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.W   LAB_02A3

    PEA     58.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-26(A5)
    TST.L   D0
    BEQ.W   LAB_02A3

    LEA     LAB_1B65,A0
    LEA     -22(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)+
    CLR.B   (A1)
    LEA     LAB_1B66,A0
    LEA     -11(A5),A1

LAB_0291:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0291

    MOVEQ   #0,D7

LAB_0292:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   LAB_0293

    MOVEQ   #58,D0
    MOVEA.L 16(A5),A0
    CMP.B   0(A0,D7.L),D0
    BEQ.S   LAB_0293

    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   LAB_0292

LAB_0293:
    CLR.B   -11(A5,D7.L)
    MOVE.L  (A3),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A3)
    LEA     LAB_1B67,A0
    LEA     -11(A5),A1

LAB_0294:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0294

    ADDQ.L  #1,-26(A5)
    MOVEQ   #0,D7

LAB_0295:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.W   LAB_02A2

    MOVEA.L -26(A5),A0
    TST.B   0(A0,D7.L)
    BEQ.W   LAB_02A2

    MOVE.L  D7,D0
    CMPI.L  #$9,D0
    BCC.W   LAB_02A1

    ADD.W   D0,D0
    MOVE.W  LAB_0296(PC,D0.W),D0
    JMP     LAB_0296+2(PC,D0.W)

LAB_0296:
    ORI.B   #$10,(A0)
    ORI.B   #$10,(A0)
    ORI.B   #$10,(A0)
    ORI.W   #$70,-94(A0,D0.W)
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B68
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_029A

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_0298

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0299

LAB_0298:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0299:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.W   LAB_02A1

LAB_029A:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   LAB_02A1

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_029B

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    BRA.W   LAB_02A1

LAB_029B:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   LAB_02A1

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
    BEQ.S   LAB_02A0

    MOVE.B  1(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   LAB_02A0

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    BTST    #1,(A6)
    BEQ.S   LAB_029C

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_029D

LAB_029C:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_029D:
    MOVE.B  D0,-11(A5,D7.L)
    ADDQ.L  #1,D7
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_029E

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_029F

LAB_029E:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_029F:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.S   LAB_02A1

LAB_02A0:
    LEA     -11(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D7,A1
    MOVEA.L D7,A6
    ADDQ.L  #1,D7
    MOVE.L  A6,D0
    MOVE.B  -22(A5,D0.L),(A1)
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)

LAB_02A1:
    ADDQ.L  #1,D7
    BRA.W   LAB_0295

LAB_02A2:
    MOVE.L  (A2),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A2)
    BRA.S   LAB_02A4

LAB_02A3:
    MOVE.L  (A3),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,(A3)
    MOVE.L  (A2),(A7)
    PEA     LAB_1B69
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  D0,(A2)

LAB_02A4:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

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

LAB_02A6:
    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.S   LAB_02A7

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),-52(A5,D1.L)
    ADDQ.W  #1,-32(A5)
    BRA.S   LAB_02A6

LAB_02A7:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    ADDQ.L  #1,-66(A5)
    MOVE.B  LAB_222D,D1
    MOVE.B  D0,-57(A5)
    CMP.B   D0,D1
    BNE.S   LAB_02A8

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_02A8

    MOVE.W  LAB_222F,D5
    MOVE.B  D0,LAB_1B92
    MOVEQ   #1,D1
    MOVE.B  D1,LAB_1B90
    BRA.S   LAB_02AA

LAB_02A8:
    MOVE.B  LAB_2230,D1
    CMP.B   D0,D1
    BNE.S   LAB_02A9

    MOVE.W  LAB_2231,D5
    MOVE.B  D0,LAB_1B91
    MOVE.B  #$1,LAB_1B8F
    BRA.S   LAB_02AA

LAB_02A9:
    MOVEQ   #1,D0
    BRA.W   LAB_02CD

LAB_02AA:
    MOVEQ   #49,D0
    MOVE.L  -66(A5),D1
    CMP.B   0(A3,D1.L),D0
    BNE.S   LAB_02AB

    ADDQ.L  #1,-66(A5)

LAB_02AB:
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_02DC

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

LAB_02AC:
    CMP.W   D5,D7
    BGE.S   LAB_02B0

    CMPI.W  #10,-32(A5)
    BGE.S   LAB_02B0

    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   LAB_02AD

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_02AD

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   LAB_02AE

LAB_02AD:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

LAB_02AE:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_00BE(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_02AF

    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVE.W  D7,-52(A5,D0.L)
    ADDQ.W  #1,-32(A5)

LAB_02AF:
    ADDQ.W  #1,D7
    BRA.S   LAB_02AC

LAB_02B0:
    MOVE.W  -52(A5),D0
    ADDQ.W  #1,D0
    BNE.S   LAB_02B1

    MOVEQ   #2,D0
    BRA.W   LAB_02CD

LAB_02B1:
    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   LAB_02B2

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_02B2

    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   LAB_02B3

LAB_02B2:
    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

LAB_02B3:
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
    BEQ.S   LAB_02B4

    LEA     24(A0),A2
    LEA     28(A0),A6
    MOVE.L  A1,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0290

    LEA     12(A7),A7
    BRA.S   LAB_02B5

LAB_02B4:
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

LAB_02B5:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -86(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_02B6

    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   LAB_02B7

LAB_02B6:
    MOVEQ   #-1,D0
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)

LAB_02B7:
    MOVE.W  -74(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    TST.L   16(A0)
    BEQ.S   LAB_02B9

    MOVEA.L -12(A5),A1
    MOVEA.L 16(A1),A0

LAB_02B8:
    TST.B   (A0)+
    BNE.S   LAB_02B8

    SUBQ.L  #1,A0
    SUBA.L  16(A1),A0
    MOVE.L  A0,D0
    ADD.L   D0,-66(A5)

LAB_02B9:
    ADDQ.L  #1,-66(A5)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0316

    ADDQ.W  #4,A7
    MOVEQ   #0,D6

LAB_02BA:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D6
    BGE.W   LAB_02C7

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
    BNE.S   LAB_02BB

    MOVEA.L -12(A5),A1
    MOVEA.L 12(A1),A0
    BRA.S   LAB_02BC

LAB_02BB:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -112(A5),A0

LAB_02BC:
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
    BNE.S   LAB_02BD

    MOVEA.L -12(A5),A2
    MOVEA.L 20(A2),A1
    BRA.S   LAB_02BE

LAB_02BD:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -110(A5),A1

LAB_02BE:
    MOVE.L  14(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.W  -108(A5),D0
    ADDQ.W  #1,D0
    BNE.S   LAB_02BF

    MOVEA.L -12(A5),A2
    MOVEA.L 8(A2),A1
    BRA.S   LAB_02C0

LAB_02BF:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -108(A5),A1

LAB_02C0:
    MOVE.L  2(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -106(A5),D0
    ADDQ.W  #1,D0
    BNE.S   LAB_02C1

    MOVEA.L -12(A5),A2
    MOVEA.L 16(A2),A1
    BRA.S   LAB_02C2

LAB_02C1:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -106(A5),A1

LAB_02C2:
    MOVE.L  10(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.W  -116(A5),D0
    ADDQ.W  #1,D0
    BNE.S   LAB_02C3

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
    BRA.S   LAB_02C4

LAB_02C3:
    LEA     18(A0),A1
    LEA     22(A0),A2
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -116(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0290

    LEA     12(A7),A7

LAB_02C4:
    MOVE.W  -114(A5),D0
    ADDQ.W  #1,D0
    BNE.S   LAB_02C5

    MOVEA.L -12(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),26(A1)
    BRA.S   LAB_02C6

LAB_02C5:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -114(A5),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,26(A0)

LAB_02C6:
    MOVE.W  -104(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    ADDQ.W  #1,D6
    BRA.W   LAB_02BA

LAB_02C7:
    MOVE.W  #1,-32(A5)

LAB_02C8:
    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -52(A5,D0.L),D1
    BEQ.W   LAB_02CC

    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.W   LAB_02CC

    MOVE.B  LAB_222D,D1
    MOVE.B  -57(A5),D2
    CMP.B   D1,D2
    BNE.S   LAB_02C9

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_02C9

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2235,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   LAB_02CA

LAB_02C9:
    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2233,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)

LAB_02CA:
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
    BSR.W   LAB_0316

    LEA     32(A7),A7
    MOVEQ   #0,D7

LAB_02CB:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D7
    BGE.W   LAB_02C8

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
    BRA.W   LAB_02CB

LAB_02CC:
    MOVEQ   #0,D0

LAB_02CD:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS
