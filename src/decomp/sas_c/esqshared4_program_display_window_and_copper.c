#include <exec/types.h>
extern volatile UWORD DIWSTRT;
extern volatile UWORD DIWSTOP;
extern volatile UWORD DDFSTRT;
extern volatile UWORD DDFSTOP;
extern volatile UWORD BPL1MOD;
extern volatile UWORD BPL2MOD;
extern volatile UWORD VPOSR;
extern volatile ULONG COP1LCH;
extern volatile UWORD COPJMP1;
extern volatile UWORD DMACON;

extern ULONG ESQ_CopperEffectListA;
extern ULONG ESQ_CopperEffectListB;
extern ULONG ESQ_CopperEffectSwitchWaitWordA;
extern ULONG ESQ_CopperEffectSwitchWaitWordB;

extern UWORD ESQ_CopperEffectListA_PtrLoWord;
extern UWORD ESQ_CopperEffectListA_PtrHiWord;
extern UWORD ESQ_CopperEffectListB_PtrLoWord;
extern UWORD ESQ_CopperEffectListB_PtrHiWord;
extern UWORD ESQ_CopperEffectJumpTargetA_LoWord;
extern UWORD ESQ_CopperEffectJumpTargetA_HiWord;
extern UWORD ESQ_CopperEffectJumpTargetB_LoWord;
extern UWORD ESQ_CopperEffectJumpTargetB_HiWord;

void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);

void ESQSHARED4_ProgramDisplayWindowAndCopper(void)
{
    ULONG ptr;

    DIWSTRT = 0x1761;
    DIWSTOP = 0xFFC5;
    DDFSTRT = 0x0038;
    DDFSTOP = 0x00D0;
    BPL1MOD = 0x0058;
    BPL2MOD = 0x0058;

    ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();

    ptr = (ULONG)&ESQ_CopperEffectListB;
    ESQ_CopperEffectListB_PtrLoWord = (UWORD)ptr;
    ESQ_CopperEffectListB_PtrHiWord = (UWORD)(ptr >> 16);

    ptr = (ULONG)&ESQ_CopperEffectListA;
    ESQ_CopperEffectListA_PtrLoWord = (UWORD)ptr;
    ESQ_CopperEffectListA_PtrHiWord = (UWORD)(ptr >> 16);

    ptr = (ULONG)&ESQ_CopperEffectSwitchWaitWordA;
    ESQ_CopperEffectJumpTargetA_LoWord = (UWORD)ptr;
    ESQ_CopperEffectJumpTargetA_HiWord = (UWORD)(ptr >> 16);

    ptr = (ULONG)&ESQ_CopperEffectSwitchWaitWordB;
    ESQ_CopperEffectJumpTargetB_LoWord = (UWORD)ptr;
    ESQ_CopperEffectJumpTargetB_HiWord = (UWORD)(ptr >> 16);

    ptr = (ULONG)&ESQ_CopperEffectListB;
    if ((WORD)VPOSR < 0) {
        ptr = (ULONG)&ESQ_CopperEffectListA;
    }

    COP1LCH = ptr;
    (void)COPJMP1;
    DMACON = 0x0020;
    DMACON = 0x8180;
}
