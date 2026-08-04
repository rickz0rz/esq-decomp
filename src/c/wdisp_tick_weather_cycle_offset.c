/* RESTORES: WDISP_TickWeatherCycleOffset
 * MODULE:   modules/groups/b/a/wdisp_p1.s   (1 of its 2 blocks)
 * STATUS:   behavioural
 *
 * Counts the weather-status cycle down by one per call, and reloads it from the
 * status digit when it reaches zero.
 *
 * THE DISASSEMBLY ALREADY CALLED IT DEAD -- the module's first line is
 * `; Dead code.` -- and it carried no label until 2026-08-04. The module before
 * it in src/Prevue.asm ends in RTS, so it cannot be reached by fall-through
 * either. Adding the label is byte-neutral. The name is OURS.
 *
 * THE RELOAD VALUE IS THE DIGIT CHARACTER MINUS '0'. The original subtracts
 * 0x30 from WDISP_WeatherStatusDigitChar, so the field holds an ASCII digit and
 * the cycle length is its numeric value. A digit of '0' is rejected up front by
 * the `== 48` test, which is why the reload can never be zero.
 *
 * THE COUNTDOWN IS WRITTEN BACK BEFORE IT IS TESTED. `SUBQ.W #1,D3` then
 * `MOVE.W D3,...` then `BGT` -- so the decremented value is stored whatever
 * happens, and only the branch depends on it. Testing before storing would
 * leave the counter one high on the reload pass.
 *
 * SASC-MISMATCH: read-modify-write-on-memory
 *   summary: the original decrements through a register and stores once; SAS/C
 *            emits the same shape here, and the divergence is the DATA=FAR
 *            absolute addressing of the three globals. A few bytes.
 *   scope:   program-wide.
 *   retest:  a compiler with a near-data addressing mode for these globals.
 */
extern short WDISP_WeatherStatusDigitChar;
extern unsigned char WDISP_WeatherStatusCountdown;
extern short WDISP_WeatherCycleOffsetCount;

void WDISP_TickWeatherCycleOffset(void)
{
    short digit = WDISP_WeatherStatusDigitChar;
    short left;

    if (digit == '0')
        return;
    if (WDISP_WeatherStatusCountdown == 0)
        return;

    left = (short)(WDISP_WeatherCycleOffsetCount - 1);
    WDISP_WeatherCycleOffsetCount = left;
    if (left > 0)
        return;

    WDISP_WeatherCycleOffsetCount = (short)(digit - '0');
}
