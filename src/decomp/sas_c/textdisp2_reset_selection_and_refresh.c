#include <exec/types.h>
extern WORD TEXTDISP_CurrentMatchIndex;

extern void SCRIPT_UpdateSerialShadowFromCtrlByte(LONG value);
extern void ESQIFF_PlayNextExternalAssetFrame(WORD value);

void TEXTDISP_ResetSelectionAndRefresh(void)
{
    SCRIPT_UpdateSerialShadowFromCtrlByte(3);
    TEXTDISP_CurrentMatchIndex = (WORD)-1;
    ESQIFF_PlayNextExternalAssetFrame((WORD)0);
}
