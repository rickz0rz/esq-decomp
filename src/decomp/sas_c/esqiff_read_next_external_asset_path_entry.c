#include <exec/types.h>
extern LONG Global_REF_LONG_DF0_LOGO_LST_DATA;
extern LONG Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern LONG Global_REF_LONG_GFX_G_ADS_DATA;
extern LONG Global_REF_LONG_GFX_G_ADS_FILESIZE;

extern WORD ESQIFF_LogoListLineIndex;
extern WORD ESQIFF_GAdsListLineIndex;
extern WORD ESQIFF_AssetSourceSelect;
extern WORD ESQIFF_GAdsSourceEnabled;
extern WORD ESQIFF_ExternalAssetPathCommaFlag;

extern void ESQDISP_ProcessGridMessagesIfIdle(void);

LONG ESQIFF_ReadNextExternalAssetPathEntry(char *out)
{
    LONG remaining;
    BYTE *cursor;
    WORD targetLine;
    WORD line;

    ESQDISP_ProcessGridMessagesIfIdle();

    if (ESQIFF_AssetSourceSelect != 0) {
        remaining = Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
        cursor = (BYTE *)Global_REF_LONG_DF0_LOGO_LST_DATA;
        targetLine = ESQIFF_LogoListLineIndex;
        ESQIFF_ExternalAssetPathCommaFlag = 0;
    } else {
        if (ESQIFF_GAdsSourceEnabled == 0) {
            return 0;
        }
        remaining = Global_REF_LONG_GFX_G_ADS_FILESIZE;
        cursor = (BYTE *)Global_REF_LONG_GFX_G_ADS_DATA;
        targetLine = ESQIFF_GAdsListLineIndex;
    }

    line = 0;
    while (line < targetLine) {
        BYTE ch;
        if (remaining <= 0) {
            break;
        }
        ch = *cursor++;
        if (ch == 10) {
            ++line;
        }
        --remaining;
    }

    if (remaining == 0) {
        if (ESQIFF_AssetSourceSelect != 0) {
            remaining = Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
            cursor = (BYTE *)Global_REF_LONG_DF0_LOGO_LST_DATA;
        } else {
            remaining = Global_REF_LONG_GFX_G_ADS_FILESIZE;
            cursor = (BYTE *)Global_REF_LONG_GFX_G_ADS_DATA;
        }
        targetLine = 1;
    } else {
        targetLine = (WORD)(targetLine + 1);
    }

    if (ESQIFF_AssetSourceSelect != 0) {
        ESQIFF_LogoListLineIndex = targetLine;
    } else {
        ESQIFF_GAdsListLineIndex = targetLine;
    }

    for (;;) {
        BYTE ch = *cursor++;
        if (ch == 10 || ch == 13 || ch == 32) {
            break;
        }

        {
            LONG oldRemaining = remaining;
            --remaining;
            if (oldRemaining <= 0) {
                break;
            }
        }

        if (ch == 44) {
            *out = '\0';
            ESQIFF_ExternalAssetPathCommaFlag = 1;
            break;
        }

        *out++ = (char)ch;
    }

    *out = '\0';
    return 1;
}
