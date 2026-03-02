#include "esq_types.h"

/*
 * Target 246 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_LoadPPVTemplate.
 */
void GCOMMAND_LoadPPVTemplate(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(void)
{
    GCOMMAND_LoadPPVTemplate();
}
