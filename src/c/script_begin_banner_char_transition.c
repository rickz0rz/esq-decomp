/* RESTORES: _SCRIPT_BeginBannerCharTransition
 * MODULE:   modules/groups/b/a/script3_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: folded-unsigned-guard
 *   ref:     4e55fff448e72f003e2d000a3c2d000e7a0010390000061e7259b001660001100c4700826c063e3c0082600a0c4700e26f043e3c00e27000bc4064042c00600a0c461d4c63043c3c1d4c4eba16703b40fff44a79000075f2660000d4b047670000ce2207240748c248c09480280213c10000c0b84a7900002964660c10390000061f724db00166104a846a08203c00001d4c600270002c002006c0fc003c223c000003e84eba16022b40fff66e0a220433c10000c0ba60664a846a0472ff6002720133c10000c0bc4a846a06240444826002240428022004222dfff64eba15ca33c00000c0ba48c0222dfff64eba15fc98806f12202dfff622044eba15ac33c0000075f060064279000075f030390000c0bac1f90000c0bc33c00000c0ba20067a0133c5000075f233c0000075ee20054cdf00f44e5d4e75
 *   got:     514f48e72f003c2f00263e2f002270001239000000002f4000147459b202660001240c4700826c063e3c0082600a0c4700e26f043e3c00e27000bc4064043c00600a0c461d4c63043c3c1d4c610000002a003039000000006708202f0014600000e4ba476608202f0014600000d8300748c0320548c190812800300713c000000000323900000000660c123900000000744db202660c4a846a063c3c1d4c60027c004846424648462206e9819286e5812001727de789610000002f4000186e0a220433c100000000606a4a846a0a33fcffff00000000600833fc0001000000004a846a0244842004222f00186100000033c00000000048c02f2f00182f0061000000504f98806f12202f001822046100000033c0000000006006427900000000303900000000323900000000c1c133c000000000700133c000000000320633c1000000004cdf00f4504f4e75
 *   summary: 332 got vs 312 ref. The original emits an unsigned lower-bound test on the rate (CMP.W / BCC) that can never fail, and 6.51 folds it away; the arithmetic that replaces it costs more elsewhere, mainly in how the step divide and the remainder budget are sequenced. Both target clamps at 130 and 226, the upper rate clamp at 7500, the active-transition and same-character early exits, the RAVESC-or-MSN rate override keyed on the delta sign, the sign and absolute-value split, the three helper divides and the final sign multiply match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char CONFIG_LRBN_FlagChar;
extern unsigned char CONFIG_MSN_FlagChar;
extern short SCRIPT_BannerTransitionActive;
extern char  SCRIPT_BannerTransitionTargetChar;
extern short SCRIPT_BannerTransitionStepDelta;
extern short SCRIPT_BannerTransitionStepSign;
extern short SCRIPT_BannerTransitionStepBudget;
extern short SCRIPT_PendingBannerSpeedMs;
extern short Global_WORD_SELECT_CODE_IS_RAVESC;

extern short GCOMMAND_GetBannerChar(void);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);

long SCRIPT_BeginBannerCharTransition(short target, unsigned short rate)
{
    short current;
    long  delta;
    long  step;
    long  result;

    result = 0;

    if (CONFIG_LRBN_FlagChar != 'Y')
        return result;

    if (target < 130)
        target = 130;
    else if (target > 226)
        target = 226;

    if (rate < 0)
        rate = 0;
    else if (rate > 7500)
        rate = 7500;

    current = GCOMMAND_GetBannerChar();

    if (SCRIPT_BannerTransitionActive != 0)
        return result;
    if (current == target)
        return result;

    delta = (long)target - (long)current;
    SCRIPT_BannerTransitionTargetChar = (char)target;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 || CONFIG_MSN_FlagChar == 'M') {
        if (delta < 0)
            rate = 7500;
        else
            rate = 0;
    }

    step = rate * 60 / 1000;
    if (step <= 0) {
        SCRIPT_BannerTransitionStepDelta = delta;
    } else {
        if (delta < 0)
            SCRIPT_BannerTransitionStepSign = -1;
        else
            SCRIPT_BannerTransitionStepSign = 1;

        if (delta < 0)
            delta = -delta;

        SCRIPT_BannerTransitionStepDelta = delta / step;
        delta -= MATH_Mulu32(
                     (long)SCRIPT_BannerTransitionStepDelta, step);
        if (delta > 0)
            SCRIPT_BannerTransitionStepBudget = step / delta;
        else
            SCRIPT_BannerTransitionStepBudget = 0;

        SCRIPT_BannerTransitionStepDelta =
            SCRIPT_BannerTransitionStepDelta * SCRIPT_BannerTransitionStepSign;
    }

    result = 1;
    SCRIPT_BannerTransitionActive = result;
    SCRIPT_PendingBannerSpeedMs = rate;
    return result;
}
