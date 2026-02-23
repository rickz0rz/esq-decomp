    XDEF    ESQ_MainInitAndRun

;------------------------------------------------------------------------------
; FUNC: ESQ_MainInitAndRun   (MainInitAndRun)
; ARGS:
;   stack +4: argc (s32, via 8(A5))
;   stack +8: argv (char**/pointer table, via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   _LVOExecute, _LVOFindTask, _LVOOpenLibrary, _LVOOpenResource,
;   GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode, GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS,
;   _LVOOpenFont, _LVOOpenDiskFont, ESQIFF_JMPTBL_MEMORY_AllocateMemory,
;   _LVOInitRastPort, _LVOSetFont, ESQIFF_JMPTBL_MATH_DivS32, ESQDISP_JMPTBL_GRAPHICS_AllocRaster,
;   _LVOBltClear, _LVOInitBitMap, GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory,
;   GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip, ESQDISP_AllocateHighlightBitmaps, GROUP_AM_JMPTBL_LIST_InitHeader, ESQDISP_QueueHighlightDrawMessage,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage, GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard, GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc, DST_RefreshBannerBuffer,
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal, GROUP_AM_JMPTBL_STRUCT_AllocWithOwner, _LVOOpenDevice,
;   _LVODoIO, SETUP_INTERRUPT_INTB_RBF, SETUP_INTERRUPT_INTB_AUD1,
;   GROUP_AM_JMPTBL_ESQ_InitAudio1Dma, GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext, GROUP_AM_JMPTBL_KYBD_InitializeInputDevices, ESQFUNC_AllocateLineTextBuffers, GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk, ESQFUNC_UpdateRefreshModeState, ESQSHARED4_InitializeBannerCopperSystem,
;   GROUP_AM_JMPTBL_TLIBA3_InitPatternTable, SETUP_INTERRUPT_INTB_VERTB, ESQIFF_RestoreBasePaletteTriples, ESQIFF_RunCopperDropTransition, _LVOSetAPen,
;   _LVORectFill, _LVOSetBPen, _LVOSetDrMd, ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode, GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults, GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState
; READS:
;   Global_REF_DOS_LIBRARY_2, AbsExecBase, Global_STR_GRAPHICS_LIBRARY,
;   Global_STR_DISKFONT_LIBRARY, Global_STR_DOS_LIBRARY, Global_STR_INTUITION_LIBRARY,
;   Global_STR_UTILITY_LIBRARY, Global_STR_BATTCLOCK_RESOURCE,
;   Global_STRUCT_TEXTATTR_TOPAZ_FONT, Global_STRUCT_TEXTATTR_PREVUEC_FONT,
;   Global_STRUCT_TEXTATTR_H26F_FONT, Global_STRUCT_TEXTATTR_PREVUE_FONT,
;   Global_STR_RAVESC, Global_STR_COPY_NIL_ASSIGN_RAM, Global_STR_ESQ_C_1..11,
;   Global_STR_SERIAL_READ, Global_STR_SERIAL_DEVICE, Global_STR_DF0_GRADIENT_INI_2,
;   Global_STR_GUIDE_START_VERSION_AND_BUILD, Global_STR_MAJOR_MINOR_VERSION,
;   Global_PTR_STR_BUILD_ID, Global_LONG_BUILD_NUMBER, Global_LONG_PATCH_VERSION_NUMBER
; WRITES:
;   ESQ_SelectCodeBuffer, Global_WORD_SELECT_CODE_IS_RAVESC,
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_DISKFONT_LIBRARY, Global_REF_DOS_LIBRARY,
;   Global_REF_INTUITION_LIBRARY, Global_REF_UTILITY_LIBRARY, Global_REF_BATTCLOCK_RESOURCE,
;   Global_HANDLE_TOPAZ_FONT, Global_HANDLE_PREVUEC_FONT, Global_HANDLE_H26F_FONT,
;   Global_HANDLE_PREVUE_FONT, Global_REF_RASTPORT_1, Global_REF_RASTPORT_2,
;   Global_REF_STR_CLOCK_FORMAT, ESQ_HighlightMsgPort, ESQ_HighlightReplyPort, WDISP_HighlightBufferMode, WDISP_HighlightRasterHeightPx,
;   WDISP_352x240RasterPtrTable/WDISP_BannerRowScratchRasterTable0/WDISP_LivePlaneRasterTable0/WDISP_DisplayContextPlanePointer0 tables, WDISP_DisplayContextBase, WDISP_BannerWorkRasterPtr,
;   SCRIPT_CtrlInterfaceEnabledFlag, ESQIFF_RecordBufferPtr, ESQSHARED_BannerRowScratchRasterBase0-ESQSHARED_BannerRowScratchRasterBase2, ESQSHARED_LivePlaneBase0-ESQSHARED_DisplayContextPlaneBase4,
;   Global_REF_BAUD_RATE, WDISP_SerialIoRequestPtr, WDISP_SerialMessagePortPtr,
;   Global_REF_96_BYTES_ALLOCATED, numerous state globals cleared in .init_global_state
; DESC:
;   Main startup routine: loads libraries/resources, opens fonts, allocates
;   rastports/bitmaps/rasters, initializes display state, sets serial/interrupts,
;   parses INI, and seeds global state for the main loop.
; NOTES:
;   - Treats argv[1] as a select code string; detects \"RAVESC\".
;   - Falls back to topaz for missing disk fonts.
;   - Copies argv strings bytewise without explicit destination-length checks.
;   - Startup banner text is composed into ESQ_StartupVersionBannerBuffer via
;     RawDoFmt-style formatting; template/string edits can affect memory safety.
;   - Current destination capacities:
;       ESQ_SelectCodeBuffer = 10 bytes (including NUL)
;       ESQ_StartupVersionBannerBuffer = 80 bytes (including NUL)
;       DISKIO_ErrorMessageScratch = 41 bytes (including NUL)
;------------------------------------------------------------------------------
ESQ_MainInitAndRun:
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BLT.S   .clear_select_code

    MOVEA.L 4(A3),A0
    LEA     ESQ_SelectCodeBuffer,A1

; Copy argv[1] into ESQ_SelectCodeBuffer until NUL terminator.
; ESQ_SelectCodeBuffer capacity is 10 bytes total (9 visible chars + NUL).
; No explicit bounds check is visible here.
; Layout-coupled spill risk:
;   byte 10+ overwrites Global_REF_BAUD_RATE,
;   byte 14+ overwrites ESQSHARED_BannerColorModeWord,
;   byte 16+ overwrites ED_Rastport2PenModeSelector.
; Trace-backed note: no active direct non-overflow writers for the latter two
; fields were found in current symbolized paths.
.copy_select_code_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_select_code_loop

    BRA.S   .select_code_ready

.clear_select_code:
    CLR.B   ESQ_SelectCodeBuffer

.select_code_ready:
    LEA     ESQ_SelectCodeBuffer,A0
    LEA     Global_STR_RAVESC,A1

.compare_select_code_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .clear_select_code_flag

    TST.B   D0
    BNE.S   .compare_select_code_loop

    BNE.S   .clear_select_code_flag

    MOVE.W  #1,Global_WORD_SELECT_CODE_IS_RAVESC
    BRA.S   .runStartupSequence

.clear_select_code_flag:
    CLR.W   Global_WORD_SELECT_CODE_IS_RAVESC

.runStartupSequence:
    LEA     Global_STR_COPY_NIL_ASSIGN_RAM,A0
    MOVE.L  A0,D1       ; command string
    MOVEQ   #0,D2       ; input
    MOVE.L  D2,D3       ; output
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    SUBA.L  A1,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,WDISP_ExecBaseHookPtr
    MOVEA.L D0,A0
    MOVE.L  184(A0),ESQ_ProcessWindowPtrBackup
    MOVEQ   #-1,D0
    MOVE.L  D0,184(A0)
    MOVE.L  D2,D0

    LEA     Global_STR_GRAPHICS_LIBRARY,A1
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_REF_GRAPHICS_LIBRARY
    TST.L   D0
    BNE.S   .loadDiskfontLibrary

    MOVE.L  D2,-(A7)
    JSR     GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadDiskfontLibrary:
    LEA     Global_STR_DISKFONT_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_REF_DISKFONT_LIBRARY
    BNE.S   .loadDosLibrary

    CLR.L   -(A7)
    JSR     GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadDosLibrary:
    LEA     Global_STR_DOS_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_REF_DOS_LIBRARY
    BNE.S   .loadIntuitionLibrary

    CLR.L   -(A7)
    JSR     GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadIntuitionLibrary:
    LEA     Global_STR_INTUITION_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_REF_INTUITION_LIBRARY
    BNE.S   .loadUtilityLibraryAndBattclockResource

    CLR.L   -(A7)
    JSR     GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadUtilityLibraryAndBattclockResource:
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0   ; Read address 20 in the library struct for Graphics.Library which is the lib_Version
    MOVEQ   #37,D1      ; Compare it to 37 ...
    CMP.W   D1,D0       ; CMP.W -> subtract D1 from D0 and store CCR conditions
    BCS.S   .loadFonts  ; If carry is set post comparison, jump to .loadFonts

    LEA     Global_STR_UTILITY_LIBRARY,A1

    ; Open the "utility.library" library, version 37
    MOVEQ   #37,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_REF_UTILITY_LIBRARY

    ; If we couldn't load the utility.library jump
    BEQ.S   .unableToLoadUtilityLibrary

    ; Open the "battclock.resource" resource
    LEA     Global_STR_BATTCLOCK_RESOURCE,A1
    JSR     _LVOOpenResource(A6)

    MOVE.L  D0,Global_REF_BATTCLOCK_RESOURCE

.unableToLoadUtilityLibrary:
    MOVEQ   #2,D0
    MOVE.L  D0,Global_LONG_ROM_VERSION_CHECK

.loadFonts:
    JSR     GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS(PC)

    ; Open the "topaz.font" file.
    LEA     Global_STRUCT_TEXTATTR_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOOpenFont(A6)

    MOVE.L  D0,Global_HANDLE_TOPAZ_FONT
    ; If we couldn't open the font, jump
    TST.L   D0
    BEQ.W   .return

    ; Open the "PrevueC.font" file.
    LEA     Global_STRUCT_TEXTATTR_PREVUEC_FONT,A0
    MOVEA.L Global_REF_DISKFONT_LIBRARY,A6

    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,Global_HANDLE_PREVUEC_FONT
    ; If we opened the font, jump.
    TST.L   D0
    BNE.S   .openH26fFont

    ; Fallback to the topaz font.
    MOVE.L  Global_HANDLE_TOPAZ_FONT,Global_HANDLE_PREVUEC_FONT

.openH26fFont:
    ; Open the "h26f.font" file.
    LEA     Global_STRUCT_TEXTATTR_H26F_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,Global_HANDLE_H26F_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .openPrevueFont

    ; Fallback to the topaz font.
    MOVE.L  Global_HANDLE_TOPAZ_FONT,Global_HANDLE_H26F_FONT

.openPrevueFont:
    ; Open the "Prevue.font" file.
    LEA     Global_STRUCT_TEXTATTR_PREVUE_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,Global_HANDLE_PREVUE_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .loadedFonts

    ; Fall back to the topaz font.
    MOVE.L  Global_HANDLE_TOPAZ_FONT,Global_HANDLE_PREVUE_FONT

.loadedFonts:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     623.W
    PEA     Global_STR_ESQ_C_1
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_RASTPORT_1  ; D0 is the allocated memory, storing its reference in Global_REF_RASTPORT_1
    MOVEA.L D0,A1                   ; Store the address of D0 into A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)    ; In the memory we have, initialize a RastPort struct

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)  ; #Global_REF_696_400_BITMAP into address of the rastport #1 bitmap

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #68,D0
    MOVE.W  D0,WDISP_HighlightRasterHeightPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .adjust_rastport_text_spacing

    MOVE.W  WDISP_HighlightRasterHeightPx,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,WDISP_HighlightRasterHeightPx

