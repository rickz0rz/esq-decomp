typedef signed char BYTE;

extern BYTE ED_MenuStateId;

extern void ED_DrawBottomHelpBarBackground(void);
extern void ED_DrawESCMenuHelpText(void);

void ED_DrawESCMenuBottomHelp(void)
{
    ED_MenuStateId = 1;
    ED_DrawBottomHelpBarBackground();
    ED_DrawESCMenuHelpText();
}
