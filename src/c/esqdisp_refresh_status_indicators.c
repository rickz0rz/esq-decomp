/* RESTORES: _ESQDISP_RefreshStatusIndicatorsFromCurrentMask
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern void ESQDISP_ApplyStatusMaskToIndicators(long mask);
void ESQDISP_RefreshStatusIndicatorsFromCurrentMask(void)
{
    ESQDISP_ApplyStatusMaskToIndicators(-1);
}
