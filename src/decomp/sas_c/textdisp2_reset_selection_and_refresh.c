typedef signed long LONG;
typedef short WORD;

extern WORD TEXTDISP_CurrentMatchIndex;

extern void SCRIPT_UpdateSerialShadowFromCtrlByte(LONG value);
extern void TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(LONG value);

void TEXTDISP_ResetSelectionAndRefresh(void)
{
    SCRIPT_UpdateSerialShadowFromCtrlByte(3);
    TEXTDISP_CurrentMatchIndex = -1;
    TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(0);
}
