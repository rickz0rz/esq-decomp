/* RESTORES: _ESQDISP_DrawStatusBanner_Impl
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0_esqdisp_drawstatusbanner_impl.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-test
 *   ref:     4e55fffc48e737203e2f00267a0022790000870270012c79000028584eaefeaa487900009aa24eba158c584f33c00000a3084a79000053cc67227200320070001039000028d074001439000028d12f022f002f014eba15284fef000c4eba15684a476708700133c00000010030390000a3087202b041654c7227b0416446323900009ab248c174004602c28213c1000087ba303900009aa6761fb0436616303900009aa4760bb043660a13fc0001000087b66064700010015280c08213c0000087b66054323900009ab248c174004602c28213c1000087b6303900009ab253406624303900009aa848c053807203c081660a13fc006e000087ba601c13fc006d000087ba6012303900009ab248c05380c08213c0000087ba303900009ab03239000053e0b240673033c0000053e05340662630390000a3085740660a700033c0000053e2601230390000a308722eb04166064279000053e47c004a8566627004bc806c5c200672144eba2eac41f900007afa2248d3c04aa90010661232390000a32248c1d2862248d3c0b291672a30390000a32248c0d0862f400018200672144eba2e74d1c0202f0018068000000100b09067047000600270012a005286609a4a85674841f900007b0e224845f900007afa700424d951c8fffc41f900007b22224845f900007b0e700424d951c8fffc41f900007b3643f900007b22700422d851c8fffc700123c000007b4630390000a30853406608700033c0000053e230390000a3087202b04165184a79000053e26610720123c1000053d233fc0001000053e2722cb0416608720033c1000053e4722db041651c4a79000053e46614610000f24eba13324eba136433fc0001000053e4
 *   got:     594f48e73f223e2f002a78147c002279000000002c790000000070014eaefeaa4879000000006100000033c000000000584f303900000000672630390000000048c0720012390000000074001439000000002f022f012f00610000004fef000c610000004a476708700133c0000000003039000000007202b0416d4c7227b0416c4632390000000048c174004602c28213c100000000303900000000761fb0436616303900000000760bb043660a13fc0001000000006064700010015280c08213c000000000605432390000000048c174004602c28213c1000000003039000000005340662430390000000048c053807203c081660a13fc006e00000000601c13fc006d00000000601230390000000048c05380c08213c000000000303900000000323900000000b041673433c10000000030390000000053406624303900000000574066084279000000006012303900000000722eb04166064279000000007a004a8666627004ba806c5c200422056100000041f9000000002248d3c045e900104a92663c32390000000048c1d2852248d3c0b291672a30390000000048c0d0852f4000202004220561000000d1c0202f0020068000000100b09067047c0160027c005285609a4a86674841f900000000224845f900000000700424d951c8fffc41f900000000224845f900000000700424d951c8fffc41f90000000043f900000000700422d851c8fffc700123c00000000030390000000053406608700033c0000000003039000000007202b0416d183239000000006610720123c10000000033fc000100000000303900000000722cb0416608720033c100000000303900000000722db0416d1c303900000000661461000000610000006100000033fc0001000000004cdf44fc584f4e754e71
 *   summary: 656 got vs 626 ref, and the reference stops at ESQDISP_DrawStatusBanner_Impl_Return so the epilogue is not counted. 6.51 reloads the half-hour slot global before each of its eight tests where the original keeps it in D0 across three pairs. The 20-byte day-entry stride is held in a local so both scalings call the 32x32 helper, and the three day-entry shifts are struct assignments, which is what produces the original's MOVE.L (A0)+,(A1)+ / DBF rather than a byte loop. The clamp gate, the leap-year group code on 31 December, the 0x6e/0x6d year-parity split, the countdown edge detector with its slot-3 and slot-46 arms, the four-day staleness scan with its two accepted day numbers, and the persist and propagation gates at slots 1, 2, 44 and 45 match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

struct StatusDayEntry { long w[5]; };       /* twenty bytes */

extern struct RastPort *Global_REF_RASTPORT_1;
extern char  CLOCK_DaySlotIndex;
extern short CLOCK_HalfHourSlotIndex;
extern short ESQDISP_StatusBannerClampGateFlag;
extern unsigned char ESQ_STR_B;
extern unsigned char ESQ_STR_E;
extern short BANNER_ResetPendingFlag;
extern short WDISP_BannerSlotCursor;
extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern short CLOCK_CacheDayIndex0;
extern short CLOCK_CacheMonthIndex0;
extern short CLOCK_CacheYear;
extern short CLOCK_CurrentDayOfYear;
extern short DST_PrimaryCountdown;
extern short ESQDISP_LastPrimaryCountdownValue;
extern short ESQDISP_SecondaryPersistArmGateFlag;
extern short ESQDISP_SecondaryPropagationDoneFlag;
extern long  ESQDISP_SecondaryPersistRequestFlag;
extern long  TLIBA1_StatusBannerPropagateGuard;
extern struct StatusDayEntry WDISP_StatusDayEntry0;
extern struct StatusDayEntry WDISP_StatusDayEntry1;
extern struct StatusDayEntry WDISP_StatusDayEntry2;
extern struct StatusDayEntry WDISP_StatusDayEntry3;

