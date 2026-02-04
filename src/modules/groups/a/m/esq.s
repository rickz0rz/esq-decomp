;------------------------------------------------------------------------------
; FUNC: ESQ_MainInitAndRun   (MainInitAndRun??)
; ARGS:
;   stack +4: argcOrMode?? (long)
;   stack +8: argvOrConfig?? (long*)
; RET:
;   D0: status/result?? (0 on success)
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   _LVOExecute, _LVOFindTask, _LVOOpenLibrary, _LVOOpenResource,
;   JMPTBL_BUFFER_FlushAllAndCloseWithCode_2, JMPTBL_OVERRIDE_INTUITION_FUNCS,
;   _LVOOpenFont, _LVOOpenDiskFont, GROUPB_JMPTBL_MEMORY_AllocateMemory,
;   _LVOInitRastPort, _LVOSetFont, GROUPB_JMPTBL_MATH_DivS32, JMPTBL_UNKNOWN2B_AllocRaster_2,
;   _LVOBltClear, _LVOInitBitMap, JMPTBL_ESQ_CheckAvailableFastMemory,
;   JMPTBL_ESQ_CheckCompatibleVideoChip, LAB_08BB, ESQ_JMPTBL_LIST_InitHeader, LAB_08C1,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, ESQ_JMPTBL_ESQ_FormatDiskErrorMessage, ESQ_JMPTBL_LAB_0017, LAB_089E, DST_RefreshBannerBuffer,
;   LAB_0BFA, GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal, ESQ_JMPTBL_STRUCT_AllocWithOwner, _LVOOpenDevice,
;   _LVODoIO, SETUP_INTERRUPT_INTB_RBF, SETUP_INTERRUPT_INTB_AUD1,
;   ESQ_JMPTBL_ESQ_InitAudio1Dma, ESQ_JMPTBL_SCRIPT_InitCtrlContext, ESQ_JMPTBL_KYBD_InitializeInputDevices, LAB_0963, ESQ_JMPTBL_LAB_041D, LAB_098A, LAB_0C7A,
;   ESQ_JMPTBL_LAB_180B, SETUP_INTERRUPT_INTB_VERTB, LAB_0A45, LAB_0A49, _LVOSetAPen,
;   _LVORectFill, _LVOSetBPen, _LVOSetDrMd, LAB_09AD, LAB_09A9,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, ESQ_JMPTBL_LAB_14E2, ESQ_JMPTBL_LAB_0D89, GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, ESQ_JMPTBL_LAB_0DE9
; READS:
;   GLOB_REF_DOS_LIBRARY_2, AbsExecBase, GLOB_STR_GRAPHICS_LIBRARY,
;   GLOB_STR_DISKFONT_LIBRARY, GLOB_STR_DOS_LIBRARY, GLOB_STR_INTUITION_LIBRARY,
;   GLOB_STR_UTILITY_LIBRARY, GLOB_STR_BATTCLOCK_RESOURCE,
;   GLOB_STRUCT_TEXTATTR_TOPAZ_FONT, GLOB_STRUCT_TEXTATTR_PREVUEC_FONT,
;   GLOB_STRUCT_TEXTATTR_H26F_FONT, GLOB_STRUCT_TEXTATTR_PREVUE_FONT,
;   GLOB_STR_RAVESC, GLOB_STR_COPY_NIL_ASSIGN_RAM, GLOB_STR_ESQ_C_1..11,
;   GLOB_STR_SERIAL_READ, GLOB_STR_SERIAL_DEVICE, GLOB_STR_DF0_GRADIENT_INI_2,
;   GLOB_STR_GUIDE_START_VERSION_AND_BUILD, GLOB_STR_MAJOR_MINOR_VERSION,
;   GLOB_PTR_STR_BUILD_ID, GLOB_LONG_BUILD_NUMBER, GLOB_LONG_PATCH_VERSION_NUMBER
; WRITES:
;   GLOB_PTR_STR_SELECT_CODE, GLOB_WORD_SELECT_CODE_IS_RAVESC,
;   GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_DISKFONT_LIBRARY, GLOB_REF_DOS_LIBRARY,
;   GLOB_REF_INTUITION_LIBRARY, GLOB_REF_UTILITY_LIBRARY, GLOB_REF_BATTCLOCK_RESOURCE,
;   GLOB_HANDLE_TOPAZ_FONT, GLOB_HANDLE_PREVUEC_FONT, GLOB_HANDLE_H26F_FONT,
;   GLOB_HANDLE_PREVUE_FONT, GLOB_REF_RASTPORT_1, GLOB_REF_RASTPORT_2,
;   GLOB_REF_STR_CLOCK_FORMAT, LAB_1DC5, LAB_1DC6, LAB_222A, LAB_222B,
;   LAB_221A/LAB_221C/LAB_2220/LAB_2224 tables, LAB_2216, LAB_2229,
;   LAB_2294, LAB_229A, LAB_2267-LAB_2269, LAB_2207-LAB_220E,
;   GLOB_REF_BAUD_RATE, LAB_2211_SERIAL_PORT_MAYBE, LAB_2212,
;   GLOB_REF_96_BYTES_ALLOCATED, numerous state globals cleared in .init_global_state
; DESC:
;   Main startup routine: loads libraries/resources, opens fonts, allocates
;   rastports/bitmaps/rasters, initializes display state, sets serial/interrupts,
;   parses INI, and seeds global state for the main loop.
; NOTES:
;   - Treats argv[1] as a select code string; detects \"RAVESC\".
;   - Falls back to topaz for missing disk fonts.
;------------------------------------------------------------------------------
ESQ_MainInitAndRun:
LAB_085E:
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BLT.S   .clear_select_code

    MOVEA.L 4(A3),A0
    LEA     GLOB_PTR_STR_SELECT_CODE,A1

