/* RESTORES: _ED_IncrementAdNumber
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern long ED_MaxAdNumber;
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_UpdateAdNumberDisplay(void);
void ED_IncrementAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER < ED_MaxAdNumber) {
        ED_ApplyActiveFlagToAdData();
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER += 1;
        ED_UpdateAdNumberDisplay();
    }
}
