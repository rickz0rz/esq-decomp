/* RESTORES: _NEWGRID_DrawGridCellText
 * MODULE:   modules/groups/b/a/newgrid1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffdc48e73f30266d0008246d000c2e2d00144a79000029646730206d001043edffe612d866fc1b7c002dffe8422dffe9206d001054882f08486dffe64eba75a0504f41edffe62b480010700030390000b40a4a806a025280e2802a00722ada81700030390000b40822004a816a025281e281206b003474003428001a928259814a816a025281e28174003428001ad28228015684720032004a816a025281e2814a876628740034004a826a025282e28276003628001a94834a826a025282e28276003628001ad48353826028740034004a826a025282e28270003028001a948059824a826a025282e28270003028001ad4805382d28248ed0002fff07005b0b900006c206614224b20390000a9c22c79000028584eaefeaa600e224b70032c79000028584eaefeaa224b70004eaefe9e204a4a1866fc538891ca20084a806f66204a4a1866fc538891ca2c084a866f0c7020b03268ff6604538660f0224b204a20062c79000028584eaeffca4a806a025280e280220592801039000005f17453b002660420046004202dfff02f400024224b2001222f00244eaeff10224b204a20064eaeffc4206d00104a1866fc538891ed001020084a806f72206d00104a1866fc538891ed00102c084a866f107020206d0010b03068ff6604538660ec224b2006206d00102c79000028584eaeffca4a806a025280e280220592801039000005f17453b0026606202dfff0600220042f400024224b2001222f00244eaeff10224b2006206d00104eaeffc44cdf0cfc4e5d4e75
 *   got:     9efc002c48e737362e2f0060246f005c266f00582a6f00543039000000006728204a43ef002612d866fc1f7c002d0028422f002941ea00022f08486f002a61000000504f45ef002670003039000000004a806a025280e2802c00722adc81700030390000000022006a025281e281206d003474003428001a928259814a816a025281e28174003428001ad2822a0156854a87663a720032004a816a025281e281740034004a826a025282e28276003628001a94834a826a025282e28276003628001ad483d28253812f41004c603a720032004a816a025281e281740034004a826a025282e28270003028001a948059824a826a025282e28270003028001ad480d28253812f41004c7005b0b9000000006614224d2039000000002c79000000004eaefeaa600e224d2c790000000070034eaefeaa224d2c790000000070004eaefe9e204b4a1866fc538891cb20084a806f000088204b4a1866fc538891cb2f480048202f00484a806f0e7220b23308ff660653af004860ea224d204b202f00482c79000000004eaeffca48c04a806a025280e280220692801039000000002f4100447453b00266062f4500406008202f004c2f4000402001224d222f00402c79000000004eaeff10224d204b202f00482c79000000004eaeffc4204a4a1866fc538891ca20084a806f000088204a4a1866fc538891ca2f480048202f00484a806f0e7220b23208ff660653af004860ea224d204a202f00482c79000000004eaeffca48c04a806a025280e280220692801039000000002f4100447453b00266082f6f004c0040600620052f4000402001224d222f00402c79000000004eaeff10224d204a202f00482c79000000004eaeffc44cdf6cecdefc002c4e75
 *   summary: 636 got vs 566 ref. The original loads the graphics base four times and reuses A6 for the calls that follow each load; esq-graphics.h reloads before all eleven library calls, which is most of the excess, and 6.51 also spills the two baselines to A7 rather than holding them in D4 and D5. Computing the centred x once and choosing the y in a separate if was worth 56 bytes on its own -- written as two full Move calls, TextLength is emitted twice per block. The RAVESC hyphen splice, the sample-width centre, both font-baseline vertical formulas selected by the right-align flag, the operation-5 pen override, the two trailing-space trims and the 83-character axis swap between the two text blocks match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <string.h>
#include "esq-graphics.h"

extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern unsigned short NEWGRID_SampleTimeTextWidthPx;
extern unsigned short NEWGRID_RowHeightPx;
extern long NEWGRID_GridOperationId;
extern long GCOMMAND_NicheTextPen;
extern unsigned char CTASKS_STR_C;

extern void STRING_AppendAtNull(char *dst, char *src);

void NEWGRID_DrawGridCellText(struct RastPort *rp, char *primary,
                              char *secondary, long rightAlign)
{
    char merged[26];
    long centreX;
    long baseY;
    long altY;
    long len;
    long x;
    long y;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
        strcpy(merged, secondary);
        merged[2] = '-';
        merged[3] = 0;
        STRING_AppendAtNull(merged, secondary + 2);
        secondary = merged;
    }

    centreX = (long)NEWGRID_SampleTimeTextWidthPx / 2 + 42;

    baseY = ((long)NEWGRID_RowHeightPx / 2 - rp->Font->tf_Baseline - 4) / 2
          + rp->Font->tf_Baseline + 3;

    if (rightAlign == 0)
        altY = (long)NEWGRID_RowHeightPx / 2
             + (((long)NEWGRID_RowHeightPx / 2 - rp->Font->tf_Baseline) / 2
                + rp->Font->tf_Baseline - 1);
    else
        altY = (long)NEWGRID_RowHeightPx / 2
             + (((long)NEWGRID_RowHeightPx / 2 - rp->Font->tf_Baseline - 4) / 2
                + rp->Font->tf_Baseline - 1);

    if (NEWGRID_GridOperationId == 5)
        SetAPen(rp, GCOMMAND_NicheTextPen);
    else
        SetAPen(rp, 3);
    SetDrMd(rp, 0);

    if ((long)strlen(primary) > 0) {
        len = strlen(primary);
        while (len > 0 && primary[len - 1] == ' ')
            len--;
        x = centreX - TextLength(rp, primary, len) / 2;
        if (CTASKS_STR_C == 'S')
            y = baseY;
        else
            y = altY;
        Move(rp, x, y);
        Text(rp, primary, len);
    }

    if ((long)strlen(secondary) > 0) {
        len = strlen(secondary);
        while (len > 0 && secondary[len - 1] == ' ')
            len--;
        x = centreX - TextLength(rp, secondary, len) / 2;
        if (CTASKS_STR_C == 'S')
            y = altY;
        else
            y = baseY;
        Move(rp, x, y);
        Text(rp, secondary, len);
    }
}
