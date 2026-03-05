typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

typedef struct DST_ClockState {
    ULONG l0;
    ULONG l4;
    ULONG l8;
    ULONG l12;
    ULONG l16;
    UWORD w20;
} DST_ClockState;

extern DST_ClockState CLOCK_DaySlotIndex;
extern DST_ClockState CLOCK_CurrentDayOfWeekIndex;
extern WORD DST_SecondaryCountdown;
extern WORD WDISP_BannerCharPhaseShift;
extern unsigned char CLOCK_FormatVariantCode;

extern void DST_TickBannerCounters(void);
extern void DST_AddTimeOffset(void *clock_state, long a, long b);

void DST_RefreshBannerBuffer(void)
{
    WORD secondary;

    DST_TickBannerCounters();

    secondary = DST_SecondaryCountdown;
    CLOCK_CurrentDayOfWeekIndex = CLOCK_DaySlotIndex;
    DST_SecondaryCountdown = secondary;

    DST_AddTimeOffset(
        &CLOCK_CurrentDayOfWeekIndex,
        (long)WDISP_BannerCharPhaseShift,
        (long)CLOCK_FormatVariantCode
    );
}
