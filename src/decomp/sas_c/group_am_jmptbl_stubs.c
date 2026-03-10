typedef signed long LONG;
typedef unsigned long ULONG;

extern void *SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri);
extern void LADFUNC_ClearBannerRectEntries(void);
extern void PARSEINI_UpdateClockFromRtc(void);
extern void SCRIPT_InitCtrlContext(void);
extern void DISKIO2_ParseIniFileFromDisk(void);
extern void ESQ_CheckTopazFontGuard(void);
extern void P_TYPE_ResetListsAndLoadPromoIds(void);
extern void LADFUNC_LoadTextAdsFromFile(void);
extern void DISKIO_LoadConfigFromDisk(void);
extern void TEXTDISP_LoadSourceConfig(void);
extern void KYBD_InitializeInputDevices(void);
extern void ESQ_CheckCompatibleVideoChip(void);
extern void ESQ_CheckAvailableFastMemory(void);
extern void *STRUCT_AllocWithOwner(void *owner, ULONG size);
extern void GCOMMAND_ResetBannerFadeState(void);
extern void TLIBA3_InitPatternTable(void);
extern void ESQ_FormatDiskErrorMessage(void);
extern void SCRIPT_PrimeBannerTransitionFromHexCode(void);
extern void LOCAVAIL_ResetFilterStateStruct(void);
extern void ESQ_InitAudio1Dma(void);
extern void LIST_InitHeader(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void LOCAVAIL_LoadAvailabilityDataFile(void);
extern void GCOMMAND_InitPresetDefaults(void);
extern void OVERRIDE_INTUITION_FUNCS(void);
extern void BUFFER_FlushAllAndCloseWithCode(void);
extern void FLIB2_ResetAndLoadListingTemplates(void);
extern void WDISP_SPrintf(void);
extern void CLEANUP_ShutdownSystem(void);
extern void LADFUNC_AllocBannerRectEntries(void);

void *GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri){return SIGNAL_CreateMsgPortWithSignal(name, pri);}
void GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries(void){LADFUNC_ClearBannerRectEntries();}
void GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc(void){PARSEINI_UpdateClockFromRtc();}
void GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext(void){SCRIPT_InitCtrlContext();}
void GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk(void){DISKIO2_ParseIniFileFromDisk();}
void GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard(void){ESQ_CheckTopazFontGuard();}
void GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds(void){P_TYPE_ResetListsAndLoadPromoIds();}
void GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(void){LADFUNC_LoadTextAdsFromFile();}
void GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk(void){DISKIO_LoadConfigFromDisk();}
void GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig(void){TEXTDISP_LoadSourceConfig();}
void GROUP_AM_JMPTBL_KYBD_InitializeInputDevices(void){KYBD_InitializeInputDevices();}
void GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip(void){ESQ_CheckCompatibleVideoChip();}
void GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory(void){ESQ_CheckAvailableFastMemory();}
void *GROUP_AM_JMPTBL_STRUCT_AllocWithOwner(void *owner, ULONG size){return STRUCT_AllocWithOwner(owner, size);}
void GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState(void){GCOMMAND_ResetBannerFadeState();}
void GROUP_AM_JMPTBL_TLIBA3_InitPatternTable(void){TLIBA3_InitPatternTable();}
void GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage(void){ESQ_FormatDiskErrorMessage();}
void GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(void){SCRIPT_PrimeBannerTransitionFromHexCode();}
void GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct(void){LOCAVAIL_ResetFilterStateStruct();}
void GROUP_AM_JMPTBL_ESQ_InitAudio1Dma(void){ESQ_InitAudio1Dma();}
void GROUP_AM_JMPTBL_LIST_InitHeader(void){LIST_InitHeader();}
void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void){ESQ_SetCopperEffect_OnEnableHighlight();}
void GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile(void){LOCAVAIL_LoadAvailabilityDataFile();}
void GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults(void){GCOMMAND_InitPresetDefaults();}
void GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS(void){OVERRIDE_INTUITION_FUNCS();}
void GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode(void){BUFFER_FlushAllAndCloseWithCode();}
void GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates(void){FLIB2_ResetAndLoadListingTemplates();}
void GROUP_AM_JMPTBL_WDISP_SPrintf(void){WDISP_SPrintf();}
void GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem(void){CLEANUP_ShutdownSystem();}
void GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries(void){LADFUNC_AllocBannerRectEntries();}
