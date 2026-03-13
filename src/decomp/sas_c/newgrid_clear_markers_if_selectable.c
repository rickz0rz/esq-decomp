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

extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID_TestEntrySelectable(const void *entry, const void *aux, LONG selectionCode);

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
    const char *entry;
    const NEWGRID_AuxData *aux;
    NEWGRID_AuxData *auxWrite;

    if (modeSel > MODE_PRIMARY_ALLOWED) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
                break;
            }
            entry = ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
            aux = (const NEWGRID_AuxData *)ESQDISP_GetEntryAuxPointerByMode(i, MODE_PRIMARY);
            if (NEWGRID_TestEntrySelectable(entry, aux, selectionCode) != 0) {
                auxWrite = (NEWGRID_AuxData *)aux;
                for (j = SLOT_FIRST; j < SLOT_LIMIT; ++j) {
                    auxWrite->rowFlags[j] &= (UBYTE)~(1u << 5);
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
        entry = ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        aux = (const NEWGRID_AuxData *)ESQDISP_GetEntryAuxPointerByMode(i, MODE_SECONDARY);
        if (NEWGRID_TestEntrySelectable(entry, aux, selectionCode) != 0) {
            auxWrite = (NEWGRID_AuxData *)aux;
            for (j = SLOT_FIRST; j < SLOT_LIMIT; ++j) {
                auxWrite->rowFlags[j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
