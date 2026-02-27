#include "esq_types.h"

/*
 * Target 137 GCC trial function.
 * Jump-table stub forwarding to NEWGRID_ValidateSelectionCode.
 */
void NEWGRID_ValidateSelectionCode(s32 grid_ptr, s32 selection_code) __attribute__((noinline));

void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(s32 grid_ptr, s32 selection_code) __attribute__((noinline, used));

void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(s32 grid_ptr, s32 selection_code)
{
    NEWGRID_ValidateSelectionCode(grid_ptr, selection_code);
}
