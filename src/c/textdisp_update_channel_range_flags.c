/* RESTORES: TEXTDISP_UpdateChannelRangeFlags
 * MODULE:   modules/groups/b/a/textdisp3_p1_p5.s
 * STATUS:   behavioural
 *
 * Picks the primary or secondary channel, checks the code against two allowed
 * ranges and today's day-of-week bit, and either records a match index or
 * stamps the two fallback banner characters.
 *
 * THE RANGES ARE TWO, NOT ONE: 48..67 and 72..77, tested in that order with the
 * gap between 68 and 71 falling through to the fallback. Collapsing them into a
 * single 48..77 test would accept four codes the original rejects.
 *
 * A channel code of 0 becomes 48 first, so an unset channel behaves as the
 * bottom of the first range rather than being rejected.
 *
 * The day check indexes Global_STR_TEXTDISP_C_3 BY THE CHANNEL CODE and tests
 * bit (1 << CLOCK_CurrentDayOfWeekIndex) of the byte there -- a per-channel
 * weekday mask. The shift is a variable ASL.L, not a table lookup.
 *
 * The fallback writes TWO different characters to TWO different globals, 0x64
 * to Selected and 0x31 to Fallback, while the success path writes only
 * Fallback. That asymmetry is in the original.
 *
 * 164 ref vs 144 got. Both range pairs (48/67 and 72/77) are VERBATIM
 * (7030 be40 6d06 7043 be40 6f0c 7048 be40 6d.. 704d be40 6e..), and so are the
 * zero-to-48 default, the variable shift, the AND, and both fallback stores
 * with their literal 0x64 and 0x31.
 *
 * SASC-MISMATCH: address-through-frame-vs-register
 *   ref:     2b7c0000bf1afffc / 41f90000bfe2 2b48fffc
 *            MOVE.L #text,-4(A5) or LEA then MOVE.L A0,-4(A5), then the slot is
 *            pushed as the call argument (2f2dfffc)
 *   got:     4bf900000000 ... 2f0d
 *            LEA text,A5, pushed straight from the register
 *   summary: the original materialises each search-text address into a FRAME
 *            SLOT and pushes it from there; 6.51 keeps it in an address
 *            register. That plus the shift-constant sharing is the 20 bytes.
 *            Same item as gcommand_seed_banner_from_prefs.c.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern short TEXTDISP_FindEntryMatchIndex(char *text, long a, long b);

extern short TEXTDISP_ChannelSourceMode;
extern short TEXTDISP_PrimaryChannelCode;
extern short TEXTDISP_SecondaryChannelCode;
extern char  TEXTDISP_PrimarySearchText[];
extern char  TEXTDISP_SecondarySearchText[];
extern short CLOCK_CurrentDayOfWeekIndex;
extern unsigned char Global_STR_TEXTDISP_C_3[];
extern char  TEXTDISP_BannerCharSelected;
extern char  TEXTDISP_BannerCharFallback;

void TEXTDISP_UpdateChannelRangeFlags(void)
{
    char *text;
    short code;

    if (TEXTDISP_ChannelSourceMode == 1) {
        text = TEXTDISP_PrimarySearchText;
        code = TEXTDISP_PrimaryChannelCode;
    } else {
        text = TEXTDISP_SecondarySearchText;
        code = TEXTDISP_SecondaryChannelCode;
    }

    if (code == 0)
        code = 48;

    if ((code >= 48 && code <= 67) || (code >= 72 && code <= 77)) {
        if ((Global_STR_TEXTDISP_C_3[code]
             & (1L << (long)CLOCK_CurrentDayOfWeekIndex)) != 0) {

            TEXTDISP_BannerCharFallback =
                (char)TEXTDISP_FindEntryMatchIndex(text, 1L, 0L);
            return;
        }
    }

    TEXTDISP_BannerCharSelected = 0x64;
    TEXTDISP_BannerCharFallback = 0x31;
}
