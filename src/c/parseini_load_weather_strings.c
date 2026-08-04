/* RESTORES: PARSEINI_LoadWeatherStrings
 * MODULE:   modules/groups/b/a/parseini.s
 * STATUS:   behavioural
 *
 * 168 bytes in the original and 168 emitted, 13 differing regions.
 *
 * This function contains DEAD CODE in the original, and reproducing it is what
 * makes the size match. After the filename-tag branch, the original emits
 *
 *     7000        MOVEQ #0,D0
 *     4a80        TST.L D0
 *     6744        BEQ   .return
 *
 * -- a test of a constant zero that always branches, leaving the entire
 * following TAG_WEATHER block (74 of the 168 bytes) unreachable. Presumably a
 * feature switched off by a flag the compiler could see was zero but did not
 * propagate.
 *
 * Writing `if (0) { ... }` does not work: SAS/C folds that away and the block
 * vanishes. Writing it through a zero-initialised local does:
 *
 *     long enabled;
 *     enabled = 0;
 *     if (enabled) { ... }
 *
 * SAS/C emits the MOVEQ/TST/BEQ and keeps the body. That is a general technique
 * for any original containing a provably-never-taken branch -- and worth knowing,
 * because the alternative is dropping the block entirely and reporting a
 * seventy-four byte "divergence" that is really a reconstruction choice.
 *
 * Reproduces otherwise: the head-pointer reset when no resource list exists yet,
 * the case-folded filename tag match, the brush node allocation chained onto the
 * previous node with type byte 10 written at +190, and the head installed on
 * first use -- all of which appear twice, once in the live path and once in the
 * dead one.
 *
 * ESQ_EXACT: keeps the dead TAG_WEATHER block alive behind a zero local. With
 *   ESQ_EXACT=0 the block is deleted outright: 74 of the 168 bytes go away and
 *   the function stops matching, but nothing observable changes, because the
 *   block is unreachable in the original too. This is the worked example for the
 *   switch -- see AGENTS.md, "Two implementations behind one switch".
 *
 * SASC-MISMATCH: case-body-layout-order
 *   summary: The two blocks are laid out in a different order and the register
 *            allocation differs, which is the 13 regions. Sizes agree exactly.
 */
#ifndef ESQ_EXACT
#define ESQ_EXACT 1
#endif

extern long  STRING_CompareNoCase(char *a, char *b);
extern void *BRUSH_AllocBrushNode(char *s, void *prev);
extern void *PARSEINI_BannerBrushResourceHead;
extern void *PARSEINI_WeatherBrushNodePtr;
extern long  P_TYPE_WeatherBrushRefreshPendingFlag;
extern char  PARSEINI_TAG_FILENAME_WeatherString[];
extern char  PARSEINI_TAG_WEATHER[];

void PARSEINI_LoadWeatherStrings(char *key, char *value)
{
    unsigned char *node;
#if ESQ_EXACT
    long enabled;
#endif

    if (PARSEINI_BannerBrushResourceHead == 0)
        PARSEINI_WeatherBrushNodePtr = 0;

    if (STRING_CompareNoCase(key,
            PARSEINI_TAG_FILENAME_WeatherString) == 0) {
        node = BRUSH_AllocBrushNode(value, PARSEINI_WeatherBrushNodePtr);
        node[190] = 10;
        PARSEINI_WeatherBrushNodePtr = node;
        if (PARSEINI_BannerBrushResourceHead == 0)
            PARSEINI_BannerBrushResourceHead = node;
        return;
    }

#if ESQ_EXACT
    /* Unreachable in the original as well: it loads a constant zero, tests it and
       branches past this block. Keeping a zero LOCAL rather than writing `if (0)`
       is what stops the compiler folding the block away -- see AGENTS.md. */
    enabled = 0;
    if (enabled) {
        if (STRING_CompareNoCase(key, PARSEINI_TAG_WEATHER) == 0) {
            P_TYPE_WeatherBrushRefreshPendingFlag = 1;
            node = BRUSH_AllocBrushNode(key, PARSEINI_WeatherBrushNodePtr);
            node[190] = 10;
            PARSEINI_WeatherBrushNodePtr = node;
            if (PARSEINI_BannerBrushResourceHead == 0)
                PARSEINI_BannerBrushResourceHead = node;
        }
    }
#endif
}
