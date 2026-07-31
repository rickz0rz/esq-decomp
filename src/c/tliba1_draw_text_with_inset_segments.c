/* RESTORES: _TLIBA1_DrawTextWithInsetSegments
 * MODULE:   modules/groups/b/a/tliba1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-locals
 *   ref:     4e55ffec48e70730266d00082e2d000c2c2d00101a2d0017246d001c42adfff0200a673c4a126738204a4a1866fc538891ca200852802b40ffec2f3c000100012f00487807324879000077464eba3ad84fef00102b40fff0204a224012d866fc4aadfff06700010a206dfff0487800132f082b48fff44eba4284504f2b40fff8224b200722062c79000028584eaeff104aadfff867000096206dfff4487800142f082b48fffc4eba4254504f2b40fff44aadfff8670c7200206dfff810c12b48fff84a806708204042182b48fff44aadfffc6724206dfffc4a10671c4a1866fc538891edfffc224b2008206dfffc2c79000028584eaeffc4700010057200122d001b2f2dfff82f012f002f0b4ebacff64fef0010487800132f2dfff44eba41de504f2b40fff84a806600ff6e4aadfff46724206dfff44a10671c4a1866fc538891edfff4224b2008206dfff42c79000028584eaeffc42f2dffec2f2dfff04878075d4879000077504eba39ec4fef00104cdf0ce04e5d4e75
 *   got:     9efc001448e707361a2f00432c2f003c2e2f0038266f00482a6f003495ca200b673a4a136736204b4a1866fc538891cb200852802f3c000100012f00487807324879000000002f4000306100000024404fef0010204b224a12d866fc200a670001022f4a002c487800132f0a61000000504f2f400028224d200722062c79000000004eaeff104aaf002867000092206f002c487800142f082f48002c61000000504f2f40002c202f00286708204042182f480028202f002c6708204042182f48002c202f0024672620404a10672022084a1866fc538891c12f48001c2040224d202f001c2c79000000004eaeffc4700010057200122f00472f2f00282f012f002f0d61000000487800132f2f0040610000004fef00182f4000286000ff6a202f002c672620404a10672022084a1866fc538891c12f48001c2040224d202f001c2c79000000004eaeffc42f2f00202f0a4878075d487900000000610000004fef00104cdf6ce0defc00144e75
 *   summary: 364 got vs 376 ref, twelve bytes short. The original keeps the working copy, the cursor, the mark and the segment pointer at negative A5 displacements and reloads each before use; 6.51 keeps them in address registers across the loop. The allocate-and-copy of the source text, the two FindCharPtr probes on 19 and 20, the in-place NUL writes with their pointer advance, both Text calls with inlined strlen, the four-argument inset draw and the matching deallocate all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern char Global_STR_TLIBA1_C_1[];
extern char Global_STR_TLIBA1_C_2[];

extern char *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, char *ptr, long size);
extern char *STR_FindCharPtr(char *s, long c);
extern void  SCRIPT_DrawInsetTextWithFrame(struct RastPort *rp, long secondary,
                                           long primary, char *text);

void TLIBA1_DrawTextWithInsetSegments(struct RastPort *rp, long x, long y,
                                      unsigned char secondary,
                                      unsigned char primary, char *text)
{
    char *copy;
    char *cursor;
    char *mark;
    char *seg;
    long  size;

    copy = 0;
    if (text != 0 && *text != 0) {
        size = strlen(text) + 1;
        copy = MEMORY_AllocateMemory(Global_STR_TLIBA1_C_1, 1842, size,
                                     MEMF_PUBLIC + MEMF_CLEAR);
        strcpy(copy, text);
    }
    if (copy == 0)
        return;

    cursor = copy;
    mark = STR_FindCharPtr(copy, 19);
    Move(rp, x, y);

    while (mark != 0) {
        seg = cursor;
        cursor = STR_FindCharPtr(cursor, 20);
        if (mark != 0)
            *mark++ = 0;
        if (cursor != 0)
            *cursor++ = 0;
        if (seg != 0 && *seg != 0)
            Text(rp, seg, strlen(seg));
        SCRIPT_DrawInsetTextWithFrame(rp, (long)secondary, (long)primary, mark);
        mark = STR_FindCharPtr(cursor, 19);
    }

    if (cursor != 0 && *cursor != 0)
        Text(rp, cursor, strlen(cursor));

    MEMORY_DeallocateMemory(Global_STR_TLIBA1_C_2, 1885, copy, size);
}