extern short ESQ_GetHalfHourSlotIndex(char *daySlot);
extern void  ESQ_ClampBannerCharRange(long slot, long lo,
                                                     long hi);
extern void  LADFUNC_UpdateHighlightState(void);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void  ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern void  LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void);
extern void  P_TYPE_EnsureSecondaryList(void);

void ESQDISP_DrawStatusBanner_Impl(short highlight)
{
    long  stale;
    long  day;
    long  stride;

    stride = 20;
    stale = 0;

    SetAPen(Global_REF_RASTPORT_1, 1);
    CLOCK_HalfHourSlotIndex =
        ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex);

    if (ESQDISP_StatusBannerClampGateFlag != 0)
        ESQ_ClampBannerCharRange((long)CLOCK_HalfHourSlotIndex,
            (long)ESQ_STR_B, (long)ESQ_STR_E);

    LADFUNC_UpdateHighlightState();

    if (highlight != 0)
        BANNER_ResetPendingFlag = 1;

    if (CLOCK_HalfHourSlotIndex >= 2 && CLOCK_HalfHourSlotIndex < 39) {
        TEXTDISP_PrimaryGroupCode = (long)WDISP_BannerSlotCursor & 0xff;
        if (CLOCK_CacheDayIndex0 == 31 && CLOCK_CacheMonthIndex0 == 11)
            TEXTDISP_SecondaryGroupCode = 1;
        else
            TEXTDISP_SecondaryGroupCode =
                ((long)(unsigned char)TEXTDISP_PrimaryGroupCode + 1) & 0xff;
    } else {
        TEXTDISP_SecondaryGroupCode = (long)WDISP_BannerSlotCursor & 0xff;
        if (WDISP_BannerSlotCursor == 1) {
            if ((((long)CLOCK_CacheYear - 1) & 3) == 0)
                TEXTDISP_PrimaryGroupCode = 'n';
            else
                TEXTDISP_PrimaryGroupCode = 'm';
        } else {
            TEXTDISP_PrimaryGroupCode = ((long)WDISP_BannerSlotCursor - 1) & 0xff;
        }
    }

    if (ESQDISP_LastPrimaryCountdownValue != DST_PrimaryCountdown) {
        ESQDISP_LastPrimaryCountdownValue = DST_PrimaryCountdown;
        if (DST_PrimaryCountdown == 1) {
            if (CLOCK_HalfHourSlotIndex == 3)
                ESQDISP_SecondaryPersistArmGateFlag = 0;
            else if (CLOCK_HalfHourSlotIndex == 46)
                ESQDISP_SecondaryPropagationDoneFlag = 0;
        }
    }

    day = 0;
    while (stale == 0 && day < 4) {
        if (*(long *)((char *)&WDISP_StatusDayEntry0 + day * stride + 16) == 0
            && (long)CLOCK_CurrentDayOfYear + day
               != *(long *)((char *)&WDISP_StatusDayEntry0 + day * stride)
            && (long)CLOCK_CurrentDayOfYear + day + 0x100
               != *(long *)((char *)&WDISP_StatusDayEntry0 + day * stride))
            stale = 1;
        else
            stale = 0;
        day++;
    }

    if (stale != 0) {
        WDISP_StatusDayEntry0 = WDISP_StatusDayEntry1;
        WDISP_StatusDayEntry1 = WDISP_StatusDayEntry2;
        WDISP_StatusDayEntry2 = WDISP_StatusDayEntry3;
        TLIBA1_StatusBannerPropagateGuard = 1;
    }

    if (CLOCK_HalfHourSlotIndex == 1)
        ESQDISP_SecondaryPersistArmGateFlag = 0;

    if (CLOCK_HalfHourSlotIndex >= 2
        && ESQDISP_SecondaryPersistArmGateFlag == 0) {
        ESQDISP_SecondaryPersistRequestFlag = 1;
        ESQDISP_SecondaryPersistArmGateFlag = 1;
    }

    if (CLOCK_HalfHourSlotIndex == 44)
        ESQDISP_SecondaryPropagationDoneFlag = 0;

    if (CLOCK_HalfHourSlotIndex >= 45
        && ESQDISP_SecondaryPropagationDoneFlag == 0) {
        ESQDISP_PropagatePrimaryTitleMetadataToSecondary();
        LOCAVAIL_SyncSecondaryFilterForCurrentGroup();
        P_TYPE_EnsureSecondaryList();
        ESQDISP_SecondaryPropagationDoneFlag = 1;
    }
}
