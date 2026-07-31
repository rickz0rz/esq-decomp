/* RESTORES: ED_CaptureKeySequence
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * 256 bytes in the original, 260 emitted, 17 differing regions.
 *
 * Reproduces: the 24-byte template copy onto the stack, the ring-table read at
 * index*5, the char-class bit-7 gate, the hex-digit parse, the phase-0 versus
 * phase-N split, the three-way validity test (sentinel negative, sentinel >= 8,
 * or digit >= 13 unsigned) that invalidates the capture, the scratch write at
 * sentinel*3 + phase, the phase advance modulo 4, and the wrap-up that restores
 * the default palette from the stack template only when the sentinel went
 * negative -- reusing the sentinel itself as the copy loop counter.
 *
 * Worth noting: memcpy(tmpl, ..., 24) compiles to the SAME MOVEQ #23 /
 * MOVE.B (A0)+,(A1)+ / DBF loop the original uses. SAS/C inlines a small
 * fixed-size memcpy exactly this way, so no library call is involved and the
 * copy is byte-identical apart from the frame register.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffe4                   LINK.W A5,#-28
 *   got:     9efc0018                   SUBA.W #24,A7
 *   summary: The A5-frame class; the 24-byte template buffer moves to
 *            A7-relative, which is most of the 17 regions.
 *
 * SASC-MISMATCH: multiply-by-five-idiom
 *   ref:     e588 d0b9xxxxxxxx          LSL.L #2,D0 / ADD.L (abs).L,D0
 *   got:     2200 e581 d280             MOVE.L D0,D1 / ASL.L #2,D1 / ADD.L D0,D1
 *   summary: index*5. Same family as the multiply-by-three idiom in
 *            ed_draw_diagnostic_register_values.c -- the original re-reads the
 *            global to add it back, SAS/C keeps a register copy.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
#include <string.h>

extern long ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(long ch);
extern long __asm GROUP_AG_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);

extern unsigned char ED_CustomPaletteTriplesDefaultTemplate24B[];
extern long  ED_StateRingIndex;
extern unsigned char ED_StateRingTable[];
extern unsigned char ED_LastKeyCode;
extern unsigned char WDISP_CharClassTable[];
extern long  ED_CustomPaletteCapturePhaseMod4;
extern long  ED_CustomPaletteCaptureIndexOrSentinel;
extern unsigned char KYBD_CustomPaletteCaptureScratchBase[];
extern unsigned char KYBD_CustomPaletteTriplesRBase[];
extern unsigned char ED_MenuStateId;

void ED_CaptureKeySequence(void)
{
    unsigned char tmpl[24];
    register unsigned char digit;
    unsigned char key;

    memcpy(tmpl, ED_CustomPaletteTriplesDefaultTemplate24B, 24);

    key = ED_StateRingTable[ED_StateRingIndex * 5];
    ED_LastKeyCode = key;

    if (WDISP_CharClassTable[key] & 0x80) {
        digit = (unsigned char)ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit((long)key);
        if (ED_CustomPaletteCapturePhaseMod4 == 0) {
            ED_CustomPaletteCaptureIndexOrSentinel = digit;
        } else if (ED_CustomPaletteCaptureIndexOrSentinel < 0
                   || ED_CustomPaletteCaptureIndexOrSentinel >= 8
                   || digit >= 13) {
            ED_CustomPaletteCaptureIndexOrSentinel = -1;
        } else {
            KYBD_CustomPaletteCaptureScratchBase[
                ED_CustomPaletteCaptureIndexOrSentinel * 3
                + ED_CustomPaletteCapturePhaseMod4] = digit;
        }
    } else {
        ED_CustomPaletteCaptureIndexOrSentinel = -1;
    }

    ED_CustomPaletteCapturePhaseMod4 = (ED_CustomPaletteCapturePhaseMod4 + 1) % 4;
    if (ED_CustomPaletteCapturePhaseMod4 == 0) {
        if (ED_CustomPaletteCaptureIndexOrSentinel < 0) {
            ED_CustomPaletteCaptureIndexOrSentinel = 0;
            while (ED_CustomPaletteCaptureIndexOrSentinel < 24) {
                KYBD_CustomPaletteTriplesRBase[ED_CustomPaletteCaptureIndexOrSentinel] =
                    tmpl[ED_CustomPaletteCaptureIndexOrSentinel];
                ED_CustomPaletteCaptureIndexOrSentinel++;
            }
        }
        ED_MenuStateId = 0;
    }
}
