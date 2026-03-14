#include <exec/types.h>
extern LONG CONFIG_RefreshIntervalSeconds;
extern WORD CONFIG_BannerCopperHeadByte;
extern UBYTE ESQPARS2_BannerQueueBuffer[];
extern WORD GCOMMAND_BannerQueueSlotPrevious;

extern LONG GCOMMAND_GetBannerChar(void);

void GCOMMAND_MapKeycodeToPreset(UBYTE keycode)
{
    LONG value = 0;

    if ((keycode & 0x30) == 0x30) {
        value = CONFIG_RefreshIntervalSeconds;
    } else if ((keycode & 0x20) == 0x20) {
        if ((WORD)GCOMMAND_GetBannerChar() == CONFIG_BannerCopperHeadByte) {
            value = CONFIG_RefreshIntervalSeconds;
        }
    } else if ((keycode & 0x40) == 0x40) {
        value = -1;
    }

    ESQPARS2_BannerQueueBuffer[GCOMMAND_BannerQueueSlotPrevious] = (UBYTE)value;
}
