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
    LONG entry_index;

    if (TEXTDISP_SecondaryGroupEntryCount != 0) {
        ESQDISP_PrimarySecondaryMirrorFlag = 0;
        return;
    }

    for (entry_index = 0; entry_index < (LONG)(unsigned short)TEXTDISP_PrimaryGroupEntryCount; ++entry_index) {
        UBYTE *src = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[entry_index];
        void *dst;
        LONG dst_index;

        ESQSHARED_CreateGroupEntryAndTitle(
            (LONG)TEXTDISP_SecondaryGroupCode,
            (LONG)src[27],
            src + 12,
            src + 1,
            src + 28,
            src + 19
        );

        dst_index = (LONG)(unsigned short)TEXTDISP_SecondaryGroupEntryCount;
        dst = TEXTDISP_SecondaryEntryPtrTablePreSlot[dst_index];

        ESQDISP_FillProgramInfoHeaderFields(
            dst,
            (LONG)(src[40] & 0x7F),
            (LONG)src[41],
            (LONG)*(unsigned short *)(src + 46),
            (LONG)src[42],
            src + 43
        );
    }

    ESQDISP_PrimarySecondaryMirrorFlag = 1;
}
