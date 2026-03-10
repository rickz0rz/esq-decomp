typedef signed long LONG;
typedef unsigned long ULONG;

extern void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(ULONG mask, ULONG value);
extern void DISKIO2_DisplayStatusLine(const char *text);
extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern LONG ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern LONG DISKIO_SaveConfigToFileHandle(void);
extern void GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void *primary, void *secondary);
extern void DISKIO2_WriteQTableIniFile(void);
extern void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void);
extern LONG DATETIME_SavePairToFile(void *pair);
extern void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void);

extern const char DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT[];
extern const char DISKIO2_STR_SAVING_TEXT_ADS_DOT[];
extern const char DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT[];
extern const char DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT[];
extern const char DISKIO2_STR_SAVING_QTABLE_DOT[];
extern const char DISKIO2_STR_SAVING_ERROR_LOG_DOT[];
extern const char DISKIO2_STR_SAVING_DST_DATA_DOT[];
extern const char DISKIO2_STR_SAVING_PROMO_TYPES[];
extern const char DISKIO2_STR_SAVING_DATA_VIEW_CONFIG[];
extern void *LOCAVAIL_PrimaryFilterState;
extern void *LOCAVAIL_SecondaryFilterState;
extern void *DST_BannerWindowPrimary;

static void DISKIO2_ShowStatusIfEnabled(ULONG enabled, const char *status)
{
    if (enabled != 0) {
        DISKIO2_DisplayStatusLine(status);
    }
}

void DISKIO2_RunDiskSyncWorkflow(ULONG showStatus)
{
    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(256, 1);

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT);
    DISKIO2_FlushDataFilesIfNeeded();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_TEXT_ADS_DOT);
    ED1_JMPTBL_LADFUNC_SaveTextAdsToFile();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT);
    DISKIO_SaveConfigToFileHandle();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT);
    GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(
        LOCAVAIL_PrimaryFilterState,
        LOCAVAIL_SecondaryFilterState);

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_QTABLE_DOT);
    DISKIO2_WriteQTableIniFile();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_ERROR_LOG_DOT);
    GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_DST_DATA_DOT);
    DATETIME_SavePairToFile(DST_BannerWindowPrimary);

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_PROMO_TYPES);
    GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile();

    DISKIO2_ShowStatusIfEnabled(showStatus, DISKIO2_STR_SAVING_DATA_VIEW_CONFIG);
    GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile();
    GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile();
    GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate();

    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(256, 0);
}