.copy_select_code_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_select_code_loop

    BRA.S   .select_code_ready

.clear_select_code:
    CLR.B   GLOB_PTR_STR_SELECT_CODE

.select_code_ready:
    LEA     GLOB_PTR_STR_SELECT_CODE,A0
    LEA     GLOB_STR_RAVESC,A1

.compare_select_code_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .clear_select_code_flag

    TST.B   D0
    BNE.S   .compare_select_code_loop

    BNE.S   .clear_select_code_flag

    MOVE.W  #1,GLOB_WORD_SELECT_CODE_IS_RAVESC
    BRA.S   .runStartupSequence

.clear_select_code_flag:
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
    JSR     JMPTBL_BUFFER_FlushAllAndCloseWithCode_2(PC)

    ADDQ.W  #4,A7

.loadDiskfontLibrary:
    LEA     GLOB_STR_DISKFONT_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_DISKFONT_LIBRARY
    BNE.S   .loadDosLibrary

    CLR.L   -(A7)
    JSR     JMPTBL_BUFFER_FlushAllAndCloseWithCode_2(PC)

    ADDQ.W  #4,A7

.loadDosLibrary:
    LEA     GLOB_STR_DOS_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_DOS_LIBRARY
    BNE.S   .loadIntuitionLibrary

    CLR.L   -(A7)
    JSR     JMPTBL_BUFFER_FlushAllAndCloseWithCode_2(PC)

    ADDQ.W  #4,A7

