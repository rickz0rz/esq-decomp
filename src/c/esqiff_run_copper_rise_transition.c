/* RESTORES: _ESQIFF_RunCopperRiseTransition
 * MODULE:   modules/groups/a/n/esqiffb.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern short COPPER_AnimationLane3_Countdown;
extern void  ESQIFF_RunPendingCopperAnimations(void);
void ESQIFF_RunCopperRiseTransition(void)
{
    COPPER_AnimationLane3_Countdown = 15;
    ESQIFF_RunPendingCopperAnimations();
}
