typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD ESQPARS2_BannerQueueAttentionCountdown;
extern UBYTE ESQPARS2_BannerQueueBuffer[];

void GCOMMAND_ClearBannerQueue(void)
{
    LONG i;
    ESQPARS2_BannerQueueAttentionCountdown = -1;
    for (i = 0; i < 98; ++i) {
        ESQPARS2_BannerQueueBuffer[i] = 0;
    }
}
