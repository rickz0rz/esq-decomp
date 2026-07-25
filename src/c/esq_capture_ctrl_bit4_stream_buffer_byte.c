/* RESTORES: ESQ_CaptureCtrlBit4StreamBufferByte
 * MODULE:   modules/groups/a/a/app.s
 * STATUS:   behavioural
 *
 * Reads the next byte from the CTRL capture ring and advances the cursor,
 * wrapping at 500. 38 bytes ref vs 42 (with OPTIMIZE) or 52 (without).
 *
 * SASC-MISMATCH: scratch-register-locals
 *   summary: The original holds both the ring index and the result in the
 *            scratch registers D0/D1 and saves nothing at all. SAS/C allocates
 *            callee-saved registers for the locals and pays for MOVEM at both
 *            ends. OPTIMIZE narrows the gap to 4 bytes but still saves D6.
 *   tried:   default and OPTIMIZE; locals as long/short/unsigned short;
 *            indexing via array subscript and via an explicit pointer.
 *   retest:  a compiler willing to keep locals in D0/D1 across a function body
 *            should close this.
 */
extern unsigned short CTRL_HPreviousSample;
extern unsigned char  CTRL_BUFFER[];

long ESQ_CaptureCtrlBit4StreamBufferByte(void)
{
    long b = 0;
    unsigned short i = CTRL_HPreviousSample;

    b = CTRL_BUFFER[i];
    i++;
    if (i == 500)
        i = 0;
    CTRL_HPreviousSample = i;
    return b;
}
