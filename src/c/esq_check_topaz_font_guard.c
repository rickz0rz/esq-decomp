/* RESTORES: ESQ_CheckTopazFontGuard
 * MODULE:   modules/groups/_main/b/bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffe048e73f0020790000285c2b680038fffc206dfffc41e800b82b48fff87002b02800056600016e20790000285c2b680034fff4302800147221b041620000c8487800fa4eba01c4584f206dfffc41e80054224870022c79000028584eaefeaa206dfffc41e80054224870002200243c0000027f763846034eaefece206dfffc41e80054224870014eaefeaa206dfffc41e800542248701472644eaeff10206dfffc41e80054224841f90000000070114eaeffc4206dfffc41e800542248701472714eaeff10206dfffc41e80054224841f900000012701a4eaeffc4206dfffc41e8005422487014727e4eaeff10206dfffc41e80054224841f90000002e702f4eaeffc460fe206dfffc3e28000e48c7206dfff43028000a48c07232928070002c790000285c4eaefee0487800644eba00da584f7032206dfffc3140000e206dfff831400002117c000100052c2800082a28000c42a8000c2806068400000fa02007223c000002804eba00ace6882205d2802b41ffe02c790000285c4eaefe802044202dffe0908422482c7800044eaeff2e60124879000000604eba007442974eba007a584f4cdf00fc4e5d4e75
 *   got:     594f48e73f36207900000000d0fc00382a5047ed00b87002b02b0005671648790000000061000000429761000000584f6000017e207900000000d0fc00342450207900000000302800147221b041620000d4487800fa61000000584f41ed005422482c790000000070024eaefeaa41ed005422482c790000000070002200243c0000027f763846034eaefece41ed005422482c790000000070014eaefeaa41ed005422482c7900000000701472644eaeff1041ed0054224841f9000000002c790000000070114eaeffc441ed005422482c7900000000701472714eaeff1041ed0054224841f9000000002c7900000000701a4eaeffc441ed005422482c79000000007014727e4eaeff1041ed0054224841f9000000002c7900000000702f4eaeffc460fe41ed000e3e1048c741ea000a301048c072329280204a2c790000000070004eaefee0487800646100000041ed000e7032308041eb00023080177c0001000541eb00082c1041eb000c2a1042902006068000000fa0487802802f072f40003461000000e6802805d8802c79000000004eaefe80206f0034200490af003422482c79000000004eaeff2e4fef000c4cdf6cfc584f4e75
 *   summary: 440 got vs 432 ref, eight bytes over. The intuition base now has a C-visible name: src/data/esq.s gains an _IntuitionBase label beside _Global_REF_INTUITION_LIBRARY, the same arrangement _GfxBase, _DOSBase and _DiskfontBase already use, and src/c/esq-intuition.h wraps the pragmas with a volatile base. A label emits no bytes, so both gates stay green. The excess is that volatile base reloading before SizeWindow and RemakeDisplay where the original loads it once. The re-run guard on the view byte, the version test at 33, the standby lockup with its three text lines and its infinite loop, the window resize to 50, the raster pointer capture and the FreeMem of the tail all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <graphics/rastport.h>
#include <intuition/intuition.h>
#include "esq-graphics.h"
#include "esq-intuition.h"
#include "esq-exec.h"

extern char Global_STR_PLEASE_STANDBY_1[];
extern char Global_STR_ATTENTION_SYSTEM_ENGINEER_1[];
extern char Global_STR_REPORT_CODE_ER003[];
extern char Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE[];

extern void DOS_Delay(long ticks);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void STREAM_BufferedWriteString(char *text);
extern void BUFFER_FlushAllAndCloseWithCode(long code);

void ESQ_CheckTopazFontGuard(void)
{
    char *screen;
    char *view;
    struct Window *window;
    long  height;
    long  base;
    long  raster;
    long  limit;
    long  top;

    screen = *(char **)((char *)IntuitionBase + 0x38);
    view = screen + 0xb8;

    if (view[5] != 2) {
        STREAM_BufferedWriteString(
            Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE);
        BUFFER_FlushAllAndCloseWithCode(0);
        return;
    }

    window = *(struct Window **)((char *)IntuitionBase + 0x34);

    if (((struct Library *)IntuitionBase)->lib_Version <= 33) {
        DOS_Delay(250);

        SetAPen((struct RastPort *)(screen + 0x54), 2);
        RectFill((struct RastPort *)(screen + 0x54), 0, 0, 639, 199);
        SetAPen((struct RastPort *)(screen + 0x54), 1);

        Move((struct RastPort *)(screen + 0x54), 20, 100);
        Text((struct RastPort *)(screen + 0x54), Global_STR_PLEASE_STANDBY_1, 17);
        Move((struct RastPort *)(screen + 0x54), 20, 113);
        Text((struct RastPort *)(screen + 0x54),
             Global_STR_ATTENTION_SYSTEM_ENGINEER_1, 26);
        Move((struct RastPort *)(screen + 0x54), 20, 126);
        Text((struct RastPort *)(screen + 0x54), Global_STR_REPORT_CODE_ER003, 47);

        for (;;)
            ;
    }

    height = *(short *)(screen + 14);
    SizeWindow(window, 0, 50 - (long)*(short *)((char *)window + 10));
    DOS_Delay(100);

    *(short *)(screen + 14) = 50;
    *(short *)(view + 2) = 50;
    view[5] = 1;

    base = *(long *)(view + 8);
    raster = *(long *)(view + 12);
    *(long *)(view + 12) = 0;

    top = base + 4000;
    limit = raster + (MATH_Mulu32(height, 640) >> 3);

    RemakeDisplay();
    FreeMem((void *)top, limit - top);
}
