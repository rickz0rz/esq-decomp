typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern UBYTE CLOCK_DaySlotIndex;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursAlt;

extern LONG NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(UBYTE *slotPtr);

void NEWGRID_InitSelectionWindowAlt(UBYTE *ctx, WORD row, LONG useAltSpan)
{
    LONG span;
    LONG end;

    if (ctx == 0) {
        return;
    }

    *(LONG *)(ctx + 0) = 0;
    *(LONG *)(ctx + 4) = 0;
    *(LONG *)(ctx + 8) = 0;
    *(WORD *)(ctx + 20) = row;

    if (row < 48) {
        if (row == 1 || (NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
            *(WORD *)(ctx + 20) = (WORD)(*(WORD *)(ctx + 20) + 48);
        }
    }

    *(WORD *)(ctx + 22) = *(WORD *)(ctx + 20);

    if (useAltSpan == 0) {
        span = (LONG)(signed char)CONFIG_NewgridWindowSpanHalfHoursPrimary;
    } else {
        span = (LONG)(signed char)CONFIG_NewgridWindowSpanHalfHoursAlt;
    }

    end = (LONG)(*(WORD *)(ctx + 20)) + span;
    *(WORD *)(ctx + 24) = (WORD)end;
    if (*(WORD *)(ctx + 24) > 96) {
        *(WORD *)(ctx + 24) = 96;
    }
    *(WORD *)(ctx + 24) = (WORD)(*(WORD *)(ctx + 24) + 1);
}
