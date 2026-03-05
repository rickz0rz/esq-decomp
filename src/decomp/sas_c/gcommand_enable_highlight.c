extern short GCOMMAND_HighlightFlag;
extern void GCOMMAND_ApplyHighlightFlag(void);

void GCOMMAND_EnableHighlight(void)
{
    GCOMMAND_HighlightFlag = 1;
    GCOMMAND_ApplyHighlightFlag();
}
