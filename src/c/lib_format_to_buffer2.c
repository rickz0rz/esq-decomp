/* RESTORES: _FORMAT_FormatToBuffer2
 * MODULE:   modules/submodules/unknown27_format_formattobuffer2.s
 * STATUS:   behavioural
 *
 * Formats into a caller-supplied buffer and returns the character count.
 *
 * IT IS ALREADY A V-FORM, WHICH IS WHY IT NEVER NEEDED ONE. Its third argument
 * is an argument POINTER, not a variable list:
 *
 *     MOVE.L  16(A5),-(A7)       ; the VALUE at 16(A5) -- the third argument
 *
 * Compare `_WDISP_SPrintf`, which is variadic and computes the pointer itself
 * with `PEA 16(A5)`. That difference is the whole reason `WDISP_SPrintf` needed
 * a `WDISP_VSPrintf` split and this function did not: callers already hand it a
 * pointer. `_FORMAT_RawDoFmtWithScratchBuffer` is one such caller.
 *
 * It terminates through the global rather than tracking the end itself, because
 * the callback is what advanced the cursor -- the same shape `_WDISP_SPrintf`
 * uses.
 *
 * THE RETURN TYPE IS `long`, NOT `void`. The original ends
 * `MOVE.L Global_FormatByteCount2(A4),D0`, so the count comes back in D0. Two
 * existing externs in the tree declare it `void`, which is harmless for a
 * caller that ignores the result and is corrected here at the definition.
 *
 * SPLIT OUT OF unknown27.s, along with its callback. The module also held
 * `FORMAT_ParseFormatSpec`, 950 bytes of printf spec parsing that is not
 * restored yet. `tools/split_module.py` cut both small routines onto their own
 * `;!======` boundaries, byte-neutral, so they can link while the parser stays
 * in assembly.
 */
#include "esq-neardata.h"

extern long FORMAT_Buffer2WriteChar(long ch);
extern void WDISP_FormatWithCallback(long (*put)(long ch), char *fmt, void *args);

long FORMAT_FormatToBuffer2(char *buf, char *fmt, void *args)
{
    Global_FormatByteCount2_A4 = 0;
    Global_FormatBufferPtr2_A4 = (long)buf;

    WDISP_FormatWithCallback(FORMAT_Buffer2WriteChar, fmt, args);

    *(char *)Global_FormatBufferPtr2_A4 = 0;

    return Global_FormatByteCount2_A4;
}
