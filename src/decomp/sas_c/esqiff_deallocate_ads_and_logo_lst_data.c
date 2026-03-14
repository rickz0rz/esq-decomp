#include <exec/types.h>
extern LONG Global_REF_LONG_GFX_G_ADS_DATA;
extern LONG Global_REF_LONG_GFX_G_ADS_FILESIZE;
extern LONG Global_REF_LONG_DF0_LOGO_LST_DATA;
extern LONG Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern const char Global_STR_ESQIFF_C_7[];
extern const char Global_STR_ESQIFF_C_8[];

extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG width, void *ptr, LONG size);

void ESQIFF_DeallocateAdsAndLogoLstData(void)
{
    if (Global_REF_LONG_GFX_G_ADS_DATA != 0 && Global_REF_LONG_GFX_G_ADS_FILESIZE != 0) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_ESQIFF_C_7,
            1988,
            (void *)Global_REF_LONG_GFX_G_ADS_DATA,
            Global_REF_LONG_GFX_G_ADS_FILESIZE + 1);
        Global_REF_LONG_GFX_G_ADS_DATA = 0;
        Global_REF_LONG_GFX_G_ADS_FILESIZE = 0;
    }

    if (Global_REF_LONG_DF0_LOGO_LST_DATA != 0 && Global_REF_LONG_DF0_LOGO_LST_FILESIZE != 0) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_ESQIFF_C_8,
            1994,
            (void *)Global_REF_LONG_DF0_LOGO_LST_DATA,
            Global_REF_LONG_DF0_LOGO_LST_FILESIZE + 1);
        Global_REF_LONG_DF0_LOGO_LST_DATA = 0;
        Global_REF_LONG_DF0_LOGO_LST_FILESIZE = 0;
    }
}
