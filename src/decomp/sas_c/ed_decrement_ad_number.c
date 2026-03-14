#include <exec/types.h>
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;

extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_UpdateAdNumberDisplay(void);

void ED_DecrementAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER <= 1) {
        return;
    }

    ED_ApplyActiveFlagToAdData();
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER -= 1;
    ED_UpdateAdNumberDisplay();
}
