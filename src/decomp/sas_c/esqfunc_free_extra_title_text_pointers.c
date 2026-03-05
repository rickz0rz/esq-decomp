typedef signed long LONG;
typedef signed short WORD;

typedef struct TitleEntry TitleEntry;
struct TitleEntry {
    char unknown0[56];
    char *extra_text[35];
};

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern TitleEntry *TEXTDISP_PrimaryTitlePtrTable[];

extern void ESQPARS_ReplaceOwnedString(LONG flags, char *ptr);

void ESQFUNC_FreeExtraTitleTextPointers(WORD max_index)
{
    WORD entry_index;

    for (entry_index = 0; entry_index < TEXTDISP_PrimaryGroupEntryCount; ++entry_index) {
        TitleEntry *title_entry;
        WORD slot_index;
        WORD saw_first;

        (void)TEXTDISP_PrimaryEntryPtrTable[entry_index];
        title_entry = TEXTDISP_PrimaryTitlePtrTable[entry_index];
        saw_first = 0;

        if (max_index > 34) {
            slot_index = 34;
        } else {
            slot_index = max_index;
        }

        for (; slot_index >= 0; --slot_index) {
            char *ptr = title_entry->extra_text[slot_index];

            if (ptr == 0) {
                continue;
            }

            if (saw_first == 0) {
                saw_first = 1;
                continue;
            }

            ESQPARS_ReplaceOwnedString(0, ptr);
            title_entry->extra_text[slot_index] = 0;
        }
    }
}
