extern void NEWGRID_DrawTopBorderLine(void);
extern void LOCAVAIL_ResetFilterCursorState(void);
extern void GCOMMAND_ResetHighlightMessages(void);
extern void LADFUNC_SetPackedPenLowNibble(void);
extern void LADFUNC_SaveTextAdsToFile(void);
extern void ESQ_ColdReboot(void);
extern void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);
extern void GCOMMAND_SeedBannerDefaults(void);
extern void MEM_Move(void);
extern void GCOMMAND_SeedBannerFromPrefs(void);
extern void CLEANUP_DrawDateTimeBannerRow(void);
extern void LADFUNC_SetPackedPenHighNibble(void);

void ED1_JMPTBL_NEWGRID_DrawTopBorderLine(void){NEWGRID_DrawTopBorderLine();}
void ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(void){LOCAVAIL_ResetFilterCursorState();}
void ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(void){GCOMMAND_ResetHighlightMessages();}
void ED1_JMPTBL_LADFUNC_MergeHighLowNibbles(void){LADFUNC_SetPackedPenLowNibble();}
void ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void){LADFUNC_SaveTextAdsToFile();}
void ED1_JMPTBL_ESQ_ColdReboot(void){ESQ_ColdReboot();}
void ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void){ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();}
void ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(void){GCOMMAND_SeedBannerDefaults();}
void ED1_JMPTBL_MEM_Move(void){MEM_Move();}
void ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(void){GCOMMAND_SeedBannerFromPrefs();}
void ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(void){CLEANUP_DrawDateTimeBannerRow();}
void ED1_JMPTBL_LADFUNC_PackNibblesToByte(void){LADFUNC_SetPackedPenHighNibble();}
