typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE CLOCK_DaySlotIndex;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;

extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(UBYTE *slotPtr);
extern LONG SCRIPT3_JMPTBL_MATH_DivS32(LONG num, LONG den);

void NEWGRID_InitSelectionWindow(UBYTE *ctx, WORD row)
{
    LONG i;
    LONG q;

    if (ctx == 0) {
        return;
    }

    *(LONG *)(ctx + 0) = 0;
    *(LONG *)(ctx + 4) = 0;
    *(LONG *)(ctx + 8) = 0;

    if (row != 0) {
        *(LONG *)(ctx + 12) = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        i = 0;
        while (i < *(LONG *)(ctx + 12)) {
            UBYTE *entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 1);
            if ((entry[47] & 0x10) != 0) {
                *(LONG *)(ctx + 12) = i;
            }
            ++i;
        }

        *(LONG *)(ctx + 16) = *(LONG *)(ctx + 12);
        i = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        while (i > *(LONG *)(ctx + 16)) {
            UBYTE *entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i - 1, 1);
            if ((entry[47] & 0x10) != 0) {
                *(LONG *)(ctx + 16) = i;
            }
            --i;
        }
    } else {
        *(LONG *)(ctx + 12) = 0;
        *(LONG *)(ctx + 16) = 0;
    }

    *(WORD *)(ctx + 20) = row;
    if (row < 48) {
        if (row == 1 || (NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
            *(WORD *)(ctx + 20) = (WORD)(*(WORD *)(ctx + 20) + 48);
        }
    }

    *(WORD *)(ctx + 22) = *(WORD *)(ctx + 20);

    q = SCRIPT3_JMPTBL_MATH_DivS32(29 + GCOMMAND_PpvSelectionWindowMinutes, 30);
    *(WORD *)(ctx + 24) = (WORD)((LONG)(*(WORD *)(ctx + 20)) + q);
    if (*(WORD *)(ctx + 24) > 96) {
        *(WORD *)(ctx + 24) = 96;
    }
    *(WORD *)(ctx + 24) = (WORD)(*(WORD *)(ctx + 24) + 1);
}
