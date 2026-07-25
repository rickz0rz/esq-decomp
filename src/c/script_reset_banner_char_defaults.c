/* RESTORES: _SCRIPT_ResetBannerCharDefaults
 * MODULE:   modules/groups/b/a/script4.s
 * STATUS:   exact
 *
 * Resets the banner character selection to its defaults. On the display path.
 */
extern char  TEXTDISP_BannerCharSelected;
extern char  TEXTDISP_BannerCharFallback;
extern short TEXTDISP_CurrentMatchIndex;

void SCRIPT_ResetBannerCharDefaults(void)
{
    TEXTDISP_BannerCharSelected = 0x64;
    TEXTDISP_BannerCharFallback = 0x31;
    TEXTDISP_CurrentMatchIndex  = -1;
}
