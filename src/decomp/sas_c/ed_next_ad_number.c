#include <exec/types.h>
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern LONG ED_MaxAdNumber;

extern void ED_CommitCurrentAdEdits(void);
extern void ED_LoadCurrentAdIntoBuffers(void);

void ED_NextAdNumber(void)
{
    if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER >= ED_MaxAdNumber) {
        return;
    }

    ED_CommitCurrentAdEdits();
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER += 1;
    ED_LoadCurrentAdIntoBuffers();
}
