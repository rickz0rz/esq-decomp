/* RESTORES: FORMAT_Buffer2WriteChar
 * MODULE:   modules/submodules/unknown27_format_buffer2writechar.s
 * STATUS:   behavioural
 *
 * The output callback for `FORMAT_FormatToBuffer2`. One character into the
 * buffer, the cursor and the count both kept in near data.
 *
 * This is the same routine as `UNKNOWN10_PrintfPutcToBuffer` in
 * `lib_hex_parse_sprintf.c`, over a different pair of globals. ESQ carries two
 * independent formatter states -- `Global_PrintfBufferPtr`/`ByteCount` for
 * sprintf and `Global_FormatBufferPtr2`/`ByteCount2` for this one -- so that a
 * format started by one cannot disturb the other. Do not fold them together.
 *
 * THE COUNT IS BUMPED BEFORE THE CURSOR IS READ, which is the order the
 * original uses and is kept here even though nothing observes the difference.
 *
 * It returns the character it wrote. `WDISP_FormatWithCallback` ignores the
 * result, but the original leaves it in D0 and a caller could read it.
 *
 * SPLIT OUT OF unknown27.s. That module also held `FORMAT_ParseFormatSpec`, 950
 * bytes of printf spec parsing that is not restored yet, and a C file replaces a
 * whole module. `tools/split_module.py` cut this and `FORMAT_FormatToBuffer2`
 * onto their own `;!======` boundaries, which is byte-neutral, so the two small
 * routines can be linked while the parser stays in assembly.
 */
#include "esq-neardata.h"

long FORMAT_Buffer2WriteChar(long ch)
{
    char *p;

    Global_FormatByteCount2_A4++;

    p = (char *)Global_FormatBufferPtr2_A4;
    *p++ = (char)ch;
    Global_FormatBufferPtr2_A4 = (long)p;

    return ch;
}
