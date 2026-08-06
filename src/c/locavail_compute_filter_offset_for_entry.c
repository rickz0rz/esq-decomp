/* RESTORES: LOCAVAIL_ComputeFilterOffsetForEntry
 * MODULE:   modules/groups/a/y/locavail_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-truncated-reference
 *   ref:     4e55ffe448e70f30266d0008246d000c78ff70ff42adffe42b40ffec4ab900006ad066000160b0b900006ad8660001567e004a136700008c1013488048c02f006100ff18584f2a0042adffe87c004a856730bcaa00026c2a2006720a4eba1d36206a0014d1c02007528072001210b081660c2b680006ffe42b48ffe86004528660cc4a8567344aadffe8672e5385206dffe83028000448c0ba806c1e206dffe44a305800671470ffb8806616b0adffec661028062b45ffec60085287528b6000ff7270ffb880670000b2202dffec72ffb081670000a62004720a4eba1cb8206a0014d1c0226800067000222dffec103118002b48ffe82b49ffe45340670e53406736534067505340675e606670001039000028e22f00487900006b2a4ebac048504f4a8067084eba091c4a00664c78ff70ff2b40ffec60421039000028e1724eb00167084ab9000001b4662e78ff70ff2b40ffec60244a790000a344661c78ff70ff2b40ffec601278ff70ff2b40ffec600878ff70ff2b40ffec25440008256dffec000c
 *   got:     9efc001048e70734266f00302a6f002c700a2f4000187eff7cff42af00244ab9000000006600014e70ffb0b900000000660001427a00101567000096488048c02f0061000000584f95ca42af001c2f4000204aaf00206736202f001cb0ab00026c2c222f001861000000206b0014d1c024487000101222055281b28066082f6a00060024600895ca52af001c60c4202f00206734220a673053af0020302a000448c0222f0020b2806c1e206f00244a30180067142007528066162006528066102e2f001c2c0160085285528d6000ff6870ffbe8067000096bc80670000902007222f001861000000206b0014d1c02448206a000610306800720012002f4800245381670e538167325381674853816752605670001039000000002f0048790000000061000000504f4a806708610000004a0066387eff7cff6032103900000000724eb00167084ab900000000661e7eff7cff601830390000000066107eff7cff600a7eff7cff60047eff7cff274700082746000c4cdf2ce0defc00104e754e71
 *   summary: 384 got vs 388 ref, four bytes short, and the reference stops at LOCAVAIL_ComputeFilterOffsetForEntry_Return so the epilogue is not counted. The ten-byte record stride is held in a local so both index scalings call the 32x32 helper as the original does. The two entry guards, the per-character class lookup, the record scan keyed on index+1, the length and content test, the first-hit break, and all five arms of the chained-subtract dispatch on the record byte -- including the two that clear the result the same way -- match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct FilterRec {
    unsigned char id;           /* +0 */
    char          pad1[3];
    short         len;          /* +4 */
    char         *str;          /* +6 */
};                              /* the record stride is ten bytes */

struct FilterCtx {
    char  pad0[2];
    long  count;                /* +2 */
    char  pad6[2];
    long  bestIndex;            /* +8 */
    long  bestSub;              /* +12 */
    char  pad16[4];
    char *table;                /* +20 */
};

extern long  LOCAVAIL_FilterStep;
extern long  LOCAVAIL_FilterPrevClassId;
extern unsigned char ED_DiagVinModeChar;
extern unsigned char ED_DiagGraphModeChar;
extern long  ESQIFF_GAdsBrushListCount;
extern short WDISP_HighlightActive;
extern char  LOCAVAIL_STR_YYLLZ_FilterGateCheck[];

extern long  LOCAVAIL_MapFilterTokenCharToClass(long c);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern char *STR_FindCharPtr(char *s, long c);
extern char  SCRIPT_ReadHandshakeBit5Mask(void);

void LOCAVAIL_ComputeFilterOffsetForEntry(char *token, struct FilterCtx *ctx)
{
    struct FilterRec *slot;
    char *rec;
    long  best;
    long  bestSub;
    long  index;
    long  cls;
    long  k;
    long  stride;

    stride = 10;
    best = -1;
    bestSub = -1;
    rec = 0;

    if (LOCAVAIL_FilterStep != 0)
        return;
    if (LOCAVAIL_FilterPrevClassId != -1)
        return;

    index = 0;
    while (*token != 0) {
        cls = LOCAVAIL_MapFilterTokenCharToClass((long)*token);
        slot = 0;
        k = 0;
        while (cls != 0 && k < ctx->count) {
            slot = (struct FilterRec *)(ctx->table + k * stride);
            if (index + 1 == (long)slot->id) {
                rec = slot->str;
                break;
            }
            slot = 0;
            k++;
        }

        if (cls != 0 && slot != 0) {
            cls--;
            if (cls < (long)slot->len && rec[cls] != 0) {
                if (best == -1 && bestSub == -1) {
                    best = k;
                    bestSub = cls;
                }
                break;
            }
        }
        index++;
        token++;
    }

    if (best != -1 && bestSub != -1) {
        slot = (struct FilterRec *)(ctx->table + best * stride);
        rec = slot->str;
        switch ((unsigned char)rec[bestSub]) {
        case 1:
            if (STR_FindCharPtr(LOCAVAIL_STR_YYLLZ_FilterGateCheck,
                    (long)ED_DiagVinModeChar) == 0
                || SCRIPT_ReadHandshakeBit5Mask() == 0) {
                best = -1;
                bestSub = -1;
            }
            break;
        case 2:
            if (ED_DiagGraphModeChar == 'N' || ESQIFF_GAdsBrushListCount == 0) {
                best = -1;
                bestSub = -1;
            }
            break;
        case 3:
            if (WDISP_HighlightActive == 0) {
                best = -1;
                bestSub = -1;
            }
            break;
        case 4:
            best = -1;
            bestSub = -1;
            break;
        default:
            best = -1;
            bestSub = -1;
            break;
        }
    }

    ctx->bestIndex = best;
    ctx->bestSub = bestSub;
}
