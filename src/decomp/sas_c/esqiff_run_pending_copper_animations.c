typedef signed short WORD;

extern WORD COPPER_AnimationLane0_Countdown;
extern WORD COPPER_AnimationLane1_Countdown;
extern WORD COPPER_AnimationLane2_Countdown;
extern WORD COPPER_AnimationLane3_Countdown;

extern void ESQ_NoOp_006A(void);
extern void ESQ_NoOp_0074(void);
extern void ESQ_DecCopperListsPrimary(void);
extern void ESQ_IncCopperListsTowardsTargets(void);

void ESQIFF_RunPendingCopperAnimations(void)
{
    while (COPPER_AnimationLane0_Countdown > 0) {
        ESQ_NoOp_006A();
        COPPER_AnimationLane0_Countdown -= 1;
    }

    while (COPPER_AnimationLane1_Countdown > 0) {
        ESQ_NoOp_0074();
        COPPER_AnimationLane1_Countdown -= 1;
    }

    while (COPPER_AnimationLane2_Countdown > 0) {
        ESQ_DecCopperListsPrimary();
        COPPER_AnimationLane2_Countdown -= 1;
    }

    while (COPPER_AnimationLane3_Countdown > 0) {
        ESQ_IncCopperListsTowardsTargets();
        COPPER_AnimationLane3_Countdown -= 1;
    }
}
