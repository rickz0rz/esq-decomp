typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

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
        UBYTE *secondary_title;
        UBYTE *secondary_entry;
        LONG primary_index;
        LONG found_match;

        secondary_title = (UBYTE *)TEXTDISP_SecondaryTitlePtrTable[secondary_index];
        if (*(void **)(secondary_title + 60) != 0) {
            continue;
        }

        secondary_entry = (UBYTE *)TEXTDISP_SecondaryEntryPtrTable[secondary_index];
        if ((LONG)(ESQSHARED_JMPTBL_ESQ_TestBit1Based((void *)(secondary_entry + 28), 1L) + 1) != 0) {
            continue;
        }

        found_match = 0;

        for (primary_index = 0; primary_index < primary_count; ++primary_index) {
            UBYTE *primary_title;
            UBYTE *primary_entry;
            LONG selector_slot;
            LONG selector_floor;

            if (found_match != 0) {
                break;
            }

            primary_title = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[primary_index];
            if ((UBYTE)ESQSHARED_JMPTBL_ESQ_WildcardMatch((const char *)secondary_title, (const char *)primary_title) != 0) {
                continue;
            }

            primary_entry = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[primary_index];
            selector_slot = 48;
            if ((primary_entry[40] & 0x20) != 0) {
                selector_floor = 0;
            } else {
                selector_floor = 44;
            }

            while (selector_slot > selector_floor) {
                if (found_match != 0) {
                    break;
                }

                if ((LONG)(ESQSHARED_JMPTBL_ESQ_TestBit1Based((void *)(primary_entry + 28), selector_slot) + 1) != 0) {
                    selector_slot -= 1;
                    continue;
                }

                if (*(void **)(primary_title + ((selector_slot << 2) + 0)) == 0) {
                    selector_slot -= 1;
                    continue;
                }

                secondary_title[8] = (UBYTE)(primary_title[252 + selector_slot] | 0x80);
                *(void **)(secondary_title + 60) = ESQPARS_ReplaceOwnedString(
                    *(void **)(primary_title + (selector_slot << 2)),
                    *(void **)(secondary_title + 60)
                );
                secondary_title[253] = primary_title[252 + selector_slot];
                secondary_title[302] = primary_title[301 + selector_slot];
                secondary_title[351] = primary_title[350 + selector_slot];
                secondary_entry[40] = (UBYTE)(secondary_entry[40] | 0x80);
                found_match = 1;
                selector_slot -= 1;
            }
        }
    }
}
