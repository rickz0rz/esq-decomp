typedef signed long LONG;
typedef signed short WORD;

typedef struct AliasRecord {
    char *label_ptr;
    char *value_ptr;
} AliasRecord;

extern WORD TEXTDISP_AliasCount;
extern AliasRecord *TEXTDISP_AliasPtrTable[];
extern const char Global_STR_ESQPARS_C_1[];

extern char *ESQPARS_ReplaceOwnedString(char *newValue, char *oldValue);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *fileName, LONG line, void *ptr, LONG size);

void ESQPARS_ClearAliasStringPointers(void)
{
    WORD i;

    for (i = 0; i < TEXTDISP_AliasCount; ++i) {
        AliasRecord *alias = TEXTDISP_AliasPtrTable[i];
        if (!alias) {
            continue;
        }

        alias->label_ptr = ESQPARS_ReplaceOwnedString(0, alias->label_ptr);
        alias->value_ptr = ESQPARS_ReplaceOwnedString(0, alias->value_ptr);
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_1, 945, alias, 8);
        TEXTDISP_AliasPtrTable[i] = 0;
    }
}
