    XDEF    DISKIO2_DisplayStatusLine
    XDEF    _DISKIO2_RunDiskSyncWorkflow


;------------------------------------------------------------------------------
; FUNC: DISKIO2_DisplayStatusLine   (Display status line at fixed position.)
; ARGS:
;   stack +4: A3 = message string
; RET:
;   D0: none
; CLOBBERS:
;   A1/A3/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none observed)
; DESC:
;   Clears a fixed area 38 characters wide, and renders the supplied text at (40,120).
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_DisplayStatusLine:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     _Global_STR_38_SPACES
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  A3,(A7)
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_RunDiskSyncWorkflow   (Disk I/O initialization sequence with optional UI.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +96: arg_2 (via 100(A5))
;   stack +100: arg_3 (via 104(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D7
; CALLS:
;   _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, DISKIO2_DisplayStatusLine, _DISKIO2_FlushDataFilesIfNeeded, ED1_JMPTBL_LADFUNC_SaveTextAdsToFile, DISKIO_SaveConfigToFileHandle, GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, _DISKIO2_WriteQTableIniFile,
;   _GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry, _DATETIME_SavePairToFile, GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile, GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile, _GCOMMAND_LoadMplexFile,
;   _GCOMMAND_LoadPPVTemplate
; READS:
;   DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT..DISKIO2_STR_SAVING_DATA_VIEW_CONFIG text tables
; WRITES:
;   (none observed)
; DESC:
;   Runs a staged initialization sequence, optionally printing status strings.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_RunDiskSyncWorkflow:
    LINK.W  A5,#-100
    MOVE.L  D7,-(A7)
    MOVE.L  8(A5),D7

    PEA     1.W
    PEA     256.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    LEA     DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

    ; Copy status string into stack buffer and optionally display it.
.loc_0485:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0485
    TST.L   D7
    BEQ.S   .loc_0486

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0486:
    BSR.W   _DISKIO2_FlushDataFilesIfNeeded

    LEA     DISKIO2_STR_SAVING_TEXT_ADS_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0487:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0487
    TST.L   D7
    BEQ.S   .loc_0488

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0488:
    JSR     ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

    LEA     DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0489:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0489
    TST.L   D7
    BEQ.S   .loc_048A

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048A:
    JSR     DISKIO_SaveConfigToFileHandle(PC)

    LEA     DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048B
    TST.L   D7
    BEQ.S   .loc_048C

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048C:
    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(PC)

    ADDQ.W  #8,A7
    LEA     DISKIO2_STR_SAVING_QTABLE_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048D
    TST.L   D7
    BEQ.S   .loc_048E

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048E:
    BSR.W   _DISKIO2_WriteQTableIniFile

    LEA     DISKIO2_STR_SAVING_ERROR_LOG_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048F:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048F
    TST.L   D7
    BEQ.S   .loc_0490

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0490:
    JSR     _GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(PC)

    LEA     DISKIO2_STR_SAVING_DST_DATA_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0491:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0491
    TST.L   D7
    BEQ.S   .loc_0492

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0492:
    PEA     _DST_BannerWindowPrimary
    JSR     _DATETIME_SavePairToFile(PC)

    ADDQ.W  #4,A7
    LEA     DISKIO2_STR_SAVING_PROMO_TYPES,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0493:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0493
    TST.L   D7
    BEQ.S   .loc_0494

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0494:
    JSR     GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    LEA     DISKIO2_STR_SAVING_DATA_VIEW_CONFIG,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0495:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0495
    TST.L   D7
    BEQ.S   .loc_0496

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0496:
    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(PC)

    CLR.L   -(A7)
    PEA     256.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVE.L  -104(A5),D7
    UNLK    A5
    RTS

;!======