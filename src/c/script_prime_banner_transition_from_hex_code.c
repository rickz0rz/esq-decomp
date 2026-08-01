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
 * 92 bytes in the original and 92 emitted. Size-exact, and the emitted stream now
 * carries the original's word load of the copper head byte (`3039` against
 * `3239`, the same instruction on another register).
 *
 * FIXED 2026-07-31: `CONFIG_BannerCopperHeadByte` was declared `unsigned char`
 * here and `short` in the eleven other restorations that read it. The byte
 * declaration read offset 0, which is the high half of the word and is 0, so
 * every banner transition primed toward character 0. In the maximum-C build the
 * guide body stopped repainting after the ESC menu closed. The earlier version
 * emitted a byte load and was 90 bytes plus an alignment NOP.
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

/* A SHORT, not a char. The data section spells it `DC.B 0 / DC.B 142`, but every
 * reader in the program loads it with MOVE.W and every writer stores MOVE.W, so
 * the value is the 16-bit 142 and the two bytes are its halves. Declared
 * `unsigned char` this read offset 0 and got 0, which primed every banner
 * transition toward character 0. Eleven other restorations already declare it
 * `short`. See the AGENTS.md section "A byte-wide extern on a word-wide global".
 */
extern short CONFIG_BannerCopperHeadByte;
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

    target = (unsigned char)CONFIG_BannerCopperHeadByte;
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
