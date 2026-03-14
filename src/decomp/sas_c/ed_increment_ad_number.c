#include <exec/types.h>
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern LONG ED_MaxAdNumber;

extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_UpdateAdNumberDisplay(void);

void ED_IncrementAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER >= ED_MaxAdNumber) {
        return;
    }

    ED_ApplyActiveFlagToAdData();
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER += 1;
    ED_UpdateAdNumberDisplay();
}
