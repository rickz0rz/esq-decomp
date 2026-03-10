extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern void NEWGRID_RebuildIndexCache(void);
typedef unsigned char UBYTE;
typedef signed long LONG;
typedef unsigned long ULONG;

extern LONG DATETIME_SavePairToFile(void *pair);
extern LONG ESQPROTO_VerifyChecksumAndParseList(UBYTE seed);
extern void P_TYPE_ParseAndStoreTypeRecord(void);
extern void ESQPROTO_CopyLabelToGlobal(void);
extern void DST_HandleBannerCommand32_33(void);
extern void ESQ_SeedMinuteEventThresholds(void);
extern void PARSEINI_HandleFontCommand(void);
extern void TEXTDISP_ApplySourceConfigAllEntries(void);
extern unsigned long BRUSH_PlaneMaskForIndex(long planeIndex);
extern void SCRIPT_ResetCtrlContextAndClearStatusLine(void);
extern void PARSEINI_WriteRtcFromGlobals(void);
extern LONG LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern void LADFUNC_SaveTextAdsToFile(void);
extern long PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern LONG DISKIO2_HandleInteractiveFileTransfer(UBYTE crc32Mode);
extern void P_TYPE_WritePromoIdDataFile(void);
extern void COI_FreeEntryResources(void *entry);
extern LONG DST_UpdateBannerQueue(void *pair);
extern void ESQPROTO_ParseDigitLabelAndDisplay(void);
extern void DISKIO_ParseConfigBuffer(char *buffer, ULONG size);
extern void CLEANUP_ParseAlignedListingBlock(void);
extern long SCRIPT_ReadNextRbfByte(void);
extern LONG ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *src, LONG length);
extern void DST_RefreshBannerBuffer(void);
extern LONG DISKIO_SaveConfigToFileHandle(void);

void ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(void){DISKIO2_FlushDataFilesIfNeeded();}
void ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(void){NEWGRID_RebuildIndexCache();}
LONG ESQPARS_JMPTBL_DATETIME_SavePairToFile(void *pair){return DATETIME_SavePairToFile(pair);}
LONG ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(LONG cmdChar){return ESQPROTO_VerifyChecksumAndParseList((UBYTE)cmdChar);}
void ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(void){P_TYPE_ParseAndStoreTypeRecord();}
void ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal(void){ESQPROTO_CopyLabelToGlobal();}
void ESQPARS_JMPTBL_DST_HandleBannerCommand32_33(void){DST_HandleBannerCommand32_33();}
void ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(void){ESQ_SeedMinuteEventThresholds();}
void ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(void){PARSEINI_HandleFontCommand();}
void ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries(void){TEXTDISP_ApplySourceConfigAllEntries();}
unsigned long ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(long planeIndex){return BRUSH_PlaneMaskForIndex(planeIndex);}
void ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(void){SCRIPT_ResetCtrlContextAndClearStatusLine();}
void ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(void){PARSEINI_WriteRtcFromGlobals();}
LONG ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr){return LOCAVAIL_SaveAvailabilityDataFile(primaryStatePtr, secondaryStatePtr);}
void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text){DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);}
void ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(void){LADFUNC_SaveTextAdsToFile();}
long ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s){return PARSE_ReadSignedLongSkipClass3_Alt(s);}
LONG ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(UBYTE crc32Mode){return DISKIO2_HandleInteractiveFileTransfer(crc32Mode);}
void ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(void){P_TYPE_WritePromoIdDataFile();}
void ESQPARS_JMPTBL_COI_FreeEntryResources(void *entry){COI_FreeEntryResources(entry);}
LONG ESQPARS_JMPTBL_DST_UpdateBannerQueue(void *pair){return DST_UpdateBannerQueue(pair);}
void ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay(void){ESQPROTO_ParseDigitLabelAndDisplay();}
void ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(char *buffer, ULONG size){DISKIO_ParseConfigBuffer(buffer, size);}
void ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(void){CLEANUP_ParseAlignedListingBlock();}
unsigned char ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void){return (unsigned char)SCRIPT_ReadNextRbfByte();}
LONG ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buffer, LONG len){return ESQ_GenerateXorChecksumByte(seed, buffer, len);}
void ESQPARS_JMPTBL_DST_RefreshBannerBuffer(void){DST_RefreshBannerBuffer();}
LONG ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(void){return DISKIO_SaveConfigToFileHandle();}
