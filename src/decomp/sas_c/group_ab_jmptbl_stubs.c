typedef signed long LONG;

extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(void);
extern void ESQFUNC_FreeLineTextBuffers(void);
extern void ESQIFF_DeallocateAdsAndLogoLstData(void);
extern void LADFUNC_FreeBannerRectEntries(void);
extern void UNKNOWN2A_Stub0(void);
extern void NEWGRID_ShutdownGridResources(void);
extern void LOCAVAIL_FreeResourceChain(void);
extern LONG GRAPHICS_FreeRaster(void *raster, LONG width, LONG height);
extern void IOSTDREQ_Free(void);
extern void ESQIFF2_ClearLineHeadTailByMode(void);

void GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(void)
{
    ESQPARS_RemoveGroupEntryAndReleaseStrings();
}

void GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(void)
{
    ESQFUNC_FreeLineTextBuffers();
}

void GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(void)
{
    ESQIFF_DeallocateAdsAndLogoLstData();
}

void GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(void)
{
    LADFUNC_FreeBannerRectEntries();
}

void GROUP_AB_JMPTBL_UNKNOWN2A_Stub0(void)
{
    UNKNOWN2A_Stub0();
}

void GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(void)
{
    NEWGRID_ShutdownGridResources();
}

void GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(void)
{
    LOCAVAIL_FreeResourceChain();
}

LONG GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, LONG line, void *raster, LONG width, LONG height)
{
    (void)tag;
    (void)line;
    return GRAPHICS_FreeRaster(raster, width, height);
}

void GROUP_AB_JMPTBL_IOSTDREQ_Free(void)
{
    IOSTDREQ_Free();
}

void GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(void)
{
    ESQIFF2_ClearLineHeadTailByMode();
}
