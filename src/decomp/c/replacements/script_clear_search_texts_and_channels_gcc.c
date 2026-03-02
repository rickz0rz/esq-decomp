#include "esq_types.h"

extern u8 TEXTDISP_PrimarySearchText[];
extern u8 TEXTDISP_SecondarySearchText[];
extern s16 TEXTDISP_PrimaryChannelCode;
extern s16 TEXTDISP_SecondaryChannelCode;

void SCRIPT_ClearSearchTextsAndChannels(void) __attribute__((noinline, used));

void SCRIPT_ClearSearchTextsAndChannels(void)
{
    TEXTDISP_SecondarySearchText[0] = 0;
    TEXTDISP_PrimarySearchText[0] = 0;
    TEXTDISP_SecondaryChannelCode = 0;
    TEXTDISP_PrimaryChannelCode = 0;
}
