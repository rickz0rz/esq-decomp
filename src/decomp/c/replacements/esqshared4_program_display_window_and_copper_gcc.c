#include "esq_types.h"

extern volatile u16 DIWSTRT;
extern volatile u16 DIWSTOP;
extern volatile u16 DDFSTRT;
extern volatile u16 DDFSTOP;
extern volatile u16 BPL1MOD;
extern volatile u16 BPL2MOD;
extern volatile u16 VPOSR;
extern volatile u16 COPJMP1;
extern volatile u32 COP1LCH;
extern volatile u16 DMACON;

extern u8 ESQ_CopperEffectListA;
extern u8 ESQ_CopperEffectListB;
extern u8 ESQ_CopperEffectSwitchWaitWordA;
extern u8 ESQ_CopperEffectSwitchWaitWordB;

extern u16 ESQ_CopperEffectListA_PtrLoWord;
extern u16 ESQ_CopperEffectListA_PtrHiWord;
extern u16 ESQ_CopperEffectListB_PtrLoWord;
extern u16 ESQ_CopperEffectListB_PtrHiWord;
extern u16 ESQ_CopperEffectJumpTargetA_LoWord;
extern u16 ESQ_CopperEffectJumpTargetA_HiWord;
extern u16 ESQ_CopperEffectJumpTargetB_LoWord;
extern u16 ESQ_CopperEffectJumpTargetB_HiWord;

void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void) __attribute__((noinline));
void ESQSHARED4_ProgramDisplayWindowAndCopper(void) __attribute__((noinline, used));

void ESQSHARED4_ProgramDisplayWindowAndCopper(void)
{
    u32 p;
    u8 *active;

    DIWSTRT = 0x1761;
    DIWSTOP = 0xFFC5;
    DDFSTRT = 0x0030;
    DDFSTOP = 0x00D8;
    BPL1MOD = 0x0058;
    BPL2MOD = 0x0058;

    ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();

    p = (u32)&ESQ_CopperEffectListB;
    ESQ_CopperEffectListB_PtrLoWord = (u16)p;
    ESQ_CopperEffectListB_PtrHiWord = (u16)(p >> 16);

    p = (u32)&ESQ_CopperEffectListA;
    ESQ_CopperEffectListA_PtrLoWord = (u16)p;
    ESQ_CopperEffectListA_PtrHiWord = (u16)(p >> 16);

    p = (u32)&ESQ_CopperEffectSwitchWaitWordA;
    ESQ_CopperEffectJumpTargetA_LoWord = (u16)p;
    ESQ_CopperEffectJumpTargetA_HiWord = (u16)(p >> 16);

    p = (u32)&ESQ_CopperEffectSwitchWaitWordB;
    ESQ_CopperEffectJumpTargetB_LoWord = (u16)p;
    ESQ_CopperEffectJumpTargetB_HiWord = (u16)(p >> 16);

    active = &ESQ_CopperEffectListB;
    if ((s16)VPOSR < 0) {
        active = &ESQ_CopperEffectListA;
    }

    COP1LCH = (u32)active;
    (void)COPJMP1;
    DMACON = 0x0020;
    DMACON = 0x8180;
}
