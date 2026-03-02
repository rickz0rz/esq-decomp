#include "esq_types.h"

/*
 * Target 250 GCC trial function.
 * Jump-table stub forwarding to P_TYPE_WritePromoIdDataFile.
 */
void P_TYPE_WritePromoIdDataFile(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(void)
{
    P_TYPE_WritePromoIdDataFile();
}
