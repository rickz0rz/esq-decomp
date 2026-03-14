#include <graphics/rastport.h>

extern UBYTE CLOCK_DaySlotIndex;
extern void *DST_BannerWindowPrimary;
extern struct RastPort *Global_REF_RASTPORT_1;
extern UBYTE Global_REF_696_400_BITMAP;

extern void PARSEINI_NormalizeClockData(UBYTE *slot_index, void *clock_data);
extern long DST_UpdateBannerQueue(void *banner_window);
extern void DST_RefreshBannerBuffer(void);
extern void CLEANUP_DrawClockBanner(void);
extern void ESQDISP_DrawStatusBanner_Impl(short highlight_flag);

void ESQDISP_NormalizeClockAndRedrawBanner(void *clock_data)
{
    void *saved_bitmap;

    PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, clock_data);
    if (DST_UpdateBannerQueue(&DST_BannerWindowPrimary) == 0) {
        DST_RefreshBannerBuffer();
    }

    saved_bitmap = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;
    CLEANUP_DrawClockBanner();
    Global_REF_RASTPORT_1->BitMap = saved_bitmap;
    ESQDISP_DrawStatusBanner_Impl(1);
}
