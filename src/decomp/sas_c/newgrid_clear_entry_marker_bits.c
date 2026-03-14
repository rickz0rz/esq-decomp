#include <exec/types.h>
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

extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);

void NEWGRID_ClearEntryMarkerBits(void *unused, WORD modeSel)
{
    const WORD MODE_PRIMARY_ALLOWED = 1;
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const UBYTE FLAG_FALSE = 0;
    LONG i;
    LONG j;
    const UBYTE *entryBytes;
    const NEWGRID_AuxData *aux;
    NEWGRID_AuxData *auxWrite;

    (void)unused;

    if (modeSel > MODE_PRIMARY_ALLOWED) {
        i = 0;
        while (i < (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
                break;
            }
            entryBytes = (const UBYTE *)ESQDISP_GetEntryPointerByMode(i, MODE_PRIMARY);
            if ((entryBytes[47] & 0x10) != 0) {
                aux = (const NEWGRID_AuxData *)ESQDISP_GetEntryAuxPointerByMode(i, MODE_PRIMARY);
                auxWrite = (NEWGRID_AuxData *)aux;
                for (j = 1; j < 49; ++j) {
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
        entryBytes = (const UBYTE *)ESQDISP_GetEntryPointerByMode(i, MODE_SECONDARY);
        if ((entryBytes[47] & 0x10) != 0) {
            aux = (const NEWGRID_AuxData *)ESQDISP_GetEntryAuxPointerByMode(i, MODE_SECONDARY);
            auxWrite = (NEWGRID_AuxData *)aux;
            for (j = 1; j < 49; ++j) {
                auxWrite->rowFlags[j] &= (UBYTE)~(1u << 5);
            }
        }
        ++i;
    }
}
