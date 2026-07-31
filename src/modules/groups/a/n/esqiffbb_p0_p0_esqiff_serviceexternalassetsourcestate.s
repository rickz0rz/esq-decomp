    XDEF    _ESQIFF_ServiceExternalAssetSourceState


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_ServiceExternalAssetSourceState   (Service external-asset source select and queue state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _ESQDISP_ProcessGridMessagesIfIdle, _ESQIFF_ReloadExternalAssetCatalogBuffers, _ESQIFF_QueueNextExternalAssetIffJob
; READS:
;   _Global_WORD_SELECT_CODE_IS_RAVESC, _COI_AttentionOverlayBusyFlag, _ESQIFF_ExternalAssetFlags, _DISKIO_Drive0WriteProtectedCode, _DISKIO_DriveWriteProtectStatusCodeDrive1
; WRITES:
;   _ESQIFF_AssetSourceSelect, _ESQIFF_GAdsSourceEnabled
; DESC:
;   Sets source-selection flags by mode, conditionally reloads external catalogs,
;   then queues the next external asset IFF job.
; NOTES:
;   Skips reload/queue work during RAVESC select mode or COI busy gate.
;------------------------------------------------------------------------------
_ESQIFF_ServiceExternalAssetSourceState:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .return

    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   _COI_AttentionOverlayBusyFlag
    BNE.S   .return

    TST.W   D7
    BEQ.S   .configure_source_for_secondary_mode

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQIFF_AssetSourceSelect
    MOVEQ   #-1,D1
    MOVE.W  D1,_ESQIFF_GAdsSourceEnabled
    BRA.S   .reload_logo_catalog_if_needed

.configure_source_for_secondary_mode:
    CLR.W   _ESQIFF_GAdsSourceEnabled
    MOVE.W  #(-1),_ESQIFF_AssetSourceSelect

.reload_logo_catalog_if_needed:
    TST.L   _DISKIO_Drive0WriteProtectedCode
    BNE.S   .reload_gads_catalog_if_needed

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #2,D0
    SUBQ.W  #2,D0
    BEQ.S   .reload_gads_catalog_if_needed

    CLR.L   -(A7)
    BSR.W   _ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.reload_gads_catalog_if_needed:
    TST.L   _DISKIO_DriveWriteProtectStatusCodeDrive1
    BNE.S   .queue_next_asset_after_reload_checks

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #1,D0
    SUBQ.W  #1,D0
    BEQ.S   .queue_next_asset_after_reload_checks

    PEA     1.W
    BSR.W   _ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.queue_next_asset_after_reload_checks:
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    BSR.W   _ESQIFF_QueueNextExternalAssetIffJob

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======