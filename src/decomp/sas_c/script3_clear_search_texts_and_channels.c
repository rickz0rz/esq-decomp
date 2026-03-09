typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern char TEXTDISP_SecondarySearchText[];
extern char TEXTDISP_PrimarySearchText[];
extern UWORD TEXTDISP_SecondaryChannelCode;
extern UWORD TEXTDISP_PrimaryChannelCode;

void SCRIPT_ClearSearchTextsAndChannels(void)
{
    TEXTDISP_SecondarySearchText[0] = 0;
    TEXTDISP_PrimarySearchText[0] = 0;
    TEXTDISP_SecondaryChannelCode = 0;
    TEXTDISP_PrimaryChannelCode = 0;
}
