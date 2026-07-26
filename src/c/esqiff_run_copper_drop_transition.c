/* RESTORES: _ESQIFF_RunCopperDropTransition
 * MODULE:   modules/groups/a/n/esqiffb.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern short COPPER_AnimationLane2_Countdown;
extern void  ESQIFF_RunPendingCopperAnimations(void);
void ESQIFF_RunCopperDropTransition(void)
{
    COPPER_AnimationLane2_Countdown = 15;
    ESQIFF_RunPendingCopperAnimations();
}
