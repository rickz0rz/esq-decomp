/* RESTORES: LADFUNC_LoadTextAdsFromFile
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-cursor
 *   ref:     4e55ffd848e72f0048780001487800026100105e4879000069441b40ffe34eba22304fef000c5280660670ff600002182c39000080002b7900008004fff46100f81e7e00702ebe806c0001e22007e58041f900009fc4d1c02b50fffc4eba21ce206dfffc30804eba21c4206dfffc314000024eba21b220404a1866fc538891c028082b40ffde2b40fff84a846f1a206dffde4a1067127003b0106606578454adffde52adffde60e24a846f000110200452802f3c000100012f004878024f4879000069cc4eba34bc4fef0010206dfffc214000064a80660670ff6000016a2f3c000100012f04487802584879000069d64eba34904fef0010206dfffc2140000a660670ff600001407a002b6dfff8ffdeba846c000098206dffde4a106700008e10107203b001666452adffde206dffde1018488048c02f002b48ffde6100fa42720012007000102dffe32e802f0161000f442b6dffdeffde72001200206dffde1410488248c22e821b40ffe32f41001c6100fa0e720012002e812f2f001c61000f384fef000c1b40ffe36018226dfffc20690006d1c510802069000ad1c5528510adffe352adffde6000ff66226dfffc206900062248d3c54211606a206dfffc4aa800066760226dfffc206900064a1866fc538891e900062808200452802f002f2900064878027e4879000069e04eba337a4fef001091c8226dfffc234800064aa9000a67202f042f29000a487802824879000069ea4eba33524fef0010206dfffc42a8000a52876000fe1a200652802f002f2dfff44878028d4879000069f44eba332870004ced00f4ffc44e5d4e75
 *   got:     9efc000c48e70f344878000148780002610000002e00487900000000610000004fef000c5280660670ff600001b22c3900000000267900000000610000007a00702eba806c00017c2005e58041f900000000d1c02a50610000003a80610000003b400002610000002440204a4a1866fc538891ca28082f4a00244a846f101012670c570066045784548a528a60ec4a846f0000d8200452802f3c000100012f004878024f487900000000610000002b4000044fef0010660670ff600001222f3c000100012f0448780258487900000000610000002b4000084fef0010660670ff600000fc42af0020246f0024202f0020b0846c681012676457006642528a101a488048c02f0061000000720012072e812f00610000002e00700010071212488148c12e812f400024610000002e802f2f0024610000004fef000c2e00601a202f0020206d0004d1c01092206d0008d1c01207108152af0020528a6090206d00042248d3ef002042116052202d0004674c204022084a1866fc538891c12808200452802f002f014878027e487900000000610000004fef001042ad0004202d0008671a2f042f0048780282487900000000610000004fef001042ad000852856000fe80200652802f002f0b4878028d487900000000610000004fef001070004cdf2cf0defc000c4e75
 *   summary: 488 got vs 592 ref, 104 bytes short, and the deficit is one variable. The original keeps the decode cursor in an A5 frame slot and rebuilds MOVEA.L -34(A5),A0 before every read and MOVE.L A0,-34(A5) after every advance -- fourteen sites at four to six bytes each, including one dead MOVE.L -34(A5),-34(A5); 6.51 holds it in an address register across each scan. The entry pointer is reloaded the same way, eight more sites. The two parsed word fields, the escape-aware length measurement that subtracts three per colour marker, both allocations with their distinct source line numbers, the decode loop that folds a high and a low nibble into the running pen, the terminating NUL, the free-existing-buffers path with its two deallocations and the closing work-buffer release all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LadEntry {
    short  flags0;
    short  flags2;
    char  *text;                /* +6 */
    char  *attr;                /* +10 */
};

extern struct LadEntry *LADFUNC_EntryPtrTable[];
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern char  KYBD_PATH_DF0_LOCAL_ADS[];

extern long  LADFUNC_ComposePackedPenByte(long hi, long lo);
extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern void  LADFUNC_ResetEntryTextBuffers(void);
extern long  DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern char *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    char *ptr, long size);
extern long  LADFUNC_ParseHexDigit(long c);
extern long  LADFUNC_SetPackedPenHighNibble(long nibble, long pen);
extern long  LADFUNC_SetPackedPenLowNibble(long pen, long nibble);

long LADFUNC_LoadTextAdsFromFile(void)
{
    struct LadEntry *entry;
    char *buf;
    char *cursor;
    char *start;
    unsigned char pen;
    long  size;
    long  row;
    long  len;
    long  pos;

    pen = LADFUNC_ComposePackedPenByte(2, 1);

    if (DISKIO_LoadFileToWorkBuffer(KYBD_PATH_DF0_LOCAL_ADS) == -1)
        return -1;

    size = Global_REF_LONG_FILE_SCRATCH;
    buf = Global_PTR_WORK_BUFFER;
    LADFUNC_ResetEntryTextBuffers();

    row = 0;
    while (row < 46) {
        entry = LADFUNC_EntryPtrTable[row];
        entry->flags0 = DISKIO_ParseLongFromWorkBuffer();
        entry->flags2 = DISKIO_ParseLongFromWorkBuffer();

        cursor = DISKIO_ConsumeCStringFromWorkBuffer();
        len = strlen(cursor);
        start = cursor;

        while (len > 0 && *cursor != 0) {
            if (*cursor == 3) {
                len -= 3;
                cursor += 2;
            }
            cursor++;
        }

        if (len > 0) {
            entry->text = MEMORY_AllocateMemory(
                "LADFUNC.c", 591, len + 1, MEMF_PUBLIC + MEMF_CLEAR);
            if (entry->text == 0)
                return -1;

            entry->attr = MEMORY_AllocateMemory(
                "LADFUNC.c", 600, len, MEMF_PUBLIC + MEMF_CLEAR);
            if (entry->attr == 0)
                return -1;

            pos = 0;
            cursor = start;
            while (pos < len && *cursor != 0) {
                if (*cursor == 3) {
                    cursor++;
                    pen = LADFUNC_SetPackedPenHighNibble(
                              LADFUNC_ParseHexDigit((long)*cursor++), (long)pen);
                    pen = LADFUNC_SetPackedPenLowNibble((long)pen,
                              LADFUNC_ParseHexDigit((long)*cursor));
                } else {
                    entry->text[pos] = *cursor;
                    entry->attr[pos] = pen;
                    pos++;
                }
                cursor++;
            }
            entry->text[pos] = 0;
        } else if (entry->text != 0) {
            len = strlen(entry->text);
            MEMORY_DeallocateMemory("LADFUNC.c", 638,
                                                   entry->text, len + 1);
            entry->text = 0;
            if (entry->attr != 0) {
                MEMORY_DeallocateMemory("LADFUNC.c",
                                                       642, entry->attr, len);
                entry->attr = 0;
            }
        }
        row++;
    }

    MEMORY_DeallocateMemory("LADFUNC.c", 653, buf,
                                           size + 1);
    return 0;
}
