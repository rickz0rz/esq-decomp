extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern void NEWGRID_RebuildIndexCache(void);
typedef unsigned char UBYTE;
typedef signed long LONG;

extern LONG DATETIME_SavePairToFile(void *pair);
extern void ESQPROTO_VerifyChecksumAndParseList(void);
extern void P_TYPE_ParseAndStoreTypeRecord(void);
extern void ESQPROTO_CopyLabelToGlobal(void);
extern void DST_HandleBannerCommand32_33(void);
extern void ESQ_SeedMinuteEventThresholds(void);
extern void PARSEINI_HandleFontCommand(void);
extern void TEXTDISP_ApplySourceConfigAllEntries(void);
extern void BRUSH_PlaneMaskForIndex(void);
extern void SCRIPT_ResetCtrlContextAndClearStatusLine(void);
extern void PARSEINI_WriteRtcFromGlobals(void);
extern void LOCAVAIL_SaveAvailabilityDataFile(void);
extern void DISPLIB_DisplayTextAtPosition(void);
extern void LADFUNC_SaveTextAdsToFile(void);
extern long PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void DISKIO2_HandleInteractiveFileTransfer(void);
extern void P_TYPE_WritePromoIdDataFile(void);
extern void COI_FreeEntryResources(void);
extern void DST_UpdateBannerQueue(void);
extern void ESQPROTO_ParseDigitLabelAndDisplay(void);
extern void DISKIO_ParseConfigBuffer(void);
extern void CLEANUP_ParseAlignedListingBlock(void);
extern long SCRIPT_ReadNextRbfByte(void);
extern LONG ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *src, LONG length);
extern void DST_RefreshBannerBuffer(void);
extern void DISKIO_SaveConfigToFileHandle(void);

void ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(void){DISKIO2_FlushDataFilesIfNeeded();}
void ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(void){NEWGRID_RebuildIndexCache();}
LONG ESQPARS_JMPTBL_DATETIME_SavePairToFile(void *pair){return DATETIME_SavePairToFile(pair);}
void ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(void){ESQPROTO_VerifyChecksumAndParseList();}
void ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(void){P_TYPE_ParseAndStoreTypeRecord();}
void ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal(void){ESQPROTO_CopyLabelToGlobal();}
void ESQPARS_JMPTBL_DST_HandleBannerCommand32_33(void){DST_HandleBannerCommand32_33();}
void ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(void){ESQ_SeedMinuteEventThresholds();}
void ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(void){PARSEINI_HandleFontCommand();}
void ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries(void){TEXTDISP_ApplySourceConfigAllEntries();}
void ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(void){BRUSH_PlaneMaskForIndex();}
void ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(void){SCRIPT_ResetCtrlContextAndClearStatusLine();}
void ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(void){PARSEINI_WriteRtcFromGlobals();}
void ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void){LOCAVAIL_SaveAvailabilityDataFile();}
void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(void){DISPLIB_DisplayTextAtPosition();}
void ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(void){LADFUNC_SaveTextAdsToFile();}
long ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s){return PARSE_ReadSignedLongSkipClass3_Alt(s);}
void ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(void){DISKIO2_HandleInteractiveFileTransfer();}
void ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(void){P_TYPE_WritePromoIdDataFile();}
void ESQPARS_JMPTBL_COI_FreeEntryResources(void){COI_FreeEntryResources();}
void ESQPARS_JMPTBL_DST_UpdateBannerQueue(void){DST_UpdateBannerQueue();}
void ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay(void){ESQPROTO_ParseDigitLabelAndDisplay();}
void ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(void){DISKIO_ParseConfigBuffer();}
void ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(void){CLEANUP_ParseAlignedListingBlock();}
unsigned char ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void){return (unsigned char)SCRIPT_ReadNextRbfByte();}
LONG ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buffer, LONG len){return ESQ_GenerateXorChecksumByte(seed, buffer, len);}
void ESQPARS_JMPTBL_DST_RefreshBannerBuffer(void){DST_RefreshBannerBuffer();}
void ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(void){DISKIO_SaveConfigToFileHandle();}
