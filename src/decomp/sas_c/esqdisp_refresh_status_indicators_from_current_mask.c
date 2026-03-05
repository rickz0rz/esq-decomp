extern void ESQDISP_ApplyStatusMaskToIndicators(void);

void ESQDISP_RefreshStatusIndicatorsFromCurrentMask(void)
{
    ESQDISP_ApplyStatusMaskToIndicators(-1);
}
