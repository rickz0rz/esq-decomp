#include "esq_types.h"

/*
 * Target 092 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_WriteErrorLogEntry.
 */
void PARSEINI_WriteErrorLogEntry(const char *msg) __attribute__((noinline));

void GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry(const char *msg) __attribute__((noinline, used));

void GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry(const char *msg)
{
    PARSEINI_WriteErrorLogEntry(msg);
}
