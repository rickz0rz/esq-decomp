/* RESTORES: ESQIFF_QueueIffBrushLoad
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dead-block-guard-shape
 *   ref:     2f072e2f00084ab900005b0267067001be80660a23f9000001a400005b0270004a80670000ae487900005b062f3900005b024eba11f8504f4a8067087002be806600009010390000a3287200b001630000ba30390000a3c27230b041670000ac42a72f3900005b024eba122823c0000001a82040117c000b00be2079000001a8317c028000802079000001a8317c00a000822079000001a8117c000300882eb9000001a84eba11c823c0000001ac2e806100fc28487800ee2f39000001a8487802d4487900005b0e4eba11984fef001860384ab900005b0267304ab900005b02672842a72f3900005b024eba11a623c0000001a82040117c000600be33fc00060000047a4eba11c2504f7002be80670e207900005b0223e800ea00005b022e1f4e75
 *   got:     48e703002e2f000c4ab900000000670620075380660c20790000000023c8000000007c004a86670000ae4879000000002f390000000061000000504f4a80670820075580660000c81039000000007200b001630000ba3039000000007230b041670000ac42a72f39000000006100000023c0000000002040117c000b00be207900000000317c02800080207900000000317c00a00082207900000000117c000300882eb9000000006100000023c0000000002e8061000000487800ee2f3900000000487802d4487900000000610000004fef0018603822390000000056c04400488048c04a806726672442a72f016100000023c0000000002040117c000600be33fc00060000000061000000504f20075580670e20790000000023e800ea000000004cdf00c04e75
 *   summary: 296 got vs 290 ref, six bytes over, and the whole weather-overlay block survives. That block is unreachable in the original too: it is guarded by a register that MOVEQ #0 has just loaded, so the zero is held in a local here rather than written as a literal, per the rule in parseini_load_weather_strings.c. A literal 0 folds the block away and the function drops to 128 bytes. The excess is the guard shape -- 6.51 tests the local with TST.L and lays the arms out in the opposite order. The reference was 298 bytes until an unlabelled six-byte LINK/UNLK/RTS stub after the RTS was given the label ESQIFF_NoOpFrame; that is byte-neutral and both gates stay green.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BrushDesc {
    char              pad0[128];
    short             width;         /* +128 */
    short             height;        /* +130 */
    char              pad132[4];
    char              depth;         /* +136 */
    char              pad137[53];
    char              kind;          /* +190 */
    char              pad191[43];
    struct BrushDesc *next;          /* +234 */
};

extern struct BrushDesc *ESQIFF_BannerBrushResourceCursor;
extern struct BrushDesc *PARSEINI_BannerBrushResourceHead;
extern struct BrushDesc *CTASKS_PendingIffBrushDescriptor;
extern struct BrushDesc *WDISP_WeatherStatusBrushListHead;
extern char   ESQIFF_STR_WEATHER[];
extern char   Global_STR_ESQIFF_C_2[];
extern unsigned char WDISP_WeatherStatusCountdown;
extern short  WDISP_WeatherStatusDigitChar;
extern short  CTASKS_IffTaskState;

extern long              STRING_CompareNoCase(char *a, char *b);
extern struct BrushDesc *BRUSH_AllocBrushNode(struct BrushDesc *src,
                                                            long flags);
extern struct BrushDesc *BRUSH_CloneBrushRecord(struct BrushDesc *src);
extern void              ESQIFF_DrawWeatherStatusOverlayIntoBrush(struct BrushDesc *b);
extern void              MEMORY_DeallocateMemory(char *who, long line,
                                                               struct BrushDesc *ptr,
                                                               long size);
extern void              CTASKS_StartIffTaskProcess(void);

void ESQIFF_QueueIffBrushLoad(long mode)
{
    long weatherPathEnabled;

    if (ESQIFF_BannerBrushResourceCursor == 0 || mode == 1)
        ESQIFF_BannerBrushResourceCursor = PARSEINI_BannerBrushResourceHead;

    /* Zero held in a local, not written as a literal: the original tests it and
     * emits the whole weather-overlay block below, which is unreachable there
     * as well. A literal 0 lets 6.51 fold the block away. */
    weatherPathEnabled = 0;

    if (weatherPathEnabled) {
        if (STRING_CompareNoCase(
                (char *)ESQIFF_BannerBrushResourceCursor, ESQIFF_STR_WEATHER) == 0
            || mode == 2) {
            if (WDISP_WeatherStatusCountdown > 0
                && WDISP_WeatherStatusDigitChar != 48) {
                CTASKS_PendingIffBrushDescriptor =
                    BRUSH_AllocBrushNode(ESQIFF_BannerBrushResourceCursor, 0);
                CTASKS_PendingIffBrushDescriptor->kind = 11;
                CTASKS_PendingIffBrushDescriptor->width = 0x280;
                CTASKS_PendingIffBrushDescriptor->height = 160;
                CTASKS_PendingIffBrushDescriptor->depth = 3;
                WDISP_WeatherStatusBrushListHead =
                    BRUSH_CloneBrushRecord(CTASKS_PendingIffBrushDescriptor);
                ESQIFF_DrawWeatherStatusOverlayIntoBrush(WDISP_WeatherStatusBrushListHead);
                MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_2, 724,
                                                      CTASKS_PendingIffBrushDescriptor,
                                                      238);
            }
        }
    } else if (ESQIFF_BannerBrushResourceCursor != 0
               && ESQIFF_BannerBrushResourceCursor != 0) {
        CTASKS_PendingIffBrushDescriptor =
            BRUSH_AllocBrushNode(ESQIFF_BannerBrushResourceCursor, 0);
        CTASKS_PendingIffBrushDescriptor->kind = 6;
        CTASKS_IffTaskState = 6;
        CTASKS_StartIffTaskProcess();
    }

    if (mode == 2)
        return;
    ESQIFF_BannerBrushResourceCursor = ESQIFF_BannerBrushResourceCursor->next;
}
