    XDEF    _ESQ_MainInitAndRun

;------------------------------------------------------------------------------
; FUNC: _ESQ_MainInitAndRun   (MainInitAndRun)
; ARGS:
;   stack +4: argc (s32, via 8(A5))
;   stack +8: argv (char**/pointer table, via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   _LVOExecute, _LVOFindTask, _LVOOpenLibrary, _LVOOpenResource,
;   _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode, _GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS,
;   _LVOOpenFont, _LVOOpenDiskFont, _ESQIFF_JMPTBL_MEMORY_AllocateMemory,
;   _LVOInitRastPort, _LVOSetFont, _ESQIFF_JMPTBL_MATH_DivS32, _ESQDISP_JMPTBL_GRAPHICS_AllocRaster,
;   _LVOBltClear, _LVOInitBitMap, _GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory,
;   _GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip, _ESQDISP_AllocateHighlightBitmaps, _GROUP_AM_JMPTBL_LIST_InitHeader, _ESQDISP_QueueHighlightDrawMessage,
;   _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, _GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage, _GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard, _GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc, _DST_RefreshBannerBuffer,
;   _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal, _GROUP_AM_JMPTBL_STRUCT_AllocWithOwner, _LVOOpenDevice,
;   _LVODoIO, _SETUP_INTERRUPT_INTB_RBF, _SETUP_INTERRUPT_INTB_AUD1,
;   _GROUP_AM_JMPTBL_ESQ_InitAudio1Dma, _GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext, _GROUP_AM_JMPTBL_KYBD_InitializeInputDevices, _ESQFUNC_AllocateLineTextBuffers, _GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk, _ESQFUNC_UpdateRefreshModeState, _ESQSHARED4_InitializeBannerCopperSystem,
;   _GROUP_AM_JMPTBL_TLIBA3_InitPatternTable, _SETUP_INTERRUPT_INTB_VERTB, _ESQIFF_RestoreBasePaletteTriples, _ESQIFF_RunCopperDropTransition, _LVOSetAPen,
;   _LVORectFill, _LVOSetBPen, _LVOSetDrMd, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode, _GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults, _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, _GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState
; READS:
;   Global_REF_DOS_LIBRARY_2, AbsExecBase, _Global_STR_GRAPHICS_LIBRARY,
;   _Global_STR_DISKFONT_LIBRARY, _Global_STR_DOS_LIBRARY, _Global_STR_INTUITION_LIBRARY,
;   _Global_STR_UTILITY_LIBRARY, _Global_STR_BATTCLOCK_RESOURCE,
;   _Global_STRUCT_TEXTATTR_TOPAZ_FONT, _Global_STRUCT_TEXTATTR_PREVUEC_FONT,
;   _Global_STRUCT_TEXTATTR_H26F_FONT, _Global_STRUCT_TEXTATTR_PREVUE_FONT,
;   _Global_STR_RAVESC, _Global_STR_COPY_NIL_ASSIGN_RAM, _Global_STR_ESQ_C_1..11,
;   _Global_STR_SERIAL_READ, _Global_STR_SERIAL_DEVICE, _Global_STR_DF0_GRADIENT_INI_2,
;   _Global_STR_GUIDE_START_VERSION_AND_BUILD, _Global_STR_MAJOR_MINOR_VERSION,
;   _Global_PTR_STR_BUILD_ID, _Global_LONG_BUILD_NUMBER, _Global_LONG_PATCH_VERSION_NUMBER
; WRITES:
;   _ESQ_SelectCodeBuffer, _Global_WORD_SELECT_CODE_IS_RAVESC,
;   _Global_REF_GRAPHICS_LIBRARY, _Global_REF_DISKFONT_LIBRARY, _Global_REF_DOS_LIBRARY,
;   _Global_REF_INTUITION_LIBRARY, _Global_REF_UTILITY_LIBRARY, _Global_REF_BATTCLOCK_RESOURCE,
;   _Global_HANDLE_TOPAZ_FONT, _Global_HANDLE_PREVUEC_FONT, _Global_HANDLE_H26F_FONT,
;   _Global_HANDLE_PREVUE_FONT, _Global_REF_RASTPORT_1, _Global_REF_RASTPORT_2,
;   _Global_REF_STR_CLOCK_FORMAT, _ESQ_HighlightMsgPort, _ESQ_HighlightReplyPort, _WDISP_HighlightBufferMode, _WDISP_HighlightRasterHeightPx,
;   _WDISP_352x240RasterPtrTable/_WDISP_BannerRowScratchRasterTable0/_WDISP_LivePlaneRasterTable0/_WDISP_DisplayContextPlanePointer0 tables, _WDISP_DisplayContextBase, _WDISP_BannerWorkRasterPtr,
;   _SCRIPT_CtrlInterfaceEnabledFlag, _ESQIFF_RecordBufferPtr, _ESQSHARED_BannerRowScratchRasterBase0-_ESQSHARED_BannerRowScratchRasterBase2, _ESQSHARED_LivePlaneBase0-_ESQSHARED_DisplayContextPlaneBase4,
;   _Global_REF_BAUD_RATE, _WDISP_SerialIoRequestPtr, _WDISP_SerialMessagePortPtr,
;   _Global_REF_96_BYTES_ALLOCATED, numerous state globals cleared in .init_global_state
; DESC:
;   Main startup routine: loads libraries/resources, opens fonts, allocates
;   rastports/bitmaps/rasters, initializes display state, sets serial/interrupts,
;   parses INI, and seeds global state for the main loop.
; NOTES:
;   - Treats argv[1] as a select code string; detects \"RAVESC\".
;   - Falls back to topaz for missing disk fonts.
;   - Copies argv strings bytewise without explicit destination-length checks.
;   - Startup banner text is composed into _ESQ_StartupVersionBannerBuffer via
;     RawDoFmt-style formatting; template/string edits can affect memory safety.
;   - Current destination capacities:
;       _ESQ_SelectCodeBuffer = 10 bytes (including NUL)
;       _ESQ_StartupVersionBannerBuffer = 80 bytes (including NUL)
;       _DISKIO_ErrorMessageScratch = 41 bytes (including NUL)
;------------------------------------------------------------------------------
_ESQ_MainInitAndRun:
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BLT.S   .clear_select_code

    MOVEA.L 4(A3),A0
    LEA     _ESQ_SelectCodeBuffer,A1

; Copy argv[1] into _ESQ_SelectCodeBuffer until NUL terminator.
; _ESQ_SelectCodeBuffer capacity is 10 bytes total (9 visible chars + NUL).
; No explicit bounds check is visible here.
; Layout-coupled spill risk:
;   byte 10+ overwrites _Global_REF_BAUD_RATE,
;   byte 14+ overwrites _ESQSHARED_BannerColorModeWord,
;   byte 16+ overwrites _ED_Rastport2PenModeSelector.
; Trace-backed note: no active direct non-overflow writers for the latter two
; fields were found in current symbolized paths.
.copy_select_code_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_select_code_loop

    BRA.S   .select_code_ready

.clear_select_code:
    CLR.B   _ESQ_SelectCodeBuffer

.select_code_ready:
    LEA     _ESQ_SelectCodeBuffer,A0
    LEA     _Global_STR_RAVESC,A1

.compare_select_code_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .clear_select_code_flag

    TST.B   D0
    BNE.S   .compare_select_code_loop

    BNE.S   .clear_select_code_flag

    MOVE.W  #1,_Global_WORD_SELECT_CODE_IS_RAVESC
    BRA.S   .runStartupSequence

.clear_select_code_flag:
    CLR.W   _Global_WORD_SELECT_CODE_IS_RAVESC

.runStartupSequence:
    LEA     _Global_STR_COPY_NIL_ASSIGN_RAM,A0
    MOVE.L  A0,D1       ; command string
    MOVEQ   #0,D2       ; input
    MOVE.L  D2,D3       ; output
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    SUBA.L  A1,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,_WDISP_ExecBaseHookPtr
    MOVEA.L D0,A0
    MOVE.L  184(A0),_ESQ_ProcessWindowPtrBackup
    MOVEQ   #-1,D0
    MOVE.L  D0,184(A0)
    MOVE.L  D2,D0

    LEA     _Global_STR_GRAPHICS_LIBRARY,A1
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,_Global_REF_GRAPHICS_LIBRARY
    TST.L   D0
    BNE.S   .loadDiskfontLibrary

    MOVE.L  D2,-(A7)
    JSR     _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadDiskfontLibrary:
    LEA     _Global_STR_DISKFONT_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,_Global_REF_DISKFONT_LIBRARY
    BNE.S   .loadDosLibrary

    CLR.L   -(A7)
    JSR     _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadDosLibrary:
    LEA     _Global_STR_DOS_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,_Global_REF_DOS_LIBRARY
    BNE.S   .loadIntuitionLibrary

    CLR.L   -(A7)
    JSR     _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadIntuitionLibrary:
    LEA     _Global_STR_INTUITION_LIBRARY,A1
    MOVEQ   #0,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,_Global_REF_INTUITION_LIBRARY
    BNE.S   .loadUtilityLibraryAndBattclockResource

    CLR.L   -(A7)
    JSR     _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.loadUtilityLibraryAndBattclockResource:
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0   ; Read address 20 in the library struct for Graphics.Library which is the lib_Version
    MOVEQ   #37,D1      ; Compare it to 37 ...
    CMP.W   D1,D0       ; CMP.W -> subtract D1 from D0 and store CCR conditions
    BCS.S   .loadFonts  ; If carry is set post comparison, jump to .loadFonts

    LEA     _Global_STR_UTILITY_LIBRARY,A1

    ; Open the "utility.library" library, version 37
    MOVEQ   #37,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,_Global_REF_UTILITY_LIBRARY

    ; If we couldn't load the utility.library jump
    BEQ.S   .unableToLoadUtilityLibrary

    ; Open the "battclock.resource" resource
    LEA     _Global_STR_BATTCLOCK_RESOURCE,A1
    JSR     _LVOOpenResource(A6)

    MOVE.L  D0,_Global_REF_BATTCLOCK_RESOURCE

.unableToLoadUtilityLibrary:
    MOVEQ   #2,D0
    MOVE.L  D0,_Global_LONG_ROM_VERSION_CHECK

.loadFonts:
    JSR     _GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS(PC)

    ; Open the "topaz.font" file.
    LEA     _Global_STRUCT_TEXTATTR_TOPAZ_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOOpenFont(A6)

    MOVE.L  D0,_Global_HANDLE_TOPAZ_FONT
    ; If we couldn't open the font, jump
    TST.L   D0
    BEQ.W   .return

    ; Open the "PrevueC.font" file.
    LEA     _Global_STRUCT_TEXTATTR_PREVUEC_FONT,A0
    MOVEA.L _Global_REF_DISKFONT_LIBRARY,A6

    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,_Global_HANDLE_PREVUEC_FONT
    ; If we opened the font, jump.
    TST.L   D0
    BNE.S   .openH26fFont

    ; Fallback to the topaz font.
    MOVE.L  _Global_HANDLE_TOPAZ_FONT,_Global_HANDLE_PREVUEC_FONT

.openH26fFont:
    ; Open the "h26f.font" file.
    LEA     _Global_STRUCT_TEXTATTR_H26F_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,_Global_HANDLE_H26F_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .openPrevueFont

    ; Fallback to the topaz font.
    MOVE.L  _Global_HANDLE_TOPAZ_FONT,_Global_HANDLE_H26F_FONT

.openPrevueFont:
    ; Open the "Prevue.font" file.
    LEA     _Global_STRUCT_TEXTATTR_PREVUE_FONT,A0
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,_Global_HANDLE_PREVUE_FONT
    ; If we couldn't open the font, jump.
    TST.L   D0
    BNE.S   .loadedFonts

    ; Fall back to the topaz font.
    MOVE.L  _Global_HANDLE_TOPAZ_FONT,_Global_HANDLE_PREVUE_FONT

.loadedFonts:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     623.W
    PEA     _Global_STR_ESQ_C_1
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_RASTPORT_1  ; D0 is the allocated memory, storing its reference in _Global_REF_RASTPORT_1
    MOVEA.L D0,A1                   ; Store the address of D0 into A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)    ; In the memory we have, initialize a RastPort struct

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)  ; #_Global_REF_696_400_BITMAP into address of the rastport #1 bitmap

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #68,D0
    MOVE.W  D0,_WDISP_HighlightRasterHeightPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     _ESQIFF_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .adjust_rastport_text_spacing

    MOVE.W  _WDISP_HighlightRasterHeightPx,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_WDISP_HighlightRasterHeightPx