.loadIntuitionLibrary:
    LEA     GLOB_STR_INTUITION_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,GLOB_REF_INTUITION_LIBRARY
    BNE.S   .loadUtilityLibraryAndBattclockResource

    CLR.L   -(A7)
    JSR     JMPTBL_BUFFER_FlushAllAndCloseWithCode_2(PC)

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
    JSR     JMPTBL_OVERRIDE_INTUITION_FUNCS(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .adjust_rastport_text_spacing

    MOVE.W  LAB_222B,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_222B

.adjust_rastport_text_spacing:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     645.W
    PEA     GLOB_STR_ESQ_C_2
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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

.init_rastport1_rows_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .init_bitmap_320_240

    MOVE.L  D5,D0
    MULS    #40,D0
    LEA     LAB_22A7,A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_08BB(PC)

    ADDQ.W  #4,A7
    ADDQ.W  #1,D5
    BRA.S   .init_rastport1_rows_loop

.init_bitmap_320_240:
    LEA     GLOB_REF_320_240_BITMAP,A0     ; BitMap struct pointer
    MOVEQ   #4,D0           ; depth: 4 bitplanes or 16 colors (2 ^ 4) into D0
    MOVE.L  #352,D1         ; width: 352 into D1
    MOVEQ   #120,D2         ; height: 120 into D2
    ADD.L   D2,D2           ; ...becomes 240 into D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.UNKNOWN2B_AllocRasters_352x240_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .select_clock_format_table

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
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

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
    BRA.S   .UNKNOWN2B_AllocRasters_352x240_loop

.select_clock_format_table:
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .use12HourClock

    LEA     GLOB_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .store_clock_format_table

.use12HourClock:
    LEA     GLOB_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.store_clock_format_table:
    MOVE.L  A0,GLOB_REF_STR_CLOCK_FORMAT

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     34.W
    PEA     683.W
    PEA     GLOB_STR_ESQ_C_4
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     ESQ_JMPTBL_LIST_InitHeader(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     34.W
    PEA     698.W
    PEA     GLOB_STR_ESQ_C_5
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     ESQ_JMPTBL_LIST_InitHeader(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.init_entry_tables_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .after_entry_tables

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
    BRA.S   .init_entry_tables_loop

.after_entry_tables:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.W   LAB_222A
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0
    MOVEQ   #34,D1
    CMP.W   D1,D0
    BCS.S   .check_graphics_version

    MOVE.W  #1,LAB_222A

.check_graphics_version:
    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #1750000,D0
    BLE.S   .check_available_mem

    MOVE.W  #2,LAB_222A

.check_available_mem:
    JSR     ESQ_JMPTBL_ESQ_FormatDiskErrorMessage(PC)

    TST.L   D0
    BNE.W   .return

    JSR     JMPTBL_ESQ_CheckAvailableFastMemory(PC)

    JSR     JMPTBL_ESQ_CheckCompatibleVideoChip(PC)

    JSR     ESQ_JMPTBL_LAB_0017(PC)

    MOVE.L  #LAB_223A,LAB_1B06
    MOVE.L  #LAB_2274,LAB_1B07
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2241
    MOVE.W  D0,LAB_227B
    JSR     LAB_089E(PC)

    JSR     DST_RefreshBannerBuffer(PC)

    CLR.W   LAB_2294
    MOVEQ   #1,D5

.scan_cart_args_loop:
    MOVE.L  D5,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .select_baud_rate

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 0(A3,D0.L),A0
    LEA     GLOB_STR_CART,A1

.compare_cart_string_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_cart_arg

    TST.B   D1
    BNE.S   .compare_cart_string_loop

    BNE.S   .next_cart_arg

    MOVE.W  #1,LAB_2294

; it looks like this tests a value to determine if we can spin up
; to a specific baud rate or if we should just jump down to 2400.
.next_cart_arg:
    ADDQ.W  #1,D5
    BRA.S   .scan_cart_args_loop

.select_baud_rate:
    MOVEQ   #2,D0
    CMP.L   D0,D7

    BLE.S   .setBaudRateTo2400

    MOVE.L  8(A3),-(A7)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_BAUD_RATE
    CMPI.L  #2400,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #4800,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #9600,D0
    BEQ.S   .after_baud_rate

    MOVE.L  #2400,D0
    MOVE.L  D0,GLOB_REF_BAUD_RATE
    BRA.S   .after_baud_rate

.setBaudRateTo2400:
    MOVE.L  #2400,GLOB_REF_BAUD_RATE

.after_baud_rate:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; flags
    PEA     9000.W                              ; 9000 bytes
    PEA     854.W                               ; line number?
    PEA     GLOB_STR_ESQ_C_6
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,LAB_229A
    CLR.L   (A7)
    PEA     GLOB_STR_SERIAL_READ
    JSR     GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    LEA     20(A7),A7
    MOVE.L  D0,LAB_2212
    BEQ.W   .return

    PEA     82.W
    MOVE.L  D0,-(A7)
    JSR     ESQ_JMPTBL_STRUCT_AllocWithOwner(PC)

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

    JSR     ESQ_JMPTBL_ESQ_InitAudio1Dma(PC)

    JSR     ESQ_JMPTBL_SCRIPT_InitCtrlContext(PC)

    JSR     ESQ_JMPTBL_KYBD_InitializeInputDevices(PC)

    JSR     LAB_0963(PC)

    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     96.W                            ; Bytes to Allocate
    PEA     984.W                           ; Line Number
    PEA     GLOB_STR_ESQ_C_7                ; Calling File
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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

.UNKNOWN2B_AllocRasters_696x509_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .seed_raster_aliases

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
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

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
    BRA.S   .UNKNOWN2B_AllocRasters_696x509_loop

.seed_raster_aliases:
    MOVE.L  LAB_221C,LAB_2267
    MOVE.L  LAB_221D,LAB_2268
    MOVE.L  LAB_221E,LAB_2269
    MOVEQ   #0,D5

.seed_raster_offsets_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .begin_UNKNOWN2B_AllocRasters_696x241

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
    BRA.S   .seed_raster_offsets_loop

.begin_UNKNOWN2B_AllocRasters_696x241:
    MOVEQ   #3,D5

.UNKNOWN2B_AllocRasters_696x241_loop:
    MOVEQ   #5,D0
    CMP.W   D0,D5
    BGE.S   .init_main_rastport

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
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

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
    BRA.S   .UNKNOWN2B_AllocRasters_696x241_loop

.init_main_rastport:
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
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    LEA     LAB_221F,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEQ   #2,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.UNKNOWN2B_AllocRasters_696x2_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .after_raster_setup

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
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

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
    BRA.S   .UNKNOWN2B_AllocRasters_696x2_loop

.after_raster_setup:
    MOVE.L  LAB_2220,LAB_2207
    MOVE.L  LAB_2221,LAB_2208
    MOVE.L  LAB_2222,LAB_2209

    PEA     15.W                        ; Height
    PEA     696.W                       ; Width
    PEA     1038.W                      ; Line Number
    PEA     GLOB_STR_ESQ_C_11           ; Calling file
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

    MOVE.L  D0,LAB_2229
    CLR.W   LAB_22AB
    CLR.L   LAB_225F
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_2260
    JSR     ESQ_JMPTBL_LAB_041D(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .init_global_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_098A(PC)

    ADDQ.W  #8,A7

.init_global_state:
    JSR     LAB_0C7A(PC)

    JSR     ESQ_JMPTBL_LAB_180B(PC)

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
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,LAB_2266
    MOVE.W  #$ff,SCRIPT_CTRL_CHECKSUM
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
    BNE.S   .format_version_banner

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     LAB_1E0F
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

; Fill out "Ver %s.%ld Build %ld %s"
.format_version_banner:
    MOVE.L  GLOB_PTR_STR_BUILD_ID,-(A7)             ; JGT
    MOVE.L  GLOB_LONG_BUILD_NUMBER,-(A7)            ; 21
    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)    ; 4
    PEA     GLOB_STR_MAJOR_MINOR_VERSION            ; 9.0
    PEA     GLOB_STR_GUIDE_START_VERSION_AND_BUILD
    PEA     LAB_2204
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     LAB_1E12,A0
    LEA     LAB_2249,A1
    MOVEQ   #9,D0

.copy_version_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_version_template_loop

    JSR     ESQ_JMPTBL_LAB_14E2(PC)

    JSR     ESQ_JMPTBL_LAB_0D89(PC)

    PEA     GLOB_STR_DF0_GRADIENT_INI_2
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     ESQ_JMPTBL_LAB_0DE9(PC)

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
    BNE.S   .check_memory_and_video_caps

    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.W   .continue_startup

.check_memory_and_video_caps:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     180.W
    PEA     LAB_1E16
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .maybe_show_compat_note

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     LAB_1E17
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.maybe_show_compat_note:
    TST.W   IS_COMPATIBLE_VIDEO_CHIP
    BEQ.S   .init_compat_wait

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .select_compat_note_y_no_fastmem

    MOVEQ   #120,D0
    ADD.L   D0,D0
    BRA.S   .draw_compat_note

.select_compat_note_y_no_fastmem:
    MOVEQ   #105,D0
    ADD.L   D0,D0

.draw_compat_note:
    MOVE.L  D0,-(A7)
    PEA     LAB_1E18
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.init_compat_wait:
    JSR     LAB_0A48(PC)

.compat_halt_loop:
    BRA.S   .compat_halt_loop

.continue_startup:
    JSR     LAB_0A48(PC)

    JSR     GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries(PC)

    JSR     ESQ_JMPTBL_LAB_0E14(PC)

    JSR     LAB_0539(PC)

    JSR     ESQ_JMPTBL_LAB_04F0(PC)

    JSR     ESQ_JMPTBL_LAB_1664(PC)

    PEA     GLOB_STR_DF0_DEFAULT_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     GLOB_STR_DF0_BRUSH_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     LAB_1ED1
    MOVE.L  LAB_1B1F,-(A7)
    JSR     GROUP_AN_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     LAB_1E1B
    JSR     LAB_0AB5(PC)

    LEA     20(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .ensure_brush_selected

    PEA     LAB_1ED1
    PEA     LAB_1E1C
    JSR     LAB_0AA3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.ensure_brush_selected:
    PEA     LAB_1ED1
    JSR     LAB_0AA5(PC)

    MOVE.L  D0,LAB_1ED0
    JSR     LAB_09DB(PC)

    PEA     GLOB_STR_DF0_BANNER_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     ESQ_JMPTBL_LAB_0CC8(PC)

    JSR     ESQ_JMPTBL_LADFUNC_LoadTextAdsFromFile(PC)

    JSR     LAB_09B7(PC)

    MOVE.W  #1,LAB_2272
    MOVE.W  LAB_226F,LAB_2257
    CLR.L   (A7)
    PEA     4095.W
    JSR     LAB_08DA(PC)

    MOVE.W  #$8100,INTENA
    JSR     ESQ_JMPTBL_LAB_1365(PC)

    PEA     LAB_2321
    JSR     ESQ_JMPTBL_LAB_0F07(PC)

    PEA     LAB_2324
    JSR     ESQ_JMPTBL_LAB_0F07(PC)

    PEA     LAB_2324
    PEA     LAB_2321
    JSR     ESQ_JMPTBL_LAB_0F5D(PC)

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_21DF
    MOVE.L  A0,LAB_21E0
    PEA     LAB_21DF
    JSR     DST_LoadBannerPairFromFiles(PC)

    CLR.W   LAB_234A
    JSR     LAB_0969(PC)

    LEA     32(A7),A7
    CLR.L   LAB_1E84
    MOVEQ   #1,D5

.scan_startup_flags_loop:
    MOVE.L  D5,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .after_startup_flag_scan

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 0(A3,D0.L),A0
    LEA     LAB_1E1E,A1

.compare_startup_flag_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_startup_flag

    TST.B   D1
    BNE.S   .compare_startup_flag_loop

    BNE.S   .next_startup_flag

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1E84

.next_startup_flag:
    ADDQ.W  #1,D5
    BRA.S   .scan_startup_flags_loop

.after_startup_flag_scan:
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

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.clear_schedule_table_loop:
    CMPI.W  #$12e,D5
    BGE.S   .after_schedule_table_clear

    MOVE.L  D5,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    ADDA.L  D0,A0
    CLR.W   (A0)
    ADDQ.W  #1,D5
    BRA.S   .clear_schedule_table_loop

.after_schedule_table_clear:
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .after_ravesc_banner

    JSR     ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7

.after_ravesc_banner:
    MOVE.W  #1,LAB_1DE5

.main_idle_loop:
    JSR     LAB_097E(PC)

    JSR     LAB_09B1(PC)

    TST.W   D0
    BEQ.S   .check_exit_condition

    TST.W   LAB_1DE4
    BNE.S   .check_exit_condition

    JSR     LAB_0B4F(PC)

.check_exit_condition:
    TST.W   LAB_1DE4
    BEQ.S   .main_idle_loop

.return:
    JSR     GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem(PC)

    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
