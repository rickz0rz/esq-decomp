typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed long LONG;

extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UWORD ESQIFF_RecordLength;
extern UWORD ESQDISP_SecondaryLinePromotePendingFlag;

extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;
extern char *ESQIFF_SecondaryLineHeadPtr;
extern char *ESQIFF_SecondaryLineTailPtr;

extern char *ESQPARS_ReplaceOwnedString(char *new_ptr, char *old_ptr);
extern char *ESQIFF2_ClearLineHeadTailByMode(UWORD mode);

void ESQIFF2_ParseLineHeadTailRecord(UBYTE *record)
{
    UWORD group = (UWORD)(record[0] & 0xFF);
    UWORD len = ESQIFF_RecordLength;
    UWORD i;

    if (group == (UWORD)TEXTDISP_PrimaryGroupCode) {
        ESQIFF2_ClearLineHeadTailByMode(1);

        if (record[1] == 18) {
            ESQIFF_PrimaryLineHeadPtr = (char *)0;
            if (record[(UWORD)(len - 1)] == 18) {
                ESQIFF_PrimaryLineTailPtr = (char *)0;
            } else {
                ESQIFF_PrimaryLineTailPtr = ESQPARS_ReplaceOwnedString((char *)(record + 2), ESQIFF_PrimaryLineTailPtr);
            }
            return;
        }

        if (record[(UWORD)(len - 1)] == 18) {
            record[(UWORD)(len - 1)] = 0;
            ESQIFF_PrimaryLineHeadPtr = ESQPARS_ReplaceOwnedString((char *)(record + 1), ESQIFF_PrimaryLineHeadPtr);
            ESQIFF_PrimaryLineTailPtr = (char *)0;
            return;
        }

        i = 3;
        while (i < 103 && record[i] != 18) {
            i = (UWORD)(i + 1);
        }

        record[i] = 0;
        ESQIFF_PrimaryLineHeadPtr = ESQPARS_ReplaceOwnedString((char *)(record + 1), ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineTailPtr = ESQPARS_ReplaceOwnedString((char *)(record + i + 1), ESQIFF_PrimaryLineTailPtr);
        return;
    }

    if (group != (UWORD)TEXTDISP_SecondaryGroupCode) {
        return;
    }

    ESQIFF2_ClearLineHeadTailByMode(2);
    ESQDISP_SecondaryLinePromotePendingFlag = 1;

    if (record[1] == 18) {
        ESQIFF_SecondaryLineHeadPtr = (char *)0;
        if (record[(UWORD)(len - 1)] == 18) {
            ESQIFF_SecondaryLineTailPtr = (char *)0;
        } else {
            ESQIFF_SecondaryLineTailPtr = ESQPARS_ReplaceOwnedString((char *)(record + 2), ESQIFF_SecondaryLineTailPtr);
        }
        return;
    }

    if (record[(UWORD)(len - 1)] == 18) {
        ESQIFF_SecondaryLineHeadPtr = ESQPARS_ReplaceOwnedString((char *)(record + 1), ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineTailPtr = (char *)0;
        return;
    }

    i = 3;
    while (i < 103 && record[i] != 18) {
        i = (UWORD)(i + 1);
    }

    record[i] = 0;
    ESQIFF_SecondaryLineHeadPtr = ESQPARS_ReplaceOwnedString((char *)(record + 1), ESQIFF_SecondaryLineHeadPtr);
    ESQIFF_SecondaryLineTailPtr = ESQPARS_ReplaceOwnedString((char *)(record + i + 1), ESQIFF_SecondaryLineTailPtr);
}
