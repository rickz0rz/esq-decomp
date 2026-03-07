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
extern LONG NEWGRID_TestEntrySelectable(UBYTE *entry, UBYTE *aux, LONG selectionCode);

void NEWGRID_ClearMarkersIfSelectable(LONG selectionCode, WORD modeSel)
{
    LONG i;
    LONG j;
    UBYTE *entry;
    UBYTE *aux;

    if (modeSel > 1) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == 0) {
                break;
            }
            entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 1);
            aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, 1);
            if (NEWGRID_TestEntrySelectable(entry, aux, selectionCode) != 0) {
                for (j = 1; j < 49; ++j) {
                    aux[7 + j] &= (UBYTE)~(1u << 5);
                }
            }
            ++i;
        }
    }

    i = 0;
    while (i < (LONG)TEXTDISP_SecondaryGroupEntryCount) {
        if (TEXTDISP_SecondaryGroupPresentFlag == 0) {
            break;
        }
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 2);
        aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(i, 2);
        if (NEWGRID_TestEntrySelectable(entry, aux, selectionCode) != 0) {
            for (j = 1; j < 49; ++j) {
                aux[7 + j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
