typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;

typedef struct ESQPARS_TitleTable {
    UBYTE pad0[56];
    char *titleTable[49];
} ESQPARS_TitleTable;

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
        ESQPARS_TitleTable *titleTable;
        LONG slot;

        if (mode == 2) {
            entry = TEXTDISP_SecondaryEntryPtrTable[idx];
            TEXTDISP_SecondaryEntryPtrTable[idx] = (void *)0;
            titleTable = (ESQPARS_TitleTable *)TEXTDISP_SecondaryTitlePtrTable[idx];
            TEXTDISP_SecondaryTitlePtrTable[idx] = (void *)0;
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[idx];
            TEXTDISP_PrimaryEntryPtrTable[idx] = (void *)0;
            titleTable = (ESQPARS_TitleTable *)TEXTDISP_PrimaryTitlePtrTable[idx];
            TEXTDISP_PrimaryTitlePtrTable[idx] = (void *)0;
        }

        for (slot = 0; titleTable != (ESQPARS_TitleTable *)0 && slot < 49; ++slot) {
            char *s = titleTable->titleTable[slot];
            if (s != (char *)0) {
                ULONG n = 0;
                while (s[n] != 0) {
                    ++n;
                }
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_2, 1025, s, n + 1);
                titleTable->titleTable[slot] = (char *)0;
            }
        }

        if (titleTable != (ESQPARS_TitleTable *)0) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_3, 1031, titleTable, 500);
        }

        ESQPARS_JMPTBL_COI_FreeEntryResources(entry);

        if (entry != (void *)0) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_4, 1040, entry, 52);
        }
    }
}
