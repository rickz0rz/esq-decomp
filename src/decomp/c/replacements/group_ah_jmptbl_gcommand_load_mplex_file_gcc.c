#include "esq_types.h"

/*
 * Target 255 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_LoadMplexFile.
 */
void GCOMMAND_LoadMplexFile(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(void)
{
    GCOMMAND_LoadMplexFile();
}
