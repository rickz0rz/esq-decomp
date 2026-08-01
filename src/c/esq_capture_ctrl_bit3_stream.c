/* RESTORES: ESQ_CaptureCtrlBit3Stream
 * MODULE:   modules/groups/a/a/app_p0.s
 * STATUS:   behavioural
 *
 * A soft UART. It is called once per tick and samples CIAB PRA bit 3 over many
 * ticks, assembling one byte per character and appending it to the sample-entry
 * ring. All of its state lives in globals because it returns between samples.
 *
 * NOT an interior label, although coverage.py screens it as one. That screen
 * fires on a body that touches A5 with no LINK.W A5, because such a body is
 * usually reached by a branch from inside a larger routine and is borrowing
 * that routine's frame. Here A5 is loaded by the function itself, twice, as an
 * ordinary scratch address register -- `LEA _CTRL_Bit3SampleScratch,A5`. The
 * function is whole, it starts at its own label and every path ends in RTS.
 *
 * THE D1-RETURN HELPER IS NOT A BLOCKER ONCE THE CALLER IS C.
 * _GET_BIT_3_OF_CIAB_PRA_INTO_D1 returns its result in D1 rather than D0, which
 * is why src/c/get_bit3_of_ciab_pra.c carried DO-NOT-LINK: no C function can
 * return in D1, so an assembly caller would read garbage. This file is that
 * helper's ONLY caller in the whole program. With both sides in C the
 * convention is C's, D0, and the restriction disappears. The helper's module
 * moves to C in the same manifest entry, so the two can never disagree.
 *
 * The phase counter doubles as a tick clock: it is bumped on every call and
 * compared against a delay that the code pushes forward as it goes -- 4 ticks
 * to confirm the start bit, 14 to reach the first data sample, then 10 per
 * sample. Samples run to phase 94, and the byte is assembled at that point.
 *
 * The byte is built MSB-first from the scratch buffer read BACKWARDS: the
 * original walks `-(A5)` while DBF counts the bit number down, so sample[i]
 * becomes bit i. A negative sample is a zero bit, which is why the test is BMI
 * and not a plain truth test -- the sampler stores 0xFF for a low line.
 *
 * A zero byte is the flush signal. The original stores the byte, tests the
 * condition codes the store itself set, and branches to the flush on zero, so
 * the count is NOT advanced in that case. A full ring -- five entries -- also
 * flushes, after overwriting the fifth slot with zero.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls, the usual cap under
 *            6.51. The state machine, the constants 4/14/10/94/5 and the
 *            backwards bit assembly all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/types.h>

extern long GET_BIT_3_OF_CIAB_PRA_INTO_D1(void);
extern void ESQ_StoreCtrlSampleEntry(void);

extern short CTRL_Bit3CapturePhase;
extern short CTRL_Bit3CaptureDelayCounter;
extern short CTRL_Bit3SampleSlotIndex;
extern BYTE  CTRL_Bit3SampleScratch[];
extern short CTRL_SampleEntryCount;
extern BYTE  CTRL_SampleEntryScratch[];

#define SAMPLE_BITS     8       /* MOVEQ #7,D0 then DBF */
#define START_DELAY     4       /* ticks to confirm the start bit */
#define FIRST_SAMPLE    14      /* ticks to the first data sample */
#define SAMPLE_STEP     10      /* ticks between samples */
#define LAST_PHASE      94      /* assemble the byte at this phase */
#define RING_ENTRIES    5

static void reset_capture(void)
{
    CTRL_Bit3CaptureDelayCounter = 0;
    CTRL_Bit3SampleSlotIndex = 0;
    CTRL_Bit3CapturePhase = 0;
}

void ESQ_CaptureCtrlBit3Stream(void)
{
    short phase;
    short slot;
    short i;
    short count;
    /* The original assembles into D0, a long, and stores its low byte. Building
     * into a signed char instead would make bit 7 implementation-defined. */
    long  acc;
    BYTE  byte;

    if (CTRL_Bit3CapturePhase == 0) {
        /* Idle. The line has to go low to start a character. */
        if (GET_BIT_3_OF_CIAB_PRA_INTO_D1() >= 0)
            return;
        CTRL_Bit3CapturePhase++;
        CTRL_Bit3CaptureDelayCounter = START_DELAY;
        CTRL_Bit3SampleSlotIndex = 0;
        return;
    }

    phase = ++CTRL_Bit3CapturePhase;
    if (CTRL_Bit3CaptureDelayCounter > phase)
        return;

    if (phase <= START_DELAY) {
        /* Still in the start bit. It must still be low, or this was noise. */
        if (GET_BIT_3_OF_CIAB_PRA_INTO_D1() >= 0) {
            reset_capture();
            return;
        }
        CTRL_Bit3CaptureDelayCounter = FIRST_SAMPLE;
        for (i = 0; i < SAMPLE_BITS; i++)
            CTRL_Bit3SampleScratch[i] = 0;
        return;
    }

    if (phase < LAST_PHASE) {
        /* One data sample, then wait again. */
        slot = CTRL_Bit3SampleSlotIndex;
        CTRL_Bit3SampleScratch[slot] = (BYTE)GET_BIT_3_OF_CIAB_PRA_INTO_D1();
        CTRL_Bit3SampleSlotIndex = slot + 1;
        CTRL_Bit3CaptureDelayCounter += SAMPLE_STEP;
        return;
    }

    /* Stop bit. It must be high, or the character is discarded. */
    if (GET_BIT_3_OF_CIAB_PRA_INTO_D1() < 0) {
        reset_capture();
        return;
    }

    acc = 0;
    for (i = (short)(CTRL_Bit3SampleSlotIndex - 1); i >= 0; i--) {
        if (CTRL_Bit3SampleScratch[i] < 0)
            acc &= ~(1L << i);
        else
            acc |= (1L << i);
    }
    byte = (BYTE)acc;

    count = CTRL_SampleEntryCount;
    CTRL_SampleEntryScratch[count] = byte;

    if (byte != 0) {
        count++;
        if (count >= RING_ENTRIES) {
            CTRL_SampleEntryScratch[CTRL_SampleEntryCount] = 0;
            ESQ_StoreCtrlSampleEntry();
            count = 0;
        }
        CTRL_SampleEntryCount = count;
    } else {
        ESQ_StoreCtrlSampleEntry();
        CTRL_SampleEntryCount = 0;
    }

    reset_capture();
}
