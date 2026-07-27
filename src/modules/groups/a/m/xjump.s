    XDEF    GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode
    XDEF    GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem
    XDEF    GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk
    XDEF    GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk
    XDEF    GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory
    XDEF    GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip
    XDEF    GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard
    XDEF    GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage
    XDEF    GROUP_AM_JMPTBL_ESQ_InitAudio1Dma
    XDEF    _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight
    XDEF    _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
    XDEF    GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates
    XDEF    GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults
    XDEF    GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState
    XDEF    GROUP_AM_JMPTBL_KYBD_InitializeInputDevices
    XDEF    GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries
    XDEF    GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries
    XDEF    _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile
    XDEF    GROUP_AM_JMPTBL_LIST_InitHeader
    XDEF    GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile
    XDEF    GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct
    XDEF    GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS
    XDEF    GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc
    XDEF    GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds
    XDEF    GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext
    XDEF    GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode
    XDEF    GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal
    XDEF    GROUP_AM_JMPTBL_STRUCT_AllocWithOwner
    XDEF    GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig
    XDEF    GROUP_AM_JMPTBL_TLIBA3_InitPatternTable
    XDEF    _GROUP_AM_JMPTBL_WDISP_SPrintf

;!======

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal   (JumpStub_SIGNAL_CreateMsgPortWithSignal)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   SIGNAL_CreateMsgPortWithSignal
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to SIGNAL_CreateMsgPortWithSignal.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal:
    JMP     SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _LADFUNC_ClearBannerRectEntries
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_ClearBannerRectEntries.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries:
    JMP     _LADFUNC_ClearBannerRectEntries

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc   (JumpStub_PARSEINI_UpdateClockFromRtc)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   PARSEINI_UpdateClockFromRtc
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to PARSEINI_UpdateClockFromRtc.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc:
    JMP     PARSEINI_UpdateClockFromRtc

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext   (JumpStub_SCRIPT_InitCtrlContext)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _SCRIPT_InitCtrlContext
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _SCRIPT_InitCtrlContext.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext:
    JMP     _SCRIPT_InitCtrlContext

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DISKIO2_ParseIniFileFromDisk
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DISKIO2_ParseIniFileFromDisk.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk:
    JMP     _DISKIO2_ParseIniFileFromDisk

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard   (JumpStub_ESQ_CheckTopazFontGuard)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_CheckTopazFontGuard
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_CheckTopazFontGuard.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard:
    JMP     ESQ_CheckTopazFontGuard

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds   (JumpStub_P_TYPE_ResetListsAndLoadPromoIds)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _P_TYPE_ResetListsAndLoadPromoIds
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _P_TYPE_ResetListsAndLoadPromoIds.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds:
    JMP     _P_TYPE_ResetListsAndLoadPromoIds

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile   (JumpStub_LADFUNC_LoadTextAdsFromFile)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_LoadTextAdsFromFile
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_LoadTextAdsFromFile.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile:
    JMP     LADFUNC_LoadTextAdsFromFile

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   DISKIO_LoadConfigFromDisk
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to DISKIO_LoadConfigFromDisk.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk:
    JMP     DISKIO_LoadConfigFromDisk

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TEXTDISP_LoadSourceConfig
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TEXTDISP_LoadSourceConfig.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig:
    JMP     TEXTDISP_LoadSourceConfig

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_KYBD_InitializeInputDevices   (JumpStub_KYBD_InitializeInputDevices)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _KYBD_InitializeInputDevices
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _KYBD_InitializeInputDevices.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_KYBD_InitializeInputDevices:
    JMP     _KYBD_InitializeInputDevices

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip   (JumpStub_ESQ_CheckCompatibleVideoChip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_CheckCompatibleVideoChip
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_CheckCompatibleVideoChip.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip:
    JMP     _ESQ_CheckCompatibleVideoChip

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory   (JumpStub_ESQ_CheckAvailableFastMemory)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_CheckAvailableFastMemory
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_CheckAvailableFastMemory.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory:
    JMP     _ESQ_CheckAvailableFastMemory

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_STRUCT_AllocWithOwner   (JumpStub_STRUCT_AllocWithOwner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   STRUCT_AllocWithOwner
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to STRUCT_AllocWithOwner.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_STRUCT_AllocWithOwner:
    JMP     STRUCT_AllocWithOwner

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _GCOMMAND_ResetBannerFadeState
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _GCOMMAND_ResetBannerFadeState.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState:
    JMP     _GCOMMAND_ResetBannerFadeState

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_TLIBA3_InitPatternTable   (JumpStub_TLIBA3_InitPatternTable)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TLIBA3_InitPatternTable
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TLIBA3_InitPatternTable.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_TLIBA3_InitPatternTable:
    JMP     TLIBA3_InitPatternTable

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage   (JumpStub_ESQ_FormatDiskErrorMessage)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_FormatDiskErrorMessage
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_FormatDiskErrorMessage.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage:
    JMP     _ESQ_FormatDiskErrorMessage

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode   (JumpStub_SCRIPT_PrimeBannerTransitionFromHexCode)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _SCRIPT_PrimeBannerTransitionFromHexCode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _SCRIPT_PrimeBannerTransitionFromHexCode.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode:
    JMP     _SCRIPT_PrimeBannerTransitionFromHexCode

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _LOCAVAIL_ResetFilterStateStruct
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LOCAVAIL_ResetFilterStateStruct.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct:
    JMP     _LOCAVAIL_ResetFilterStateStruct

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_ESQ_InitAudio1Dma   (JumpStub_ESQ_InitAudio1Dma)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_InitAudio1Dma
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_InitAudio1Dma.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_ESQ_InitAudio1Dma:
    JMP     _ESQ_InitAudio1Dma

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_LIST_InitHeader   (JumpStub_LIST_InitHeader)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LIST_InitHeader
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LIST_InitHeader.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_LIST_InitHeader:
    JMP     LIST_InitHeader

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight   (JumpStub_ESQ_SetCopperEffect_OnEnableHighlight)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_SetCopperEffect_OnEnableHighlight.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight:
    JMP     _ESQ_SetCopperEffect_OnEnableHighlight

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_LoadAvailabilityDataFile
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_LoadAvailabilityDataFile.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile:
    JMP     LOCAVAIL_LoadAvailabilityDataFile

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _GCOMMAND_InitPresetDefaults
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _GCOMMAND_InitPresetDefaults.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults:
    JMP     _GCOMMAND_InitPresetDefaults

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS   (JumpStub_OVERRIDE_INTUITION_FUNCS)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _OVERRIDE_INTUITION_FUNCS
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _OVERRIDE_INTUITION_FUNCS.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS:
    JMP     _OVERRIDE_INTUITION_FUNCS

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode   (JumpStub_BUFFER_FlushAllAndCloseWithCode)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   BUFFER_FlushAllAndCloseWithCode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to BUFFER_FlushAllAndCloseWithCode.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode:
    JMP     BUFFER_FlushAllAndCloseWithCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _FLIB2_ResetAndLoadListingTemplates
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _FLIB2_ResetAndLoadListingTemplates.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates:
    JMP     _FLIB2_ResetAndLoadListingTemplates

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_WDISP_SPrintf   (JumpStub_PRINTF)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _WDISP_SPrintf
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _WDISP_SPrintf.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_WDISP_SPrintf:
    JMP     _WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight   (JumpStub_ESQ_SetCopperEffect_OffDisableHighlight)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_SetCopperEffect_OffDisableHighlight
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_SetCopperEffect_OffDisableHighlight.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight:
    JMP     _ESQ_SetCopperEffect_OffDisableHighlight

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem   (JumpStub_CLEANUP_ShutdownSystem)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   CLEANUP_ShutdownSystem
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_ShutdownSystem.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem:
    JMP     CLEANUP_ShutdownSystem

;------------------------------------------------------------------------------
; FUNC: GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries   (JumpStub_LADFUNC_AllocBannerRectEntries)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _LADFUNC_AllocBannerRectEntries
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_AllocBannerRectEntries.
;------------------------------------------------------------------------------
GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries:
    JMP     _LADFUNC_AllocBannerRectEntries

;!======

    ; Alignment
    MOVEQ   #97,D0
