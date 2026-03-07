typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;

extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);

void NEWGRID_ClearEntryMarkerBits(void *unused, WORD modeSel)
{
    const WORD MODE_PRIMARY_ALLOWED = 1;
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG ENTRY_FLAGS_OFFSET = 47;
    const LONG BIT_SHIFT_ENTRY_MARKER = 4;
    const UBYTE FLAG_FALSE = 0;
    LONG i;
    LONG j;
    UBYTE *entry;
    UBYTE *aux;

    (void)unused;

    if (modeSel > MODE_PRIMARY_ALLOWED) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
                break;
            }
            entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
            if ((entry[ENTRY_FLAGS_OFFSET] & (1u << BIT_SHIFT_ENTRY_MARKER)) != 0) {
                aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_PRIMARY);
                for (j = 1; j < 49; ++j) {
                    aux[7 + j] &= (UBYTE)~(1u << 5);
                }
            }
            ++i;
        }
    }

    i = 0;
    while (i < (LONG)TEXTDISP_SecondaryGroupEntryCount) {
        if (TEXTDISP_SecondaryGroupPresentFlag == FLAG_FALSE) {
            break;
        }
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        if ((entry[ENTRY_FLAGS_OFFSET] & (1u << BIT_SHIFT_ENTRY_MARKER)) != 0) {
            aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_SECONDARY);
            for (j = 1; j < 49; ++j) {
                aux[7 + j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
