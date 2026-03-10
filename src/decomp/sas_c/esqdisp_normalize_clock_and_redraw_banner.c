typedef unsigned char UBYTE;

typedef struct ESQDISP_RastPort {
    UBYTE pad0[4];
    void *bitmap;
} ESQDISP_RastPort;

extern UBYTE CLOCK_DaySlotIndex;
extern void *DST_BannerWindowPrimary;
extern ESQDISP_RastPort *Global_REF_RASTPORT_1;
extern UBYTE Global_REF_696_400_BITMAP;

extern void ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(UBYTE *slot_index, void *clock_data);
extern long DST_UpdateBannerQueue(void *banner_window);
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

    saved_bitmap = Global_REF_RASTPORT_1->bitmap;
    Global_REF_RASTPORT_1->bitmap = &Global_REF_696_400_BITMAP;
    ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner();
    Global_REF_RASTPORT_1->bitmap = saved_bitmap;
    ESQDISP_DrawStatusBanner_Impl(1);
}
