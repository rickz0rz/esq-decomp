#include "esq_types.h"

u8 *NEWGRID2_JMPTBL_STR_SkipClass3Chars(u8 *s) __attribute__((noinline));

s32 NEWGRID_ShouldOpenEditor(u8 *entry) __attribute__((noinline, used));

s32 NEWGRID_ShouldOpenEditor(u8 *entry)
{
    u8 *primary_scan;
    u8 *secondary_scan;

    if (entry == 0) {
        return 0;
    }

    primary_scan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entry + 19);
    secondary_scan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entry + 1);

    if ((primary_scan != 0) && (*primary_scan != 0)) {
        return 0;
    }

    if ((secondary_scan != 0) && (*secondary_scan != 0)) {
        return 0;
    }

    if ((entry[27] & 0x20) == 0) {
        return 0;
    }

    return 1;
}
