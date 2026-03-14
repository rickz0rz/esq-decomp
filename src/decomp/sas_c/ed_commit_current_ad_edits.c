#include <exec/types.h>
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern char ED_EditBufferLive[];
extern char ED_EditBufferScratch[];

extern void GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(LONG adIndex, void *scratch, void *live);

void ED_CommitCurrentAdEdits(void)
{
    LONG adIndex = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER - 1;

    GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(
        adIndex,
        ED_EditBufferScratch,
        ED_EditBufferLive
    );
}
