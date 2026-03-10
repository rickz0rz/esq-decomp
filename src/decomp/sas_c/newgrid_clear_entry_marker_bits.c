typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[47];
    UBYTE flags47;
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
} NEWGRID_AuxData;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;

extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);

void NEWGRID_ClearEntryMarkerBits(void *unused, WORD modeSel)
{
    const WORD MODE_PRIMARY_ALLOWED = 1;
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG BIT_SHIFT_ENTRY_MARKER = 4;
    const UBYTE FLAG_FALSE = 0;
    LONG i;
    LONG j;
    const NEWGRID_Entry *entry;
    NEWGRID_AuxData *aux;

    (void)unused;

    if (modeSel > MODE_PRIMARY_ALLOWED) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
                break;
            }
            entry = (const NEWGRID_Entry *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
            if ((entry->flags47 & (1u << BIT_SHIFT_ENTRY_MARKER)) != 0) {
                aux = (NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_PRIMARY);
                for (j = 1; j < 49; ++j) {
                    aux->rowFlags[j] &= (UBYTE)~(1u << 5);
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
        entry = (const NEWGRID_Entry *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        if ((entry->flags47 & (1u << BIT_SHIFT_ENTRY_MARKER)) != 0) {
            aux = (NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_SECONDARY);
            for (j = 1; j < 49; ++j) {
                aux->rowFlags[j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
