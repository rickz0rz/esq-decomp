/* RESTORES: TLIBA3_DrawCenteredWrappedTextLines
 * MODULE:   modules/groups/b/a/tliba3_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffec48e70730266d0008246d000c2e2d0010422dffee1b6b001cfff11b6b0019fff01b6b001affef1b6b0018fff2206b00041b680005fff3224b70012c79000028584eaefe9e224b70014eaefeaa224b70074eaefea4206b00047a003a10e785204a4a1866fc538891ca2b48fff4202dfff44a806f24224b204a2c79000028584eaeffca220592804a816a025281e2812c016c0653adfff460d44a2dffee67047000600c202dfff410320800488048c0222dfff4423218001b40ffee4a866b102f0a2f072f062f0b4eba23244fef0010206b00347000302800145280de80204ad1edfff410adffee24484a126600ff72102dfff0488048c0224b2c79000028584eaefeaa102dffef488048c0224b4eaefea4102dfff1488048c0224b4eaefe9e176dfff20018206b0004116dfff300054cdf0ce04e5d4e75
 *   got:     9efc001448e707162e2f0038266f00342a6f00307c001a2d001c1f6d001900281f6d001a001f102d0018206d0004122800051f40001e1f41001d224d2c790000000070014eaefe9e224d2c790000000070014eaefeaa224d2c790000000070074eaefea4206d000430104840424048402200e7812f410024204b4a1866fc538891cb2f480018202f00184a806f2c224d204b2c79000000004eaeffca48c0222f002492804a816a025281e28148ef000200206c0653af001860cc4a066706422f001c600c202f0018103308001f40001c202f0018423308001c2f001c202f00204a806b102f0b2f072f002f0d610000004fef0010206d00347000302800145280de80d7ef001816864a136600ff6c102f0028488048c0224d2c79000000004eaefeaa102f001f488048c0224d2c79000000004eaefea41005488048c0224d2c79000000004eaefe9e102f001e1b400018206d0004102f001d114000054cdf68e0defc00144e754e71
 *   summary: 360 got vs 314 ref. The original loads the graphics base three times -- once for the opening pen block, once inside the measure loop, once for the restore block -- and reuses A6 for the calls that follow each load. esq-graphics.h forces a reload before every one of the eight library calls, +18, and esq-graphics-leaf.h is NOT usable because DISPLIB_DisplayTextAtPosition sits between the measure loop and the restore block. 6.51 also sign-extends the WORD from TextLength and addresses ten frame slots from A7 where the original uses A5. The saved pen/mode/mask/depth set, the shrink-to-fit loop, the temporary NUL with its restore, the font-height advance and the outer wrap loop all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <graphics/text.h>
#include <string.h>
#include "esq-graphics.h"

extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(struct RastPort *rp,
                long x, long y, char *text);

void TLIBA3_DrawCenteredWrappedTextLines(struct RastPort *rp, char *text, long y)
{
    char savedChar;
    char savedDrMd;
    char savedFgPen;
    char savedBgPen;
    char savedMask;
    char savedDepth;
    char c;
    long len;
    long width;
    long x;

    savedChar  = 0;
    savedDrMd  = rp->DrawMode;
    savedFgPen = rp->FgPen;
    savedBgPen = rp->BgPen;
    savedMask  = rp->Mask;
    savedDepth = rp->BitMap->Depth;

    SetDrMd(rp, 1);
    SetAPen(rp, 1);
    SetBPen(rp, 7);

    width = rp->BitMap->BytesPerRow * 8;

    do {
        len = strlen(text);
        while (len > 0) {
            x = (width - TextLength(rp, text, len)) / 2;
            if (x >= 0)
                break;
            len--;
        }

        if (savedChar != 0)
            c = 0;
        else
            c = text[len];
        text[len] = 0;
        savedChar = c;

        if (x >= 0)
            UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(rp, x, y, text);

        y += rp->Font->tf_YSize + 1;
        text += len;
        *text = savedChar;
    } while (*text != 0);

    SetAPen(rp, savedFgPen);
    SetBPen(rp, savedBgPen);
    SetDrMd(rp, savedDrMd);
    rp->Mask = savedMask;
    rp->BitMap->Depth = savedDepth;
}
