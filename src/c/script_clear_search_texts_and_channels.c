/* RESTORES: SCRIPT_ClearSearchTextsAndChannels
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   exact
 *
 * Clears both search strings and both channel codes.
 *
 * NOTE: the chained assignments are load-bearing. The original loads zero into
 * a register once per group and stores it twice; writing four separate `= 0`
 * statements makes SAS/C emit CLR.B/CLR.W instead and the bytes diverge.
 */
extern char  TEXTDISP_SecondarySearchText[];
extern char  TEXTDISP_PrimarySearchText[];
extern short TEXTDISP_SecondaryChannelCode;
extern short TEXTDISP_PrimaryChannelCode;

void SCRIPT_ClearSearchTextsAndChannels(void)
{
    TEXTDISP_SecondarySearchText[0] = TEXTDISP_PrimarySearchText[0] = 0;
    TEXTDISP_SecondaryChannelCode = TEXTDISP_PrimaryChannelCode = 0;
}
