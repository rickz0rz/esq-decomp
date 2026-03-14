#include <exec/libraries.h>
#include <exec/ports.h>
#include <graphics/rastport.h>

typedef struct ESQ_Task {
    UBYTE pad0[184];
    LONG windowPtr;
} ESQ_Task;

typedef struct ESQ_SerialIORequest {
    UBYTE pad0[28];
    UWORD command;
    UBYTE pad30[30];
    LONG baudRate;
    UBYTE pad64[15];
    UBYTE flags79;
} ESQ_SerialIORequest;

typedef struct ESQ_LayerData {
    UBYTE pad0[53];
    UBYTE flags53;
    UBYTE pad54;
    UBYTE flag55;
} ESQ_LayerData;

enum {
    MEMF_PUBLIC = 1,
    MEMF_CLEAR = 0x10000,
    DISPLAY_RASTPORT2_DELTA = -458
};

extern void *AbsExecBase;

extern UBYTE ESQ_SelectCodeBuffer[];
extern UWORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_DOS_LIBRARY;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_DISKFONT_LIBRARY;
extern void *Global_REF_INTUITION_LIBRARY;
extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;
extern void *Global_HANDLE_TOPAZ_FONT;
extern void *Global_HANDLE_PREVUEC_FONT;
extern void *Global_HANDLE_H26F_FONT;
extern void *Global_HANDLE_PREVUE_FONT;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct RastPort *Global_REF_RASTPORT_2;
extern void *Global_REF_STR_CLOCK_FORMAT;
extern struct MsgPort *ESQ_HighlightMsgPort;
extern struct MsgPort *ESQ_HighlightReplyPort;
extern UWORD WDISP_HighlightBufferMode;
extern UWORD WDISP_HighlightRasterHeightPx;
extern void *WDISP_352x240RasterPtrTable[];
extern void *WDISP_BannerRowScratchRasterTable0;
extern void *WDISP_BannerRowScratchRasterTable1;
extern void *WDISP_BannerRowScratchRasterTable2;
extern void *WDISP_LivePlaneRasterTable0;
extern void *WDISP_LivePlaneRasterTable1;
extern void *WDISP_LivePlaneRasterTable2;
extern void *WDISP_DisplayContextPlanePointer0;
extern void *WDISP_DisplayContextPlanePointer1;
extern void *WDISP_DisplayContextPlanePointer2;
extern void *WDISP_DisplayContextPlanePointer3;
extern void *WDISP_DisplayContextPlanePointer4;
extern LONG WDISP_DisplayContextBase;
extern void *WDISP_BannerWorkRasterPtr;
extern UWORD SCRIPT_CtrlInterfaceEnabledFlag;
extern void *ESQIFF_RecordBufferPtr;
extern void *ESQSHARED_BannerRowScratchRasterBase0;
extern void *ESQSHARED_BannerRowScratchRasterBase1;
extern void *ESQSHARED_BannerRowScratchRasterBase2;
extern void *ESQSHARED_DisplayContextPlaneBase0;
extern void *ESQSHARED_DisplayContextPlaneBase1;
extern void *ESQSHARED_DisplayContextPlaneBase2;
extern void *ESQSHARED_DisplayContextPlaneBase3;
extern void *ESQSHARED_DisplayContextPlaneBase4;
extern void *ESQSHARED_LivePlaneBase0;
extern void *ESQSHARED_LivePlaneBase1;
extern void *ESQSHARED_LivePlaneBase2;
extern LONG Global_REF_BAUD_RATE;
extern void *WDISP_SerialIoRequestPtr;
extern void *WDISP_SerialMessagePortPtr;
extern void *Global_REF_96_BYTES_ALLOCATED;
extern LONG WDISP_ExecBaseHookPtr;
extern LONG ESQ_ProcessWindowPtrBackup;
extern LONG Global_LONG_ROM_VERSION_CHECK;
extern UWORD DST_PrimaryCountdown;
extern UWORD DST_SecondaryCountdown;
extern UWORD SCRIPT_CTRL_CHECKSUM;
extern UWORD SCRIPT_CTRL_READ_INDEX;
extern UWORD PARSEINI_CtrlHChangeGateFlag;
extern UWORD Global_UIBusyFlag;
extern UWORD ESQ_StartupStateWord2203;
extern UWORD TEXTDISP_SecondaryGroupRecordLength;
extern UWORD TEXTDISP_PrimaryGroupRecordLength;
extern UWORD ESQ_TickModulo60Counter;
extern UWORD ESQ_StartupWriteOnlyWord2271;
extern UWORD ESQIFF_ParseAttemptCount;
extern UWORD SCRIPT_CtrlCmdCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD ESQIFF_GAdsListLineIndex;
extern UWORD ESQIFF_LogoListLineIndex;
extern UWORD ESQIFF_StatusPacketReadyFlag;
extern UWORD TEXTDISP_GroupMutationState;
extern UWORD ESQ_SerialRbfFillLevel;
extern UWORD Global_WORD_MAX_VALUE;
extern UWORD Global_WORD_T_VALUE;
extern UWORD Global_WORD_H_VALUE;
extern UWORD CLEANUP_PendingAlertFlag;
extern UWORD CTRL_BufferedByteCount;
extern UWORD CTRL_HDeltaMax;
extern UWORD CTRL_HPreviousSample;
extern UWORD CTRL_H;
extern UWORD ESQ_SerialRbfErrorCount;
extern UWORD DATACErrs;
extern UWORD SCRIPT_CtrlCmdChecksumErrorCount;
extern UWORD ESQIFF_LineErrorCount;
extern UWORD SCRIPT_CtrlCmdLengthErrorCount;
extern UWORD ESQPARS_CommandPreambleArmedFlag;
extern UWORD ESQPARS_Preamble55SeenFlag;
extern UWORD WDISP_BannerCharPhaseShift;
extern UWORD ESQPARS_SelectionMatchCode;
extern UWORD ESQPARS_ResetArmedFlag;
extern UBYTE ESQIFF_UseCachedChecksumFlag;
extern UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
extern UBYTE TEXTDISP_PrimaryGroupRecordChecksum;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UWORD ESQ_StartupPhaseSeed225E;
extern UWORD CLOCK_HalfHourSlotIndex;
extern UWORD ESQ_StartupWriteOnlyLong2272;
extern UWORD WDISP_BannerCharRangeStart;
extern UWORD WDISP_BannerCharIndex;
extern UWORD IS_COMPATIBLE_VIDEO_CHIP;
extern UWORD HAS_REQUESTED_FAST_MEMORY;
extern void *BRUSH_SelectedNode;
extern void *ESQFUNC_FallbackType3BrushNode;
extern UWORD WDISP_AccumulatorFlushPending;
extern LONG NEWGRID_RefreshStateFlag;
extern LONG NEWGRID_MessagePumpSuspendFlag;
extern UWORD ESQIFF_ExternalAssetFlags;
extern UWORD ESQ_MainLoopUiTickEnabledFlag;
extern UWORD ESQ_ShutdownRequestedFlag;
extern LONG ESQDISP_DisplayActiveFlag;
extern UWORD Global_RefreshTickCounter;
extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern LONG CLOCK_DaySlotIndexPtr;
extern LONG CLOCK_CurrentDayOfWeekIndexPtr;
extern UWORD ESQIFF_ExternalAssetFlags;

