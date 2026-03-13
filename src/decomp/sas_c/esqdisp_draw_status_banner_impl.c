typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct StatusDayEntry {
    LONG dayOfYearKey;
    LONG flagOrBrushIndex;
    LONG highTempOrValue;
    LONG lowTempOrValue;
    LONG isInactive;
} StatusDayEntry;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern UBYTE ESQ_STR_B;
extern UBYTE ESQ_STR_E;

extern UBYTE CLOCK_DaySlotIndex;
extern WORD CLOCK_HalfHourSlotIndex;
extern WORD CLOCK_CacheMonthIndex0;
extern WORD CLOCK_CacheDayIndex0;
extern WORD CLOCK_CacheYear;
extern WORD CLOCK_CurrentDayOfYear;

extern WORD BANNER_ResetPendingFlag;
extern WORD DST_PrimaryCountdown;
extern WORD WDISP_BannerSlotCursor;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;

extern WORD ESQDISP_StatusBannerClampGateFlag;
extern WORD ESQDISP_LastPrimaryCountdownValue;
extern WORD ESQDISP_SecondaryPersistArmGateFlag;
extern WORD ESQDISP_SecondaryPropagationDoneFlag;
extern LONG ESQDISP_SecondaryPersistRequestFlag;
extern LONG TLIBA1_StatusBannerPropagateGuard;

extern StatusDayEntry WDISP_StatusDayEntry0[];

extern void _LVOSetAPen(void *graphicsBase, void *rastPort, LONG pen);
extern ULONG ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(void *timePtr);
extern void ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(LONG currentChar,
                                                    LONG startBandChar,
                                                    LONG endBandChar);
extern void ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(void);
extern void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern void ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void);
extern void ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(void);

void ESQDISP_DrawStatusBanner_Impl(WORD highlightFlag);

void ESQDISP_DrawStatusBanner(WORD highlightFlag)
{
    ESQDISP_DrawStatusBanner_Impl(highlightFlag);
}

void ESQDISP_DrawStatusBanner_Impl(WORD highlightFlag)
{
    LONG slotIndex;
    LONG hasContiguousStatusDays;
    LONG dayIndex;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    slotIndex = (LONG)ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex);
    CLOCK_HalfHourSlotIndex = (WORD)slotIndex;

    if (ESQDISP_StatusBannerClampGateFlag != 0) {
        ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(
            slotIndex,
            (LONG)ESQ_STR_B,
            (LONG)ESQ_STR_E
        );
    }

    ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState();

    if (highlightFlag != 0) {
        BANNER_ResetPendingFlag = 1;
    }

    if (slotIndex >= 2 && slotIndex < 39) {
        TEXTDISP_PrimaryGroupCode = (UBYTE)WDISP_BannerSlotCursor;

        if (CLOCK_CacheDayIndex0 == 31 && CLOCK_CacheMonthIndex0 == 11) {
            TEXTDISP_SecondaryGroupCode = 1;
        } else {
            TEXTDISP_SecondaryGroupCode = (UBYTE)(TEXTDISP_PrimaryGroupCode + 1);
        }
    } else {
        TEXTDISP_SecondaryGroupCode = (UBYTE)WDISP_BannerSlotCursor;

        if ((WORD)(WDISP_BannerSlotCursor - 1) == 0) {
            if ((((LONG)CLOCK_CacheYear - 1) & 3) == 0) {
                TEXTDISP_PrimaryGroupCode = 0x6E;
            } else {
                TEXTDISP_PrimaryGroupCode = 0x6D;
            }
        } else {
            TEXTDISP_PrimaryGroupCode = (UBYTE)(WDISP_BannerSlotCursor - 1);
        }
    }

    if (DST_PrimaryCountdown != ESQDISP_LastPrimaryCountdownValue) {
        ESQDISP_LastPrimaryCountdownValue = DST_PrimaryCountdown;

        if ((WORD)(DST_PrimaryCountdown - 1) == 0) {
            if ((WORD)(CLOCK_HalfHourSlotIndex - 3) == 0) {
                ESQDISP_SecondaryPersistArmGateFlag = 0;
            } else if (CLOCK_HalfHourSlotIndex == 46) {
                ESQDISP_SecondaryPropagationDoneFlag = 0;
            }
        }
    }

    hasContiguousStatusDays = 0;
    dayIndex = 0;
    while (hasContiguousStatusDays == 0 && dayIndex < 4) {
        LONG expectedDay;
        StatusDayEntry *entry;

        entry = &WDISP_StatusDayEntry0[dayIndex];
        expectedDay = (LONG)(UWORD)(CLOCK_CurrentDayOfYear + (WORD)dayIndex);

        if (entry->isInactive == 0 && entry->dayOfYearKey == expectedDay) {
            hasContiguousStatusDays = 1;
        } else if (entry->dayOfYearKey == expectedDay + 0x100L) {
            hasContiguousStatusDays = 1;
        }

        dayIndex += 1;
    }

    if (hasContiguousStatusDays != 0) {
        WDISP_StatusDayEntry0[0] = WDISP_StatusDayEntry0[1];
        WDISP_StatusDayEntry0[1] = WDISP_StatusDayEntry0[2];
        WDISP_StatusDayEntry0[2] = WDISP_StatusDayEntry0[3];
        TLIBA1_StatusBannerPropagateGuard = 1;
    }

    if ((WORD)(CLOCK_HalfHourSlotIndex - 1) == 0) {
        ESQDISP_SecondaryPersistArmGateFlag = 0;
    }

    if (CLOCK_HalfHourSlotIndex >= 2 &&
        ESQDISP_SecondaryPersistArmGateFlag == 0) {
        ESQDISP_SecondaryPersistRequestFlag = 1;
        ESQDISP_SecondaryPersistArmGateFlag = 1;
    }

    if (CLOCK_HalfHourSlotIndex == 44) {
        ESQDISP_SecondaryPropagationDoneFlag = 0;
    }

    if (CLOCK_HalfHourSlotIndex >= 45 &&
        ESQDISP_SecondaryPropagationDoneFlag == 0) {
        ESQDISP_PropagatePrimaryTitleMetadataToSecondary();
        ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup();
        ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList();
        ESQDISP_SecondaryPropagationDoneFlag = 1;
    }
}
