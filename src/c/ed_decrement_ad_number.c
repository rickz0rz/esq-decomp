/* RESTORES: _ED_DecrementAdNumber
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 *
 * Was recorded as `behavioural` with a branch-shape divergence. That was an
 * artifact of the reference, not the compiler: refbytes.py dropped bytes
 * emitted on macro-expansion and continuation lines, so this function was
 * being diffed against a truncated original. With the oracle fixed it
 * matches exactly and the recorded divergence is deleted as false.
 */
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_UpdateAdNumberDisplay(void);
void ED_DecrementAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER > 1) {
        ED_ApplyActiveFlagToAdData();
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER -= 1;
        ED_UpdateAdNumberDisplay();
    }
}
