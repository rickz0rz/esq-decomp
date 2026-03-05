typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;

extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

extern const char Global_STR_ESQPARS_C_2[];
extern const char Global_STR_ESQPARS_C_3[];
extern const char Global_STR_ESQPARS_C_4[];

extern void ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(void);
extern void ESQIFF2_ClearLineHeadTailByMode(LONG mode);
extern void ESQPARS_JMPTBL_COI_FreeEntryResources(void *entry);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, ULONG size);

void ESQPARS_RemoveGroupEntryAndReleaseStrings(UWORD mode)
{
    LONG idx;

    ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine();
    ESQIFF2_ClearLineHeadTailByMode((LONG)mode);

    if (mode == 2) {
        idx = (LONG)TEXTDISP_SecondaryGroupEntryCount - 1;
        TEXTDISP_SecondaryGroupEntryCount = 0;
        TEXTDISP_SecondaryGroupPresentFlag = 0;
    } else {
        idx = (LONG)TEXTDISP_PrimaryGroupEntryCount - 1;
        TEXTDISP_PrimaryGroupEntryCount = 0;
        TEXTDISP_PrimaryGroupPresentFlag = 0;
    }

    for (; idx >= 0; --idx) {
        void *entry;
        void *title_table;
        LONG slot;

        if (mode == 2) {
            entry = TEXTDISP_SecondaryEntryPtrTable[idx];
            TEXTDISP_SecondaryEntryPtrTable[idx] = (void *)0;
            title_table = TEXTDISP_SecondaryTitlePtrTable[idx];
            TEXTDISP_SecondaryTitlePtrTable[idx] = (void *)0;
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[idx];
            TEXTDISP_PrimaryEntryPtrTable[idx] = (void *)0;
            title_table = TEXTDISP_PrimaryTitlePtrTable[idx];
            TEXTDISP_PrimaryTitlePtrTable[idx] = (void *)0;
        }

        for (slot = 0; title_table != (void *)0 && slot < 49; ++slot) {
            char **slot_ptr = (char **)((UBYTE *)title_table + 56 + (slot * 4));
            char *s = *slot_ptr;
            if (s != (char *)0) {
                ULONG n = 0;
                while (s[n] != 0) {
                    ++n;
                }
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_2, 1025, s, n + 1);
                *slot_ptr = (char *)0;
            }
        }

        if (title_table != (void *)0) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_3, 1031, title_table, 500);
        }

        ESQPARS_JMPTBL_COI_FreeEntryResources(entry);

        if (entry != (void *)0) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_4, 1040, entry, 52);
        }
    }
}
