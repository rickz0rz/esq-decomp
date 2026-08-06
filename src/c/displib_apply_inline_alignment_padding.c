/* RESTORES: DISPLIB_ApplyInlineAlignmentPadding
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: textlength-extension-and-a7-frame
 *   ref:     4e55ffe448e70f10266d00081e2d000f204b4a1866fc538891cb2a08204b20052279000087022c79000028584eaeffca223c0000027092802c014a866f0000de7018be00662c22790000870241f900001b3470014eaeffca2f4000142006222f00144ebae1da4a806a025280e2802800602c701abe00662422790000870241f900001b3670014eaeffca2f4000142006222f00144ebae1a82800600278004a84677a20055280487800012f00487800c2487900001b384ebae1c24fef00102b40fffc4a806756204b224012d866fc2b4bfff842adffe8202dffe8b0846c12206dfff810fc00202b48fff852adffe860e6206dfff842102f2dfffc2f0b4eba0c56200552802e802f2dfffc487800cc487900001b424ebae12e4fef0014
 *   got:     514f48e70f361e2f00332a6f002c204d4a1866fc538891cd2c08227900000000204d20062c79000000004eaeffca48c0724ee78992802a014a856f0000da7018be00663422790000000041f9000000002c790000000070014eaeffca48c02f4000202005222f0020610000004a806a025280e28028006034701abe00662c22790000000041f9000000002c790000000070014eaeffca48c02f4000202005222f0020610000002800600278004a84676620065280487800012f00487800c24879000000006100000026404a804fef00106744204d224b12d866fc244d42af0024202f0024b0846c0a14fc002052af002460ee42122f0b2f0d61000000200652802e8b2f00487800cc487900000000610000004fef00144cdf6cf0504f4e754e71
 *   summary: 288 got vs 284 ref, four bytes over. 6.51 sign-extends the WORD result of TextLength (48c0 EXT.L D0) where the original consumes D0 directly, and it builds 624 as MOVEQ #78 / ASL.L #3 where the original writes MOVE.L #624 -- the two nearly cancel. The rest is the frame register: SUBQ.W #8,A7 and A7 displacements against LINK.W A5,#-28. Both TextLength measurements, both MATH_DivS32 calls, the extra halving on the centre arm, the allocate/strcpy/space-fill/append/deallocate sequence and the pad==0 early return match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L

extern struct RastPort *Global_REF_RASTPORT_1;
extern char DISPLIB_STR_InlineAlignPadCharCenter[];
extern char DISPLIB_STR_InlineAlignPadCharRight[];

extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern char *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     long size, char *ptr);
extern void  STRING_AppendAtNull(char *dst, char *src);

void DISPLIB_ApplyInlineAlignmentPadding(char *buf, char mode)
{
    long  len;
    long  avail;
    long  pad;
    char *copy;
    char *p;
    long  i;

    len = strlen(buf);
    avail = 624 - TextLength(Global_REF_RASTPORT_1, buf, len);
    if (avail <= 0)
        return;

    if (mode == 24)
        pad = avail / TextLength(Global_REF_RASTPORT_1,
                                 DISPLIB_STR_InlineAlignPadCharCenter, 1) / 2;
    else if (mode == 26)
        pad = avail / TextLength(Global_REF_RASTPORT_1,
                                 DISPLIB_STR_InlineAlignPadCharRight, 1);
    else
        pad = 0;

    if (pad == 0)
        return;

    copy = MEMORY_AllocateMemory("DISPLIB.c", 194,
                                                 len + 1, MEMF_PUBLIC);
    if (copy == 0)
        return;

    strcpy(copy, buf);
    p = buf;
    for (i = 0; i < pad; i++)
        *p++ = ' ';
    *p = 0;

    STRING_AppendAtNull(buf, copy);
    MEMORY_DeallocateMemory("DISPLIB.c", 204,
                                            len + 1, copy);
}
