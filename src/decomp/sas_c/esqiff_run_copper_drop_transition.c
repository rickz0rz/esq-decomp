typedef signed short WORD;

extern WORD COPPER_AnimationLane2_Countdown;

extern void ESQIFF_RunPendingCopperAnimations(void);

void ESQIFF_RunCopperDropTransition(void)
{
    COPPER_AnimationLane2_Countdown = 15;
    ESQIFF_RunPendingCopperAnimations();
}
