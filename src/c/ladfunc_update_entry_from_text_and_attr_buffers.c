/* RESTORES: LADFUNC_UpdateEntryFromTextAndAttrBuffers
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: table-index-rematerialisation
 *   ref:     4e55fff848e703322e2f0024266f0028246f002c2f0a2f0b6100fcca504f2007e58041f900009fc42248d3c04a91664ed1c02f3c000100014878000e48780552487900006a8e2f4800244eba26604fef0010206f001420802007e58041f900009fc42248d3c04a9167142248d3c02c5172003c812248d3c02c513d4100022007e5802248d3c04a91670001082248d3c02c514aae00066716d1c02250206900064a1866fc538891e900062c0860027c002007e58041f900009fc42248d3c02c51d1c022502f2900062f0b2f4e00204eba823c504f206f0018214000064a8667362007e58041f900009fc42248d3c02c514aae000a67202007e580d1c022502f062f29000a4878056a487900006a984eba25844fef00102007e58041f900009fc4d1c02250206900064a1866fc538891e900062c082007e58041f900009fc4d1c022502f3c000100012f064878056d487900006aa22f4900244eba25524fef0010206f00142140000a2007e58041f900009fc42248d3c02c514aae000a6714d1c022502006204a2c69000a60021cd8538064fa
 *   got:     594f48e703342e2f001c266f00242a6f00202f0b2f0d61000000504f2007e58041f9000000002248d3c04a91664cd1c02f3c000100014878000e487805524879000000002f480024610000004fef0010206f001420802007e58041f9000000002248d3c04a9167122248d3c0245142522248d3c02451426a00022007e5802248d3c04a91670001082007e5802248d3c024514aaa00046716d1c022502069000420084a1866fc538891c02c0860027c002007e58041f9000000002248d3c02451d1c022502f2900042f0d61000000504f254000044a8667362007e58041f9000000002248d3c024514aaa000867202007e580d1c022502f062f2900084878056a487900000000610000004fef00102007e58041f900000000d1c022502069000420084a1866fc538891c02c082007e58041f900000000d1c022502f3c000100012f064878056d4879000000002f490024610000004fef0010206f0014214000082007e58041f9000000002248d3c024514aaa000867182007e580d1c022502006204b24690008600214d8538064fa4cdf2cc0584f4e754e71
 *   summary: 408 got vs 402 ref, and the reference stops at LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return so the epilogue is not counted. The original rebuilds the scaled table index and reloads the entry pointer before nearly every field access -- fourteen sites -- and 6.51 does the same but reaches the field through a different register pair at three of them. The lazy 14-byte record allocation with its two word clears, the length capture before the string replace, the conditional attribute-buffer free, the reallocation sized from the new text and the trailing byte copy all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LadEntry {
    short  flags0;              /* +0 */
    short  flags2;              /* +2 */
    char  *text;                /* +6 */
    char  *attr;                /* +10 */
};                              /* 14 bytes */

extern struct LadEntry *LADFUNC_EntryPtrTable[];

extern void  LADFUNC_RepackEntryTextAndAttrBuffers(char *text, char *attr);
extern char *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    char *ptr, long size);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);

void LADFUNC_UpdateEntryFromTextAndAttrBuffers(long index, char *text,
                                               char *attr)
{
    long len;

    LADFUNC_RepackEntryTextAndAttrBuffers(text, attr);

    if (LADFUNC_EntryPtrTable[index] == 0) {
        LADFUNC_EntryPtrTable[index] = (struct LadEntry *)
            MEMORY_AllocateMemory("LADFUNC.c", 1362,
                14, MEMF_PUBLIC + MEMF_CLEAR);
        if (LADFUNC_EntryPtrTable[index] != 0) {
            LADFUNC_EntryPtrTable[index]->flags0 = 0;
            LADFUNC_EntryPtrTable[index]->flags2 = 0;
        }
    }

    if (LADFUNC_EntryPtrTable[index] == 0)
        return;

    if (LADFUNC_EntryPtrTable[index]->text != 0)
        len = strlen(LADFUNC_EntryPtrTable[index]->text);
    else
        len = 0;

    LADFUNC_EntryPtrTable[index]->text = ESQPARS_ReplaceOwnedString(text,
        LADFUNC_EntryPtrTable[index]->text);

    if (len != 0 && LADFUNC_EntryPtrTable[index]->attr != 0)
        MEMORY_DeallocateMemory("LADFUNC.c", 1386,
            LADFUNC_EntryPtrTable[index]->attr, len);

    len = strlen(LADFUNC_EntryPtrTable[index]->text);
    LADFUNC_EntryPtrTable[index]->attr =
        MEMORY_AllocateMemory("LADFUNC.c", 1389, len,
            MEMF_PUBLIC + MEMF_CLEAR);

    if (LADFUNC_EntryPtrTable[index]->attr == 0)
        return;

    memcpy(LADFUNC_EntryPtrTable[index]->attr, attr, len);
}
