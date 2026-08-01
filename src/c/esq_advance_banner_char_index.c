/* RESTORES: ESQ_AdvanceBannerCharIndex
 * MODULE:   modules/groups/a/a/app2_p7.s  (with ESQ_AdjustBracketedHourInString)
 * STATUS:   behavioural
 *
 * Steps the banner character index on by one, wraps it at the configured range,
 * raises a one-shot pulse when it wraps, and writes a phase-shifted copy of the
 * new index to a shadow global.
 *
 * NO CALLER. The label carries no XDEF and every mention of the name in the tree
 * is inside a `; USED BY:` comment in src/data/wdisp.s. The module it shares with
 * ESQ_AdjustBracketedHourInString is replaced whole, so this has to be restored
 * even though nothing runs it.
 *
 * THE PULSE FIRES ON TWO DIFFERENT CONDITIONS THAT SHARE ONE TAIL. A pending
 * reset flag CLEARS the flag and wraps; otherwise reaching the range end wraps
 * without touching the flag. Both paths fall into the same two stores, which is
 * why the C has the pair written twice rather than a combined test -- combining
 * them would have to clear the flag on the range-end path too.
 *
 * THE SHADOW IS WRITTEN ON EVERY PATH, including the early exit when the phase
 * shift is zero. The original's `BEQ` jumps to the _Return label, and that label
 * is the store, not the RTS.
 *
 * THE PHASE SHIFT IS ADDED TWICE, not multiplied. `ADD.W D1,D0 / ADD.W D1,D0` is
 * what the original does, and the doubled value is then wrapped into 1..48 with
 * ONE correction in each direction -- not a loop. A shift beyond +/-24 therefore
 * leaves the shadow outside the range, in the original too.
 *
 * EVERY VALUE IS A SIGNED WORD. All the compares are BLE/BGE on .W operands, so
 * the locals and the globals are `short`.
 *
 * SASC-MISMATCH: compare-register-order
 *   ref:     MOVEQ #48,D3 / CMP.W D3,D0    the bound is held in a register
 *   got:     an immediate compare against 48
 *   summary: the original hoists 1 and 48 into D2 and D3 and reuses them at
 *            four sites. 6.51 re-materialises each constant. Same values, same
 *            branch conditions.
 *   scope:   program-wide constant-hoisting difference.
 *   retest:  re-run tools/mismatches.py --recheck against another SAS/C.
 */

extern short WDISP_BannerCharIndex;
extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;
extern short WDISP_BannerCharPhaseShift;
extern short BANNER_ResetPendingFlag;
extern short ESQ_BannerCharResetPulse;
extern short ESQ_BannerCharIndexShadow2273;

void ESQ_AdvanceBannerCharIndex(void)
{
    short v;
    short shift;

    v = WDISP_BannerCharIndex + 1;
    if (v > 48)
        v = 1;

    if (BANNER_ResetPendingFlag != 0) {
        BANNER_ResetPendingFlag = 0;
        ESQ_BannerCharResetPulse = 1;
        v = WDISP_BannerCharRangeStart;
    } else if (v == WDISP_BannerCharRangeEnd) {
        ESQ_BannerCharResetPulse = 1;
        v = WDISP_BannerCharRangeStart;
    }

    WDISP_BannerCharIndex = v;

    shift = WDISP_BannerCharPhaseShift;
    if (shift != 0) {
        v += shift;
        v += shift;
        if (v < 1)
            v += 48;
        else if (v > 48)
            v -= 48;
    }

    ESQ_BannerCharIndexShadow2273 = v;
}
