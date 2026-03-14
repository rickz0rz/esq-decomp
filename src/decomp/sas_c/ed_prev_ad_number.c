#include <exec/types.h>
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;

extern void ED_CommitCurrentAdEdits(void);
extern void ED_LoadCurrentAdIntoBuffers(void);

void ED_PrevAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER <= 1) {
        return;
    }

    ED_CommitCurrentAdEdits();
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER -= 1;
    ED_LoadCurrentAdIntoBuffers();
}
