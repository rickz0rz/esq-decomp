typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD Global_RefreshTickCounter;
extern UBYTE ESQDISP_LatchedInputModeBit;
extern LONG ESQDISP_InputModeDebounceCount;

extern void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(LONG mode);
extern void ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void);

void ESQDISP_PollInputModeAndRefreshSelection(void)
{
    volatile UBYTE *input_reg;
    LONG mode_bit;

    Global_RefreshTickCounter = -1;
    input_reg = (volatile UBYTE *)0x00BFD0EEUL;
    mode_bit = 4;
    mode_bit &= *input_reg;

    if (ESQDISP_LatchedInputModeBit != (UBYTE)mode_bit) {
        ESQDISP_InputModeDebounceCount += 1;
    } else {
        ESQDISP_InputModeDebounceCount = 0;
    }

    if (ESQDISP_InputModeDebounceCount <= 5) {
        return;
    }

    ESQDISP_LatchedInputModeBit = (UBYTE)mode_bit;
    ESQDISP_InputModeDebounceCount = 0;
    if ((UBYTE)mode_bit == 0) {
        ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(0);
        return;
    }

    ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh();
}
