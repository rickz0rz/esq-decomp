extern short GCOMMAND_HighlightFlag;
extern void GCOMMAND_ApplyHighlightFlag(void);

void GCOMMAND_DisableHighlight(void)
{
    GCOMMAND_HighlightFlag = 0;
    GCOMMAND_ApplyHighlightFlag();
}
