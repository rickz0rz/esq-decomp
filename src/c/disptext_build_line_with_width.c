/* RESTORES: DISPTEXT_BuildLineWithWidth
 * MODULE:   modules/groups/a/i/disptext_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload-and-a7-frame
 *   ref:     4e55ffb448e73f30266d0008246d000c2e2d0014224b41f900001b5c70012c79000028584eaeffca206d001042102b40fff0200a670001304a126700012abeadfff06f000122206d00104a106712487900001b5e2f084eba09c6504f9eadfff02f0a4eba09b424402b4affec487900001b6048780032486dffb72f0a4eba09a64fef0014244041edffb722484a1966fc538993c82c09224b20062c79000028584eaeffca2a00206dffec10107213b00166025085ba876f7a3439000080ce7602b443640824390000814c6002740026390000814896822803ba846f4cb0016700ff52ba876f1c4a866f185386224b200641edffb72c79000028584eaeffca2a0060e04a866f12423568b7486dffb72f2d00104eba090a504f206dffec2248d3c624497e006000ff0c246dffec7e006000ff02486dffb72f2d00104eba08e2504f9e857213206dffecb21057c04400488048c032390000815448c1828033c1000081546000fece4a12660295ca200a4cdf0cfc4e5d4e75
 *   got:     9efc005c48e73f362e2f0094246f0090266f008c2a6f0088224d41f9000000002c790000000070014eaeffca3c0048c64212200b670001484a1367000142be866f00013c4a12670e4879000000002f0a61000000504f9e862f0b6100000026402f4b008448790000000048780032486f00372f0b6100000026404fef001441ef002b22484a1966fc538993c82a09224d20052c79000000004eaeffca48c0206f0080121048ef0001007c1f41002a7413b202660450af007c202f007cb0876f00008a3639000000007802b644640a2f79000000000078600676002f43007826390000000096af007848ef00080074b0836e0826487e006000ff3ab2026700ff34202f007cb0876f204a856f1c5385224d41ef002b20052c79000000004eaeffca48c02f40007c60d84a856f104237582b486f002b2f0a61000000504f206f0080d1c526487e006000feea486f002b2f0a61000000504f9eaf007c7213206f0080b21057c04400488048c032390000000048c1828033c1000000006000feb64a13660297cb200b4cdf6cfcdefc005c4e75
 *   summary: 400 got vs 374 ref. The original loads the graphics base three times and reuses A6 across the calls that follow; esq-graphics.h reloads before each of the four TextLength calls, and the leaf header is not usable because STR_SkipClass3Chars and the append helper sit between them. The rest is the frame register. The space-width measurement, the separator append, the word extraction with its 50-character cap, the control-character bonus of eight pixels, the shrink loop, the three source-advance arms and the marker-flag OR all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

extern char DISPTEXT_STR_SINGLE_SPACE_MEASURE[];
extern char DISPTEXT_STR_SINGLE_SPACE_APPEND[];
extern char DISPTEXT_STR_SINGLE_SPACE_DELIM[];
extern unsigned short DISPTEXT_CurrentLineIndex;
extern long  DISPTEXT_ControlMarkerWidthPx;
extern long  DISPTEXT_LineWidthPx;
extern short DISPTEXT_ControlMarkersEnabledFlag;

extern void  STRING_AppendAtNull(char *dst, char *src);
extern char *STR_SkipClass3Chars(char *s);
extern char *STR_CopyUntilAnyDelimN(char *src, char *dst,
                                                    long max, char *delims);

char *DISPTEXT_BuildLineWithWidth(struct RastPort *rp, char *src, char *out,
                                  long width)
{
    char  word[73];
    char *start;
    long  spaceW;
    long  wlen;
    long  wpx;
    long  marker;
    long  avail;
    char  c;

    spaceW = TextLength(rp, DISPTEXT_STR_SINGLE_SPACE_MEASURE, 1);
    *out = 0;

    while (src != 0 && *src != 0 && width > spaceW) {
        if (*out != 0)
            STRING_AppendAtNull(out,
                DISPTEXT_STR_SINGLE_SPACE_APPEND);
        width -= spaceW;

        src = STR_SkipClass3Chars(src);
        start = src;
        src = STR_CopyUntilAnyDelimN(src, word, 50,
                  DISPTEXT_STR_SINGLE_SPACE_DELIM);

        wlen = strlen(word);
        wpx = TextLength(rp, word, wlen);
        c = *start;
        if (c == 19)
            wpx += 8;

        if (wpx > width) {
            if (DISPTEXT_CurrentLineIndex < 2)
                marker = DISPTEXT_ControlMarkerWidthPx;
            else
                marker = 0;
            avail = DISPTEXT_LineWidthPx - marker;

            if (wpx <= avail) {
                src = start;
                width = 0;
                continue;
            }
            if (c == 19)
                continue;

            while (wpx > width && wlen > 0) {
                wlen--;
                wpx = TextLength(rp, word, wlen);
            }
            if (wlen > 0) {
                word[wlen] = 0;
                STRING_AppendAtNull(out, word);
            }
            src = start + wlen;
            width = 0;
            continue;
        }

        STRING_AppendAtNull(out, word);
        width -= wpx;
        DISPTEXT_ControlMarkersEnabledFlag =
            DISPTEXT_ControlMarkersEnabledFlag | (*start == 19);
    }

    if (*src == 0)
        src = 0;
    return src;
}
