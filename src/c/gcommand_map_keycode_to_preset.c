/* RESTORES: GCOMMAND_MapKeycodeToPreset
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: byte-vs-long-register-width
 *   ref:     48e703001e2f000f7c002007...   MOVEM D6-D7 / MOVE.B 15(A7),D7 / MOVEQ #0,D6 / MOVE.L D7,D0
 *   got:     48e707001e2f00131c077a00...   MOVEM D5-D7 / MOVE.B 19(A7),D5 / MOVE.B D7,D6 / MOVEQ #0,D5
 *   summary: 98 bytes against 104. The original holds the keycode in D7 and
 *            copies it with MOVE.L before each byte mask; SAS/C keeps a separate
 *            byte copy, which costs a third register (mask 48E70700 vs 48E70300)
 *            and shifts every stack offset by four. The masking, the three-way
 *            branch and the indexed store are otherwise identical.
 *   tried:   SHORTINT, char vs long parameter, with and without a local copy.
 *   scope:   functions taking a char parameter that is then used in word or long
 *            context.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C.
 */
extern long  CONFIG_RefreshIntervalSeconds;
extern short CONFIG_BannerCopperHeadByte;
extern char  ESQPARS2_BannerQueueBuffer[];
extern short GCOMMAND_BannerQueueSlotPrevious;
extern short GCOMMAND_GetBannerChar(void);
void GCOMMAND_MapKeycodeToPreset(char key)
{
    register char k = key;
    register long value = 0;
    if ((k & 0x30) == 0x30)
        value = CONFIG_RefreshIntervalSeconds;
    else if ((k & 0x20) == 0x20) {
        if (CONFIG_BannerCopperHeadByte == GCOMMAND_GetBannerChar())
            value = CONFIG_RefreshIntervalSeconds;
    }
    else if ((k & 0x40) == 0x40)
        value = -1;
    ESQPARS2_BannerQueueBuffer[GCOMMAND_BannerQueueSlotPrevious] = (char)value;
}
