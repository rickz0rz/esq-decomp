/* RESTORES: ESQ_CaptureCtrlBit4Stream
 * MODULE:   modules/groups/a/a/app_p1.s
 * STATUS:   behavioural
 *
 * A soft UART, and the twin of ESQ_CaptureCtrlBit3Stream. It is called once per
 * tick, samples CIAB PRA bit 4 over many ticks, assembles one byte per
 * character, and appends it to a 500-byte wrapping buffer. All of its state
 * lives in globals because it returns between samples.
 *
 * THE TIMING IS IDENTICAL TO THE BIT-3 SAMPLER: 4 ticks to confirm the start
 * bit, 14 to the first data sample, 10 between samples, byte assembled at phase
 * 94, 8 bits built MSB-last from the scratch buffer read BACKWARDS. Only the
 * delivery end differs.
 *
 * NOT an interior label, although coverage.py screens it as one. That screen
 * fires on a body that touches A5 with no `LINK.W A5`, because such a body is
 * usually borrowing an enclosing routine's frame. Here A5 is loaded by the
 * function itself, four times, as an ordinary scratch address register
 * (`LEA CTRL_Bit4SampleScratch,A5`). The function starts at its own label and
 * every path ends in RTS.
 *
 * WHERE THE BIT-3 TWIN WRITES A RING OF SAMPLE ENTRIES, THIS ONE WRITES A
 * WRAPPING BUFFER and then measures how full it is:
 *
 *   CTRL_BUFFER[CTRL_H] = byte;  CTRL_H = (CTRL_H + 1) % 500;
 *   fill = CTRL_H - CTRL_HPreviousSample;   modulo 500, UNSIGNED
 *   CTRL_BufferedByteCount = fill;
 *   if (fill >= CTRL_HDeltaMax) CTRL_HDeltaMax = fill;
 *
 * THE TWO COMPARISONS IN THAT TAIL ARE UNSIGNED, and reading them as signed
 * inverts both. `SUB.W D1,D0 / BCC` skips the +500 correction when no borrow
 * occurred, which is an unsigned `>=`; `CMP.W CTRL_HDeltaMax,D0 / BCS` takes the
 * exit when the new fill is unsigned-LESS than the running maximum. So
 * CTRL_HDeltaMax is a high-water mark, and it is never reset here.
 *
 * THE WRAP TEST IS `== 500`, NOT `>= 500`. The original is `CMPI.W #$1f4,D1 /
 * BNE`, so a CTRL_H that somehow started above 500 would run away rather than be
 * clamped. Written as a modulo it would silently be more robust than the
 * original, so it is written as the equality test.
 *
 * A NEGATIVE SAMPLE IS A ZERO BIT. The sampler stores the helper's return value,
 * which is -1 for a LOW line, so the assembly tests `BMI` rather than testing
 * for truth. The helper returns -1 rather than 0xFF precisely so that this test
 * has the same meaning at long width as the original's had at byte width -- see
 * get_bit4_of_ciab_pra.c.
 *
 * THE STOP BIT MUST BE HIGH. At phase 94 the line is read once more and the
 * whole character is DISCARDED if it is still low, without touching the buffer.
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: the usual cross-unit call encoding cap. Same size, same
 *            displacement, same effect.
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: bit-set-clear-vs-mask
 *   ref:     BSET D1,D0 / BCLR D1,D0 under DBF
 *   got:     a shift and an OR / AND-NOT
 *   summary: the original sets or clears the bit with the 68000 bit
 *            instructions, which take the bit number in a register. 6.51 builds
 *            a mask. Same result for every bit number 0..7.
 *   scope:   shared with esq_capture_ctrl_bit3_stream.c, which records it too.
 *   retest:  a compiler that emits BSET/BCLR for a variable bit index.
 */
#include <exec/types.h>

extern long GET_BIT_4_OF_CIAB_PRA_INTO_D1(void);

extern short CTRL_Bit4CapturePhase;
extern short CTRL_Bit4CaptureDelayCounter;
extern short CTRL_Bit4SampleSlotIndex;
extern BYTE  CTRL_Bit4SampleScratch[];