extern UWORD CLOCK_DaySlotIndex;
extern UWORD CLOCK_CurrentDayOfWeekIndex;

extern UBYTE Global_REF_696_400_BITMAP;
extern UBYTE Global_REF_320_240_BITMAP;
extern UBYTE Global_REF_696_241_BITMAP;
extern UBYTE WDISP_BannerGridBitmapStruct;
extern UBYTE GCOMMAND_HighlightMessageSlotTable[];
extern UBYTE ESQDISP_HighlightBitmapTable[];
extern UWORD CLEANUP_AlignedStatusEntryCycleTable[];

extern char DISKIO_ErrorMessageScratch[];
extern char ESQ_StartupVersionBannerBuffer[];
extern const char Global_STR_RAVESC[];
extern const char Global_STR_COPY_NIL_ASSIGN_RAM[];
extern const char Global_STR_GRAPHICS_LIBRARY[];
extern const char Global_STR_DISKFONT_LIBRARY[];
extern const char Global_STR_DOS_LIBRARY[];
extern const char Global_STR_INTUITION_LIBRARY[];
extern const char Global_STR_UTILITY_LIBRARY[];
extern const char Global_STR_BATTCLOCK_RESOURCE[];
extern const char Global_STR_SERIAL_READ[];
extern const char Global_STR_SERIAL_DEVICE[];
extern const char Global_STR_DF0_GRADIENT_INI_2[];
extern const char Global_STR_DF0_DEFAULT_INI_1[];
extern const char Global_STR_DF0_BRUSH_INI_1[];
extern const char Global_STR_DF0_BANNER_INI_1[];
extern const char Global_STR_GUIDE_START_VERSION_AND_BUILD[];
extern const char Global_STR_MAJOR_MINOR_VERSION[];
extern const char Global_STR_ESQ_C_1[];
extern const char Global_STR_ESQ_C_2[];
extern const char Global_STR_ESQ_C_3[];
extern const char Global_STR_ESQ_C_4[];
extern const char Global_STR_ESQ_C_5[];
extern const char Global_STR_ESQ_C_6[];
extern const char Global_STR_ESQ_C_7[];
extern const char Global_STR_ESQ_C_8[];
extern const char Global_STR_ESQ_C_9[];
extern const char Global_STR_ESQ_C_10[];
extern const char Global_STR_ESQ_C_11[];
extern const char ESQ_STR_NO_DF1_PRESENT[];
extern const char ESQ_STR_38_Spaces[];
extern const char ESQ_STR_SystemInitializing[];
extern const char ESQ_STR_PleaseStandByEllipsis[];
extern const char ESQ_STR_AttentionSystemEngineer[];
extern const char ESQ_STR_ReportErrorCodeEr011ToTVGuide[];
extern const char ESQ_STR_ReportErrorCodeER012ToTVGuide[];
extern const char ESQ_STR_DT[];
extern const char ESQ_STR_DITHER[];
extern const char ESQ_TAG_GRANADA[];
extern const char *Global_PTR_STR_BUILD_ID;
extern LONG Global_LONG_BUILD_NUMBER;
extern LONG Global_LONG_PATCH_VERSION_NUMBER;

