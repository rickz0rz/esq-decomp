typedef signed long LONG;
typedef signed short WORD;

typedef struct TitleEntry TitleEntry;
struct TitleEntry {
    char base_text_prefix[56];
    char *extra_text[35];
};

typedef struct ESQFUNC_EntryTableEntry {
    char pad0[1];
} ESQFUNC_EntryTableEntry;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern ESQFUNC_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern TitleEntry *TEXTDISP_PrimaryTitlePtrTable[];

extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

void ESQFUNC_FreeExtraTitleTextPointers(WORD max_index)
{
    const WORD EXTRA_SLOT_MAX = 34;
    const WORD SLOT_FIRST = 0;
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    WORD entry_index;

    for (entry_index = 0; entry_index < TEXTDISP_PrimaryGroupEntryCount; ++entry_index) {
        TitleEntry *title_entry;
        WORD slot_index;
        WORD kept_first_non_null_slot;

        (void)TEXTDISP_PrimaryEntryPtrTable[entry_index];
        title_entry = TEXTDISP_PrimaryTitlePtrTable[entry_index];
        kept_first_non_null_slot = FLAG_FALSE;

        if (max_index > EXTRA_SLOT_MAX) {
            slot_index = EXTRA_SLOT_MAX;
        } else {
            slot_index = max_index;
        }

        for (; slot_index >= SLOT_FIRST; --slot_index) {
            char *ptr = title_entry->extra_text[slot_index];

            if (ptr == (char *)0) {
                continue;
            }

            if (kept_first_non_null_slot == FLAG_FALSE) {
                kept_first_non_null_slot = FLAG_TRUE;
                continue;
            }

            ESQPARS_ReplaceOwnedString((const char *)0, ptr);
            title_entry->extra_text[slot_index] = (char *)0;
        }
    }
}
