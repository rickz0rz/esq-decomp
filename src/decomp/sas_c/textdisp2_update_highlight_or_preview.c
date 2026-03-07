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
    const LONG FLAG_TRUE = 1;
    const LONG CLASS_UNKNOWN = -1;
    const LONG CLASS_EXTERNAL_ASSET = 2;
    const LONG CLASS_PREVIEW = 3;
    const UBYTE DIAG_MODE_NONE = 'N';
    LONG classId;

    if (LOCAVAIL_FilterModeFlag == FLAG_TRUE) {
        classId = LOCAVAIL_FilterClassId;
        if (classId == CLASS_UNKNOWN) {
            classId = LOCAVAIL_FilterPrevClassId;
        }

        if (ED_DiagGraphModeChar != DIAG_MODE_NONE && classId == CLASS_EXTERNAL_ASSET) {
            TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(FLAG_TRUE);
            return;
        }

        if (WDISP_HighlightActive == FLAG_TRUE && classId == CLASS_PREVIEW) {
            TEXTDISP_DrawNextEntryPreview();
        } else {
            TEXTDISP_ResetSelectionAndRefresh();
        }
        return;
    }

    if (ED_DiagGraphModeChar != DIAG_MODE_NONE) {
        TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(FLAG_TRUE);
        return;
    }

    if (WDISP_HighlightActive == FLAG_TRUE) {
        TEXTDISP_DrawNextEntryPreview();
    } else {
        TEXTDISP_ResetSelectionAndRefresh();
    }
}
