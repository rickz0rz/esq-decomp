/* RESTORES: SCRIPT_ApplyPendingBannerTarget
 * MODULE:   modules/groups/b/a/script3b_p0.s
 * STATUS:   behavioural
 *
 * Starts a banner character transition toward whatever target is pending, and
 * clears the read-mode latch afterwards.
 *
 * The pending target is a three-way sentinel and the values matter:
 *   -2  cancel -- reset the target to -1 and start nothing
 *   -1  no explicit target -- fall back to the configured head byte, and only
 *       transition if the banner is not already showing it
 *   otherwise  transition to that character
 *
 * Every path that starts a transition resets the target to -1, so a pending
 * target fires once.
 *
 * The speed is widened with MOVEQ #0 / MOVE.W -- unsigned short -- while the
 * character is EXT.L'd, so it is signed. Both are passed as longs.
 *
 * The final pair of stores clears ESQPARS2_ReadModeFlags first and the latch
 * second, both from one zeroed register, so the C chain is written
 * right-to-left against that order.
 *
 * 142 ref vs 144 got. Both transition calls with their argument pushes and
 * ADDQ.W #8 cleanups, both MOVE.W #-1 target resets, the MOVEQ #-2 and
 * MOVEQ #-1 sentinels, the speed widening and the final two zero stores match
 * in kind and size.
 *
 * SASC-MISMATCH: compare-direction
 *   ref:     70fe b079....     MOVEQ #-2,D0 / CMP.W target,D0
 *   got:     3039.... 5440     MOVE.W target,D0 / ADDQ.W #2,D0
 *   summary: the original materialises the sentinel and compares against it;
 *            6.51 loads the target and ADDs 2, letting the result be zero when
 *            it was -2. Same condition. It does the same for the -1 test
 *            (5240, ADDQ.W #1). Two bytes, and it is the chained-subtract
 *            idiom appearing where the source has plain equality tests.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long GCOMMAND_GetBannerChar(void);
extern void SCRIPT_BeginBannerCharTransition(long ch, long speed);

extern short SCRIPT_PendingBannerTargetChar;
extern unsigned short SCRIPT_PendingBannerSpeedMs;
extern short SCRIPT_ReadModeActiveLatch;
extern short CONFIG_BannerCopperHeadByte;
extern short ESQPARS2_ReadModeFlags;

void SCRIPT_ApplyPendingBannerTarget(void)
{
    long current;

    current = GCOMMAND_GetBannerChar();

    if (SCRIPT_PendingBannerTargetChar == -2) {
        SCRIPT_PendingBannerTargetChar = -1;

    } else if (SCRIPT_PendingBannerTargetChar != -1) {
        SCRIPT_BeginBannerCharTransition((long)SCRIPT_PendingBannerTargetChar,
                                         (long)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;

    } else if ((short)current != CONFIG_BannerCopperHeadByte) {
        SCRIPT_BeginBannerCharTransition((long)CONFIG_BannerCopperHeadByte,
                                         (long)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;
    }

    if (SCRIPT_ReadModeActiveLatch != 0)
        SCRIPT_ReadModeActiveLatch = ESQPARS2_ReadModeFlags = 0;
}
