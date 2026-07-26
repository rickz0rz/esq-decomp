/* RESTORES: ESQ_InitAudio1Dma
 * MODULE:   modules/groups/a/a/app.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: hardware-base-pointer
 *   ref:     207c00dff00043f9000053a4214900b0317c000100b4317c000000b8317c065b00b6317c82020096700033c0000000cc33c0000000d033c0000000ee4e75
 *   got:     2f0d2a7c00dff0002b7c0000000000b03b7c000100b4426d00b83b7c065b00b6207c00dff09630bc8202700033c00000000033c00000000033c0000000002a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Custom-chip register block at 0xDFF000; the original addresses it through a
 * base pointer in A0 with fixed displacements. */
struct Custom {
    char pad_a[0xB0];
    unsigned long  aud1lch;    /* 0xDFF0B0 */
    unsigned short aud1len;    /* 0xDFF0B4 */
    unsigned short aud1per;    /* 0xDFF0B6 */
    unsigned short aud1vol;    /* 0xDFF0B8 */
};
extern char Global_PTR_AUD1_DMA[];
extern short CTRL_Bit4CaptureDelayCounter, CTRL_Bit4CapturePhase, CTRL_SampleEntryCount;
#define CUSTOMBASE ((struct Custom *)0xDFF000L)
#define DMACONW    (*(volatile unsigned short *)0xDFF096L)

void ESQ_InitAudio1Dma(void)
{
    struct Custom *c = CUSTOMBASE;

    c->aud1lch = (unsigned long)Global_PTR_AUD1_DMA;
    c->aud1len = 1;
    c->aud1vol = 0;
    c->aud1per = 0x65b;
    DMACONW = 0x8202;
    CTRL_SampleEntryCount = CTRL_Bit4CapturePhase = CTRL_Bit4CaptureDelayCounter = 0;
}
