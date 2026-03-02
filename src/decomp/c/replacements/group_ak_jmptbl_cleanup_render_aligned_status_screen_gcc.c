#include "esq_types.h"

/*
 * Target 275 GCC trial function.
 * Jump-table stub forwarding to CLEANUP_RenderAlignedStatusScreen.
 */
void CLEANUP_RenderAlignedStatusScreen(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(void)
{
    CLEANUP_RenderAlignedStatusScreen();
}
