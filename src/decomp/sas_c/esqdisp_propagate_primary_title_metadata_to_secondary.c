typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct ESQDISP_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
    UBYTE pad1[11];
    UBYTE flags40;
} ESQDISP_Entry;

typedef struct ESQDISP_TitleData {
    UBYTE pad0[7];
    UBYTE slotFlags[49];
    char *titleTable[49];
    UBYTE slotAttr252[49];
    UBYTE slotAttr301[49];
    UBYTE slotAttr350[49];
} ESQDISP_TitleData;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern ESQDISP_Entry *TEXTDISP_PrimaryEntryPtrTable[];
extern ESQDISP_Entry *TEXTDISP_SecondaryEntryPtrTable[];
extern ESQDISP_TitleData *TEXTDISP_PrimaryTitlePtrTable[];
extern ESQDISP_TitleData *TEXTDISP_SecondaryTitlePtrTable[];

extern LONG ESQSHARED_JMPTBL_ESQ_TestBit1Based(void *bitset_base, LONG bit_index);
extern LONG ESQSHARED_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern void *ESQPARS_ReplaceOwnedString(const void *new_ptr, void *old_ptr);

void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void)
{
    LONG secondary_index;
    LONG secondary_count;
    LONG primary_count;

    primary_count = (LONG)(unsigned short)TEXTDISP_PrimaryGroupEntryCount;
    if (primary_count <= 0) {
        return;
    }

    secondary_count = (LONG)(unsigned short)TEXTDISP_SecondaryGroupEntryCount;
    if (secondary_count <= 0) {
        return;
    }

    for (secondary_index = 0; secondary_index < secondary_count; ++secondary_index) {
        ESQDISP_TitleData *secondaryTitle;
        ESQDISP_Entry *secondaryEntry;
        LONG primary_index;
        LONG found_match;

        secondaryTitle = TEXTDISP_SecondaryTitlePtrTable[secondary_index];
        if (secondaryTitle->titleTable[1] != (char *)0) {
            continue;
        }

        secondaryEntry = TEXTDISP_SecondaryEntryPtrTable[secondary_index];
        if ((LONG)(ESQSHARED_JMPTBL_ESQ_TestBit1Based((void *)secondaryEntry->selectionBits, 1L) + 1) != 0) {
            continue;
        }

        found_match = 0;

        for (primary_index = 0; primary_index < primary_count; ++primary_index) {
            ESQDISP_TitleData *primaryTitle;
            ESQDISP_Entry *primaryEntry;
            LONG selector_slot;
            LONG selector_floor;

            if (found_match != 0) {
                break;
            }

            primaryTitle = TEXTDISP_PrimaryTitlePtrTable[primary_index];
            if ((UBYTE)ESQSHARED_JMPTBL_ESQ_WildcardMatch(
                    (const char *)secondaryTitle,
                    (const char *)primaryTitle) != 0) {
                continue;
            }

            primaryEntry = TEXTDISP_PrimaryEntryPtrTable[primary_index];
            selector_slot = 48;
            if ((primaryEntry->flags40 & 0x20) != 0) {
                selector_floor = 0;
            } else {
                selector_floor = 44;
            }

            while (selector_slot > selector_floor) {
                if (found_match != 0) {
                    break;
                }

                if ((LONG)(ESQSHARED_JMPTBL_ESQ_TestBit1Based((void *)primaryEntry->selectionBits, selector_slot) + 1) != 0) {
                    selector_slot -= 1;
                    continue;
                }

                if (primaryTitle->titleTable[selector_slot] == (char *)0) {
                    selector_slot -= 1;
                    continue;
                }

                secondaryTitle->slotFlags[1] = (UBYTE)(primaryTitle->slotAttr252[selector_slot] | 0x80);
                secondaryTitle->titleTable[1] = (char *)ESQPARS_ReplaceOwnedString(
                    primaryTitle->titleTable[selector_slot],
                    secondaryTitle->titleTable[1]
                );
                secondaryTitle->slotAttr252[1] = primaryTitle->slotAttr252[selector_slot];
                secondaryTitle->slotAttr301[1] = primaryTitle->slotAttr301[selector_slot];
                secondaryTitle->slotAttr350[1] = primaryTitle->slotAttr350[selector_slot];
                secondaryEntry->flags40 = (UBYTE)(secondaryEntry->flags40 | 0x80);
                found_match = 1;
                selector_slot -= 1;
            }
        }
    }
}