.adjust_rastport_text_spacing:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     645.W
    PEA     Global_STR_ESQ_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_RASTPORT_2
    MOVEA.L D0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L Global_REF_RASTPORT_2,A0
    MOVE.L  #Global_REF_320_240_BITMAP,4(A0)      ; #Global_REF_320_240_BITMAP into Global_REF_RASTPORT_2.BitMap

    MOVEA.L Global_REF_RASTPORT_2,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D5

.init_rastport1_rows_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .init_bitmap_320_240

    MOVE.L  D5,D0
    MULS    #40,D0
    LEA     ESQDISP_HighlightBitmapTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    JSR     ESQDISP_AllocateHighlightBitmaps(PC)

    ADDQ.W  #4,A7
    ADDQ.W  #1,D5
    BRA.S   .init_rastport1_rows_loop

.init_bitmap_320_240:
    LEA     Global_REF_320_240_BITMAP,A0     ; BitMap struct pointer
    MOVEQ   #4,D0           ; depth: 4 bitplanes or 16 colors (2 ^ 4) into D0
    MOVE.L  #352,D1         ; width: 352 into D1
    MOVEQ   #120,D2         ; height: 120 into D2
    ADD.L   D2,D2           ; ...becomes 240 into D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.GRAPHICS_AllocRasters_352x240_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .select_clock_format_table

    MOVE.L  D5,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     WDISP_352x240RasterPtrTable,A0
    ADDA.L  D1,A0

    PEA     240.W                       ; Height
    PEA     352.W                       ; Width
    PEA     668.W                       ; Line Number
    PEA     Global_STR_ESQ_C_3            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_352x240RasterPtrTable,A0
    ADDA.L  D0,A0

    MOVEA.L (A0),A1         ; memBlock
    MOVE.L  #10560,D0       ; byte count
    MOVEQ   #0,D1           ; flags
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_352x240_loop

