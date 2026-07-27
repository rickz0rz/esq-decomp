/* RESTORES: SCRIPT_PrimeBannerTransitionFromHexCode
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * Sets up a banner-character transition from the current character to the one the
 * copper head byte names: records the target, the signed distance, and the step
 * direction, and arms the transition only if there is actually a distance to
 * cover.
 *
 * The active flag is written twice -- cleared on entry and set or cleared again at
 * the end -- so a caller that primes a zero-distance transition leaves it off.
 *
 * 92 bytes in the original, 90 emitted plus one alignment NOP. Size-exact; the
 * itemisation nets to zero.
 *
 * SASC-MISMATCH: register-zero-reuse
 *   ref:     7000 then 33c0... three times   MOVEQ #0,D0 held across the whole
 *                                           function and stored three times
 *   got:     4279xxxxxxxx three times        CLR.W at each site
 *   summary: The three zero stores to the active flag and the step budget are far
 *            apart and in exclusive branches, so there is no way to write them as
 *            a chain -- the same situation ctasks_ifftaskcleanup.c records as
 *            unreachable from C. Costs nothing here: 6 bytes either way.
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     D2-D3/D7
 *   got:     D4-D7
 *   summary: Same count, different registers, no cost.
 */

extern short SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void);

extern unsigned char CONFIG_BannerCopperHeadByte;
extern short SCRIPT_BannerTransitionActive;
extern char SCRIPT_BannerTransitionTargetChar;
extern short SCRIPT_BannerTransitionStepDelta;
extern short SCRIPT_BannerTransitionStepBudget;
extern short SCRIPT_BannerTransitionStepSign;

void SCRIPT_PrimeBannerTransitionFromHexCode(void)
{
    short current;
    short target;
    short delta;
    short sign;

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    SCRIPT_BannerTransitionActive = 0;

    target = CONFIG_BannerCopperHeadByte;
    delta = target - current;
    SCRIPT_BannerTransitionTargetChar = target;
    SCRIPT_BannerTransitionStepDelta = delta;

    if (delta >= 0)
        sign = 1;
    else
        sign = -1;

    SCRIPT_BannerTransitionStepBudget = 0;
    SCRIPT_BannerTransitionStepSign = sign;

    if (delta)
        SCRIPT_BannerTransitionActive = 1;
    else
        SCRIPT_BannerTransitionActive = 0;
}
