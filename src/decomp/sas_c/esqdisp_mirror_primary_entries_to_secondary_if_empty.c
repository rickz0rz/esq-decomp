#include <exec/types.h>
typedef struct ESQDISP_PrimaryEntry {
    UBYTE pad0[1];
    UBYTE field1[11];
    UBYTE titleText[7];
    UBYTE field3[8];
    UBYTE groupCode27;
    UBYTE field2[12];
    UBYTE flags40;
    UBYTE field41;
    UBYTE field42;
    UBYTE field43[3];
    WORD word46;
} ESQDISP_PrimaryEntry;

typedef struct ESQDISP_SecondaryEntry {
    UBYTE pad0[1];
} ESQDISP_SecondaryEntry;

extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern ESQDISP_PrimaryEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern ESQDISP_SecondaryEntry *TEXTDISP_SecondaryEntryPtrTablePreSlot[];
extern WORD ESQDISP_PrimarySecondaryMirrorFlag;

extern void ESQSHARED_CreateGroupEntryAndTitle(LONG group_code, LONG entry_code, void *ptr1, void *ptr2, void *ptr3, void *ptr4);
extern void ESQDISP_FillProgramInfoHeaderFields(void *dst, LONG flags, LONG v41, LONG v46, LONG v42, void *v43);

void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void)
{
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    const UBYTE MASK_FLAGS_LOW7 = 0x7F;
    LONG entry_index;

    if (TEXTDISP_SecondaryGroupEntryCount != FLAG_FALSE) {
        ESQDISP_PrimarySecondaryMirrorFlag = FLAG_FALSE;
        return;
    }

    for (entry_index = 0; entry_index < (LONG)(unsigned short)TEXTDISP_PrimaryGroupEntryCount; ++entry_index) {
        ESQDISP_PrimaryEntry *src = TEXTDISP_PrimaryEntryPtrTable[entry_index];
        ESQDISP_SecondaryEntry *dst;
        LONG dst_index;

        ESQSHARED_CreateGroupEntryAndTitle(
            (LONG)TEXTDISP_SecondaryGroupCode,
            (LONG)src->groupCode27,
            src->titleText,
            src->field1,
            src->field2,
            src->field3
        );

        dst_index = (LONG)(unsigned short)TEXTDISP_SecondaryGroupEntryCount;
        dst = TEXTDISP_SecondaryEntryPtrTablePreSlot[dst_index];

        ESQDISP_FillProgramInfoHeaderFields(
            dst,
            (LONG)(src->flags40 & MASK_FLAGS_LOW7),
            (LONG)src->field41,
            (LONG)(unsigned short)src->word46,
            (LONG)src->field42,
            src->field43
        );
    }

    ESQDISP_PrimarySecondaryMirrorFlag = FLAG_TRUE;
}
