#include <exec/types.h>
extern UBYTE ESQ_CopperEffectListA[];
extern UBYTE ESQ_CopperEffectListB[];
extern volatile UWORD VPOSR;
extern volatile ULONG COP1LCH;

extern ULONG ESQPARS2_ActiveCopperListSelectFlag;
extern UWORD ESQPARS2_CopperProgramPendingFlag;
extern UWORD SCRIPT_BannerTransitionActive;
extern UBYTE GCOMMAND_HighlightHoldoffTickCount;
extern UWORD ESQPARS2_ReadModeFlags;
extern UWORD ESQPARS2_HighlightTickCountdown;
extern UWORD ESQPARS2_StateIndex;
extern UWORD ED2_HighlightTickEnabledFlag;

void ESQSHARED4_ProgramDisplayWindowAndCopper(void);
void SCRIPT_UpdateBannerCharTransition(void);
void GCOMMAND_TickHighlightState(void);
void ESQSHARED4_BlitBannerRowsForActiveField(void);

void ESQSHARED4_TickCopperAndBannerTransitions(void)
{
    UBYTE *active_list = ESQ_CopperEffectListA;
    ULONG active_flag = 1;

    if ((WORD)VPOSR < 0) {
        active_list = ESQ_CopperEffectListB;
        active_flag = 0;
    }

    COP1LCH = (ULONG)active_list;
    ESQPARS2_ActiveCopperListSelectFlag = active_flag;

    if (ESQPARS2_CopperProgramPendingFlag != 0) {
        ESQSHARED4_ProgramDisplayWindowAndCopper();
        ESQPARS2_CopperProgramPendingFlag = 0;
        return;
    }

    SCRIPT_UpdateBannerCharTransition();
    if (SCRIPT_BannerTransitionActive != 0) {
        return;
    }

    if (GCOMMAND_HighlightHoldoffTickCount != 0) {
        GCOMMAND_HighlightHoldoffTickCount = (UBYTE)(GCOMMAND_HighlightHoldoffTickCount - 1);
        ESQPARS2_HighlightTickCountdown = (UWORD)(ESQPARS2_HighlightTickCountdown - 1);
        ESQSHARED4_BlitBannerRowsForActiveField();
        return;
    }

    if (ESQPARS2_ReadModeFlags == 0x0200) {
        ESQPARS2_ReadModeFlags = 0x0100;
    } else if (ESQPARS2_ReadModeFlags == 0x0102) {
        return;
    } else if (ESQPARS2_ReadModeFlags == 0x0101) {
        return;
    } else if (ESQPARS2_ReadModeFlags == 0x0100) {
        return;
    } else if ((WORD)ESQPARS2_ReadModeFlags >= 0) {
        ESQPARS2_ReadModeFlags = (UWORD)(ESQPARS2_ReadModeFlags - 1);
        return;
    } else {
        ESQPARS2_HighlightTickCountdown = (UWORD)(ESQPARS2_HighlightTickCountdown - 1);
        if ((WORD)ESQPARS2_HighlightTickCountdown >= 0) {
            return;
        }
    }

    ESQPARS2_HighlightTickCountdown = ESQPARS2_StateIndex;
    if (ED2_HighlightTickEnabledFlag != 0) {
        GCOMMAND_TickHighlightState();
    }
}