extern void *Global_STRUCT_TEXTATTR_TOPAZ_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUEC_FONT;
extern void *Global_STRUCT_TEXTATTR_H26F_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUE_FONT;
extern void *PARSEINI_ParsedDescriptorListHead;
extern void *ESQIFF_BrushIniListHead;

extern LONG _LVOExecute(void *dosBase, const char *command, LONG input, LONG output);
extern void * _LVOFindTask(void *execBase, void *taskName);
extern void * _LVOOpenLibrary(void *execBase, const char *name, LONG version);
extern void * _LVOOpenResource(void *execBase, const char *name);
extern void * _LVOOpenFont(void *graphicsBase, void *textAttr);
extern void * _LVOOpenDiskFont(void *diskfontBase, void *textAttr);
extern void _LVOInitRastPort(void *graphicsBase, void *rastPort);
extern void _LVOSetFont(void *graphicsBase, void *rastPort, void *font);
extern void _LVOInitBitMap(void *graphicsBase, void *bitmap, LONG depth, LONG width, LONG height);
extern LONG _LVOAvailMem(void *execBase, LONG requirements);
extern LONG _LVOOpenDevice(void *execBase, const char *name, LONG unit, LONG ioRequest, LONG flags);
extern LONG _LVODoIO(void *execBase, void *ioRequest);
extern void _LVOSetAPen(void *graphicsBase, void *rastPort, LONG pen);
extern void _LVORectFill(void *graphicsBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void _LVOSetBPen(void *graphicsBase, void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *graphicsBase, void *rastPort, LONG mode);
extern void _LVOBltClear(void *graphicsBase, void *memory, LONG byteCount, LONG flags);
extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);

extern void *MEMORY_AllocateMemory(LONG bytes, LONG flags);
extern LONG MATH_DivS32(LONG value, LONG divisor);
extern void *GRAPHICS_AllocRaster(LONG width, LONG height);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG arg1, LONG arg2);
extern void BRUSH_PopulateBrushList(void *descriptorHead, void **listHead);
extern void BRUSH_SelectBrushByLabel(const char *label);
extern void *BRUSH_FindBrushByPredicate(const void *label, void *listHead);
extern void *BRUSH_FindType3Brush(void *listHead);

extern LONG BUFFER_FlushAllAndCloseWithCode(LONG code);
extern void OVERRIDE_INTUITION_FUNCS(void);
extern void LIST_InitHeader(void *list);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern LONG ESQ_FormatDiskErrorMessage(void);
extern void ESQ_CheckAvailableFastMemory(void);
extern void ESQ_CheckCompatibleVideoChip(void);
extern void ESQ_CheckTopazFontGuard(void);
extern void PARSEINI_UpdateClockFromRtc(void);
extern void *SIGNAL_CreateMsgPortWithSignal(const char *name, LONG signal);
extern void *STRUCT_AllocWithOwner(void *owner, LONG size);
extern void ESQ_InitAudio1Dma(void);
extern void SCRIPT_InitCtrlContext(void);
extern void KYBD_InitializeInputDevices(void);
extern LONG DISKIO_LoadConfigFromDisk(void);
extern void TLIBA3_InitPatternTable(void);
extern void WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void SCRIPT_PrimeBannerTransitionFromHexCode(void);
extern void GCOMMAND_InitPresetDefaults(void);
extern void GCOMMAND_ResetBannerFadeState(void);
extern void LADFUNC_AllocBannerRectEntries(void);
extern void LADFUNC_ClearBannerRectEntries(void);
extern void DISKIO2_ParseIniFileFromDisk(void);
extern void TEXTDISP_LoadSourceConfig(void);
extern void FLIB2_ResetAndLoadListingTemplates(void);
extern LONG LADFUNC_LoadTextAdsFromFile(void);
extern void P_TYPE_ResetListsAndLoadPromoIds(void);
extern void LOCAVAIL_ResetFilterStateStruct(void *state);
extern LONG LOCAVAIL_LoadAvailabilityDataFile(void *primary, void *secondary);