.select_clock_format_table:
    MOVE.B  Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .use12HourClock

    LEA     Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .store_clock_format_table

.use12HourClock:
    LEA     Global_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.store_clock_format_table:
    MOVE.L  A0,Global_REF_STR_CLOCK_FORMAT

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     34.W
    PEA     683.W
    PEA     Global_STR_ESQ_C_4
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,ESQ_HighlightMsgPort
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L ESQ_HighlightMsgPort,A0
    CLR.B   9(A0)
    MOVEA.L ESQ_HighlightMsgPort,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L ESQ_HighlightMsgPort,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L ESQ_HighlightMsgPort,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AM_JMPTBL_LIST_InitHeader(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     34.W
    PEA     698.W
    PEA     Global_STR_ESQ_C_5
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,ESQ_HighlightReplyPort
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L ESQ_HighlightReplyPort,A0
    CLR.B   9(A0)
    MOVEA.L ESQ_HighlightReplyPort,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L ESQ_HighlightReplyPort,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L ESQ_HighlightReplyPort,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AM_JMPTBL_LIST_InitHeader(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.init_entry_tables_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .after_entry_tables

    MOVE.L  D5,D0
    MULS    #$a0,D0
    LEA     GCOMMAND_HighlightMessageSlotTable,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    MULS    #$28,D0
    LEA     ESQDISP_HighlightBitmapTable,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQDISP_QueueHighlightDrawMessage(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D5
    BRA.S   .init_entry_tables_loop

.after_entry_tables:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.W   WDISP_HighlightBufferMode
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0
    MOVEQ   #34,D1
    CMP.W   D1,D0
    BCS.S   .check_graphics_version

    MOVE.W  #1,WDISP_HighlightBufferMode

.check_graphics_version:
    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #1750000,D0
    BLE.S   .check_available_mem

    MOVE.W  #2,WDISP_HighlightBufferMode

.check_available_mem:
    JSR     GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage(PC)

    TST.L   D0
    BNE.W   .return

    JSR     GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard(PC)

    MOVE.L  #CLOCK_DaySlotIndex,CLOCK_DaySlotIndexPtr
    MOVE.L  #CLOCK_CurrentDayOfWeekIndex,CLOCK_CurrentDayOfWeekIndexPtr
    MOVEQ   #0,D0
    MOVE.W  D0,DST_PrimaryCountdown
    MOVE.W  D0,DST_SecondaryCountdown
    JSR     GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc(PC)

    JSR     DST_RefreshBannerBuffer(PC)

    CLR.W   SCRIPT_CtrlInterfaceEnabledFlag
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
    LEA     Global_STR_CART,A1

.compare_cart_string_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_cart_arg

    TST.B   D1
    BNE.S   .compare_cart_string_loop

    BNE.S   .next_cart_arg

    MOVE.W  #1,SCRIPT_CtrlInterfaceEnabledFlag

; it looks like this tests a value to determine if we can spin up
; to a specific baud rate or if we should just jump down to 2400.
.next_cart_arg:
    ADDQ.W  #1,D5
    BRA.S   .scan_cart_args_loop

.select_baud_rate:
    ; Serial device speed gate for the standard ingest path.
    ; Accepted runtime values here are 2400/4800/9600; other values clamp to 2400.
    ; The downstream parser/record handlers are shared regardless of which accepted
    ; baud is selected (see ESQPARS_ConsumeRbfByteAndDispatchCommand and ESQIFF2_ReadRbfBytes*).
    MOVEQ   #2,D0
    CMP.L   D0,D7

    BLE.S   .setBaudRateTo2400

    MOVE.L  8(A3),-(A7)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_BAUD_RATE
    CMPI.L  #2400,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #4800,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #9600,D0
    BEQ.S   .after_baud_rate

    MOVE.L  #2400,D0
    MOVE.L  D0,Global_REF_BAUD_RATE
    BRA.S   .after_baud_rate

.setBaudRateTo2400:
    MOVE.L  #2400,Global_REF_BAUD_RATE

.after_baud_rate:
    ; Startup then opens serial.device and enables RBF/AUD1 interrupt service.
    ; Custom protocol experiments that still want the normal 2400 command/data
    ; decode path should continue feeding bytes into this same serial/RBF chain.
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; flags
    PEA     9000.W                              ; 9000 bytes
    PEA     854.W                               ; line number?
    PEA     Global_STR_ESQ_C_6
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,ESQIFF_RecordBufferPtr
    CLR.L   (A7)
    PEA     Global_STR_SERIAL_READ
    JSR     GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    LEA     20(A7),A7
    MOVE.L  D0,WDISP_SerialMessagePortPtr
    BEQ.W   .return

    PEA     82.W
    MOVE.L  D0,-(A7)
    JSR     GROUP_AM_JMPTBL_STRUCT_AllocWithOwner(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,WDISP_SerialIoRequestPtr
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A1                       ; ioRequest
    LEA     Global_STR_SERIAL_DEVICE,A0   ; devName
    MOVEQ   #0,D0                       ; unit number
    MOVE.L  D0,D1                       ; flags
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6                       ; Copy D0 into D6
    TST.L   D6                          ; Test D6 to see if it's 0 (failed)
    BNE.W   .return                     ; Branch if unable to open serial device

    MOVEA.L WDISP_SerialIoRequestPtr,A0
    MOVE.B  #16,79(A0)
    MOVEA.L WDISP_SerialIoRequestPtr,A0
    MOVE.L  Global_REF_BAUD_RATE,60(A0)
    MOVEA.L WDISP_SerialIoRequestPtr,A0
    MOVE.W  #11,28(A0)
    MOVEA.L WDISP_SerialIoRequestPtr,A1
    JSR     _LVODoIO(A6)

    JSR     SETUP_INTERRUPT_INTB_RBF(PC)

    JSR     SETUP_INTERRUPT_INTB_AUD1(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_InitAudio1Dma(PC)

    JSR     GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext(PC)

    JSR     GROUP_AM_JMPTBL_KYBD_InitializeInputDevices(PC)

    JSR     ESQFUNC_AllocateLineTextBuffers(PC)

    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     96.W                            ; Bytes to Allocate
    PEA     984.W                           ; Line Number
    PEA     Global_STR_ESQ_C_7                ; Calling File
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_96_BYTES_ALLOCATED                     ; whatever was allocated above

    LEA     Global_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0       ; 3 bitplanes
    MOVE.L  #696,D1     ; 696 w
    MOVE.L  #400,D2     ; 400 h
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    LEA     Global_REF_696_241_BITMAP,A0
    MOVEQ   #4,D0       ; 4 bitplanes
    MOVE.L  #696,D1     ; 696 w
    MOVEQ   #14,D2      ; 14 h
    NOT.B   D2          ; Flip last byte of D2 means D2 is now 241 h
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.GRAPHICS_AllocRasters_696x509_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .seed_raster_aliases

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0

    PEA     509.W                       ; Height
    PEA     696.W                       ; Width
    PEA     991.W                       ; Line Number
    PEA     Global_STR_ESQ_C_8            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$aef8,D0
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x509_loop

.seed_raster_aliases:
    ; Preserve original 696x509 raster bases for display/scratch reuse.
    MOVE.L  WDISP_BannerRowScratchRasterTable0,ESQSHARED_BannerRowScratchRasterBase0
    MOVE.L  WDISP_BannerRowScratchRasterTable1,ESQSHARED_BannerRowScratchRasterBase1
    MOVE.L  WDISP_BannerRowScratchRasterTable2,ESQSHARED_BannerRowScratchRasterBase2
    MOVEQ   #0,D5

.seed_raster_offsets_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .begin_GRAPHICS_AllocRasters_696x241

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0
    LEA     WDISP_BannerRowScratchRasterTable0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ; Derive plane base aliases by fixed +$5C20 offset from 696x509 rasters.
    ADDA.W  #$5c20,A2
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D5
    BRA.S   .seed_raster_offsets_loop

.begin_GRAPHICS_AllocRasters_696x241:
    MOVEQ   #3,D5

.GRAPHICS_AllocRasters_696x241_loop:
    MOVEQ   #5,D0
    CMP.W   D0,D5
    BGE.S   .init_main_rastport

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0

    PEA     241.W                       ; Height
    PEA     696.W                       ; Width
    PEA     1008.W                      ; Line Number
    PEA     Global_STR_ESQ_C_9            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$52d8,D0
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x241_loop

.init_main_rastport:
    MOVE.L  WDISP_DisplayContextPlanePointer0,ESQSHARED_DisplayContextPlaneBase0
    MOVE.L  WDISP_DisplayContextPlanePointer1,ESQSHARED_DisplayContextPlaneBase1
    MOVE.L  WDISP_DisplayContextPlanePointer2,ESQSHARED_DisplayContextPlaneBase2
    MOVE.L  WDISP_DisplayContextPlanePointer3,ESQSHARED_DisplayContextPlaneBase3
    MOVE.L  WDISP_DisplayContextPlanePointer4,ESQSHARED_DisplayContextPlaneBase4
    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  52(A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    PEA     3.W
    CLR.L   -(A7)
    PEA     2.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    LEA     WDISP_BannerGridBitmapStruct,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEQ   #2,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.GRAPHICS_AllocRasters_696x2_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .after_raster_setup

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     WDISP_LivePlaneRasterTable0,A0
    ADDA.L  D0,A0

    PEA     2.W                         ; Height
    PEA     696.W                       ; Width
    PEA     1027.W                      ; Line Number
    PEA     Global_STR_ESQ_C_10           ; Calling file
    MOVE.L  A0,44(A7)
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0

    LEA     WDISP_LivePlaneRasterTable0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x2_loop

.after_raster_setup:
    ; Snapshot currently live 696x2 plane bases for ESQSHARED copy paths.
    MOVE.L  WDISP_LivePlaneRasterTable0,ESQSHARED_LivePlaneBase0
    MOVE.L  WDISP_LivePlaneRasterTable1,ESQSHARED_LivePlaneBase1
    MOVE.L  WDISP_LivePlaneRasterTable2,ESQSHARED_LivePlaneBase2

    PEA     15.W                        ; Height
    PEA     696.W                       ; Width
    PEA     1038.W                      ; Line Number
    PEA     Global_STR_ESQ_C_11           ; Calling file
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    MOVE.L  D0,WDISP_BannerWorkRasterPtr
    CLR.W   WDISP_AccumulatorFlushPending
    CLR.L   NEWGRID_RefreshStateFlag
    MOVEQ   #-1,D0
    MOVE.L  D0,NEWGRID_MessagePumpSuspendFlag
    JSR     GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .init_global_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQFUNC_UpdateRefreshModeState(PC)

    ADDQ.W  #8,A7

.init_global_state:
    JSR     ESQSHARED4_InitializeBannerCopperSystem(PC)

    JSR     GROUP_AM_JMPTBL_TLIBA3_InitPatternTable(PC)

    JSR     SETUP_INTERRUPT_INTB_VERTB(PC)

    ; This is just clearing out a BUNCH of variables to zero or whatever
    ; default value it uses.
    MOVEQ   #0,D0
    MOVE.W  D0,Global_UIBusyFlag
    MOVE.W  D0,ESQ_StartupStateWord2203
    MOVE.W  D0,TEXTDISP_SecondaryGroupRecordLength
    MOVE.W  D0,TEXTDISP_PrimaryGroupRecordLength
    MOVE.W  D0,ESQ_TickModulo60Counter
    MOVE.W  D0,ESQ_StartupWriteOnlyWord2271
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVE.W  D0,SCRIPT_CtrlCmdCount
    MOVE.W  D0,TEXTDISP_SecondaryGroupEntryCount
    MOVE.W  D0,TEXTDISP_PrimaryGroupEntryCount
    MOVE.W  D0,ESQIFF_GAdsListLineIndex
    MOVE.W  D0,ESQIFF_LogoListLineIndex
    MOVE.W  D0,ESQIFF_StatusPacketReadyFlag
    MOVE.W  D0,TEXTDISP_GroupMutationState
    MOVE.W  D0,ESQ_SerialRbfFillLevel
    MOVE.W  D0,Global_WORD_MAX_VALUE
    MOVE.W  D0,Global_WORD_T_VALUE
    MOVE.W  D0,Global_WORD_H_VALUE
    MOVE.W  D0,CLEANUP_PendingAlertFlag
    MOVE.W  D0,CTRL_BufferedByteCount
    MOVE.W  D0,CTRL_HDeltaMax
    MOVE.W  D0,CTRL_HPreviousSample
    MOVE.W  D0,CTRL_H
    MOVE.W  D0,ESQ_SerialRbfErrorCount
    MOVE.W  D0,DATACErrs
    MOVE.W  D0,SCRIPT_CtrlCmdChecksumErrorCount
    MOVE.W  D0,ESQIFF_LineErrorCount
    MOVE.W  D0,SCRIPT_CtrlCmdLengthErrorCount
    MOVE.W  D0,ESQPARS_CommandPreambleArmedFlag
    MOVE.W  D0,ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,WDISP_BannerCharPhaseShift
    MOVE.W  D0,ESQPARS_SelectionMatchCode
    MOVE.W  D0,ESQPARS_ResetArmedFlag
    MOVEQ   #0,D1
    MOVE.B  D1,ESQIFF_UseCachedChecksumFlag
    MOVE.B  D1,TEXTDISP_SecondaryGroupRecordChecksum
    MOVE.B  D1,TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.B  D1,TEXTDISP_SecondaryGroupPresentFlag
    MOVE.B  D1,TEXTDISP_PrimaryGroupCode
    MOVE.B  #$1,TEXTDISP_SecondaryGroupCode
    MOVE.W  #7,ESQ_StartupPhaseSeed225E
    MOVE.W  #2,CLOCK_HalfHourSlotIndex
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,PARSEINI_CtrlHChangeGateFlag
    MOVE.W  #$ff,SCRIPT_CTRL_CHECKSUM
    JSR     ESQIFF_RestoreBasePaletteTriples(PC)

    JSR     ESQIFF_RunCopperDropTransition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rect from 0,0 to 695,399
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_241_BITMAP,4(A0)
    MOVEA.L Global_REF_RASTPORT_1,A1

    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rectangle from 0,0 to 120,120
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #120,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     DISKIO_ErrorMessageScratch
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    JSR     ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

    LEA     12(A7),A7
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   DISKIO_DriveWriteProtectStatusCodeDrive1,D0
    BNE.S   .format_version_banner

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     ESQ_STR_NO_DF1_PRESENT
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

; Fill out "Ver %s.%ld Build %ld %s"
.format_version_banner:
    ; Formatting depends on mutable build-id/version strings and destination size.
    ; WDISP_SPrintf has no destination-length parameter.
    ; Current format literal contributes 13 fixed chars; remaining budget is
    ; shared across %s/%ld/%ld/%s substitutions.
    ; Current configured render: "Ver 9.0.4 Build 21 JGT" (22 chars + NUL).
    ; ESQ_StartupVersionBannerBuffer capacity is 80 bytes => current headroom 57.
    ; With signed-32 worst-case %ld fields and current %s inputs, usage is
    ; 41 chars + NUL (headroom 38). Under current major/minor width, final
    ; build-id text above 41 chars would drop below a 16-byte safety margin.
    PEA     Global_STR_GitCommitHash                  ; Commit Hash
    MOVE.L  Global_LONG_PATCH_VERSION_NUMBER,-(A7)    ; 0
    PEA     Global_STR_MAJOR_MINOR_VERSION            ; 10.0
    PEA     Global_STR_GUIDE_START_VERSION_AND_BUILD
    PEA     ESQ_StartupVersionBannerBuffer
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     ESQ_STR_38_Spaces,A0
    LEA     DISKIO_ErrorMessageScratch,A1
    MOVEQ   #9,D0

; Copy 40 bytes (10 longwords) from ESQ_STR_38_Spaces into a 41-byte scratch.
; Current ESQ_STR_38_Spaces length is 39 chars + NUL = 40 bytes.
; If that source string shrinks, this fixed-size copy can pull adjacent data.
.copy_version_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_version_template_loop

    JSR     GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(PC)

    JSR     GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults(PC)

    PEA     Global_STR_DF0_GRADIENT_INI_2
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     60.W
    ; Also displays select-code text copied from argv[1] earlier.
    PEA     ESQ_SelectCodeBuffer
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     90.W
    PEA     ESQ_StartupVersionBannerBuffer
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     120.W
    PEA     ESQ_STR_CommunityPatchEdition
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     ESQ_STR_SystemInitializing
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     180.W
    PEA     ESQ_STR_PleaseStandByEllipsis
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     76(A7),A7
    TST.W   IS_COMPATIBLE_VIDEO_CHIP
    BNE.S   .check_memory_and_video_caps

    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.W   .continue_startup

.check_memory_and_video_caps:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     180.W
    PEA     ESQ_STR_AttentionSystemEngineer
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    TST.W   HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .maybe_show_compat_note

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     210.W
    PEA     ESQ_STR_ReportErrorCodeEr011ToTVGuide
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.maybe_show_compat_note:
    TST.W   IS_COMPATIBLE_VIDEO_CHIP
    BEQ.S   .init_compat_wait

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
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
    PEA     ESQ_STR_ReportErrorCodeER012ToTVGuide
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.init_compat_wait:
    JSR     ESQIFF_RunCopperRiseTransition(PC)

.compat_halt_loop:
    BRA.S   .compat_halt_loop

.continue_startup:
    JSR     ESQIFF_RunCopperRiseTransition(PC)

    JSR     GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries(PC)

    JSR     GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries(PC)

    JSR     DISKIO2_ReloadDataFilesAndRebuildIndex(PC)

    JSR     GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk(PC)

    JSR     GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig(PC)

    PEA     Global_STR_DF0_DEFAULT_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     Global_STR_DF0_BRUSH_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     ESQIFF_BrushIniListHead
    MOVE.L  PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     ESQ_STR_DT
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     20(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .ensure_brush_selected

    PEA     ESQIFF_BrushIniListHead
    PEA     ESQ_STR_DITHER
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.ensure_brush_selected:
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,ESQFUNC_FallbackType3BrushNode
    JSR     ESQFUNC_RebuildPwBrushListFromTagTable(PC)

    PEA     Global_STR_DF0_BANNER_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates(PC)

    JSR     GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(PC)

    JSR     ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    MOVE.W  #1,ESQ_StartupWriteOnlyLong2272
    MOVE.W  WDISP_BannerCharRangeStart,WDISP_BannerCharIndex
    CLR.L   (A7)
    PEA     4095.W
    JSR     ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVE.W  #$8100,INTENA
    JSR     GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds(PC)

    PEA     LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct(PC)

    PEA     LOCAVAIL_SecondaryFilterState
    JSR     GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct(PC)

    PEA     LOCAVAIL_SecondaryFilterState
    PEA     LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile(PC)

    SUBA.L  A0,A0
    MOVE.L  A0,DST_BannerWindowPrimary
    MOVE.L  A0,DST_BannerWindowSecondary
    PEA     DST_BannerWindowPrimary
    JSR     DST_LoadBannerPairFromFiles(PC)

    CLR.W   Global_RefreshTickCounter
    JSR     ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    LEA     32(A7),A7
    CLR.L   ESQDISP_DisplayActiveFlag
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
    LEA     ESQ_TAG_GRANADA,A1

.compare_startup_flag_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_startup_flag

    TST.B   D1
    BNE.S   .compare_startup_flag_loop

    BNE.S   .next_startup_flag

    MOVEQ   #1,D0
    MOVE.L  D0,ESQDISP_DisplayActiveFlag

.next_startup_flag:
    ADDQ.W  #1,D5
    BRA.S   .scan_startup_flags_loop

.after_startup_flag_scan:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    ; Clear out these values
    MOVEQ   #0,D0
    MOVE.W  D0,ESQ_SerialRbfFillLevel
    MOVE.W  D0,Global_WORD_MAX_VALUE
    MOVE.W  D0,Global_WORD_T_VALUE
    MOVE.W  D0,Global_WORD_H_VALUE
    JSR     _LVOEnable(A6)

    CLR.W   ESQIFF_ExternalAssetFlags
    CLR.L   -(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.clear_schedule_table_loop:
    CMPI.W  #$12e,D5
    BGE.S   .after_schedule_table_clear

    MOVE.L  D5,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     CLEANUP_AlignedStatusEntryCycleTable,A0
    ADDA.L  D0,A0
    CLR.W   (A0)
    ADDQ.W  #1,D5
    BRA.S   .clear_schedule_table_loop

.after_schedule_table_clear:
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .after_ravesc_banner

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.after_ravesc_banner:
    MOVE.W  #1,ESQ_MainLoopUiTickEnabledFlag

.main_idle_loop:
    JSR     ESQFUNC_ServiceUiTickIfRunning(PC)

    JSR     ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(PC)

    TST.W   D0
    BEQ.S   .check_exit_condition

    TST.W   ESQ_ShutdownRequestedFlag
    BNE.S   .check_exit_condition

    JSR     ESQPARS_ConsumeRbfByteAndDispatchCommand(PC)

.check_exit_condition:
    TST.W   ESQ_ShutdownRequestedFlag
    BEQ.S   .main_idle_loop

.return:
    JSR     GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem(PC)

    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
