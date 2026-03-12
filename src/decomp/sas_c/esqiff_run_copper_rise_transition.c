typedef signed short WORD;

extern WORD COPPER_AnimationLane3_Countdown;

extern void ESQIFF_RunPendingCopperAnimations(void);

void ESQIFF_RunCopperRiseTransition(void)
{
    COPPER_AnimationLane3_Countdown = 15;
    ESQIFF_RunPendingCopperAnimations();
}
