/* RESTORES: UNKNOWN_ParseRecordAndUpdateDisplay
 * MODULE:   modules/submodules/unknown.s   (1 of its 12 labels)
 * STATUS:   behavioural
 *
 * The 'W' record handler: it reads one weather-status record out of the RBF
 * serial buffer and, when the record's label matches the one on screen,
 * replaces the overlay text and its three attribute bytes.
 *
 * Despite living in `submodules/`, this is ESQ's OWN code and not SAS/C
 * runtime -- the same point esqproto_parse.c makes about its four neighbours.
 * The `unknown*.s` naming says where the disassembly put the module, not who
 * wrote it.
 *
 * THE RECORD LAYOUT, read off the entry rather than guessed:
 *
 *     +0  countdown     byte
 *     +1  colour code   byte
 *     +2  brush index   byte, valid 2..6
 *     +3  (skipped)     the original does a bare ADDQ.L #1,A3
 *     +4  label         up to 11 bytes, terminated by 18 (0x12)
 *     ..  text          whatever follows the label
 *
 * THE BRUSH INDEX TEST IS UNSIGNED, and it has to be. The original uses BCS
 * and BLS, not BLT and BLE, so a byte of 0x80 or more is ABOVE the range and
 * falls back to 1. A signed test would take the same byte as negative,
 * therefore below 2, and reach the same fallback by luck -- but only for the
 * fallback. The cast is written out so the reader does not have to check.
 *
 * THE LABEL LOOP STORES BEFORE IT TESTS, which is why the terminator lands in
 * the buffer and is then overwritten by the NUL. Eleven bytes are consumed at
 * most, index 0 through 10 inclusive, and index 10 is written twice. The same
 * loop appears in esqproto_parse.c as copy_label(); it is duplicated here
 * rather than shared because the original duplicates it, and sharing it would
 * add a call the original does not have.
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     the final DisplayTextAtPosition block is popped with
 *            `LEA 16(A7),A7`, and the two eight-byte blocks before it with
 *            `ADDQ.W #8,A7`
 *   got:     the same, since SAS/C also pops per call here
 *   summary: no divergence in the cleanup on this function. Recorded because
 *            its sibling ParseListAndUpdateEntries DOES overlap its blocks and
 *            the two read as if they should agree.
 *
 * SASC-MISMATCH: byte-local-in-register
 *   ref:     the three attribute bytes stay in D6/D5/D4 across the whole
 *            routine, including across three calls
 *   got:     SAS/C keeps them in callee-saved registers as well, but reloads
 *            the label buffer address per use rather than holding it in A3
 *   scope:   program-wide, the ordinary DATA=FAR addressing cost.
 *   retest:  a compiler that pins a frame pointer for the buffer.
 */
#include <graphics/rastport.h>

extern unsigned char WDISP_WeatherStatusCountdown;
extern unsigned char WDISP_WeatherStatusColorCode;
extern unsigned char WDISP_WeatherStatusBrushIndex;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char  WDISP_WeatherStatusLabelBuffer[];
extern short ED_DiagnosticsScreenActive;
extern struct RastPort *Global_REF_RASTPORT_1;

extern char  ESQ_WildcardMatch(char *pattern, char *text);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);
extern void  DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                           char *text);

void UNKNOWN_ParseRecordAndUpdateDisplay(char *buf)
{
    char  label[13];
    char *src = buf;
    unsigned char countdown;
    unsigned char colour;
    unsigned char brush;
    short i;
    char  c;

    countdown = (unsigned char)*src++;
    colour    = (unsigned char)*src++;
    brush     = (unsigned char)*src++;
    src++;

    if (brush < 2 || brush > 6)
        brush = 1;

    i = 0;
    for (;;) {
        c = *src++;
        label[i] = c;
        if (c == 18)
            break;
        if (i >= 10)
            break;
        i++;
    }
    label[i] = 0;

    if (label[0] == 0)
        return;
    if (ESQ_WildcardMatch(WDISP_WeatherStatusLabelBuffer, label) != 0)
        return;

    WDISP_WeatherStatusOverlayTextPtr =
        ESQPARS_ReplaceOwnedString(src, WDISP_WeatherStatusOverlayTextPtr);
    WDISP_WeatherStatusCountdown  = countdown;
    WDISP_WeatherStatusColorCode  = colour;
    WDISP_WeatherStatusBrushIndex = brush;

    if (ED_DiagnosticsScreenActive == 0)
        return;

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 0L, 172L,
                                  WDISP_WeatherStatusOverlayTextPtr);
}