.adjust_rastport_text_spacing:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     645.W
    PEA     _Global_STR_ESQ_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_RASTPORT_2
    MOVEA.L D0,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L _Global_REF_RASTPORT_2,A0
    MOVE.L  #_Global_REF_320_240_BITMAP,4(A0)      ; #_Global_REF_320_240_BITMAP into _Global_REF_RASTPORT_2.BitMap

    MOVEA.L _Global_REF_RASTPORT_2,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D5

.init_rastport1_rows_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .init_bitmap_320_240

    MOVE.L  D5,D0
    MULS    #40,D0
    LEA     _ESQDISP_HighlightBitmapTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    JSR     _ESQDISP_AllocateHighlightBitmaps(PC)

    ADDQ.W  #4,A7
    ADDQ.W  #1,D5
    BRA.S   .init_rastport1_rows_loop

.init_bitmap_320_240:
    LEA     _Global_REF_320_240_BITMAP,A0     ; BitMap struct pointer
    MOVEQ   #4,D0           ; depth: 4 bitplanes or 16 colors (2 ^ 4) into D0
    MOVE.L  #352,D1         ; width: 352 into D1
    MOVEQ   #120,D2         ; height: 120 into D2
    ADD.L   D2,D2           ; ...becomes 240 into D2
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.GRAPHICS_AllocRasters_352x240_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .select_clock_format_table

    MOVE.L  D5,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _WDISP_352x240RasterPtrTable,A0
    ADDA.L  D1,A0

    PEA     240.W                       ; Height
    PEA     352.W                       ; Width
    PEA     668.W                       ; Line Number
    PEA     _Global_STR_ESQ_C_3            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _WDISP_352x240RasterPtrTable,A0
    ADDA.L  D0,A0

    MOVEA.L (A0),A1         ; memBlock
    MOVE.L  #10560,D0       ; byte count
    MOVEQ   #0,D1           ; flags
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_352x240_loop

