typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed long LONG;

extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UWORD ESQIFF_RecordLength;
extern UWORD ESQDISP_SecondaryLinePromotePendingFlag;

extern UBYTE *ESQIFF_PrimaryLineHeadPtr;
extern UBYTE *ESQIFF_PrimaryLineTailPtr;
extern UBYTE *ESQIFF_SecondaryLineHeadPtr;
extern UBYTE *ESQIFF_SecondaryLineTailPtr;

extern UBYTE *ESQPARS_ReplaceOwnedString(UBYTE *new_ptr, UBYTE *old_ptr);
extern UBYTE *ESQIFF2_ClearLineHeadTailByMode(UWORD mode);

void ESQIFF2_ParseLineHeadTailRecord(UBYTE *record)
{
    UWORD group = (UWORD)(record[0] & 0xFF);
    UWORD len = ESQIFF_RecordLength;
    UWORD i;

    if (group == (UWORD)TEXTDISP_PrimaryGroupCode) {
        ESQIFF2_ClearLineHeadTailByMode(1);

        if (record[1] == 18) {
            ESQIFF_PrimaryLineHeadPtr = (UBYTE *)0;
            if (record[(UWORD)(len - 1)] == 18) {
                ESQIFF_PrimaryLineTailPtr = (UBYTE *)0;
            } else {
                ESQIFF_PrimaryLineTailPtr = ESQPARS_ReplaceOwnedString(record + 2, ESQIFF_PrimaryLineTailPtr);
            }
            return;
        }

        if (record[(UWORD)(len - 1)] == 18) {
            record[(UWORD)(len - 1)] = 0;
            ESQIFF_PrimaryLineHeadPtr = ESQPARS_ReplaceOwnedString(record + 1, ESQIFF_PrimaryLineHeadPtr);
            ESQIFF_PrimaryLineTailPtr = (UBYTE *)0;
            return;
        }

        i = 3;
        while (i < 103 && record[i] != 18) {
            i = (UWORD)(i + 1);
        }

        record[i] = 0;
        ESQIFF_PrimaryLineHeadPtr = ESQPARS_ReplaceOwnedString(record + 1, ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineTailPtr = ESQPARS_ReplaceOwnedString(record + i + 1, ESQIFF_PrimaryLineTailPtr);
        return;
    }

    if (group != (UWORD)TEXTDISP_SecondaryGroupCode) {
        return;
    }

    ESQIFF2_ClearLineHeadTailByMode(2);
    ESQDISP_SecondaryLinePromotePendingFlag = 1;

    if (record[1] == 18) {
        ESQIFF_SecondaryLineHeadPtr = (UBYTE *)0;
        if (record[(UWORD)(len - 1)] == 18) {
            ESQIFF_SecondaryLineTailPtr = (UBYTE *)0;
        } else {
            ESQIFF_SecondaryLineTailPtr = ESQPARS_ReplaceOwnedString(record + 2, ESQIFF_SecondaryLineTailPtr);
        }
        return;
    }

    if (record[(UWORD)(len - 1)] == 18) {
        ESQIFF_SecondaryLineHeadPtr = ESQPARS_ReplaceOwnedString(record + 1, ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineTailPtr = (UBYTE *)0;
        return;
    }

    i = 3;
    while (i < 103 && record[i] != 18) {
        i = (UWORD)(i + 1);
    }

    record[i] = 0;
    ESQIFF_SecondaryLineHeadPtr = ESQPARS_ReplaceOwnedString(record + 1, ESQIFF_SecondaryLineHeadPtr);
    ESQIFF_SecondaryLineTailPtr = ESQPARS_ReplaceOwnedString(record + i + 1, ESQIFF_SecondaryLineTailPtr);
}
