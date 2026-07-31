/* RESTORES: _GCOMMAND_ClearBannerQueue
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p1.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern short ESQPARS2_BannerQueueAttentionCountdown;
extern char  ESQPARS2_BannerQueueBuffer[];

void GCOMMAND_ClearBannerQueue(void)
{
    long i;

    ESQPARS2_BannerQueueAttentionCountdown = -1;
    for (i = 0; i < 98; i++)
        ESQPARS2_BannerQueueBuffer[i] = 0;
}
