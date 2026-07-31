    XDEF    _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex
    XDEF    ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock
    XDEF    ESQPARS_JMPTBL_COI_FreeEntryResources
    XDEF    _ESQPARS_JMPTBL_DATETIME_SavePairToFile
    XDEF    _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded
    XDEF    ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer
    XDEF    ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer
    XDEF    ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle
    XDEF    _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition
    XDEF    ESQPARS_JMPTBL_DST_HandleBannerCommand32_33
    XDEF    ESQPARS_JMPTBL_DST_RefreshBannerBuffer
    XDEF    ESQPARS_JMPTBL_DST_UpdateBannerQueue
    XDEF    ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte
    XDEF    ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds
    XDEF    _ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile
    XDEF    _ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile
    XDEF    _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache
    XDEF    ESQPARS_JMPTBL_PARSEINI_HandleFontCommand
    XDEF    _ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals
    XDEF    _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord
    XDEF    _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile
    XDEF    _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte
    XDEF    ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine
    XDEF    _ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries
    XDEF    ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal
    XDEF    ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay
    XDEF    ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList
    XDEF    ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord


;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO2_FlushDataFilesIfNeeded
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded:
    JMP     _DISKIO2_FlushDataFilesIfNeeded

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_RebuildIndexCache
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache:
    JMP     _NEWGRID_RebuildIndexCache

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_DATETIME_SavePairToFile   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_SavePairToFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_DATETIME_SavePairToFile:
    JMP     _DATETIME_SavePairToFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPROTO_VerifyChecksumAndParseList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList:
    JMP     ESQPROTO_VerifyChecksumAndParseList

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_ParseAndStoreTypeRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord:
    JMP     P_TYPE_ParseAndStoreTypeRecord

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPROTO_CopyLabelToGlobal
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal:
    JMP     ESQPROTO_CopyLabelToGlobal

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_HandleBannerCommand32_33   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DST_HandleBannerCommand32_33
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_HandleBannerCommand32_33:
    JMP     _DST_HandleBannerCommand32_33

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_SeedMinuteEventThresholds
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds:
    JMP     _ESQ_SeedMinuteEventThresholds

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_PARSEINI_HandleFontCommand   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_HandleFontCommand
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_PARSEINI_HandleFontCommand:
    JMP     PARSEINI_HandleFontCommand

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _TEXTDISP_ApplySourceConfigAllEntries
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries:
    JMP     _TEXTDISP_ApplySourceConfigAllEntries

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_PlaneMaskForIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex:
    JMP     _BRUSH_PlaneMaskForIndex

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ResetCtrlContextAndClearStatusLine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine:
    JMP     _SCRIPT_ResetCtrlContextAndClearStatusLine

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals:
    JMP     PARSEINI_WriteRtcFromGlobals

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_SaveAvailabilityDataFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile:
    BRA.W   _LOCAVAIL_SaveAvailabilityDataFile

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISPLIB_DisplayTextAtPosition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition:
    JMP     _DISPLIB_DisplayTextAtPosition

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SaveTextAdsToFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile:
    BRA.W   _LADFUNC_SaveTextAdsToFile

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    JMP     _PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _DISKIO2_HandleInteractiveFileTransfer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer:
    JMP     _DISKIO2_HandleInteractiveFileTransfer

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_WritePromoIdDataFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile:
    JMP     P_TYPE_WritePromoIdDataFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_COI_FreeEntryResources   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _COI_FreeEntryResources
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_COI_FreeEntryResources:
    JMP     _COI_FreeEntryResources

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_UpdateBannerQueue   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DST_UpdateBannerQueue
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_UpdateBannerQueue:
    JMP     _DST_UpdateBannerQueue

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPROTO_VerifyChecksumAndParseRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord:
    JMP     ESQPROTO_VerifyChecksumAndParseRecord

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPROTO_ParseDigitLabelAndDisplay
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay:
    JMP     ESQPROTO_ParseDigitLabelAndDisplay

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ParseConfigBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer:
    JMP     _DISKIO_ParseConfigBuffer

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_ParseAlignedListingBlock
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock:
    JMP     _CLEANUP_ParseAlignedListingBlock

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ReadNextRbfByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte:
    JMP     _SCRIPT_ReadNextRbfByte

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _ESQ_GenerateXorChecksumByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte:
    JMP     _ESQ_GenerateXorChecksumByte

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_RefreshBannerBuffer   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DST_RefreshBannerBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_RefreshBannerBuffer:
    JMP     _DST_RefreshBannerBuffer

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_SaveConfigToFileHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle:
    JMP     DISKIO_SaveConfigToFileHandle
