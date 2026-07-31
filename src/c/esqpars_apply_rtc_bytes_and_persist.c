/* RESTORES: ESQPARS_ApplyRtcBytesAndPersist
 * MODULE:   modules/groups/a/o/esqpars_p1_2.s
 * STATUS:   behavioural
 *
 * Expands eight RTC bytes into a clock record, normalizes and redraws it, then
 * writes the clock back out with the read-mode flags forced to 256.
 *
 * Every byte is SIGN-extended (MOVE.B / EXT.W), not zero-extended, so the
 * source array is signed char. The fourth byte is the year and gets 1900 added
 * in LONG (EXT.L / ADDI.L #1900) before being stored back as a word.
 *
 * The eight destinations are consecutive words at -24(A5) through -10(A5), so
 * the record is eight shorts -- the same 16-byte prefix
 * parseini_normalize_clock_data.c models the front of.
 *
 * The mode save/restore around the write is the same idiom
 * esqfunc_commit_secondary_state_and_persist.c uses, and for the same reason:
 * the persist path reads that flag.
 *
 * 140 ref vs 144 got. All eight MOVE.B / EXT.W widenings, the EXT.L and
 * ADDI.L #1900 on the year, all eight word stores at their consecutive offsets,
 * the PEA of the record and the mode save/restore pair match exactly.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe8 ... 3b40ffe8 ... 4ced0880ffe0 4e5d
 *            LINK.W A5,#-24 / stores at -24(A5).. / MOVEM from A5 / UNLK
 *   got:     9efc0010 ... 3f400008 ... 4cdf2080 defc0010
 *            SUBA.W #16,A7 / stores at 8(A7).. / MOVEM / ADDA.W
 *   summary: the frame class. Note 6.51 allocates 16 bytes where the original
 *            takes 24 -- the record is only 16 bytes and the original reserves
 *            8 more it never uses, which is the same over-allocation seen in
 *            p_type_clone_entry.c.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void ESQDISP_NormalizeClockAndRedrawBanner(void *clock);
extern void ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(void);

extern short ESQPARS2_ReadModeFlags;

void ESQPARS_ApplyRtcBytesAndPersist(char *rtc)
{
    short clock[8];
    short savedMode;

    clock[0] = rtc[0];
    clock[1] = rtc[1];
    clock[2] = rtc[2];
    clock[3] = (short)((long)rtc[3] + 1900);
    clock[4] = rtc[4];
    clock[5] = rtc[5];
    clock[6] = rtc[6];
    clock[7] = rtc[7];

    ESQDISP_NormalizeClockAndRedrawBanner(clock);

    savedMode = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 256;
    ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals();
    ESQPARS2_ReadModeFlags = savedMode;
}
