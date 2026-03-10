typedef signed long LONG;
typedef signed short WORD;

extern LONG LOCAVAIL_GetFilterWindowHalfSpan(void);
extern void LADFUNC_DrawEntryPreview(LONG entryIndex);
extern void ESQIFF_RunPendingCopperAnimations(void);
extern void ESQIFF_PlayNextExternalAssetFrame(WORD arg);

LONG TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan(void){return LOCAVAIL_GetFilterWindowHalfSpan();}
void TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(LONG entryIndex){LADFUNC_DrawEntryPreview(entryIndex);}
void TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations(void){ESQIFF_RunPendingCopperAnimations();}
void TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(LONG value){ESQIFF_PlayNextExternalAssetFrame((WORD)value);}
