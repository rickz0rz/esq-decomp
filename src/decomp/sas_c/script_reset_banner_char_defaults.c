typedef short WORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerCharFallback;
extern WORD TEXTDISP_CurrentMatchIndex;

void SCRIPT_ResetBannerCharDefaults(void)
{
    TEXTDISP_BannerCharSelected = 0x64;
    TEXTDISP_BannerCharFallback = 0x31;
    TEXTDISP_CurrentMatchIndex = -1;
}
