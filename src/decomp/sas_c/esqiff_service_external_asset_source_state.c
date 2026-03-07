typedef signed long LONG;
typedef signed short WORD;

extern WORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern WORD COI_AttentionOverlayBusyFlag;
extern WORD ESQIFF_AssetSourceSelect;
extern WORD ESQIFF_GAdsSourceEnabled;
extern WORD ESQIFF_ExternalAssetFlags;
extern LONG DISKIO_Drive0WriteProtectedCode;
extern LONG DISKIO_DriveWriteProtectStatusCodeDrive1;

extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ESQIFF_ReloadExternalAssetCatalogBuffers(WORD which);
extern void ESQIFF_QueueNextExternalAssetIffJob(void);

void ESQIFF_ServiceExternalAssetSourceState(WORD mode)
{
    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
        return;
    }

    ESQDISP_ProcessGridMessagesIfIdle();

    if (COI_AttentionOverlayBusyFlag != 0) {
        return;
    }

    if (mode != 0) {
        ESQIFF_AssetSourceSelect = 0;
        ESQIFF_GAdsSourceEnabled = -1;
    } else {
        ESQIFF_GAdsSourceEnabled = 0;
        ESQIFF_AssetSourceSelect = -1;
    }

    if (DISKIO_Drive0WriteProtectedCode == 0) {
        if ((ESQIFF_ExternalAssetFlags & 2) != 2) {
            ESQIFF_ReloadExternalAssetCatalogBuffers(0);
        }
    }

    if (DISKIO_DriveWriteProtectStatusCodeDrive1 == 0) {
        if ((ESQIFF_ExternalAssetFlags & 1) != 1) {
            ESQIFF_ReloadExternalAssetCatalogBuffers(1);
        }
    }

    ESQDISP_ProcessGridMessagesIfIdle();
    ESQIFF_QueueNextExternalAssetIffJob();
}
