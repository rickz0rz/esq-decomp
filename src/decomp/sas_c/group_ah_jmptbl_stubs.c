extern void ESQDISP_UpdateStatusMaskAndRefresh(void);
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern void ESQIFF2_ApplyIncomingStatusPacket(void);
extern void ESQIFF2_ShowAttentionOverlay(void);
extern void ESQPARS_ClearAliasStringPointers(void);
extern void ESQSHARED_ApplyProgramTitleTextFilters(void);
extern void ESQSHARED_InitEntryDefaults(void);
extern void ESQ_TestBit1Based(void);
extern void ESQ_WildcardMatch(void);
extern void GCOMMAND_LoadCommandFile(void);
extern void GCOMMAND_LoadMplexFile(void);
extern void GCOMMAND_LoadPPVTemplate(void);
extern void LOCAVAIL_SaveAvailabilityDataFile(void);
extern void NEWGRID_RebuildIndexCache(void);
extern void PARSE_ReadSignedLongSkipClass3(void);
extern void P_TYPE_WritePromoIdDataFile(void);
extern void SCRIPT_ReadNextRbfByte(void);
extern void STR_FindAnyCharPtr(void);

void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(void){ESQDISP_UpdateStatusMaskAndRefresh();}
void GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void){ESQFUNC_WaitForClockChangeAndServiceUi();}
void GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(void){ESQIFF2_ApplyIncomingStatusPacket();}
void GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(void){ESQIFF2_ShowAttentionOverlay();}
void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void){ESQPARS_ClearAliasStringPointers();}
void GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(void){ESQSHARED_ApplyProgramTitleTextFilters();}
void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(void){ESQSHARED_InitEntryDefaults();}
void GROUP_AH_JMPTBL_ESQ_TestBit1Based(void){ESQ_TestBit1Based();}
void GROUP_AH_JMPTBL_ESQ_WildcardMatch(void){ESQ_WildcardMatch();}
void GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(void){GCOMMAND_LoadCommandFile();}
void GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void){GCOMMAND_LoadMplexFile();}
void GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void){GCOMMAND_LoadPPVTemplate();}
void GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void){LOCAVAIL_SaveAvailabilityDataFile();}
void GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(void){NEWGRID_RebuildIndexCache();}
void GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(void){PARSE_ReadSignedLongSkipClass3();}
void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void){P_TYPE_WritePromoIdDataFile();}
void GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void){SCRIPT_ReadNextRbfByte();}
void GROUP_AH_JMPTBL_STR_FindAnyCharPtr(void){STR_FindAnyCharPtr();}
