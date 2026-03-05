typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern LONG LOCAVAIL_FilterModeFlag;
extern LONG LOCAVAIL_FilterClassId;
extern LONG LOCAVAIL_FilterPrevClassId;
extern UBYTE ED_DiagGraphModeChar;
extern WORD WDISP_HighlightActive;

extern void TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(LONG value);
extern void TEXTDISP_DrawNextEntryPreview(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

void TEXTDISP_UpdateHighlightOrPreview(void)
{
    LONG classId;

    if (LOCAVAIL_FilterModeFlag == 1) {
        classId = LOCAVAIL_FilterClassId;
        if (classId == -1) {
            classId = LOCAVAIL_FilterPrevClassId;
        }

        if (ED_DiagGraphModeChar != 'N' && classId == 2) {
            TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(1);
            return;
        }

        if (WDISP_HighlightActive == 1 && classId == 3) {
            TEXTDISP_DrawNextEntryPreview();
        } else {
            TEXTDISP_ResetSelectionAndRefresh();
        }
        return;
    }

    if (ED_DiagGraphModeChar != 'N') {
        TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(1);
        return;
    }

    if (WDISP_HighlightActive == 1) {
        TEXTDISP_DrawNextEntryPreview();
    } else {
        TEXTDISP_ResetSelectionAndRefresh();
    }
}
