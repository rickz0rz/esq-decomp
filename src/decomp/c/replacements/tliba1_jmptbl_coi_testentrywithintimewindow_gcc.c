#include "esq_types.h"

void COI_TestEntryWithinTimeWindow(void) __attribute__((noinline));

void TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void) __attribute__((noinline, used));

void TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void)
{
    COI_TestEntryWithinTimeWindow();
}
