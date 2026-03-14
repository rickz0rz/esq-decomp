#include <exec/types.h>
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UWORD TEXTDISP_PrimaryGroupRecordLength;
extern UBYTE TEXTDISP_PrimaryGroupRecordChecksum;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UWORD TEXTDISP_SecondaryGroupRecordLength;
extern UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;

extern UWORD TEXTDISP_MaxEntryTitleLength;
extern UWORD ESQIFF_RecordLength;
extern UBYTE ESQIFF_RecordChecksumByte;
extern ULONG NEWGRID_RefreshStateFlag;

extern UBYTE ESQIFF_ParseField0Buffer[10];
extern UBYTE ESQIFF_ParseField1Buffer[10];
extern UBYTE ESQIFF_ParseField2Buffer[6];
extern UBYTE ESQIFF_ParseField3Buffer[10];
extern UBYTE ESQIFF_ParseField0TailBuffer;
extern UBYTE ESQIFF_ParseField1TailByte;
extern UBYTE ESQIFF_ParseField3TailBuffer;

extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(UWORD mode);
extern LONG ESQIFF2_ValidateFieldIndexAndLength(LONG field_index, LONG field_length);
extern void ESQSHARED_CreateGroupEntryAndTitle(LONG group_code, LONG display_mode, UBYTE *field0, UBYTE *field1, UBYTE *field2, UBYTE *field3);
extern LONG ESQIFF2_PadEntriesToMaxTitleWidth(signed char group_code);
extern void TEXTDISP_ApplySourceConfigAllEntries(void);
extern void NEWGRID_RebuildIndexCache(void);

static UBYTE *ParseGroup_FieldPtrFromIndex(UWORD field_index)
{
    if (field_index == 0) return ESQIFF_ParseField0Buffer;
    if (field_index == 1) return ESQIFF_ParseField1Buffer;
    if (field_index == 2) return ESQIFF_ParseField2Buffer;
    return ESQIFF_ParseField3Buffer;
}

static void ParseGroup_ResetParseBuffers(void)
{
    UWORD i;

    ESQIFF_ParseField0Buffer[0] = 0;
    ESQIFF_ParseField1Buffer[0] = 0;
    for (i = 0; i < 6; ++i) {
        ESQIFF_ParseField2Buffer[i] = 0xFF;
    }
    ESQIFF_ParseField3Buffer[0] = 0;
}

void ESQIFF2_ParseGroupRecordAndRefresh(UBYTE *src)
{
    LONG display_mode = 1;
    LONG field_index = 0;
    LONG field_length = 0;
    LONG first_entry_pending = 1;
    LONG parse_failed = 0;
    UWORD has_field3_split = 0;
    UBYTE group_code = *src++;
    UBYTE byte_value = 0;

    if (group_code == TEXTDISP_PrimaryGroupCode) {
        if ((TEXTDISP_PrimaryGroupRecordLength != ESQIFF_RecordLength) ||
            (TEXTDISP_PrimaryGroupRecordChecksum != ESQIFF_RecordChecksumByte)) {
            TEXTDISP_PrimaryGroupRecordLength = ESQIFF_RecordLength;
            TEXTDISP_PrimaryGroupRecordChecksum = ESQIFF_RecordChecksumByte;
            TEXTDISP_MaxEntryTitleLength = 0;
            if (TEXTDISP_PrimaryGroupEntryCount > 0) {
                ESQPARS_RemoveGroupEntryAndReleaseStrings(1);
                NEWGRID_RefreshStateFlag = 1;
            }
        } else {
            return;
        }
    } else if (group_code == TEXTDISP_SecondaryGroupCode) {
        if ((TEXTDISP_SecondaryGroupRecordLength != ESQIFF_RecordLength) ||
            (TEXTDISP_SecondaryGroupRecordChecksum != ESQIFF_RecordChecksumByte)) {
            TEXTDISP_SecondaryGroupRecordLength = ESQIFF_RecordLength;
            TEXTDISP_SecondaryGroupRecordChecksum = ESQIFF_RecordChecksumByte;
            TEXTDISP_MaxEntryTitleLength = 0;
            if (TEXTDISP_SecondaryGroupEntryCount > 0) {
                ESQPARS_RemoveGroupEntryAndReleaseStrings(2);
            }
        } else {
            return;
        }
    } else {
        return;
    }

    ParseGroup_ResetParseBuffers();

    for (;;) {
        byte_value = *src++;

        if (byte_value == 0 || parse_failed != 0) {
            break;
        }

        switch (byte_value) {
        case 0x12:
            if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
                parse_failed = 1;
                continue;
            }
            ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length] = 0;
            if (first_entry_pending == 0) {
                if (has_field3_split == 0) {
                    UBYTE *in_ptr = ESQIFF_ParseField0Buffer;
                    UBYTE *out_ptr = ESQIFF_ParseField3Buffer;
                    do {
                        *out_ptr++ = *in_ptr;
                    } while (*in_ptr++ != 0);
                }
                ESQIFF_ParseField0TailBuffer = 0;
                ESQIFF_ParseField1TailByte = 0;
                ESQIFF_ParseField3TailBuffer = 0;
                ESQSHARED_CreateGroupEntryAndTitle((LONG)group_code, display_mode,
                                                   ESQIFF_ParseField0Buffer,
                                                   ESQIFF_ParseField1Buffer,
                                                   ESQIFF_ParseField2Buffer,
                                                   ESQIFF_ParseField3Buffer);
                has_field3_split = 0;
            } else {
                first_entry_pending = 0;
            }
            ParseGroup_ResetParseBuffers();
            field_index = 0;
            field_length = 0;
            display_mode = (LONG)(*src++);
            break;

        case 0x11:
            if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
                parse_failed = 1;
                continue;
            }
            ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length] = 0;
            field_index = 1;
            field_length = 0;
            break;

        case 0x14:
            if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
                parse_failed = 1;
                continue;
            }
            ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length] = 0;
            field_length = 0;
            {
                UWORD i;
                for (i = 0; i < 6; ++i) {
                    ESQIFF_ParseField2Buffer[i] = *src++;
                }
            }
            break;

        case 0x01:
            if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
                parse_failed = 1;
                continue;
            }
            if (field_index != 2) {
                ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length] = 0;
            }
            field_index = 3;
            field_length = 0;
            has_field3_split = 1;
            break;

        default:
            if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
                parse_failed = 1;
                continue;
            }
            ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length++] = byte_value;
            break;
        }
    }

    if (ESQIFF2_ValidateFieldIndexAndLength(field_index, field_length) == 0) {
        return;
    }

    ParseGroup_FieldPtrFromIndex((UWORD)field_index)[field_length] = 0;
    ESQIFF_ParseField0TailBuffer = 0;
    ESQIFF_ParseField1TailByte = 0;
    ESQIFF_ParseField3TailBuffer = 0;
    ESQSHARED_CreateGroupEntryAndTitle((LONG)group_code, display_mode,
                                       ESQIFF_ParseField0Buffer,
                                       ESQIFF_ParseField1Buffer,
                                       ESQIFF_ParseField2Buffer,
                                       ESQIFF_ParseField3Buffer);
    ESQIFF2_PadEntriesToMaxTitleWidth((signed char)group_code);
    TEXTDISP_ApplySourceConfigAllEntries();
    NEWGRID_RebuildIndexCache();
}