.select_clock_format_table:
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .use12HourClock

    LEA     _Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .store_clock_format_table

.use12HourClock:
    LEA     _Global_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.store_clock_format_table:
    MOVE.L  A0,_Global_REF_STR_CLOCK_FORMAT

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     34.W
    PEA     683.W
    PEA     _Global_STR_ESQ_C_4
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_ESQ_HighlightMsgPort
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L _ESQ_HighlightMsgPort,A0
    CLR.B   9(A0)
    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L _ESQ_HighlightMsgPort,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AM_JMPTBL_LIST_InitHeader(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     34.W
    PEA     698.W
    PEA     _Global_STR_ESQ_C_5
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_ESQ_HighlightReplyPort
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   10(A0)
    MOVEA.L _ESQ_HighlightReplyPort,A0
    CLR.B   9(A0)
    MOVEA.L _ESQ_HighlightReplyPort,A0
    MOVE.B  #$4,8(A0)
    MOVEA.L _ESQ_HighlightReplyPort,A0
    MOVE.B  #$2,14(A0)
    MOVEA.L _ESQ_HighlightReplyPort,A0
    ADDA.W  #20,A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AM_JMPTBL_LIST_InitHeader(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.init_entry_tables_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D5
    BGE.S   .after_entry_tables

    MOVE.L  D5,D0
    MULS    #$a0,D0
    LEA     _GCOMMAND_HighlightMessageSlotTable,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    MULS    #$28,D0
    LEA     _ESQDISP_HighlightBitmapTable,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQDISP_QueueHighlightDrawMessage(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D5
    BRA.S   .init_entry_tables_loop

.after_entry_tables:
    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.W   _WDISP_HighlightBufferMode
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  20(A0),D0
    MOVEQ   #34,D1
    CMP.W   D1,D0
    BCS.S   .check_graphics_version

    MOVE.W  #1,_WDISP_HighlightBufferMode

.check_graphics_version:
    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #1750000,D0
    BLE.S   .check_available_mem

    MOVE.W  #2,_WDISP_HighlightBufferMode

.check_available_mem:
    JSR     _GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage(PC)

    TST.L   D0
    BNE.W   .return

    JSR     _GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard(PC)

    MOVE.L  #_CLOCK_DaySlotIndex,_CLOCK_DaySlotIndexPtr
    MOVE.L  #_CLOCK_CurrentDayOfWeekIndex,_CLOCK_CurrentDayOfWeekIndexPtr
    MOVEQ   #0,D0
    MOVE.W  D0,_DST_PrimaryCountdown
    MOVE.W  D0,_DST_SecondaryCountdown
    JSR     _GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc(PC)

    JSR     _DST_RefreshBannerBuffer(PC)

    CLR.W   _SCRIPT_CtrlInterfaceEnabledFlag
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
    LEA     _Global_STR_CART,A1

.compare_cart_string_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_cart_arg

    TST.B   D1
    BNE.S   .compare_cart_string_loop

    BNE.S   .next_cart_arg

    MOVE.W  #1,_SCRIPT_CtrlInterfaceEnabledFlag

; it looks like this tests a value to determine if we can spin up
; to a specific baud rate or if we should just jump down to 2400.
.next_cart_arg:
    ADDQ.W  #1,D5
    BRA.S   .scan_cart_args_loop

.select_baud_rate:
    ; Serial device speed gate for the standard ingest path.
    ; Accepted runtime values here are 2400/4800/9600; other values clamp to 2400.
    ; The downstream parser/record handlers are shared regardless of which accepted
    ; baud is selected (see _ESQPARS_ConsumeRbfByteAndDispatchCommand and ESQIFF2_ReadRbfBytes*).
    MOVEQ   #2,D0
    CMP.L   D0,D7

    BLE.S   .setBaudRateTo2400

    MOVE.L  8(A3),-(A7)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_Global_REF_BAUD_RATE
    CMPI.L  #2400,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #4800,D0
    BEQ.S   .after_baud_rate

    CMPI.L  #9600,D0
    BEQ.S   .after_baud_rate

    MOVE.L  #2400,D0
    MOVE.L  D0,_Global_REF_BAUD_RATE
    BRA.S   .after_baud_rate

.setBaudRateTo2400:
    MOVE.L  #2400,_Global_REF_BAUD_RATE

.after_baud_rate:
    ; Startup then opens serial.device and enables RBF/AUD1 interrupt service.
    ; Custom protocol experiments that still want the normal 2400 command/data
    ; decode path should continue feeding bytes into this same serial/RBF chain.
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; flags
    PEA     9000.W                              ; 9000 bytes
    PEA     854.W                               ; line number?
    PEA     _Global_STR_ESQ_C_6
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,_ESQIFF_RecordBufferPtr
    CLR.L   (A7)
    PEA     _Global_STR_SERIAL_READ
    JSR     _GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    LEA     20(A7),A7
    MOVE.L  D0,_WDISP_SerialMessagePortPtr
    BEQ.W   .return

    PEA     82.W
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AM_JMPTBL_STRUCT_AllocWithOwner(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_WDISP_SerialIoRequestPtr
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A1                       ; ioRequest
    LEA     _Global_STR_SERIAL_DEVICE,A0   ; devName
    MOVEQ   #0,D0                       ; unit number
    MOVE.L  D0,D1                       ; flags
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6                       ; Copy D0 into D6
    TST.L   D6                          ; Test D6 to see if it's 0 (failed)
    BNE.W   .return                     ; Branch if unable to open serial device

    MOVEA.L _WDISP_SerialIoRequestPtr,A0
    MOVE.B  #16,79(A0)
    MOVEA.L _WDISP_SerialIoRequestPtr,A0
    MOVE.L  _Global_REF_BAUD_RATE,60(A0)
    MOVEA.L _WDISP_SerialIoRequestPtr,A0
    MOVE.W  #11,28(A0)
    MOVEA.L _WDISP_SerialIoRequestPtr,A1
    JSR     _LVODoIO(A6)

    JSR     _SETUP_INTERRUPT_INTB_RBF(PC)

    JSR     _SETUP_INTERRUPT_INTB_AUD1(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_InitAudio1Dma(PC)

    JSR     _GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext(PC)

    JSR     _GROUP_AM_JMPTBL_KYBD_InitializeInputDevices(PC)

    JSR     _ESQFUNC_AllocateLineTextBuffers(PC)

    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     96.W                            ; Bytes to Allocate
    PEA     984.W                           ; Line Number
    PEA     _Global_STR_ESQ_C_7                ; Calling File
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_96_BYTES_ALLOCATED                     ; whatever was allocated above

    LEA     _Global_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0       ; 3 bitplanes
    MOVE.L  #696,D1     ; 696 w
    MOVE.L  #400,D2     ; 400 h
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    LEA     _Global_REF_696_241_BITMAP,A0
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
    LEA     _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0

    PEA     509.W                       ; Height
    PEA     696.W                       ; Width
    PEA     991.W                       ; Line Number
    PEA     _Global_STR_ESQ_C_8            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$aef8,D0
    MOVEQ   #0,D1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x509_loop

.seed_raster_aliases:
    ; Preserve original 696x509 raster bases for display/scratch reuse.
    MOVE.L  _WDISP_BannerRowScratchRasterTable0,_ESQSHARED_BannerRowScratchRasterBase0
    MOVE.L  _WDISP_BannerRowScratchRasterTable1,_ESQSHARED_BannerRowScratchRasterBase1
    MOVE.L  _WDISP_BannerRowScratchRasterTable2,_ESQSHARED_BannerRowScratchRasterBase2
    MOVEQ   #0,D5

.seed_raster_offsets_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .begin_GRAPHICS_AllocRasters_696x241

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0
    LEA     _WDISP_BannerRowScratchRasterTable0,A1
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
    LEA     _WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0

    PEA     241.W                       ; Height
    PEA     696.W                       ; Width
    PEA     1008.W                      ; Line Number
    PEA     _Global_STR_ESQ_C_9            ; Calling File
    MOVE.L  A0,44(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #$52d8,D0
    MOVEQ   #0,D1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x241_loop

.init_main_rastport:
    MOVE.L  _WDISP_DisplayContextPlanePointer0,_ESQSHARED_DisplayContextPlaneBase0
    MOVE.L  _WDISP_DisplayContextPlanePointer1,_ESQSHARED_DisplayContextPlaneBase1
    MOVE.L  _WDISP_DisplayContextPlanePointer2,_ESQSHARED_DisplayContextPlaneBase2
    MOVE.L  _WDISP_DisplayContextPlanePointer3,_ESQSHARED_DisplayContextPlaneBase3
    MOVE.L  _WDISP_DisplayContextPlanePointer4,_ESQSHARED_DisplayContextPlaneBase4
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  52(A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    PEA     3.W
    CLR.L   -(A7)
    PEA     2.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    LEA     _WDISP_BannerGridBitmapStruct,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEQ   #2,D2
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D5

.GRAPHICS_AllocRasters_696x2_loop:
    MOVEQ   #3,D0
    CMP.W   D0,D5
    BGE.S   .after_raster_setup

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _WDISP_LivePlaneRasterTable0,A0
    ADDA.L  D0,A0

    PEA     2.W                         ; Height
    PEA     696.W                       ; Width
    PEA     1027.W                      ; Line Number
    PEA     _Global_STR_ESQ_C_10           ; Calling file
    MOVE.L  A0,44(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L 28(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0

    LEA     _WDISP_LivePlaneRasterTable0,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    MOVEQ   #0,D1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.W  #1,D5
    BRA.S   .GRAPHICS_AllocRasters_696x2_loop

.after_raster_setup:
    ; Snapshot currently live 696x2 plane bases for ESQSHARED copy paths.
    MOVE.L  _WDISP_LivePlaneRasterTable0,_ESQSHARED_LivePlaneBase0
    MOVE.L  _WDISP_LivePlaneRasterTable1,_ESQSHARED_LivePlaneBase1
    MOVE.L  _WDISP_LivePlaneRasterTable2,_ESQSHARED_LivePlaneBase2

    PEA     15.W                        ; Height
    PEA     696.W                       ; Width
    PEA     1038.W                      ; Line Number
    PEA     _Global_STR_ESQ_C_11           ; Calling file
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    MOVE.L  D0,_WDISP_BannerWorkRasterPtr
    CLR.W   _WDISP_AccumulatorFlushPending
    CLR.L   _NEWGRID_RefreshStateFlag
    MOVEQ   #-1,D0
    MOVE.L  D0,_NEWGRID_MessagePumpSuspendFlag
    JSR     _GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .init_global_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQFUNC_UpdateRefreshModeState(PC)

    ADDQ.W  #8,A7

.init_global_state:
    JSR     _ESQSHARED4_InitializeBannerCopperSystem(PC)

    JSR     _GROUP_AM_JMPTBL_TLIBA3_InitPatternTable(PC)

    JSR     _SETUP_INTERRUPT_INTB_VERTB(PC)

    ; This is just clearing out a BUNCH of variables to zero or whatever
    ; default value it uses.
    MOVEQ   #0,D0
    MOVE.W  D0,_Global_UIBusyFlag
    MOVE.W  D0,_ESQ_StartupStateWord2203
    MOVE.W  D0,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.W  D0,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.W  D0,_ESQ_TickModulo60Counter
    MOVE.W  D0,_ESQ_StartupWriteOnlyWord2271
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVE.W  D0,_SCRIPT_CtrlCmdCount
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVE.W  D0,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.W  D0,_ESQIFF_GAdsListLineIndex
    MOVE.W  D0,_ESQIFF_LogoListLineIndex
    MOVE.W  D0,_ESQIFF_StatusPacketReadyFlag
    MOVE.W  D0,_TEXTDISP_GroupMutationState
    MOVE.W  D0,_ESQ_SerialRbfFillLevel
    MOVE.W  D0,_Global_WORD_MAX_VALUE
    MOVE.W  D0,_Global_WORD_T_VALUE
    MOVE.W  D0,_Global_WORD_H_VALUE
    MOVE.W  D0,_CLEANUP_PendingAlertFlag
    MOVE.W  D0,_CTRL_BufferedByteCount
    MOVE.W  D0,_CTRL_HDeltaMax
    MOVE.W  D0,_CTRL_HPreviousSample
    MOVE.W  D0,_CTRL_H
    MOVE.W  D0,_ESQ_SerialRbfErrorCount
    MOVE.W  D0,_DATACErrs
    MOVE.W  D0,_SCRIPT_CtrlCmdChecksumErrorCount
    MOVE.W  D0,_ESQIFF_LineErrorCount
    MOVE.W  D0,_SCRIPT_CtrlCmdLengthErrorCount
    MOVE.W  D0,_ESQPARS_CommandPreambleArmedFlag
    MOVE.W  D0,_ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,_WDISP_BannerCharPhaseShift
    MOVE.W  D0,_ESQPARS_SelectionMatchCode
    MOVE.W  D0,_ESQPARS_ResetArmedFlag
    MOVEQ   #0,D1
    MOVE.B  D1,_ESQIFF_UseCachedChecksumFlag
    MOVE.B  D1,_TEXTDISP_SecondaryGroupRecordChecksum
    MOVE.B  D1,_TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.B  D1,_TEXTDISP_SecondaryGroupPresentFlag
    MOVE.B  D1,_TEXTDISP_PrimaryGroupCode
    MOVE.B  #$1,_TEXTDISP_SecondaryGroupCode
    MOVE.W  #7,_ESQ_StartupPhaseSeed225E
    MOVE.W  #2,_CLOCK_HalfHourSlotIndex
    MOVE.W  D0,_SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,_PARSEINI_CtrlHChangeGateFlag
    MOVE.W  #$ff,_SCRIPT_CTRL_CHECKSUM
    JSR     _ESQIFF_RestoreBasePaletteTriples(PC)

    JSR     _ESQIFF_RunCopperDropTransition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rect from 0,0 to 695,399
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_241_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1

    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a rectangle from 0,0 to 120,120
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #120,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     _DISKIO_ErrorMessageScratch
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    JSR     _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

    LEA     12(A7),A7
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   _DISKIO_DriveWriteProtectStatusCodeDrive1,D0
    BNE.S   .format_version_banner

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     _ESQ_STR_NO_DF1_PRESENT
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

; Fill out "Ver %s.%ld Build %ld %s"
.format_version_banner:
    ; Formatting depends on mutable build-id/version strings and destination size.
    ; _WDISP_SPrintf has no destination-length parameter.
    ; Current format literal contributes 13 fixed chars; remaining budget is
    ; shared across %s/%ld/%ld/%s substitutions.
    ; Current configured render: "Ver 9.0.4 Build 21 JGT" (22 chars + NUL).
    ; _ESQ_StartupVersionBannerBuffer capacity is 80 bytes => current headroom 57.
    ; With signed-32 worst-case %ld fields and current %s inputs, usage is
    ; 41 chars + NUL (headroom 38). Under current major/minor width, final
    ; build-id text above 41 chars would drop below a 16-byte safety margin.
    MOVE.L  _Global_PTR_STR_BUILD_ID,-(A7)             ; JGT
    MOVE.L  _Global_LONG_BUILD_NUMBER,-(A7)            ; 21
    MOVE.L  _Global_LONG_PATCH_VERSION_NUMBER,-(A7)    ; 4
    PEA     _Global_STR_MAJOR_MINOR_VERSION            ; 9.0
    PEA     _Global_STR_GUIDE_START_VERSION_AND_BUILD
    PEA     _ESQ_StartupVersionBannerBuffer
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     _ESQ_STR_38_Spaces,A0
    LEA     _DISKIO_ErrorMessageScratch,A1
    MOVEQ   #9,D0

; Copy 40 bytes (10 longwords) from _ESQ_STR_38_Spaces into a 41-byte scratch.
; Current _ESQ_STR_38_Spaces length is 39 chars + NUL = 40 bytes.
; If that source string shrinks, this fixed-size copy can pull adjacent data.
.copy_version_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_version_template_loop

    JSR     _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(PC)

    JSR     _GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults(PC)

    PEA     _Global_STR_DF0_GRADIENT_INI_2
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     _GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     60.W
    ; Also displays select-code text copied from argv[1] earlier.
    PEA     _ESQ_SelectCodeBuffer
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     90.W
    PEA     _ESQ_StartupVersionBannerBuffer
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     _ESQ_STR_SystemInitializing
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     _ESQ_STR_PleaseStandByEllipsis
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     76(A7),A7
    TST.W   _IS_COMPATIBLE_VIDEO_CHIP
    BNE.S   .check_memory_and_video_caps

    TST.W   _HAS_REQUESTED_FAST_MEMORY
    BEQ.W   .continue_startup

.check_memory_and_video_caps:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     180.W
    PEA     _ESQ_STR_AttentionSystemEngineer
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    TST.W   _HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .maybe_show_compat_note

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     210.W
    PEA     _ESQ_STR_ReportErrorCodeEr011ToTVGuide
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.maybe_show_compat_note:
    TST.W   _IS_COMPATIBLE_VIDEO_CHIP
    BEQ.S   .init_compat_wait

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    TST.W   _HAS_REQUESTED_FAST_MEMORY
    BEQ.S   .select_compat_note_y_no_fastmem

    MOVEQ   #120,D0
    ADD.L   D0,D0
    BRA.S   .draw_compat_note

.select_compat_note_y_no_fastmem:
    MOVEQ   #105,D0
    ADD.L   D0,D0

.draw_compat_note:
    MOVE.L  D0,-(A7)
    PEA     _ESQ_STR_ReportErrorCodeER012ToTVGuide
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.init_compat_wait:
    JSR     _ESQIFF_RunCopperRiseTransition(PC)

.compat_halt_loop:
    BRA.S   .compat_halt_loop

.continue_startup:
    JSR     _ESQIFF_RunCopperRiseTransition(PC)

    JSR     _GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries(PC)

    JSR     _GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries(PC)

    JSR     _DISKIO2_ReloadDataFilesAndRebuildIndex(PC)

    JSR     _GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk(PC)

    JSR     _GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig(PC)

    PEA     _Global_STR_DF0_DEFAULT_INI_1
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     _Global_STR_DF0_BRUSH_INI_1
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     _ESQIFF_BrushIniListHead
    MOVE.L  _PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     _ESQ_STR_DT
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     20(A7),A7
    TST.L   _BRUSH_SelectedNode
    BNE.S   .ensure_brush_selected

    PEA     _ESQIFF_BrushIniListHead
    PEA     _ESQ_STR_DITHER
    JSR     _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_BRUSH_SelectedNode

.ensure_brush_selected:
    PEA     _ESQIFF_BrushIniListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,_ESQFUNC_FallbackType3BrushNode
    JSR     _ESQFUNC_RebuildPwBrushListFromTagTable(PC)

    PEA     _Global_STR_DF0_BANNER_INI_1
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    JSR     _GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates(PC)

    JSR     _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(PC)

    JSR     _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    MOVE.W  #1,_ESQ_StartupWriteOnlyLong2272
    MOVE.W  _WDISP_BannerCharRangeStart,_WDISP_BannerCharIndex
    CLR.L   (A7)
    PEA     4095.W
    JSR     _ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVE.W  #$8100,INTENA
    JSR     _GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds(PC)

    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    JSR     _GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile(PC)

    SUBA.L  A0,A0
    MOVE.L  A0,_DST_BannerWindowPrimary
    MOVE.L  A0,_DST_BannerWindowSecondary
    PEA     _DST_BannerWindowPrimary
    JSR     _DST_LoadBannerPairFromFiles(PC)

    CLR.W   _Global_RefreshTickCounter
    JSR     _ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    LEA     32(A7),A7
    CLR.L   _ESQDISP_DisplayActiveFlag
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
    LEA     _ESQ_TAG_GRANADA,A1

.compare_startup_flag_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .next_startup_flag

    TST.B   D1
    BNE.S   .compare_startup_flag_loop

    BNE.S   .next_startup_flag

    MOVEQ   #1,D0
    MOVE.L  D0,_ESQDISP_DisplayActiveFlag

.next_startup_flag:
    ADDQ.W  #1,D5
    BRA.S   .scan_startup_flags_loop

.after_startup_flag_scan:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    ; Clear out these values
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQ_SerialRbfFillLevel
    MOVE.W  D0,_Global_WORD_MAX_VALUE
    MOVE.W  D0,_Global_WORD_T_VALUE
    MOVE.W  D0,_Global_WORD_H_VALUE
    JSR     _LVOEnable(A6)

    CLR.W   _ESQIFF_ExternalAssetFlags
    CLR.L   -(A7)
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D5

.clear_schedule_table_loop:
    CMPI.W  #$12e,D5
    BGE.S   .after_schedule_table_clear

    MOVE.L  D5,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     _CLEANUP_AlignedStatusEntryCycleTable,A0
    ADDA.L  D0,A0
    CLR.W   (A0)
    ADDQ.W  #1,D5
    BRA.S   .clear_schedule_table_loop

.after_schedule_table_clear:
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .after_ravesc_banner

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.after_ravesc_banner:
    MOVE.W  #1,_ESQ_MainLoopUiTickEnabledFlag

.main_idle_loop:
    JSR     _ESQFUNC_ServiceUiTickIfRunning(PC)

    JSR     _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(PC)

    TST.W   D0
    BEQ.S   .check_exit_condition

    TST.W   _ESQ_ShutdownRequestedFlag
    BNE.S   .check_exit_condition

    JSR     _ESQPARS_ConsumeRbfByteAndDispatchCommand(PC)

.check_exit_condition:
    TST.W   _ESQ_ShutdownRequestedFlag
    BEQ.S   .main_idle_loop

.return:
    JSR     _GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem(PC)

    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