extern BYTE  CTRL_BUFFER[];
extern short CTRL_H;
extern short CTRL_HPreviousSample;
extern short CTRL_BufferedByteCount;
extern short CTRL_HDeltaMax;

#define SAMPLE_BITS     8       /* MOVEQ #7,D0 then DBF */
#define START_DELAY     4       /* ticks to confirm the start bit */
#define FIRST_SAMPLE    14      /* ticks to the first data sample */
#define SAMPLE_STEP     10      /* ticks between samples */
#define LAST_PHASE      94      /* assemble the byte at this phase */
#define BUFFER_WRAP     500     /* CMPI.W #$1f4 */

static void reset_capture(void)
{
    CTRL_Bit4CaptureDelayCounter = 0;
    CTRL_Bit4SampleSlotIndex = 0;
    CTRL_Bit4CapturePhase = 0;
}

void ESQ_CaptureCtrlBit4Stream(void)
{
    short phase;
    short slot;
    short i;
    short head;
    unsigned short fill;
    unsigned short prev;
    /* The original assembles into D0, a long, and stores its low byte. Building
     * into a signed char instead would make bit 7 implementation-defined. */
    long  acc;

    if (CTRL_Bit4CapturePhase == 0) {
        /* Idle. The line has to go low to start a character. */
        if (GET_BIT_4_OF_CIAB_PRA_INTO_D1() >= 0)
            return;
        CTRL_Bit4CapturePhase++;
        CTRL_Bit4CaptureDelayCounter = START_DELAY;
        CTRL_Bit4SampleSlotIndex = 0;
        return;
    }

    phase = ++CTRL_Bit4CapturePhase;
    if (CTRL_Bit4CaptureDelayCounter > phase)
        return;

    if (phase <= START_DELAY) {
        /* Still in the start bit. It must still be low, or this was noise. */
        if (GET_BIT_4_OF_CIAB_PRA_INTO_D1() >= 0) {
            reset_capture();
            return;
        }
        CTRL_Bit4CaptureDelayCounter = FIRST_SAMPLE;
        for (i = 0; i < SAMPLE_BITS; i++)
            CTRL_Bit4SampleScratch[i] = 0;
        return;
    }

    if (phase < LAST_PHASE) {
        /* One data sample, then wait again. */
        slot = CTRL_Bit4SampleSlotIndex;
        CTRL_Bit4SampleScratch[slot] = (BYTE)GET_BIT_4_OF_CIAB_PRA_INTO_D1();
        CTRL_Bit4SampleSlotIndex = slot + 1;
        CTRL_Bit4CaptureDelayCounter += SAMPLE_STEP;
        return;
    }

    /* Stop bit. It must be high, or the character is discarded. */
    if (GET_BIT_4_OF_CIAB_PRA_INTO_D1() < 0) {
        reset_capture();
        return;
    }

    acc = 0;
    for (i = (short)(CTRL_Bit4SampleSlotIndex - 1); i >= 0; i--) {
        if (CTRL_Bit4SampleScratch[i] < 0)
            acc &= ~(1L << i);
        else
            acc |= (1L << i);
    }

    head = CTRL_H;
    CTRL_BUFFER[head] = (BYTE)acc;
    head++;
    if (head == BUFFER_WRAP)            /* equality, not a clamp -- see above */
        head = 0;
    CTRL_H = head;

    /* Both compares below are UNSIGNED in the original: `SUB.W / BCC` and
     * `CMP.W / BCS`. Reading either as signed inverts it. */
    prev = (unsigned short)CTRL_HPreviousSample;
    fill = (unsigned short)((unsigned short)head - prev);
    if ((unsigned short)head < prev)
        fill = (unsigned short)(fill + BUFFER_WRAP);
    CTRL_BufferedByteCount = (short)fill;

    if (fill >= (unsigned short)CTRL_HDeltaMax)
        CTRL_HDeltaMax = (short)fill;

    reset_capture();
}
