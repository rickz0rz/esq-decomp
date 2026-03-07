typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTablePreSlot[];
extern WORD ESQDISP_PrimarySecondaryMirrorFlag;

extern void ESQSHARED_CreateGroupEntryAndTitle(LONG group_code, LONG entry_code, void *ptr1, void *ptr2, void *ptr3, void *ptr4);
extern void ESQDISP_FillProgramInfoHeaderFields(void *dst, LONG flags, LONG v41, LONG v46, LONG v42, void *v43);

void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void)
{
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    const LONG ENTRY_GROUPCODE_OFFSET = 27;
    const LONG ENTRY_TITLE_OFFSET = 12;
    const LONG ENTRY_FIELD1_OFFSET = 1;
    const LONG ENTRY_FIELD2_OFFSET = 28;
    const LONG ENTRY_FIELD3_OFFSET = 19;
    const LONG ENTRY_FLAGS_OFFSET = 40;
    const LONG ENTRY_FIELD41_OFFSET = 41;
    const LONG ENTRY_FIELD42_OFFSET = 42;
    const LONG ENTRY_FIELD43_OFFSET = 43;
    const LONG ENTRY_WORD46_OFFSET = 46;
    const UBYTE MASK_FLAGS_LOW7 = 0x7F;
    LONG entry_index;

    if (TEXTDISP_SecondaryGroupEntryCount != FLAG_FALSE) {
        ESQDISP_PrimarySecondaryMirrorFlag = FLAG_FALSE;
        return;
    }

    for (entry_index = 0; entry_index < (LONG)(unsigned short)TEXTDISP_PrimaryGroupEntryCount; ++entry_index) {
        UBYTE *src = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[entry_index];
        void *dst;
        LONG dst_index;

        ESQSHARED_CreateGroupEntryAndTitle(
            (LONG)TEXTDISP_SecondaryGroupCode,
            (LONG)src[ENTRY_GROUPCODE_OFFSET],
            src + ENTRY_TITLE_OFFSET,
            src + ENTRY_FIELD1_OFFSET,
            src + ENTRY_FIELD2_OFFSET,
            src + ENTRY_FIELD3_OFFSET
        );

        dst_index = (LONG)(unsigned short)TEXTDISP_SecondaryGroupEntryCount;
        dst = TEXTDISP_SecondaryEntryPtrTablePreSlot[dst_index];

        ESQDISP_FillProgramInfoHeaderFields(
            dst,
            (LONG)(src[ENTRY_FLAGS_OFFSET] & MASK_FLAGS_LOW7),
            (LONG)src[ENTRY_FIELD41_OFFSET],
            (LONG)*(unsigned short *)(src + ENTRY_WORD46_OFFSET),
            (LONG)src[ENTRY_FIELD42_OFFSET],
            src + ENTRY_FIELD43_OFFSET
        );
    }

    ESQDISP_PrimarySecondaryMirrorFlag = FLAG_TRUE;
}
