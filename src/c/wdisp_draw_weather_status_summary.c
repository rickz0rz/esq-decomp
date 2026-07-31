/* RESTORES: WDISP_DrawWeatherStatusSummary
 * MODULE:   modules/groups/b/a/wdisp_p0.s
 * STATUS:   behavioural
 *
 * Clears the weather RastPort and either draws three day panels or centres a
 * single fallback message in it.
 *
 * The choice needs BOTH conditions: the day-entry counter must be above zero
 * (an UNSIGNED byte compare, BLS) AND the status digit must not be '0'. Either
 * one failing gives the fallback text.
 *
 * The fallback string itself has a fallback: the forecast message if one is
 * set, otherwise the no-forecast placeholder.
 *
 * The centring is the interesting part and both halves are signed halvings
 * (TST.L / BPL / ADDQ #1 / ASR #1), not shifts:
 *
 *   x = (width  - TextLength(text)) / 2
 *   y = (height - font->tf_YSize) / 2 + font->tf_Baseline
 *
 * tf_YSize is the word at +20 of a TextFont and tf_Baseline the word at +26,
 * which is what the original reads. The baseline is added AFTER the halving, so
 * it is not part of the centring.
 *
 * The volatile graphics header is right here: the day-panel drawer is ESQ
 * assembly, and the original duly reloads the base for the TextLength that
 * follows the loop, then keeps it across TextLength/Move/Text -- all library
 * calls with nothing between them.
 *
 * 224 ref vs 240 got. Both signed halvings are VERBATIM
 * (4a81 6a02 5281 e281 and 4a82 6a02 5282 e282), and so are the tf_YSize read
 * at +20, the tf_Baseline read at +26, the inline strlen, the MOVEQ #48 digit
 * test, the MOVEQ #3 panel bound and the TextLength/Move/Text run.
 *
 * THE PANEL COUNTER IS DECLARED `register`, and that is measured. Without it
 * 6.51 spills the three-iteration counter to a stack slot and increments it in
 * memory (42af001c / 52af001c), where the original keeps it in D4 (7800 /
 * 5284). `register` moves it back into a data register and takes the function
 * from 240 bytes to 236. This is the OPPOSITE of the usual direction -- almost
 * everywhere else 6.51 keeps in registers what the original spills -- and it
 * happens here because the loop body passes four arguments and exhausts the
 * allocator. Worth trying on any counter whose loop body makes a wide call;
 * SAS/C does honour the keyword.
 */
#include "esq-graphics.h"
#include <string.h>

extern void WDISP_DrawWeatherStatusDayEntry(struct RastPort *rp, long index,
                                            long width, long height);

extern unsigned char TLIBA1_DayEntryModeCounter;
extern short WDISP_WeatherStatusDigitChar;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *SCRIPT_PtrNoForecastWeatherData;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

void WDISP_DrawWeatherStatusSummary(struct RastPort *rp, long width,
                                    long height)
{
    char *text;
    long  len;
    long  x, y;
    register long i;

    SetRast(rp, 0L);

    if (TLIBA1_DayEntryModeCounter > 0 && WDISP_WeatherStatusDigitChar != 48) {
        for (i = 0; i < 3; i++)
            WDISP_DrawWeatherStatusDayEntry(rp, i, width, height);
        return;
    }

    if (P_TYPE_WeatherForecastMsgPtr != 0)
        text = P_TYPE_WeatherForecastMsgPtr;
    else
        text = SCRIPT_PtrNoForecastWeatherData;

    len = (long)strlen(text);

    x = (width - TextLength(rp, text, len)) / 2;
    y = (height - (long)Global_HANDLE_PREVUEC_FONT->tf_YSize) / 2
        + (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline;

    Move(rp, x, y);
    Text(rp, text, len);
}
