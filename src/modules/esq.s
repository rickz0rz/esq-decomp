;!======

; there's a lot going on here so i'm wondering if this
; is the main initialization + run loop?
LAB_085E:
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BLT.S   .clearSelectCodeByte

    MOVEA.L 4(A3),A0
    LEA     GLOB_PTR_STR_SELECT_CODE,A1

.loopWhileA0IsNotNull:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loopWhileA0IsNotNull

    BRA.S   .LAB_0861

.clearSelectCodeByte:
    CLR.B   GLOB_PTR_STR_SELECT_CODE

.LAB_0861:
    LEA     GLOB_PTR_STR_SELECT_CODE,A0
    LEA     GLOB_STR_RAVESC,A1

.testSelectCodeForRAVESC:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .clear_GLOB_WORD_SELECT_CODE_IS_RAVESC

    TST.B   D0
    BNE.S   .testSelectCodeForRAVESC

    BNE.S   .clear_GLOB_WORD_SELECT_CODE_IS_RAVESC

    MOVE.W  #1,GLOB_WORD_SELECT_CODE_IS_RAVESC
    BRA.S   .runStartupSequence

.clear_GLOB_WORD_SELECT_CODE_IS_RAVESC:
    CLR.W   GLOB_WORD_SELECT_CODE_IS_RAVESC

