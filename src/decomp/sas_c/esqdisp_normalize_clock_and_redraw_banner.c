typedef unsigned char UBYTE;

extern UBYTE CLOCK_DaySlotIndex;
extern UBYTE DST_BannerWindowPrimary;
extern void *Global_REF_RASTPORT_1;
extern UBYTE Global_REF_696_400_BITMAP;

extern void ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(UBYTE *slot_index, void *clock_data);
extern long DST_UpdateBannerQueue(UBYTE *banner_window);
extern void DST_RefreshBannerBuffer(void);
extern void ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(void);
extern void ESQDISP_DrawStatusBanner_Impl(short highlight_flag);

void ESQDISP_NormalizeClockAndRedrawBanner(void *clock_data)
{
    void *saved_bitmap;

    ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, clock_data);
    if (DST_UpdateBannerQueue(&DST_BannerWindowPrimary) == 0) {
        DST_RefreshBannerBuffer();
    }

    saved_bitmap = *(void **)((UBYTE *)Global_REF_RASTPORT_1 + 4);
    *(void **)((UBYTE *)Global_REF_RASTPORT_1 + 4) = &Global_REF_696_400_BITMAP;
    ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner();
    *(void **)((UBYTE *)Global_REF_RASTPORT_1 + 4) = saved_bitmap;
    ESQDISP_DrawStatusBanner_Impl(1);
}
