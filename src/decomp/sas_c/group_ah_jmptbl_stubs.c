#include <exec/types.h>
extern void ESQDISP_UpdateStatusMaskAndRefresh(ULONG mask, LONG setMode);
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern void ESQIFF2_ApplyIncomingStatusPacket(UBYTE *src);
extern void ESQIFF2_ShowAttentionOverlay(BYTE code);
extern void ESQPARS_ClearAliasStringPointers(void);
extern char *ESQSHARED_ApplyProgramTitleTextFilters(const char *text, ULONG flags);
extern void ESQSHARED_InitEntryDefaults(UBYTE *entry);
extern LONG ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex);
extern long ESQ_WildcardMatch(const char *pattern, const char *text);
extern LONG GCOMMAND_LoadCommandFile(void);
extern LONG GCOMMAND_LoadMplexFile(void);
extern LONG GCOMMAND_LoadPPVTemplate(void);
extern LONG LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr);
extern void NEWGRID_RebuildIndexCache(void);
extern LONG PARSE_ReadSignedLongSkipClass3(const char *cursor);
extern void P_TYPE_WritePromoIdDataFile(void);
extern LONG SCRIPT_ReadNextRbfByte(void);
extern char *STR_FindAnyCharPtr(const char *s, const char *charset);

void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(ULONG mask, LONG setMode){ESQDISP_UpdateStatusMaskAndRefresh(mask, setMode);}
void GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void){ESQFUNC_WaitForClockChangeAndServiceUi();}
void GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(const char *src){ESQIFF2_ApplyIncomingStatusPacket((UBYTE *)src);}
void GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(LONG code){ESQIFF2_ShowAttentionOverlay((BYTE)code);}
void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void){ESQPARS_ClearAliasStringPointers();}
char *GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(const char *text, ULONG flags){return ESQSHARED_ApplyProgramTitleTextFilters(text, flags);}
void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(UBYTE *entry){ESQSHARED_InitEntryDefaults(entry);}
LONG GROUP_AH_JMPTBL_ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
long GROUP_AH_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text){return ESQ_WildcardMatch(pattern, text);}
LONG GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(void){return GCOMMAND_LoadCommandFile();}
LONG GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void){return GCOMMAND_LoadMplexFile();}
LONG GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void){return GCOMMAND_LoadPPVTemplate();}
LONG GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr){return LOCAVAIL_SaveAvailabilityDataFile(primaryStatePtr, secondaryStatePtr);}
void GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(void){NEWGRID_RebuildIndexCache();}
LONG GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(const char *cursor){return PARSE_ReadSignedLongSkipClass3(cursor);}
void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void){P_TYPE_WritePromoIdDataFile();}
LONG GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void){return SCRIPT_ReadNextRbfByte();}
char *GROUP_AH_JMPTBL_STR_FindAnyCharPtr(const char *s, const char *charset){return STR_FindAnyCharPtr(s, charset);}
