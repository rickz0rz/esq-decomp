/* RESTORES: NEWGRID_DrawWrappedText
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   behavioural
 *
 * 450 bytes in the original, 432 emitted, 19 differing regions.
 *
 * This is a measure-and-draw word wrapper with six live values (scan cursor,
 * word start, accumulated width, space width, word width, trim length) that the
 * original keeps entirely in the frame. Reproduces: the leading SkipClass3Chars,
 * the per-word CopyUntilAnyDelimN/SkipClass3Chars pair, the empty-word early
 * return of 0, the overflow path that returns the previous word boundary when
 * the word would fit on a line of its own, the character-at-a-time shrink loop
 * that trims a too-long word until it fits, the drawFlag gating that skips only
 * the Text calls while still advancing the width accounting, and the inter-word
 * spacer handling.
 *
 * QUIRK in the original, deliberately not reproduced: when the input pointer is
 * null the function branches straight to the epilogue with D0 never set, so it
 * returns whatever happened to be in D0 -- here the leftovers of the Move call.
 * Every other exit sets D0 explicitly. This looks like a genuine bug in the
 * original rather than an idiom, and the C says `return cursor` (which is null on
 * that path), costing a MOVEQ #0 we do not otherwise need. Reproducing an
 * uninitialised return would require deliberately writing undefined behaviour.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffb0                   LINK.W A5,#-80
 *   got:     9efc0048                   SUBA.W #72,A7
 *   summary: The A5-frame class. With six frame slots the original spills
 *            constantly; SAS/C keeps most of them in registers, which is why this
 *            comes out 18 bytes smaller.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls.
 */
#include "esq-graphics.h"
#include <string.h>

extern char *STR_SkipClass3Chars(char *s);
extern char *STR_CopyUntilAnyDelimN(char *src, char *dst, long max, char *delims);
extern char Global_STR_SINGLE_SPACE[];
extern char NEWGRID_WrapWordSpacer[];
extern char NEWGRID_WrapReturnSpacer[];

char *NEWGRID_DrawWrappedText(struct RastPort *rp, long x, long y, long maxWidth,
                              char *text, long drawFlag)
{
    char word[50];
    long spaceWidth;
    long usedWidth = 0;
    long trimLen = 0;
    long wordWidth;
    char *cursor;
    char *wordStart;

    if (text)
        cursor = STR_SkipClass3Chars(text);
    else
        cursor = 0;
    wordStart = cursor;

    spaceWidth = TextLength(rp, Global_STR_SINGLE_SPACE, 1L);
    Move(rp, x, y);

    while (cursor) {
        cursor = STR_CopyUntilAnyDelimN(cursor, word, 50, NEWGRID_WrapWordSpacer);
        cursor = STR_SkipClass3Chars(cursor);
        if (word[0] == 0)
            return 0;

        wordWidth = TextLength(rp, word, (long)strlen(word));
        if (wordWidth > maxWidth - usedWidth) {
            if (wordWidth <= maxWidth)
                return wordStart;
            trimLen = (long)strlen(word) - 1;
            while (trimLen > 0 &&
                   TextLength(rp, word, trimLen) > maxWidth - usedWidth)
                trimLen--;
            if (trimLen > 0 && drawFlag)
                Text(rp, word, trimLen);
            return wordStart + trimLen;
        }

        if (drawFlag)
            Text(rp, word, (long)strlen(word));
        usedWidth += wordWidth;
        wordStart = cursor;

        if (*cursor == 0)
            continue;
        if (spaceWidth + usedWidth > maxWidth)
            return wordStart;
        if (drawFlag)
            Text(rp, NEWGRID_WrapReturnSpacer, 1L);
        usedWidth += spaceWidth;
    }
    return cursor;
}
