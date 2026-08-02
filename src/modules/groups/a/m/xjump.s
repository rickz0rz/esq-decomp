    XDEF    _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode
    XDEF    _GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem
    XDEF    _GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk
    XDEF    _GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk
    XDEF    _GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory
    XDEF    _GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip
    XDEF    _GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard
    XDEF    _GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage
    XDEF    _GROUP_AM_JMPTBL_ESQ_InitAudio1Dma
    XDEF    _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight
    XDEF    _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
    XDEF    _GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates
    XDEF    _GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults
    XDEF    _GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState
    XDEF    _GROUP_AM_JMPTBL_KYBD_InitializeInputDevices
    XDEF    _GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries
    XDEF    _GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries
    XDEF    _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile
    XDEF    _GROUP_AM_JMPTBL_LIST_InitHeader
    XDEF    _GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile
    XDEF    _GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct
    XDEF    _GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS
    XDEF    _GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc
    XDEF    _GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds
    XDEF    _GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext
    XDEF    _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode
    XDEF    _GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal
    XDEF    _GROUP_AM_JMPTBL_STRUCT_AllocWithOwner
    XDEF    _GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig
    XDEF    _GROUP_AM_JMPTBL_TLIBA3_InitPatternTable
    XDEF    _GROUP_AM_JMPTBL_WDISP_SPrintf

;!======

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal   (JumpStub_SIGNAL_CreateMsgPortWithSignal)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _SIGNAL_CreateMsgPortWithSignal
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _SIGNAL_CreateMsgPortWithSignal.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal:
    JMP     _SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries   (JumpStub)
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
_GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries:
    JMP     _LADFUNC_ClearBannerRectEntries

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc   (JumpStub_PARSEINI_UpdateClockFromRtc)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _PARSEINI_UpdateClockFromRtc
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _PARSEINI_UpdateClockFromRtc.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc:
    JMP     _PARSEINI_UpdateClockFromRtc

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext   (JumpStub_SCRIPT_InitCtrlContext)
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
_GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext:
    JMP     _SCRIPT_InitCtrlContext

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk   (JumpStub)
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
_GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk:
    JMP     _DISKIO2_ParseIniFileFromDisk

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard   (JumpStub_ESQ_CheckTopazFontGuard)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_CheckTopazFontGuard
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_CheckTopazFontGuard.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard:
    JMP     _ESQ_CheckTopazFontGuard

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds   (JumpStub_P_TYPE_ResetListsAndLoadPromoIds)
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
_GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds:
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
;   _LADFUNC_LoadTextAdsFromFile
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_LoadTextAdsFromFile.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile:
    JMP     _LADFUNC_LoadTextAdsFromFile

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DISKIO_LoadConfigFromDisk
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DISKIO_LoadConfigFromDisk.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk:
    JMP     _DISKIO_LoadConfigFromDisk

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_LoadSourceConfig
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_LoadSourceConfig.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig:
    JMP     _TEXTDISP_LoadSourceConfig

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_KYBD_InitializeInputDevices   (JumpStub_KYBD_InitializeInputDevices)
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
_GROUP_AM_JMPTBL_KYBD_InitializeInputDevices:
    JMP     _KYBD_InitializeInputDevices

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip   (JumpStub_ESQ_CheckCompatibleVideoChip)
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
_GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip:
    JMP     _ESQ_CheckCompatibleVideoChip

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory   (JumpStub_ESQ_CheckAvailableFastMemory)
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
_GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory:
    JMP     _ESQ_CheckAvailableFastMemory

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_STRUCT_AllocWithOwner   (JumpStub_STRUCT_AllocWithOwner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _STRUCT_AllocWithOwner
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _STRUCT_AllocWithOwner.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_STRUCT_AllocWithOwner:
    JMP     _STRUCT_AllocWithOwner

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState   (JumpStub)
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
_GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState:
    JMP     _GCOMMAND_ResetBannerFadeState

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_TLIBA3_InitPatternTable   (JumpStub_TLIBA3_InitPatternTable)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TLIBA3_InitPatternTable
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TLIBA3_InitPatternTable.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_TLIBA3_InitPatternTable:
    JMP     _TLIBA3_InitPatternTable

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage   (JumpStub_ESQ_FormatDiskErrorMessage)
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
_GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage:
    JMP     _ESQ_FormatDiskErrorMessage

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode   (JumpStub_SCRIPT_PrimeBannerTransitionFromHexCode)
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
_GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode:
    JMP     _SCRIPT_PrimeBannerTransitionFromHexCode

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct   (JumpStub)
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
_GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct:
    JMP     _LOCAVAIL_ResetFilterStateStruct

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_ESQ_InitAudio1Dma   (JumpStub_ESQ_InitAudio1Dma)
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
_GROUP_AM_JMPTBL_ESQ_InitAudio1Dma:
    JMP     _ESQ_InitAudio1Dma

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_LIST_InitHeader   (JumpStub_LIST_InitHeader)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _LIST_InitHeader
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LIST_InitHeader.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_LIST_InitHeader:
    JMP     _LIST_InitHeader

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
; FUNC: _GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _LOCAVAIL_LoadAvailabilityDataFile
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LOCAVAIL_LoadAvailabilityDataFile.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile:
    JMP     _LOCAVAIL_LoadAvailabilityDataFile

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults   (JumpStub)
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
_GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults:
    JMP     _GCOMMAND_InitPresetDefaults

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS   (JumpStub_OVERRIDE_INTUITION_FUNCS)
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
_GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS:
    JMP     _OVERRIDE_INTUITION_FUNCS

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode   (JumpStub_BUFFER_FlushAllAndCloseWithCode)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _BUFFER_FlushAllAndCloseWithCode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _BUFFER_FlushAllAndCloseWithCode.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode:
    JMP     _BUFFER_FlushAllAndCloseWithCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates   (JumpStub)
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
_GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates:
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
; FUNC: _GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem   (JumpStub_CLEANUP_ShutdownSystem)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _CLEANUP_ShutdownSystem
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _CLEANUP_ShutdownSystem.
;------------------------------------------------------------------------------
_GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem:
    JMP     _CLEANUP_ShutdownSystem

;------------------------------------------------------------------------------
; FUNC: _GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries   (JumpStub_LADFUNC_AllocBannerRectEntries)
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
_GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries:
    JMP     _LADFUNC_AllocBannerRectEntries

;!======

    ; Alignment
    MOVEQ   #97,D0