extern void ESQDISP_AllocateHighlightBitmaps(void *entry);
extern void ESQDISP_QueueHighlightDrawMessage(void *slot, void *bitmap);
extern void ESQFUNC_AllocateLineTextBuffers(void);
extern void ESQFUNC_UpdateRefreshModeState(LONG arg0, LONG arg1);
extern void ESQSHARED4_InitializeBannerCopperSystem(void);
extern void SETUP_INTERRUPT_INTB_VERTB(void);
extern void SETUP_INTERRUPT_INTB_RBF(void);
extern void SETUP_INTERRUPT_INTB_AUD1(void);
extern void DST_RefreshBannerBuffer(void);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void TLIBA3_DrawCenteredWrappedTextLines(void *rastPort, const char *text, LONG y);
extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern void LADFUNC_UpdateHighlightState(void);
extern void ESQDISP_UpdateStatusMaskAndRefresh(LONG mask, LONG arg1);
extern void DST_LoadBannerPairFromFiles(void **pairPtr);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern void TEXTDISP_SetRastForMode(LONG mode);
extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG PARSEINI_MonitorClockChange(void);
extern void ESQPARS_ConsumeRbfByteAndDispatchCommand(void);
extern LONG CLEANUP_ShutdownSystem(void);
extern void DISKIO2_ReloadDataFilesAndRebuildIndex(void);

extern LONG DISKIO_DriveWriteProtectStatusCodeDrive1;
extern void *LOCAVAIL_PrimaryFilterState;
extern void *LOCAVAIL_SecondaryFilterState;
extern void *DST_BannerWindowPrimary;
extern void *DST_BannerWindowSecondary;
extern volatile UWORD INTENA;

