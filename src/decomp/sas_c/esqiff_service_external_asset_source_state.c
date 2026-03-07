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
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = -1;
    const WORD EXTERNAL_SRC_BIT_DRIVE0 = 2;
    const WORD EXTERNAL_SRC_BIT_DRIVE1 = 1;
    const WORD RELOAD_DRIVE0 = 0;
    const WORD RELOAD_DRIVE1 = 1;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != FLAG_FALSE) {
        return;
    }

    ESQDISP_ProcessGridMessagesIfIdle();

    if (COI_AttentionOverlayBusyFlag != FLAG_FALSE) {
        return;
    }

    if (mode != FLAG_FALSE) {
        ESQIFF_AssetSourceSelect = FLAG_FALSE;
        ESQIFF_GAdsSourceEnabled = FLAG_TRUE;
    } else {
        ESQIFF_GAdsSourceEnabled = FLAG_FALSE;
        ESQIFF_AssetSourceSelect = FLAG_TRUE;
    }

    if (DISKIO_Drive0WriteProtectedCode == FLAG_FALSE) {
        if ((ESQIFF_ExternalAssetFlags & EXTERNAL_SRC_BIT_DRIVE0) != EXTERNAL_SRC_BIT_DRIVE0) {
            ESQIFF_ReloadExternalAssetCatalogBuffers(RELOAD_DRIVE0);
        }
    }

    if (DISKIO_DriveWriteProtectStatusCodeDrive1 == FLAG_FALSE) {
        if ((ESQIFF_ExternalAssetFlags & EXTERNAL_SRC_BIT_DRIVE1) != EXTERNAL_SRC_BIT_DRIVE1) {
            ESQIFF_ReloadExternalAssetCatalogBuffers(RELOAD_DRIVE1);
        }
    }

    ESQDISP_ProcessGridMessagesIfIdle();
    ESQIFF_QueueNextExternalAssetIffJob();
}