.runStartupSequence:
    LEA     GLOB_STR_COPY_NIL_ASSIGN_RAM,A0
    MOVE.L  A0,D1       ; command string
    MOVEQ   #0,D2       ; input
    MOVE.L  D2,D3       ; output
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    SUBA.L  A1,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,LAB_222C
    MOVEA.L D0,A0
    MOVE.L  184(A0),LAB_1DC7
    MOVEQ   #-1,D0
    MOVE.L  D0,184(A0)
    MOVE.L  D2,D0

    LEA     GLOB_STR_GRAPHICS_LIBRARY,A1
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_GRAPHICS_LIBRARY
    TST.L   D0
    BNE.S   .loadDiskfontLibrary

    MOVE.L  D2,-(A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_2(PC)

    ADDQ.W  #4,A7

.loadDiskfontLibrary:
    LEA     GLOB_STR_DISKFONT_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_DISKFONT_LIBRARY
    BNE.S   .loadDosLibrary

    CLR.L   -(A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_2(PC)

    ADDQ.W  #4,A7

.loadDosLibrary:
    LEA     GLOB_STR_DOS_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_DOS_LIBRARY
    BNE.S   .loadIntuitionLibrary

    CLR.L   -(A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_2(PC)

    ADDQ.W  #4,A7

.loadIntuitionLibrary:
    LEA     GLOB_STR_INTUITION_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_INTUITION_LIBRARY
    BNE.S   .loadUtilityLibraryAndBattclockResource

    CLR.L   -(A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_2(PC)

    ADDQ.W  #4,A7

.loadUtilityLibraryAndBattclockResource:
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0   ; Read address 20 in the library struct for Graphics.Library which is the lib_Version
    MOVEQ   #37,D1      ; Compare it to 37 ...
    CMP.W   D1,D0       ; CMP.W -> subtract D1 from D0 and store CCR conditions
    BCS.S   .loadFonts  ; If carry is set post comparison, jump to .loadFonts

    LEA     GLOB_STR_UTILITY_LIBRARY,A1

    ; Open the "utility.library" library, version 37
    MOVEQ   #37,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_UTILITY_LIBRARY

    ; If we couldn't load the utility.library jump
    BEQ.S   .unableToLoadUtilityLibrary

    ; Open the "battclock.resource" resource
    LEA     GLOB_STR_BATTCLOCK_RESOURCE,A1
    JSR     _LVOOpenResource(A6)

    MOVE.L  D0,GLOB_REF_BATTCLOCK_RESOURCE

.unableToLoadUtilityLibrary:
    MOVEQ   #2,D0
    MOVE.L  D0,GLOB_LONG_ROM_VERSION_CHECK

.loadFonts:
    JSR     JMP_TBL_OVERRIDE_INTUITION_FUNCS(PC)

    ; Open the "topaz.font" file.
    LEA     GLOB_STRUCT_TEXTATTR_TOPAZ_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOOpenFont(A6)

    MOVE.L  D0,GLOB_HANDLE_TOPAZ_FONT
    ; If we couldn't open the font, jump
    TST.L   D0
    BEQ.W   .return

    ; Open the "PrevueC.font" file.
    LEA     GLOB_STRUCT_TEXTATTR_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_DISKFONT_LIBRARY,A6

    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,GLOB_HANDLE_PREVUEC_FONT
    ; If we opened the font, jump.
    TST.L   D0
    BNE.S   .openH26fFont

    ; Fallback to the topaz font.
    MOVE.L  GLOB_HANDLE_TOPAZ_FONT,GLOB_HANDLE_PREVUEC_FONT

.openH26fFont:
    ; Open the "h26f.font" file.
    LEA     GLOB_STRUCT_TEXTATTR_H26F_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,GLOB_HANDLE_H26F_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .openPrevueFont

    ; Fallback to the topaz font.
    MOVE.L  GLOB_HANDLE_TOPAZ_FONT,GLOB_HANDLE_H26F_FONT

.openPrevueFont:
    ; Open the "Prevue.font" file.
    LEA     GLOB_STRUCT_TEXTATTR_PREVUE_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,GLOB_HANDLE_PREVUE_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .loadedFonts

    ; Fall back to the topaz font.
    MOVE.L  GLOB_HANDLE_TOPAZ_FONT,GLOB_HANDLE_PREVUE_FONT

.loadedFonts:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     623.W
    PEA     GLOB_STR_ESQ_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_RASTPORT_1  ; D0 is the allocated memory, storing its reference in GLOB_REF_RASTPORT_1
    MOVEA.L D0,A1                   ; Store the address of D0 into A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)    ; In the memory we have, initialize a RastPort struct

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)  ; #GLOB_REF_696_400_BITMAP into address of the rastport #1 bitmap

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #68,D0
    MOVE.W  D0,LAB_222B
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_2(PC)

    TST.L   D1
    BEQ.S   .LAB_086E

    MOVE.W  LAB_222B,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_222B

.LAB_086E:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     645.W
    PEA     GLOB_STR_ESQ_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_RASTPORT_2
    MOVEA.L D0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L GLOB_REF_RASTPORT_2,A0
    MOVE.L  #GLOB_REF_320_240_BITMAP,4(A0)      ; #GLOB_REF_320_240_BITMAP into GLOB_REF_RASTPORT_2.BitMap

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D5

.LAB_086F:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0870

    MOVE.L  D5,D0
    MULS    #40,D0
    LEA     LAB_22A7,A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_08BB(PC)

    ADDQ.W  #4,A7
    ADDQ.W  #1,D5
    BRA.S   .LAB_086F

.LAB_0870:
    LEA     GLOB_REF_320_240_BITMAP,A0     ; BitMap struct pointer
    MOVEQ   #4,D0           ; depth: 4 bitplanes or 16 colors (2 ^ 4) into D0
    MOVE.L  #352,D1         ; width: 352 into D1
    MOVEQ   #120,D2         ; height: 120 into D2
    ADD.L   D2,D2           ; ...becomes 240 into D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.LAB_0871:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0872

    MOVE.L  D5,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_221A,A0
    ADDA.L  D1,A0

    PEA     240.W                       ; Height
    PEA     352.W                       ; Width
    PEA     668.W                       ; Line Number
    PEA     GLOB_STR_ESQ_C_3            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     JMP_TBL_ALLOC_RASTER_2(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_221A,A0
    ADDA.L  D0,A0

    MOVEA.L (A0),A1         ; memBlock
    MOVE.L  #10560,D0       ; byte count
    MOVEQ   #0,D1           ; flags
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .LAB_0871

.LAB_0872:
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .use12HourClock

    LEA     GLOB_JMP_TBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .LAB_0874

.use12HourClock:
    LEA     GLOB_JMP_TBL_HALF_HOURS_12_HR_FMT,A0

.LAB_0874:
    MOVE.L  A0,GLOB_REF_STR_CLOCK_FORMAT

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     34.W
    PEA     683.W
    PEA     GLOB_STR_ESQ_C_4
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_1DC5
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L LAB_1DC5,A0
    CLR.B   9(A0)
    MOVEA.L LAB_1DC5,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L LAB_1DC5,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L LAB_1DC5,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_08B0(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     34.W
    PEA     698.W
    PEA     GLOB_STR_ESQ_C_5
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_1DC6
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L LAB_1DC6,A0
    CLR.B   9(A0)
    MOVEA.L LAB_1DC6,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L LAB_1DC6,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L LAB_1DC6,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_08B0(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.LAB_0875:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0876

    MOVE.L  D5,D0
    MULS    #$a0,D0
    LEA     LAB_22A6,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    MULS    #$28,D0
    LEA     LAB_22A7,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_08C1(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D5
    BRA.S   .LAB_0875

.LAB_0876:
    JSR     LAB_08B8(PC)

    CLR.W   LAB_222A
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0
    MOVEQ   #34,D1
    CMP.W   D1,D0
    BCS.S   .LAB_0877

    MOVE.W  #1,LAB_222A

.LAB_0877:
    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #1750000,D0
    BLE.S   .LAB_0878

    MOVE.W  #2,LAB_222A

.LAB_0878:
    JSR     LAB_08AC(PC)

    TST.L   D0
    BNE.W   .return

    JSR     JMP_TBL_CHECK_AVAILABLE_FAST_MEMORY(PC)

    JSR     JMP_TBL_CHECK_IF_COMPATIBLE_VIDEO_CHIP(PC)

    JSR     LAB_08A1(PC)

    MOVE.L  #LAB_223A,LAB_1B06
    MOVE.L  #LAB_2274,LAB_1B07
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2241
    MOVE.W  D0,LAB_227B
    JSR     LAB_089E(PC)

    JSR     DST_RefreshBannerBuffer(PC)

    CLR.W   LAB_2294
    MOVEQ   #1,D5

.LAB_0879:
    MOVE.L  D5,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .LAB_087C

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 0(A3,D0.L),A0
    LEA     GLOB_STR_CART,A1

.LAB_087A:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .LAB_087B

    TST.B   D1
    BNE.S   .LAB_087A

    BNE.S   .LAB_087B

    MOVE.W  #1,LAB_2294

; it looks like this tests a value to determine if we can spin up
; to a specific baud rate or if we should just jump down to 2400.
.LAB_087B:
    ADDQ.W  #1,D5
    BRA.S   .LAB_0879

.LAB_087C:
    MOVEQ   #2,D0
    CMP.L   D0,D7

    BLE.S   .setBaudRateTo2400

    MOVE.L  8(A3),-(A7)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_BAUD_RATE
    CMPI.L  #2400,D0
    BEQ.S   .LAB_087E

    CMPI.L  #4800,D0
    BEQ.S   .LAB_087E

    CMPI.L  #9600,D0
    BEQ.S   .LAB_087E

    MOVE.L  #2400,D0
    MOVE.L  D0,GLOB_REF_BAUD_RATE
    BRA.S   .LAB_087E

.setBaudRateTo2400:
    MOVE.L  #2400,GLOB_REF_BAUD_RATE

.LAB_087E:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; flags
    PEA     9000.W                              ; 9000 bytes
    PEA     854.W                               ; line number?
    PEA     GLOB_STR_ESQ_C_6
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    MOVE.L  D0,LAB_229A
    CLR.L   (A7)
    PEA     GLOB_STR_SERIAL_READ
    JSR     JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_2(PC)

    LEA     20(A7),A7
    MOVE.L  D0,LAB_2212
    BEQ.W   .return

    PEA     82.W
    MOVE.L  D0,-(A7)
    JSR     LAB_08A9(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2211_SERIAL_PORT_MAYBE
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A1                       ; ioRequest
    LEA     GLOB_STR_SERIAL_DEVICE,A0   ; devName
    MOVEQ   #0,D0                       ; unit number
    MOVE.L  D0,D1                       ; flags
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6                       ; Copy D0 into D6
    TST.L   D6                          ; Test D6 to see if it's 0 (failed)
    BNE.W   .return                     ; Branch if unable to open serial device

    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A0
    MOVE.B  #16,79(A0)
    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A0
    MOVE.L  GLOB_REF_BAUD_RATE,60(A0)
    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A0
    MOVE.W  #11,28(A0)
    MOVEA.L LAB_2211_SERIAL_PORT_MAYBE,A1
    JSR     _LVODoIO(A6)

    JSR     SETUP_INTERRUPT_INTB_RBF(PC)

    JSR     SETUP_INTERRUPT_INTB_AUD1(PC)

    JSR     LAB_08AF(PC)

    JSR     LAB_089F(PC)

    JSR     LAB_08A6(PC)

    JSR     LAB_0963(PC)

    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     96.W                            ; Bytes to Allocate
    PEA     984.W                           ; Line Number
    PEA     GLOB_STR_ESQ_C_7                ; Calling File
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_96_BYTES_ALLOCATED                     ; whatever was allocated above

    LEA     GLOB_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0       ; 3 bitplanes
    MOVE.L  #696,D1     ; 696 w
    MOVE.L  #400,D2     ; 400 h
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    LEA     GLOB_REF_696_241_BITMAP,A0
    MOVEQ   #4,D0       ; 4 bitplanes
    MOVE.L  #696,D1     ; 696 w
    MOVEQ   #14,D2      ; 14 h
    NOT.B   D2          ; Flip last byte of D2 means D2 is now 241 h
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.LAB_087F:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0880

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_221C,A0
    ADDA.L  D0,A0

    PEA     509.W                       ; Height
    PEA     696.W                       ; Width
    PEA     991.W                       ; Line Number
    PEA     GLOB_STR_ESQ_C_8            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     JMP_TBL_ALLOC_RASTER_2(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_221C,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$aef8,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .LAB_087F

.LAB_0880:
    MOVE.L  LAB_221C,LAB_2267
    MOVE.L  LAB_221D,LAB_2268
    MOVE.L  LAB_221E,LAB_2269
    MOVEQ   #0,D5

.LAB_0881:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0882

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2224,A0
    ADDA.L  D0,A0
    LEA     LAB_221C,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.W  #$5c20,A2
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D5
    BRA.S   .LAB_0881

.LAB_0882:
    MOVEQ   #3,D5

.LAB_0883:
    MOVEQ   #5,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0884

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2224,A0
    ADDA.L  D0,A0

    PEA     241.W                       ; Height
    PEA     696.W                       ; Width
    PEA     1008.W                      ; Line Number
    PEA     GLOB_STR_ESQ_C_9            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     JMP_TBL_ALLOC_RASTER_2(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2224,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$52d8,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .LAB_0883

.LAB_0884:
    MOVE.L  LAB_2224,LAB_220A
    MOVE.L  LAB_2225,LAB_220B
    MOVE.L  LAB_2226,LAB_220C
    MOVE.L  LAB_2227,LAB_220D
    MOVE.L  LAB_2228,LAB_220E
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  52(A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    PEA     3.W
    CLR.L   -(A7)
    PEA     2.W
    JSR     LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    LEA     LAB_221F,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEQ   #2,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.LAB_0885:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .LAB_0886

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2220,A0
    ADDA.L  D0,A0

    PEA     2.W                         ; Height
    PEA     696.W                       ; Width
    PEA     1027.W                      ; Line Number
    PEA     GLOB_STR_ESQ_C_10           ; Calling file
    MOVE.L  A0,44(A7)
    JSR     JMP_TBL_ALLOC_RASTER_2(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0

    LEA     LAB_2220,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .LAB_0885

.LAB_0886:
    MOVE.L  LAB_2220,LAB_2207
    MOVE.L  LAB_2221,LAB_2208
    MOVE.L  LAB_2222,LAB_2209

    PEA     15.W                        ; Height
    PEA     696.W                       ; Width
    PEA     1038.W                      ; Line Number
    PEA     GLOB_STR_ESQ_C_11           ; Calling file
    JSR     JMP_TBL_ALLOC_RASTER_2(PC)

    MOVE.L  D0,LAB_2229
    CLR.W   LAB_22AB
    CLR.L   LAB_225F
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_2260
    JSR     LAB_08A4(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .LAB_0887

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_098A(PC)

    ADDQ.W  #8,A7

.LAB_0887:
    JSR     LAB_0C7A(PC)

    JSR     LAB_08AB(PC)

    JSR     SETUP_INTERRUPT_INTB_VERTB(PC)

    ; This is just clearing out a BUNCH of variables to zero or whatever
    ; default value it uses.
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2263
    MOVE.W  D0,LAB_2203
    MOVE.W  D0,LAB_224E
    MOVE.W  D0,LAB_2248
    MOVE.W  D0,LAB_2205
    MOVE.W  D0,LAB_2271
    MOVE.W  D0,LAB_2285
    MOVE.W  D0,LAB_2347
    MOVE.W  D0,LAB_222F
    MOVE.W  D0,LAB_2231
    MOVE.W  D0,LAB_22AD
    MOVE.W  D0,LAB_22AC
    MOVE.W  D0,LAB_2299
    MOVE.W  D0,LAB_224B
    MOVE.W  D0,LAB_228C
    MOVE.W  D0,GLOB_WORD_MAX_VALUE
    MOVE.W  D0,GLOB_WORD_T_VALUE
    MOVE.W  D0,GLOB_WORD_H_VALUE
    MOVE.W  D0,LAB_2264
    MOVE.W  D0,LAB_2284
    MOVE.W  D0,LAB_2283
    MOVE.W  D0,LAB_2282
    MOVE.W  D0,CTRL_H
    MOVE.W  D0,LAB_228A
    MOVE.W  D0,DATACErrs
    MOVE.W  D0,LAB_2348
    MOVE.W  D0,LAB_2287
    MOVE.W  D0,LAB_2349
    MOVE.W  D0,LAB_229F
    MOVE.W  D0,LAB_229E
    MOVE.W  D0,LAB_225C
    MOVE.W  D0,LAB_22A0
    MOVE.W  D0,LAB_22A1
    MOVEQ   #0,D1
    MOVE.B  D1,LAB_2206
    MOVE.B  D1,LAB_224D
    MOVE.B  D1,LAB_2247
    MOVE.B  D1,LAB_222E
    MOVE.B  D1,LAB_2230
    MOVE.B  #$1,LAB_222D
    MOVE.W  #7,LAB_225E
    MOVE.W  #2,LAB_2270
    MOVE.W  D0,CTRLRead1
    MOVE.W  D0,LAB_2266
    MOVE.W  #$ff,CTRLRead2
    JSR     LAB_0A45(PC)

    JSR     LAB_0A49(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rect from 0,0 to 695,399
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_241_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1

    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rectangle from 0,0 to 120,120
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #120,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     LAB_2249
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    JSR     LAB_09A9(PC)

    LEA     12(A7),A7
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   LAB_2319,D0
    BNE.S   .LAB_0888

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     LAB_1E0F
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

; Fill out "Ver %s.%ld Build %ld %s"
.LAB_0888:
    MOVE.L  GLOB_PTR_STR_BUILD_ID,-(A7)             ; JGT
    MOVE.L  GLOB_LONG_BUILD_NUMBER,-(A7)            ; 21
    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)    ; 4
    PEA     GLOB_STR_MAJOR_MINOR_VERSION            ; 9.0
    PEA     GLOB_STR_GUIDE_START_VERSION_AND_BUILD
    PEA     LAB_2204
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     LAB_1E12,A0
    LEA     LAB_2249,A1
    MOVEQ   #9,D0

.LAB_0889:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_0889

    JSR     LAB_08AD(PC)

    JSR     LAB_08B3(PC)

    PEA     GLOB_STR_DF0_GRADIENT_INI_2
    JSR     JMP_TBL_PARSE_INI(PC)

    JSR     LAB_08AA(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     60.W
    PEA     GLOB_PTR_STR_SELECT_CODE
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     90.W
    PEA     LAB_2204
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     120.W
    PEA     LAB_1E14
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     LAB_1E15
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     76(A7),A7
    TST.W   IS_COMPATIBLE_VIDEO_CHIP
    BNE.S   .LAB_088A

    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.W   .LAB_0890

.LAB_088A:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     180.W
    PEA     LAB_1E16
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .LAB_088B

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     LAB_1E17
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.LAB_088B:
    TST.W   IS_COMPATIBLE_VIDEO_CHIP
    BEQ.S   .LAB_088E

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .LAB_088C

    MOVEQ   #120,D0
    ADD.L   D0,D0
    BRA.S   .LAB_088D

.LAB_088C:
    MOVEQ   #105,D0
    ADD.L   D0,D0

.LAB_088D:
    MOVE.L  D0,-(A7)
    PEA     LAB_1E18
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.LAB_088E:
    JSR     LAB_0A48(PC)

.LAB_088F:
    BRA.S   .LAB_088F

.LAB_0890:
    JSR     LAB_0A48(PC)

    JSR     LAB_08BA(PC)

    JSR     LAB_089D(PC)

    JSR     LAB_0539(PC)

    JSR     LAB_08A0(PC)

    JSR     LAB_08A5(PC)

    PEA     GLOB_STR_DF0_DEFAULT_INI_1
    JSR     JMP_TBL_PARSE_INI(PC)

    PEA     GLOB_STR_DF0_BRUSH_INI_1
    JSR     JMP_TBL_PARSE_INI(PC)

    PEA     LAB_1ED1
    MOVE.L  LAB_1B1F,-(A7)
    JSR     LAB_0AAA(PC)

    PEA     LAB_1E1B
    JSR     LAB_0AB5(PC)

    LEA     20(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .LAB_0891

    PEA     LAB_1ED1
    PEA     LAB_1E1C
    JSR     LAB_0AA3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.LAB_0891:
    PEA     LAB_1ED1
    JSR     LAB_0AA5(PC)

    MOVE.L  D0,LAB_1ED0
    JSR     LAB_09DB(PC)

    PEA     GLOB_STR_DF0_BANNER_INI_1
    JSR     JMP_TBL_PARSE_INI(PC)

    JSR     LAB_08B6(PC)

    JSR     LAB_08A3(PC)

    JSR     LAB_09B7(PC)

    MOVE.W  #1,LAB_2272
    MOVE.W  LAB_226F,LAB_2257
    CLR.L   (A7)
    PEA     4095.W
    JSR     LAB_08DA(PC)

    MOVE.W  #$8100,INTENA
    JSR     LAB_08A2(PC)

    PEA     LAB_2321
    JSR     LAB_08AE(PC)

    PEA     LAB_2324
    JSR     LAB_08AE(PC)

    PEA     LAB_2324
    PEA     LAB_2321
    JSR     LAB_08B2(PC)

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_21DF
    MOVE.L  A0,LAB_21E0
    PEA     LAB_21DF
    JSR     LAB_061E(PC)

    CLR.W   LAB_234A
    JSR     LAB_0969(PC)

    LEA     32(A7),A7
    CLR.L   LAB_1E84
    MOVEQ   #1,D5

.LAB_0892:
    MOVE.L  D5,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .LAB_0895

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 0(A3,D0.L),A0
    LEA     LAB_1E1E,A1

.LAB_0893:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .LAB_0894

    TST.B   D1
    BNE.S   .LAB_0893

    BNE.S   .LAB_0894

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1E84

.LAB_0894:
    ADDQ.W  #1,D5
    BRA.S   .LAB_0892

.LAB_0895:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    ; Clear out these values
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_228C
    MOVE.W  D0,GLOB_WORD_MAX_VALUE
    MOVE.W  D0,GLOB_WORD_T_VALUE
    MOVE.W  D0,GLOB_WORD_H_VALUE
    JSR     _LVOEnable(A6)

    CLR.W   LAB_22A9
    CLR.L   -(A7)
    JSR     LAB_09A7(PC)

    JSR     LAB_08B8(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.LAB_0896:
    CMPI.W  #$12e,D5
    BGE.S   .LAB_0897

    MOVE.L  D5,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    ADDA.L  D0,A0
    CLR.W   (A0)
    ADDQ.W  #1,D5
    BRA.S   .LAB_0896

.LAB_0897:
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .LAB_0898

    JSR     LAB_08B1(PC)

    CLR.L   -(A7)
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7

.LAB_0898:
    MOVE.W  #1,LAB_1DE5

.LAB_0899:
    JSR     LAB_097E(PC)

    JSR     LAB_09B1(PC)

    TST.W   D0
    BEQ.S   .LAB_089A

    TST.W   LAB_1DE4
    BNE.S   .LAB_089A

    JSR     LAB_0B4F(PC)

.LAB_089A:
    TST.W   LAB_1DE4
    BEQ.S   .LAB_0899

.return:
    JSR     LAB_08B9(PC)

    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    DC.W    $0000

;!======

JMP_TBL_SETUP_SIGNAL_AND_MSGPORT_2:
    JMP     SETUP_SIGNAL_AND_MSGPORT

LAB_089D:
    JMP     LAB_0E14

LAB_089E:
    JMP     LAB_1470

LAB_089F:
    JMP     LAB_14E7

LAB_08A0:
    JMP     LAB_04F0

LAB_08A1:
    JMP     LAB_0017

LAB_08A2:
    JMP     LAB_1365

LAB_08A3:
    JMP     LAB_0E57

LAB_08A4:
    JMP     LAB_041D

LAB_08A5:
    JMP     LAB_1664

LAB_08A6:
    JMP     KYBD_InitializeInputDevices

JMP_TBL_CHECK_IF_COMPATIBLE_VIDEO_CHIP:
    JMP     CHECK_IF_COMPATIBLE_VIDEO_CHIP

JMP_TBL_CHECK_AVAILABLE_FAST_MEMORY:
    JMP     CHECK_AVAILABLE_FAST_MEMORY

LAB_08A9:
    JMP     LAB_1A30

LAB_08AA:
    JMP     LAB_0DE9

LAB_08AB:
    JMP     LAB_180B

LAB_08AC:
    JMP     LAB_001E

LAB_08AD:
    JMP     LAB_14E2

LAB_08AE:
    JMP     LAB_0F07

LAB_08AF:
    JMP     LAB_002F

LAB_08B0:
    JMP     LAB_1AAD

LAB_08B1:
    JMP     LAB_0057

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_08B2:
    JMP     LAB_0F5D

LAB_08B3:
    JMP     LAB_0D89

JMP_TBL_OVERRIDE_INTUITION_FUNCS:
    JMP     OVERRIDE_INTUITION_FUNCS

JMP_TBL_LIBRARIES_LOAD_FAILED_2:
    JMP     LIBRARIES_LOAD_FAILED

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_08B6:
    JMP     LAB_0CC8

JMP_TBL_PRINTF_2:
    JMP     PRINTF

LAB_08B8:
    JMP     LAB_0056

LAB_08B9:
    JMP     CLEANUP_ShutdownSystem

LAB_08BA:
    JMP     LAB_0E09

;!======

    ; ?????
    MOVEQ   #97,D0
