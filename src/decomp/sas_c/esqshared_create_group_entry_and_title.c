/*
 * ESQSHARED_CreateGroupEntryAndTitle -- allocate + register one group entry and
 * its title table, seed defaults/flags/text fields, and append the new pointers
 * to the primary or secondary group tables.
 *
 * Restored from src/modules/groups/a/p/esqshared.s:346. The original selects the
 * primary or secondary group table by matching the passed group code against
 * TEXTDISP_{Primary,Secondary}GroupCode; an unmatched code returns immediately.
 *
 * Entry record layout (52-byte alloc, MEMF_PUBLIC|MEMF_CLEAR), by byte offset:
 *   0      group code
 *   1..    selection code from field1 with spaces removed, then a space + NUL
 *   12..   name string (field0)
 *   19..   field3 string
 *   27     display/entry-code byte (arg2)
 *   28..33 reversed-bit copy of the 6-byte field2 bitmap
 *   34..39 cleared to 0
 *   40..46 defaults seeded by ESQSHARED_InitEntryDefaults
 * Title table layout (500-byte alloc):
 *   0..    name string (field0)
 *   7+i    present flag = 1 for i in 0..48
 *   56+i*4 slot pointer = 0 (long) for i in 0..48
 *   498    group code
 */
#include <exec/types.h>

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, LONG size, LONG flags);
extern void ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(void *entry);
extern void ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(UBYTE *dst, UBYTE *src);
extern void ESQSHARED_InitEntryDefaults(UBYTE *entry);

extern const char Global_ESQPARS2_C_1[];
extern const char Global_ESQPARS2_C_2[];
extern const char Global_ESQPARS2_C_3[];
extern const char Global_ESQPARS2_C_4[];

extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

extern BYTE TEXTDISP_PrimaryGroupCode;
extern BYTE TEXTDISP_SecondaryGroupCode;
extern BYTE TEXTDISP_PrimaryGroupHeaderCode;
extern BYTE TEXTDISP_SecondaryGroupHeaderCode;
extern BYTE TEXTDISP_PrimaryGroupPresentFlag;
extern BYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern WORD TEXTDISP_GroupMutationState;
extern WORD TEXTDISP_MaxEntryTitleLength;

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

void ESQSHARED_CreateGroupEntryAndTitle(LONG group_code, LONG entry_code,
                                        UBYTE *nameField, UBYTE *selCodeField,
                                        UBYTE *bitmapField, UBYTE *tailField)
{
    UBYTE groupByte;
    UBYTE *entry;
    UBYTE *title;
    UBYTE *src;
    UBYTE *dst;
    WORD len;
    WORD i;

    groupByte = (UBYTE)group_code;

    if (groupByte == (UBYTE)TEXTDISP_SecondaryGroupCode) {
        TEXTDISP_SecondaryEntryPtrTable[TEXTDISP_SecondaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_1, 299, 52,
                                                MEMF_PUBLIC + MEMF_CLEAR);
        TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_SecondaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_2, 301, 500,
                                                MEMF_PUBLIC + MEMF_CLEAR);
        TEXTDISP_SecondaryGroupPresentFlag = 1;
        TEXTDISP_SecondaryGroupHeaderCode = (BYTE)groupByte;
        entry = (UBYTE *)TEXTDISP_SecondaryEntryPtrTable[TEXTDISP_SecondaryGroupEntryCount];
        title = (UBYTE *)TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_SecondaryGroupEntryCount];
    } else if (groupByte == (UBYTE)TEXTDISP_PrimaryGroupCode) {
        TEXTDISP_PrimaryEntryPtrTable[TEXTDISP_PrimaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_3, 314, 52,
                                                MEMF_PUBLIC + MEMF_CLEAR);
        TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_PrimaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_4, 315, 500,
                                                MEMF_PUBLIC + MEMF_CLEAR);
        TEXTDISP_PrimaryGroupPresentFlag = 1;
        TEXTDISP_PrimaryGroupHeaderCode = (BYTE)groupByte;
        entry = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[TEXTDISP_PrimaryGroupEntryCount];
        title = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_PrimaryGroupEntryCount];
    } else {
        return;
    }

    ESQSHARED_InitEntryDefaults(entry);
    ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(entry);

    entry[0] = groupByte;

    /* entry+1 = selection code with spaces stripped, then a space + NUL */
    len = 0;
    for (src = selCodeField; *src != 0; src++)
        len++;
    src = selCodeField;
    dst = entry + 1;
    while (len != 0) {
        if (*src != 32) {
            *dst++ = *src;
        }
        src++;
        len--;
    }
    *dst++ = ' ';
    *dst = 0;

    /* track the widest stripped selection code seen */
    len = 0;
    for (src = entry + 1; *src != 0; src++)
        len++;
    if (len > TEXTDISP_MaxEntryTitleLength)
        TEXTDISP_MaxEntryTitleLength = len;

    /* name -> entry+12, tail field -> entry+19 */
    dst = entry + 12;
    src = nameField;
    do {
        *dst++ = *src;
    } while (*src++ != 0);
    dst = entry + 19;
    src = tailField;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    entry[27] = (UBYTE)entry_code;

    ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(entry + 28, bitmapField);
    for (i = 0; i < 6; i++)
        entry[34 + i] = 0;

    /* title table: name at 0, group code at 498, 49 present flags + slot ptrs */
    dst = title;
    src = nameField;
    do {
        *dst++ = *src;
    } while (*src++ != 0);
    title[498] = groupByte;
    for (i = 0; i < 49; i++) {
        title[7 + i] = 1;
        *(LONG *)(title + 56 + (i << 2)) = 0;
    }

    if ((BYTE)TEXTDISP_PrimaryGroupCode == (BYTE)groupByte) {
        TEXTDISP_PrimaryGroupEntryCount++;
        if (TEXTDISP_GroupMutationState != 2)
            TEXTDISP_GroupMutationState = 1;
    } else if (groupByte == (UBYTE)TEXTDISP_SecondaryGroupCode) {
        TEXTDISP_SecondaryGroupEntryCount++;
        TEXTDISP_GroupMutationState = 2;
    }
}
