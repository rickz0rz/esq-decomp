/* RESTORES: _ESQFUNC_ProcessUiFrameTick
 * MODULE:   modules/groups/a/n/esqfunc_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-test
 *   ref:     4a790000690067044eba0bde7001b0b9000053c866046100f5924a790000a2dc66044ebaec2a4eba8fbc4a790000a2dc66044eba0c264a790000a2de6700010c4eba0be24ab9000053d2670a42b9000053d26100ff444a7900000478670000ec0839000100005aef67164a790000a2dc660e08b9000100005aef4eba0b9660240839000000005aef671a4a790000a2dc661208b9000000005aef487800014eba21d6584f4ab900005ae8661a4a790000a2dc661230390000a82422000241fffd33c10000a8241039000028e1724eb00167204ab900005ae066184a790000a2dc661030390000a8240240fffe33c00000a8244ab9000001ac66104ab9000001a4670842a74eba129a584f0cb900000001000001b86c0a42a74eba20d4584f602a1039000028e1724eb001671e0cb900000002000001b46c124a790000a2dc660a487800014eba20a8584f4eba0b1a4a39000053d667124a39000068ba660a4239000053d64ebaed684e75
 *   got:     3039000000006704610000007001b0b9000000006604610000003039000000006604610000006100000030390000000066046100000030390000000067000114610000004ab900000000670a42b90000000061000000303900000000670000f410390000000008000001671832390000000066100200fffd13c00000000061000000602208000000671c32390000000066140200fffe13c0000000004878000161000000584f4ab900000000661c303900000000661432390000000048c102810000fffd33c100000000103900000000724eb00167244ab900000000661c303900000000661430390000000048c002800000fffe33c0000000004ab90000000066104ab900000000670842a761000000584f0cb900000001000000006c0a42a761000000584f602a103900000000724eb001671e0cb900000002000000006c12303900000000660a4878000161000000584f610000001039000000004a0067141039000000004a00660a423900000000610000004e754e71
 *   summary: 376 got vs 362 ref. The original reads the busy flag once per guard and reuses the condition codes across two adjacent tests in three places; 6.51 emits a fresh TST.W each time. Every gate is preserved in order: the drive probe, the display-active poll, the two busy-flag guards around the grid pump and the serial command, the pending-alert block with its secondary-persist commit, both IFF task gate bits with their BCLR, the two external-asset flag masks, the brush queue and the two service arms selected by the logo and g-ads counts.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short GCOMMAND_DriveProbeRequestedFlag;
extern long  ESQDISP_DisplayActiveFlag;
extern short Global_UIBusyFlag;
extern short CLEANUP_PendingAlertFlag;
extern long  ESQDISP_SecondaryPersistRequestFlag;
extern short CTASKS_IffTaskDoneFlag;
extern unsigned char ESQFUNC_IffTaskGateFlags;
extern long  Global_REF_LONG_DF0_LOGO_LST_DATA;
extern long  Global_REF_LONG_GFX_G_ADS_DATA;
extern short ESQIFF_ExternalAssetFlags;
extern unsigned char ED_DiagGraphModeChar;
extern long  WDISP_WeatherStatusBrushListHead;
extern long  PARSEINI_BannerBrushResourceHead;
extern long  ESQIFF_LogoBrushListCount;
extern long  ESQIFF_GAdsBrushListCount;
extern char  ESQDISP_StatusRefreshPendingFlag;
extern char  GCOMMAND_HighlightHoldoffTickCount;

extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void ESQDISP_PollInputModeAndRefreshSelection(void);
extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ED_DispatchEscMenuState(void);
extern void SCRIPT_HandleSerialCtrlCmd(void);
extern void CLEANUP_ProcessAlerts(void);
extern void ESQFUNC_CommitSecondaryStateAndPersist(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void ESQIFF_PlayNextExternalAssetFrame(long mode);
extern void ESQIFF_QueueIffBrushLoad(long mode);
extern void ESQIFF_ServiceExternalAssetSourceState(long mode);
extern void TEXTDISP_TickDisplayState(void);
extern void ESQDISP_RefreshStatusIndicatorsFromCurrentMask(void);

void ESQFUNC_ProcessUiFrameTick(void)
{
    if (GCOMMAND_DriveProbeRequestedFlag != 0)
        DISKIO_ProbeDrivesAndAssignPaths();

    if (ESQDISP_DisplayActiveFlag == 1)
        ESQDISP_PollInputModeAndRefreshSelection();

    if (Global_UIBusyFlag == 0)
        ESQDISP_ProcessGridMessagesIfIdle();

    ED_DispatchEscMenuState();

    if (Global_UIBusyFlag == 0)
        SCRIPT_HandleSerialCtrlCmd();

    if (CLEANUP_PendingAlertFlag != 0) {
        CLEANUP_ProcessAlerts();

        if (ESQDISP_SecondaryPersistRequestFlag != 0) {
            ESQDISP_SecondaryPersistRequestFlag = 0;
            ESQFUNC_CommitSecondaryStateAndPersist();
        }

        if (CTASKS_IffTaskDoneFlag != 0) {
            if ((ESQFUNC_IffTaskGateFlags & 2) && Global_UIBusyFlag == 0) {
                ESQFUNC_IffTaskGateFlags &= ~2;
                TEXTDISP_ResetSelectionAndRefresh();
            } else if ((ESQFUNC_IffTaskGateFlags & 1) && Global_UIBusyFlag == 0) {
                ESQFUNC_IffTaskGateFlags &= ~1;
                ESQIFF_PlayNextExternalAssetFrame(1);
            }

            if (Global_REF_LONG_DF0_LOGO_LST_DATA == 0 && Global_UIBusyFlag == 0)
                ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags & 0xfffd;

            if (ED_DiagGraphModeChar != 78 && Global_REF_LONG_GFX_G_ADS_DATA == 0
                && Global_UIBusyFlag == 0)
                ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags & 0xfffe;

            if (WDISP_WeatherStatusBrushListHead == 0
                && PARSEINI_BannerBrushResourceHead != 0)
                ESQIFF_QueueIffBrushLoad(0);

            if (ESQIFF_LogoBrushListCount < 1) {
                ESQIFF_ServiceExternalAssetSourceState(0);
            } else if (ED_DiagGraphModeChar != 78
                       && ESQIFF_GAdsBrushListCount < 2
                       && Global_UIBusyFlag == 0) {
                ESQIFF_ServiceExternalAssetSourceState(1);
            }
        }
    }

    TEXTDISP_TickDisplayState();

    if (ESQDISP_StatusRefreshPendingFlag != 0
        && GCOMMAND_HighlightHoldoffTickCount == 0) {
        ESQDISP_StatusRefreshPendingFlag = 0;
        ESQDISP_RefreshStatusIndicatorsFromCurrentMask();
    }
}
