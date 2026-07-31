/* RESTORES: _DISKIO2_RunDiskSyncWorkflow
 * MODULE:   modules/groups/a/h/diskio2_p1_2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame
 *   ref:     4e55ff9c2f072e2d000848780001487801004eba18de504f41f900000f6443edff9c700822d851c8fffc4a87670a486dff9c6100ff74584f6100183441f900000f8843edff9c700822d851c8fffc4a87670a486dff9c6100ff50584f4eba54d841f900000fac43edff9c700822d851c8fffc4a87670a486dff9c6100ff2c584f4ebaef5041f900000fd043edff9c700822d851c8fffc4a87670a486dff9c6100ff08584f48790000b3e448790000b3cc4eba1850504f41f900000ff443edff9c700822d851c8fffc4a87670a486dff9c6100fed6584f61000bfa41f90000101843edff9c700822d851c8fffc4a87670a486dff9c6100feb2584f4eba694a41f90000103c43edff9c700822d851c8fffc4a87670a486dff9c6100fe8e584f4879000081604eba2ddc584f41f90000106043edff9c700822d851c8fffc4a87670a486dff9c6100fe62584f4eba17c841f90000108443edff9c700822d851c8fffc4a87670a486dff9c6100fe3e584f4eba17984eba17be4eba178442a7487801004eba17702e2dff984e5d4e75
 *   got:     9efc00642f072e2f006c487800014878010061000000504f41f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f48790000000048790000000061000000504f41f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f48790000000061000000584f41f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f6100000041f90000000043ef0004700822d851c8fffc4a87670a486f000461000000584f61000000610000006100000042a74878010061000000504f2e1fdefc00644e754e71
 *   summary: 400 got vs 396 ref, four bytes over. Each of the nine status strings is copied through a nine-long struct assignment, which is what produces the original's MOVEQ #8 / MOVE.L (A0)+,(A1)+ / DBF; memcpy on the same char array inlines a MOVE.B loop instead. The residue is the frame register. All nine verbose-gated status lines, the nine save or load actions in their original order, the two status-mask calls that bracket the workflow and the two-argument availability save match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct SyncMessage { long w[9]; };       /* 36 bytes, copied as nine longs */

extern struct SyncMessage DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_TEXT_ADS_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_QTABLE_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_ERROR_LOG_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_DST_DATA_DOT;
extern struct SyncMessage DISKIO2_STR_SAVING_PROMO_TYPES;
extern struct SyncMessage DISKIO2_STR_SAVING_DATA_VIEW_CONFIG;

extern char LOCAVAIL_PrimaryFilterState;
extern char LOCAVAIL_SecondaryFilterState;
extern char DST_BannerWindowPrimary;

extern void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(long mask,
                                                               long on);
extern void DISKIO2_DisplayStatusLine(char *text);
extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern void ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern void DISKIO_SaveConfigToFileHandle(void);
extern void GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(char *primary,
                                                              char *secondary);
extern void DISKIO2_WriteQTableIniFile(void);
extern void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void);
extern void DATETIME_SavePairToFile(char *window);
extern void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void);
extern void GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void);

void DISKIO2_RunDiskSyncWorkflow(long verbose)
{
    char line[100];

    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(256, 1);

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    DISKIO2_FlushDataFilesIfNeeded();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_TEXT_ADS_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    ED1_JMPTBL_LADFUNC_SaveTextAdsToFile();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    DISKIO_SaveConfigToFileHandle();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(&LOCAVAIL_PrimaryFilterState,
                                                      &LOCAVAIL_SecondaryFilterState);

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_QTABLE_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    DISKIO2_WriteQTableIniFile();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_ERROR_LOG_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_DST_DATA_DOT;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    DATETIME_SavePairToFile(&DST_BannerWindowPrimary);

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_PROMO_TYPES;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile();

    *(struct SyncMessage *)line = DISKIO2_STR_SAVING_DATA_VIEW_CONFIG;
    if (verbose != 0)
        DISKIO2_DisplayStatusLine(line);
    GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile();
    GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile();
    GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate();

    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(256, 0);
}
