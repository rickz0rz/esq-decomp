typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
} NEWGRID_AuxData;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;

extern char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID_TestEntrySelectable(char *entry, char *aux, LONG selectionCode);

void NEWGRID_ClearMarkersIfSelectable(LONG selectionCode, WORD modeSel)
{
    const WORD MODE_PRIMARY_ALLOWED = 1;
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_LIMIT = 49;
    const UBYTE FLAG_FALSE = 0;
    LONG i;
    LONG j;
    char *entry;
    NEWGRID_AuxData *aux;

    if (modeSel > MODE_PRIMARY_ALLOWED) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
                break;
            }
            entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
            aux = (NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_PRIMARY);
            if (NEWGRID_TestEntrySelectable(entry, (char *)aux, selectionCode) != 0) {
                for (j = SLOT_FIRST; j < SLOT_LIMIT; ++j) {
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
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        aux = (NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, MODE_SECONDARY);
        if (NEWGRID_TestEntrySelectable(entry, (char *)aux, selectionCode) != 0) {
            for (j = SLOT_FIRST; j < SLOT_LIMIT; ++j) {
                aux->rowFlags[j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