LONG ESQ_MainInitAndRun(LONG argc, char **argv)
{
    LONG i;
    LONG d0;
    LONG baudRate;
    ESQ_Task *task;
    ESQ_LayerData *layerData;
    ESQ_SerialIORequest *serialIoRequest;
    char *displayRastPort;

    if (argc >= 2) {
        char *src = argv[1];
        UBYTE *dst = ESQ_SelectCodeBuffer;
        do {
            *dst++ = (UBYTE)*src;
        } while (*src++ != 0);
    } else {
        ESQ_SelectCodeBuffer[0] = 0;
    }

    if (ESQ_SelectCodeBuffer[0] == Global_STR_RAVESC[0]) {
        i = 0;
        while (ESQ_SelectCodeBuffer[i] == Global_STR_RAVESC[i]) {
            if (ESQ_SelectCodeBuffer[i] == 0) {
                Global_WORD_SELECT_CODE_IS_RAVESC = 1;
                break;
            }
            ++i;
        }
        if (ESQ_SelectCodeBuffer[i] != Global_STR_RAVESC[i]) {
            Global_WORD_SELECT_CODE_IS_RAVESC = 0;
        }
    } else {
        Global_WORD_SELECT_CODE_IS_RAVESC = 0;
    }

    _LVOExecute(Global_REF_DOS_LIBRARY_2, Global_STR_COPY_NIL_ASSIGN_RAM, 0, 0);

    task = (ESQ_Task *)_LVOFindTask(AbsExecBase, (void *)0);
    WDISP_ExecBaseHookPtr = (LONG)task;
    ESQ_ProcessWindowPtrBackup = task->windowPtr;
    task->windowPtr = -1;

    Global_REF_GRAPHICS_LIBRARY = _LVOOpenLibrary(AbsExecBase, Global_STR_GRAPHICS_LIBRARY, 0);
    if (Global_REF_GRAPHICS_LIBRARY == (void *)0) {
        return BUFFER_FlushAllAndCloseWithCode(0);
    }

    Global_REF_DISKFONT_LIBRARY = _LVOOpenLibrary(AbsExecBase, Global_STR_DISKFONT_LIBRARY, 0);
    if (Global_REF_DISKFONT_LIBRARY == (void *)0) {
        return BUFFER_FlushAllAndCloseWithCode(0);
    }

    Global_REF_DOS_LIBRARY = _LVOOpenLibrary(AbsExecBase, Global_STR_DOS_LIBRARY, 0);
    if (Global_REF_DOS_LIBRARY == (void *)0) {
        return BUFFER_FlushAllAndCloseWithCode(0);
    }

    Global_REF_INTUITION_LIBRARY = _LVOOpenLibrary(AbsExecBase, Global_STR_INTUITION_LIBRARY, 0);
    if (Global_REF_INTUITION_LIBRARY == (void *)0) {
        return BUFFER_FlushAllAndCloseWithCode(0);
    }

    if ((LONG)((struct Library *)Global_REF_GRAPHICS_LIBRARY)->lib_Version >= 37) {
        Global_REF_UTILITY_LIBRARY = _LVOOpenLibrary(AbsExecBase, Global_STR_UTILITY_LIBRARY, 37);
        if (Global_REF_UTILITY_LIBRARY != (void *)0) {
            Global_REF_BATTCLOCK_RESOURCE = _LVOOpenResource(AbsExecBase, Global_STR_BATTCLOCK_RESOURCE);
        }
        Global_LONG_ROM_VERSION_CHECK = 2;
    }

    OVERRIDE_INTUITION_FUNCS();

    Global_HANDLE_TOPAZ_FONT = _LVOOpenFont(Global_REF_GRAPHICS_LIBRARY, Global_STRUCT_TEXTATTR_TOPAZ_FONT);
    if (Global_HANDLE_TOPAZ_FONT == (void *)0) {
        return 0;
    }

    Global_HANDLE_PREVUEC_FONT = _LVOOpenDiskFont(Global_REF_DISKFONT_LIBRARY, Global_STRUCT_TEXTATTR_PREVUEC_FONT);
    if (Global_HANDLE_PREVUEC_FONT == (void *)0) {
        Global_HANDLE_PREVUEC_FONT = Global_HANDLE_TOPAZ_FONT;
    }

    Global_HANDLE_H26F_FONT = _LVOOpenDiskFont(Global_REF_DISKFONT_LIBRARY, Global_STRUCT_TEXTATTR_H26F_FONT);
    if (Global_HANDLE_H26F_FONT == (void *)0) {
        Global_HANDLE_H26F_FONT = Global_HANDLE_TOPAZ_FONT;
    }

    Global_HANDLE_PREVUE_FONT = _LVOOpenDiskFont(Global_REF_DISKFONT_LIBRARY, Global_STRUCT_TEXTATTR_PREVUE_FONT);
    if (Global_HANDLE_PREVUE_FONT == (void *)0) {
        Global_HANDLE_PREVUE_FONT = Global_HANDLE_TOPAZ_FONT;
    }

    Global_REF_RASTPORT_1 = (struct RastPort *)MEMORY_AllocateMemory(100, MEMF_PUBLIC + MEMF_CLEAR);
    _LVOInitRastPort(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1);
    Global_REF_RASTPORT_1->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);

    WDISP_HighlightRasterHeightPx = 68;
    d0 = MATH_DivS32((LONG)(UWORD)WDISP_HighlightRasterHeightPx, 2);
    if (d0 != 0) {
        --WDISP_HighlightRasterHeightPx;
    }

    Global_REF_RASTPORT_2 = (struct RastPort *)MEMORY_AllocateMemory(100, MEMF_PUBLIC + MEMF_CLEAR);
    _LVOInitRastPort(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2);
    Global_REF_RASTPORT_2->BitMap = (struct BitMap *)&Global_REF_320_240_BITMAP;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, Global_HANDLE_PREVUEC_FONT);

    for (i = 0; i < 4; ++i) {
        ESQDISP_AllocateHighlightBitmaps(ESQDISP_HighlightBitmapTable + (i * 40));
    }

    _LVOInitBitMap(Global_REF_GRAPHICS_LIBRARY, &Global_REF_320_240_BITMAP, 4, 352, 240);
    for (i = 0; i < 4; ++i) {
        WDISP_352x240RasterPtrTable[i] = GRAPHICS_AllocRaster(352, 240);
        _LVOBltClear(Global_REF_GRAPHICS_LIBRARY, WDISP_352x240RasterPtrTable[i], 10560, 0);
    }

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
        extern UBYTE Global_JMPTBL_HALF_HOURS_24_HR_FMT;
        Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_24_HR_FMT;
    } else {
        extern UBYTE Global_JMPTBL_HALF_HOURS_12_HR_FMT;
        Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_12_HR_FMT;
    }

    ESQ_HighlightMsgPort = (struct MsgPort *)MEMORY_AllocateMemory(34, MEMF_PUBLIC + MEMF_CLEAR);
    if (ESQ_HighlightMsgPort == (struct MsgPort *)0) {
        return 0;
    }
    ESQ_HighlightMsgPort->mp_SigTask = (void *)0;
    ESQ_HighlightMsgPort->mp_SigBit = 0;
    ESQ_HighlightMsgPort->mp_Flags = 4;
    ESQ_HighlightMsgPort->mp_Node.ln_Type = 2;
    LIST_InitHeader((struct MinList *)&ESQ_HighlightMsgPort->mp_MsgList);

    ESQ_HighlightReplyPort = (struct MsgPort *)MEMORY_AllocateMemory(34, MEMF_PUBLIC + MEMF_CLEAR);
    if (ESQ_HighlightReplyPort == (struct MsgPort *)0) {
        return 0;
    }
    ESQ_HighlightReplyPort->mp_SigTask = (void *)0;
    ESQ_HighlightReplyPort->mp_SigBit = 0;
    ESQ_HighlightReplyPort->mp_Flags = 4;
    ESQ_HighlightReplyPort->mp_Node.ln_Type = 2;
    LIST_InitHeader((struct MinList *)&ESQ_HighlightReplyPort->mp_MsgList);

    for (i = 0; i < 4; ++i) {
        ESQDISP_QueueHighlightDrawMessage(
            GCOMMAND_HighlightMessageSlotTable + (i * 0xa0),
            ESQDISP_HighlightBitmapTable + (i * 0x28)
        );
    }

    ESQ_SetCopperEffect_OffDisableHighlight();
    WDISP_HighlightBufferMode = 0;
    if ((LONG)((struct Library *)Global_REF_GRAPHICS_LIBRARY)->lib_Version >= 34) {
        WDISP_HighlightBufferMode = 1;
    }

    if (_LVOAvailMem(AbsExecBase, 4) > 1750000) {
        WDISP_HighlightBufferMode = 2;
    }

    if (ESQ_FormatDiskErrorMessage() != 0) {
        return 0;
    }

    ESQ_CheckAvailableFastMemory();
    ESQ_CheckCompatibleVideoChip();
    ESQ_CheckTopazFontGuard();

    CLOCK_DaySlotIndexPtr = (LONG)&CLOCK_DaySlotIndex;
    CLOCK_CurrentDayOfWeekIndexPtr = (LONG)&CLOCK_CurrentDayOfWeekIndex;
    DST_PrimaryCountdown = 0;
    DST_SecondaryCountdown = 0;
    PARSEINI_UpdateClockFromRtc();
    DST_RefreshBannerBuffer();

    SCRIPT_CtrlInterfaceEnabledFlag = 0;
    for (i = 1; i < argc; ++i) {
        char *p = argv[i];
        d0 = 0;
        while (p[d0] == ESQ_TAG_GRANADA[d0]) {
            if (p[d0] == 0) {
                SCRIPT_CtrlInterfaceEnabledFlag = 1;
                break;
            }
            ++d0;
        }
    }

    if (argc > 2) {
        baudRate = PARSE_ReadSignedLongSkipClass3_Alt(argv[2]);
        if (baudRate != 2400 && baudRate != 4800 && baudRate != 9600) {
            baudRate = 2400;
        }
    } else {
        baudRate = 2400;
    }
    Global_REF_BAUD_RATE = baudRate;

    ESQIFF_RecordBufferPtr = MEMORY_AllocateMemory(9000, MEMF_PUBLIC + MEMF_CLEAR);
    WDISP_SerialMessagePortPtr = SIGNAL_CreateMsgPortWithSignal(Global_STR_SERIAL_READ, 0);
    if (WDISP_SerialMessagePortPtr == (void *)0) {
        return 0;
    }

    WDISP_SerialIoRequestPtr = STRUCT_AllocWithOwner(WDISP_SerialMessagePortPtr, 82);
    if (WDISP_SerialIoRequestPtr == (void *)0) {
        return 0;
    }

    d0 = _LVOOpenDevice(AbsExecBase, Global_STR_SERIAL_DEVICE, 0, (LONG)WDISP_SerialIoRequestPtr, 0);
    if (d0 != 0) {
        return 0;
    }

    serialIoRequest = (ESQ_SerialIORequest *)WDISP_SerialIoRequestPtr;
    serialIoRequest->flags79 = 16;
    serialIoRequest->baudRate = Global_REF_BAUD_RATE;
    serialIoRequest->command = 11;
    _LVODoIO(AbsExecBase, WDISP_SerialIoRequestPtr);

    SETUP_INTERRUPT_INTB_RBF();
    SETUP_INTERRUPT_INTB_AUD1();
    ESQ_InitAudio1Dma();
    SCRIPT_InitCtrlContext();
    KYBD_InitializeInputDevices();
    ESQFUNC_AllocateLineTextBuffers();

    Global_REF_96_BYTES_ALLOCATED = MEMORY_AllocateMemory(96, MEMF_PUBLIC);

    _LVOInitBitMap(Global_REF_GRAPHICS_LIBRARY, &Global_REF_696_400_BITMAP, 3, 696, 400);
    _LVOInitBitMap(Global_REF_GRAPHICS_LIBRARY, &Global_REF_696_241_BITMAP, 4, 696, 241);

    for (i = 0; i < 3; ++i) {
        (&WDISP_BannerRowScratchRasterTable0)[i] = GRAPHICS_AllocRaster(696, 509);
        _LVOBltClear(Global_REF_GRAPHICS_LIBRARY, (&WDISP_BannerRowScratchRasterTable0)[i], 0xaef8, 0);
    }

    ESQSHARED_BannerRowScratchRasterBase0 = WDISP_BannerRowScratchRasterTable0;
    ESQSHARED_BannerRowScratchRasterBase1 = WDISP_BannerRowScratchRasterTable1;
    ESQSHARED_BannerRowScratchRasterBase2 = WDISP_BannerRowScratchRasterTable2;

    for (i = 0; i < 3; ++i) {
        (&WDISP_DisplayContextPlanePointer0)[i] = (UBYTE *)(&WDISP_BannerRowScratchRasterTable0)[i] + 0x5c20;
    }

    for (i = 3; i < 5; ++i) {
        (&WDISP_DisplayContextPlanePointer0)[i] = GRAPHICS_AllocRaster(696, 241);
        _LVOBltClear(Global_REF_GRAPHICS_LIBRARY, (&WDISP_DisplayContextPlanePointer0)[i], 0x52d8, 0);
    }

    ESQSHARED_DisplayContextPlaneBase0 = WDISP_DisplayContextPlanePointer0;
    ESQSHARED_DisplayContextPlaneBase1 = WDISP_DisplayContextPlanePointer1;
    ESQSHARED_DisplayContextPlaneBase2 = WDISP_DisplayContextPlanePointer2;
    ESQSHARED_DisplayContextPlaneBase3 = WDISP_DisplayContextPlanePointer3;
    ESQSHARED_DisplayContextPlaneBase4 = WDISP_DisplayContextPlanePointer4;

    layerData = (ESQ_LayerData *)Global_REF_RASTPORT_1->areaPtr;
    layerData->flag55 = 1;
    layerData->flags53 = (UBYTE)(layerData->flags53 | 1);

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(2, 0, 3);

    _LVOInitBitMap(Global_REF_GRAPHICS_LIBRARY, &WDISP_BannerGridBitmapStruct, 3, 696, 2);
    for (i = 0; i < 3; ++i) {
        (&WDISP_LivePlaneRasterTable0)[i] = GRAPHICS_AllocRaster(696, 2);
        _LVOBltClear(Global_REF_GRAPHICS_LIBRARY, (&WDISP_LivePlaneRasterTable0)[i], 176, 0);
    }

    ESQSHARED_LivePlaneBase0 = WDISP_LivePlaneRasterTable0;
    ESQSHARED_LivePlaneBase1 = WDISP_LivePlaneRasterTable1;
    ESQSHARED_LivePlaneBase2 = WDISP_LivePlaneRasterTable2;

    WDISP_BannerWorkRasterPtr = GRAPHICS_AllocRaster(696, 15);
    WDISP_AccumulatorFlushPending = 0;
    NEWGRID_RefreshStateFlag = 0;
    NEWGRID_MessagePumpSuspendFlag = -1;

    if (DISKIO_LoadConfigFromDisk() == -1) {
        ESQFUNC_UpdateRefreshModeState(0, 0);
    }

    ESQSHARED4_InitializeBannerCopperSystem();
    TLIBA3_InitPatternTable();
    SETUP_INTERRUPT_INTB_VERTB();

    Global_UIBusyFlag = 0;
    ESQ_StartupStateWord2203 = 0;
    TEXTDISP_SecondaryGroupRecordLength = 0;
    TEXTDISP_PrimaryGroupRecordLength = 0;
    ESQ_TickModulo60Counter = 0;
    ESQ_StartupWriteOnlyWord2271 = 0;
    ESQIFF_ParseAttemptCount = 0;
    SCRIPT_CtrlCmdCount = 0;
    TEXTDISP_SecondaryGroupEntryCount = 0;
    TEXTDISP_PrimaryGroupEntryCount = 0;
    ESQIFF_GAdsListLineIndex = 0;
    ESQIFF_LogoListLineIndex = 0;
    ESQIFF_StatusPacketReadyFlag = 0;
    TEXTDISP_GroupMutationState = 0;
    ESQ_SerialRbfFillLevel = 0;
    Global_WORD_MAX_VALUE = 0;
    Global_WORD_T_VALUE = 0;
    Global_WORD_H_VALUE = 0;
    CLEANUP_PendingAlertFlag = 0;
    CTRL_BufferedByteCount = 0;
    CTRL_HDeltaMax = 0;
    CTRL_HPreviousSample = 0;
    CTRL_H = 0;
    ESQ_SerialRbfErrorCount = 0;
    DATACErrs = 0;
    SCRIPT_CtrlCmdChecksumErrorCount = 0;
    ESQIFF_LineErrorCount = 0;
    SCRIPT_CtrlCmdLengthErrorCount = 0;
    ESQPARS_CommandPreambleArmedFlag = 0;
    ESQPARS_Preamble55SeenFlag = 0;
    WDISP_BannerCharPhaseShift = 0;
    ESQPARS_SelectionMatchCode = 0;
    ESQPARS_ResetArmedFlag = 0;
    ESQIFF_UseCachedChecksumFlag = 0;
    TEXTDISP_SecondaryGroupRecordChecksum = 0;
    TEXTDISP_PrimaryGroupRecordChecksum = 0;
    TEXTDISP_SecondaryGroupPresentFlag = 0;
    TEXTDISP_PrimaryGroupCode = 0;
    TEXTDISP_SecondaryGroupCode = 1;
    ESQ_StartupPhaseSeed225E = 7;
    CLOCK_HalfHourSlotIndex = 2;
    SCRIPT_CTRL_READ_INDEX = 0;
    PARSEINI_CtrlHChangeGateFlag = 0;
    SCRIPT_CTRL_CHECKSUM = 0xff;

    ESQIFF_RestoreBasePaletteTriples();
    ESQIFF_RunCopperDropTransition();

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0, 0, 695, 399);

    Global_REF_RASTPORT_1->BitMap = (struct BitMap *)&Global_REF_696_241_BITMAP;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0, 0, 0, 240);
    Global_REF_RASTPORT_1->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    displayRastPort = (char *)(WDISP_DisplayContextBase + DISPLAY_RASTPORT2_DELTA);
    TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, DISKIO_ErrorMessageScratch, 150);
    DISKIO_ProbeDrivesAndAssignPaths();

    if (DISKIO_DriveWriteProtectStatusCodeDrive1 == 218) {
        TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_STR_NO_DF1_PRESENT, 150);
    }

    WDISP_SPrintf(
        ESQ_StartupVersionBannerBuffer,
        Global_STR_GUIDE_START_VERSION_AND_BUILD,
        Global_STR_MAJOR_MINOR_VERSION,
        Global_LONG_PATCH_VERSION_NUMBER,
        Global_LONG_BUILD_NUMBER,
        Global_PTR_STR_BUILD_ID
    );

    for (i = 0; i < 40; i += 4) {
        *(LONG *)(DISKIO_ErrorMessageScratch + i) = *(const LONG *)(ESQ_STR_38_Spaces + i);
    }

    SCRIPT_PrimeBannerTransitionFromHexCode();
    GCOMMAND_InitPresetDefaults();
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_2);
    GCOMMAND_ResetBannerFadeState();

    TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_SelectCodeBuffer, 60);
    TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_StartupVersionBannerBuffer, 90);
    TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_STR_SystemInitializing, 120);
    TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_STR_PleaseStandByEllipsis, 150);

    if (IS_COMPATIBLE_VIDEO_CHIP != 0 || HAS_REQUESTED_FAST_MEMORY != 0) {
        TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_STR_AttentionSystemEngineer, 180);
        if (HAS_REQUESTED_FAST_MEMORY != 0) {
            TLIBA3_DrawCenteredWrappedTextLines(displayRastPort, ESQ_STR_ReportErrorCodeEr011ToTVGuide, 210);
        }
        if (IS_COMPATIBLE_VIDEO_CHIP != 0) {
            TLIBA3_DrawCenteredWrappedTextLines(
                displayRastPort,
                ESQ_STR_ReportErrorCodeER012ToTVGuide,
                (HAS_REQUESTED_FAST_MEMORY != 0) ? 240 : 210
            );
        }
        ESQIFF_RunCopperRiseTransition();
        for (;;) {
        }
    }

    ESQIFF_RunCopperRiseTransition();
    LADFUNC_AllocBannerRectEntries();
    LADFUNC_ClearBannerRectEntries();
    DISKIO2_ReloadDataFilesAndRebuildIndex();
    DISKIO2_ParseIniFileFromDisk();
    TEXTDISP_LoadSourceConfig();
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_DEFAULT_INI_1);
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BRUSH_INI_1);
    BRUSH_PopulateBrushList(PARSEINI_ParsedDescriptorListHead, &ESQIFF_BrushIniListHead);
    BRUSH_SelectBrushByLabel(ESQ_STR_DT);
    if (BRUSH_SelectedNode == (void *)0) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(ESQ_STR_DITHER, ESQIFF_BrushIniListHead);
    }

    ESQFUNC_FallbackType3BrushNode = BRUSH_FindType3Brush(ESQIFF_BrushIniListHead);
    ESQFUNC_RebuildPwBrushListFromTagTable();
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BANNER_INI_1);
    FLIB2_ResetAndLoadListingTemplates();
    LADFUNC_LoadTextAdsFromFile();
    LADFUNC_UpdateHighlightState();

    ESQ_StartupWriteOnlyLong2272 = 1;
    WDISP_BannerCharIndex = WDISP_BannerCharRangeStart;
    ESQDISP_UpdateStatusMaskAndRefresh(4095, 0);
    INTENA = 0x8100;
    P_TYPE_ResetListsAndLoadPromoIds();
    LOCAVAIL_ResetFilterStateStruct(LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_ResetFilterStateStruct(LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_LoadAvailabilityDataFile(LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState);

    DST_BannerWindowPrimary = (void *)0;
    DST_BannerWindowSecondary = (void *)0;
    DST_LoadBannerPairFromFiles(&DST_BannerWindowPrimary);

    Global_RefreshTickCounter = 0;
    ESQFUNC_UpdateDiskWarningAndRefreshTick();
    ESQDISP_DisplayActiveFlag = 0;

    for (i = 1; i < argc; ++i) {
        char *p = argv[i];
        d0 = 0;
        while (p[d0] == ESQ_TAG_GRANADA[d0]) {
            if (p[d0] == 0) {
                ESQDISP_DisplayActiveFlag = 1;
                break;
            }
            ++d0;
        }
    }

    _LVODisable(AbsExecBase);
    ESQ_SerialRbfFillLevel = 0;
    Global_WORD_MAX_VALUE = 0;
    Global_WORD_T_VALUE = 0;
    Global_WORD_H_VALUE = 0;
    _LVOEnable(AbsExecBase);

    ESQIFF_ExternalAssetFlags = 0;
    TEXTDISP_SetRastForMode(0);
    ESQ_SetCopperEffect_OffDisableHighlight();

    for (i = 0; i < 0x12e; ++i) {
        CLEANUP_AlignedStatusEntryCycleTable[i] = 0;
    }

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
        ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
    }

    ESQ_MainLoopUiTickEnabledFlag = 1;
    for (;;) {
        ESQFUNC_ServiceUiTickIfRunning();
        d0 = PARSEINI_MonitorClockChange();
        if (d0 != 0 && ESQ_ShutdownRequestedFlag == 0) {
            ESQPARS_ConsumeRbfByteAndDispatchCommand();
        }
        if (ESQ_ShutdownRequestedFlag != 0) {
            break;
        }
    }

    return CLEANUP_ShutdownSystem();
}
