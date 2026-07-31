/* RESTORES: _NEWGRID_UpdatePresetEntry
 * MODULE:   modules/groups/b/a/newgrid1b_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dead-initial-reads
 *   ref:     4e55fff048e70f32266d0008246d000c3e2d00122c2d001478002b53fff42b52fff07030be406f06044700307801487800012f064eba54b0487800012f062b40fff44eba54784fef00102b40fff04aadfff4670000c24a80670000bc7201be416716487900009aa24eba549a584f534067064a84670000a04a39000087b7670000964ab900006c1c67602006e580207900006c1c2a3008004a856b3270003039000087b8ba806c26206dfff441e8000c2005e58043f900008c78d3c02c5143ee000c1018b01966064a0066f667282f2dfff04eba53d4584f2a002006e580207900006c1c21850800600c2f2dfff04eba53b8584f2a00487800022f054eba53e8487800022f052b40fff44eba53b04fef00102b40fff026adfff424adfff020074cdf4cf04e5d4e75
 *   got:     594f48e70f362c2f00343e2f0032266f002c2a6f00287a0024552f5300207030be406f06044700307a01487800012f06610000002440487800012f06610000004fef00102f400020200a670000bc4aaf0020670000b420075340671648790000000061000000584f534067064a85670000981039000000004a006700008c20390000000067582206e5812040d1c128104a846b2e7000303900000000b8806c2241ea000c2004e58043f900000000d3c02c51dcfc000c1018b01e66044a0066f667282f2f0020610000002800584f2006e580207900000000d1c02084600c2f2f0020610000002800584f487800022f04610000002440487800022f04610000004fef00102f4000202a8a26af002030074cdf6cf0584f4e75
 *   summary: 280 got vs 296 ref, sixteen bytes short. The original opens by copying both out-parameter slots into its frame locals and then overwrites both unconditionally, so those two loads are dead; C cannot express a dead read and 6.51 drops them. The 48-offset selector normalisation with its alt flag, the three-term gate on selector, half-hour slot and alt, the secondary-group present test, the cache probe with its range check and inlined strcmp, the rebuild path that writes the cache back, and the mode-2 re-fetch of both pointers match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern char  CLOCK_DaySlotIndex;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern long *NEWGRID_SecondaryIndexCachePtr;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern char *TEXTDISP_SecondaryEntryPtrTable[];

extern char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(long index, long kind);
extern char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(long index,
                                                              long kind);
extern short NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(char *daySlot);
extern long  NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(char *aux);

short NEWGRID_UpdatePresetEntry(char **outEntry, char **outAux, short sel,
                                long index)
{
    char *entry;
    char *aux;
    long  alt;
    long  cached;

    alt = 0;
    entry = *outEntry;
    aux   = *outAux;

    if (sel > 48) {
        sel -= 48;
        alt = 1;
    }

    entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(index, 1);
    aux   = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(index, 1);

    if (entry != 0 && aux != 0) {
        if (sel == 1
            || NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) == 1
            || alt != 0) {
            if (TEXTDISP_SecondaryGroupPresentFlag != 0) {
                if (NEWGRID_SecondaryIndexCachePtr != 0) {
                    cached = NEWGRID_SecondaryIndexCachePtr[index];
                    if (cached < 0
                        || cached >= (long)TEXTDISP_SecondaryGroupEntryCount
                        || strcmp(entry + 12,
                                  TEXTDISP_SecondaryEntryPtrTable[cached] + 12) != 0) {
                        cached = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
                        NEWGRID_SecondaryIndexCachePtr[index] = cached;
                    }
                } else {
                    cached = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
                }
                entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(cached, 2);
                aux   = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(cached, 2);
            }
        }
    }

    *outEntry = entry;
    *outAux = aux;
    return sel;
}
