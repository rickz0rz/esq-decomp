#include <exec/types.h>
extern LONG ED_AdActiveFlag;
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern UWORD *ED_AdRecordPtrTable[];

void ED_ApplyActiveFlagToAdData(void)
{
    UWORD *record;
    LONG adIndex;

    adIndex = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
    record = ED_AdRecordPtrTable[adIndex];

    if (ED_AdActiveFlag == 0) {
        record[0] = 0;
        record[1] = 0;
        return;
    }

    record[0] = 1;
    record[1] = 0x30;
}
