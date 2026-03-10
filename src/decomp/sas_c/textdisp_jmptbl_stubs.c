typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_ShouldOpenEditor(char *entry);
extern LONG ESQDISP_TestEntryGridEligibility(const UBYTE *entry, WORD index);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void CLEANUP_BuildAlignedStatusLine(char *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken);
extern void CLEANUP_DrawInsetRectFrame(UBYTE *rp, UBYTE pen, UWORD w, UWORD h);

LONG TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(char *entry){return NEWGRID_ShouldOpenEditor(entry);}
LONG TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(const char *entry, LONG index){return ESQDISP_TestEntryGridEligibility((const UBYTE *)entry, (WORD)index);}
void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void){ESQIFF_RunCopperRiseTransition();}
void TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(char *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken){CLEANUP_BuildAlignedStatusLine(out, isPrimary, modeSel, slot, alignToken);}
void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(char *rastport, LONG framePen, LONG width, LONG depth){CLEANUP_DrawInsetRectFrame((UBYTE *)rastport, (UBYTE)framePen, (UWORD)width, (UWORD)depth);}
