#include <exec/types.h>
extern void NEWGRID_DrawTopBorderLine(void);
extern void LOCAVAIL_ResetFilterCursorState(void);
extern void GCOMMAND_ResetHighlightMessages(void);
extern LONG LADFUNC_SetPackedPenLowNibble(UBYTE packed, UBYTE lowNibble);
extern LONG LADFUNC_SaveTextAdsToFile(void);
extern void ESQ_ColdReboot(void);
extern void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);
extern void GCOMMAND_SeedBannerDefaults(void);
extern LONG MEM_Move(UBYTE *src, UBYTE *dst, LONG length);
extern void GCOMMAND_SeedBannerFromPrefs(void);
extern void CLEANUP_DrawDateTimeBannerRow(void);
extern LONG LADFUNC_SetPackedPenHighNibble(UBYTE highNibble, UBYTE lowNibble);

void ED1_JMPTBL_NEWGRID_DrawTopBorderLine(void){NEWGRID_DrawTopBorderLine();}
void ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(void){LOCAVAIL_ResetFilterCursorState();}
void ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(void){GCOMMAND_ResetHighlightMessages();}
LONG ED1_JMPTBL_LADFUNC_MergeHighLowNibbles(UBYTE packed, UBYTE lowNibble){return LADFUNC_SetPackedPenLowNibble(packed, lowNibble);}
LONG ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void){return LADFUNC_SaveTextAdsToFile();}
void ED1_JMPTBL_ESQ_ColdReboot(void){ESQ_ColdReboot();}
void ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void){ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();}
void ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(void){GCOMMAND_SeedBannerDefaults();}
LONG ED1_JMPTBL_MEM_Move(UBYTE *src, UBYTE *dst, LONG length){return MEM_Move(src, dst, length);}
void ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(void){GCOMMAND_SeedBannerFromPrefs();}
void ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(void){CLEANUP_DrawDateTimeBannerRow();}
LONG ED1_JMPTBL_LADFUNC_PackNibblesToByte(UBYTE highNibble, UBYTE lowNibble){return LADFUNC_SetPackedPenHighNibble(highNibble, lowNibble);}
