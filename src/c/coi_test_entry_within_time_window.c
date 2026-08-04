/* RESTORES: COI_TestEntryWithinTimeWindow
 * MODULE:   modules/groups/a/e/coi_p4_coi_testentrywithintimewindow.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-shared-epilogue
 *   ref:     4e55ffe848e70730266d0008246d000c3e2d00122c2d00142a2d001870012b40fffc700091c82b40fff42b40fff82b48ffec2b48fff0200b67000104200a670000fe4a476f0000f84a476f247031be406c1e7000101348c0220748c12f012f0a2f004eba01784fef000c2b40fff86018200748c0720032390000a3089081721e4eba21622b40fff8082b0004001b6778206b00302b48fff0676842adffe8206dfff03028002448c0222dffe8b2806c26e581226dfff020690026d1c12b50ffec206dffec3010b0476602600a42adffec52adffe860c84aadffec670c206dffec2b68001afff4600c206dfff0202800202b40fff470ffb0adfff466242b45fff4601e2b45fff46018200748c02f002f0a6100fe28504f222dfff890812b40fff4202dfff44a806b0e222dfff8b2866e064480b2806c0e70002b40fffc600670002b40fffc
 *   got:     9efc001848e707342a2f00442c2f00403e2f003e266f00382a6f003470012f40002c700024402f4a0018721e2f41001c2f4000242f400028220d6708200b67044a476e067000600000ec4a476f227031be406c1c70001015320748c12f012f0b2f00610000004fef000c2f400028601a300748c032390000000048c19081222f001c610000002f400028082d0004001b676a246d0030200a675c42af0020302a002448c0222f0020b2806c222001e580206a0026d1c02f500018206f00183010b047670a42af001852af002060d04aaf0018670c206f00182f68001a00246008202a00202f40002470ffb0af002466242f450024601e2f4500246018300748c02f002f0b61000000504f222f002890812f400024202f00244a806b0e222f0028b2866e064480b2806c0670002f40002c202f002c4cdf2ce0defc00184e754e71
 *   summary: 320 got vs 324 ref, but the reference STOPS EARLY: the module gives the epilogue its own label COI_TestEntryWithinTimeWindow_Return, so refbytes.py extracts label to label and the MOVEM/UNLK/RTS is not counted. Add the eight bytes back and the true comparison is 320 against 332. The deficit is the guard block: the original routes all three null and range failures through the shared tail that clears the result flag, 6.51 returns 0 directly. The 30-minute slot scale is held in a local so it calls the 32x32 helper as the original does. The sub-record scan, the -1 fallback, and the three-term window test match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct CoiItem {
    short slot;                 /* +0 */
    char  pad2[24];
    long  value26;              /* +26 */
};

struct CoiSub {
    char             pad0[32];
    long             value32;   /* +32 */
    short            count36;   /* +36 */
    struct CoiItem **table38;   /* +38 */
};

#ifndef COIENTRY_DEFINED
#define COIENTRY_DEFINED
struct CoiEntry {
    unsigned char  kind;        /* +0 */
    char           pad1[26];
    unsigned char  flags27;     /* +27 */
    char           pad28[20];
    struct CoiSub *sub48;       /* +48 */
};
#endif

extern short CLOCK_HalfHourSlotIndex;

extern long TEXTDISP_ComputeTimeOffset(long kind, void *aux,
                                                       long slot);
extern long COI_ComputeEntryTimeDeltaMinutes(void *aux, long slot);

long COI_TestEntryWithinTimeWindow(struct CoiEntry *entry, void *aux,
                                   short slot, long window, long fallback)
{
    long result;
    long offs;
    long base;
    long k;
    long half;
    struct CoiSub  *sub;
    struct CoiItem *item;

    result = 1;
    base = offs = 0;
    item = sub = 0;
    half = 30;

    if (entry == 0 || aux == 0 || slot <= 0)
        return 0;

    if (slot > 0 && slot < 49)
        offs = TEXTDISP_ComputeTimeOffset((long)entry->kind,
                                                          aux, (long)slot);
    else
        offs = ((long)slot - CLOCK_HalfHourSlotIndex) * half;

    if (entry->flags27 & 0x10) {
        sub = entry->sub48;
        if (sub != 0) {
            k = 0;
            while (k < sub->count36) {
                item = sub->table38[k];
                if (item->slot == slot)
                    break;
                item = 0;
                k++;
            }
            if (item != 0)
                base = item->value26;
            else
                base = sub->value32;
            if (base == -1)
                base = fallback;
        } else {
            base = fallback;
        }
    } else {
        base = COI_ComputeEntryTimeDeltaMinutes(aux, (long)slot) - offs;
    }

    if (base < 0 || offs > window || offs < -base)
        result = 0;
    return result;
}
