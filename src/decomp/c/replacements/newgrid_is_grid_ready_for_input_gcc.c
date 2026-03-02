#include "esq_types.h"

extern u8 TEXTDISP_SecondaryGroupPresentFlag;
extern u16 TEXTDISP_SecondaryGroupEntryCount;
extern u8 TEXTDISP_PrimaryGroupPresentFlag;
extern u16 TEXTDISP_PrimaryGroupEntryCount;

s32 NEWGRID_IsGridReadyForInput(s32 gate_selector) __attribute__((noinline, used));

s32 NEWGRID_IsGridReadyForInput(s32 gate_selector)
{
    if (gate_selector == 1) {
        if (TEXTDISP_SecondaryGroupPresentFlag != 0) {
            if (TEXTDISP_SecondaryGroupEntryCount > 0) {
                return 0;
            }
        }
    }

    if (TEXTDISP_PrimaryGroupPresentFlag != 0) {
        if (TEXTDISP_PrimaryGroupEntryCount > 0) {
            return 0;
        }
    }

    return 1;
}
