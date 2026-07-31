/* RESTORES: SCRIPT_BuildTokenIndexMap
 * MODULE:   modules/groups/b/a/script_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: reserved-a5-frame
 *   ref:     4e55fff448e72730266d0008246d000c3e2d00123c2d001a1a2d001f70003b40fffa3b40fff6302dfffab0476c12220048c1d28135bcffff1800526dfffa60e670003b40fff83b40fffc302dfffc1b730000ffff122dffffb205675ab0466c563b6dfff8fffa302dfffab0476c34122dffff206d0014b23000006620220048c1d281302dfffc240052423582180042330000526dfff83b40fff66006526dfffa60c4200748c0d08072ffb27208fe6606526dfffc60944a6dfff666063b6dfffcfff64a6d00226726426dfffa302dfffab0476c1a220048c1d28170ffb0721800660635adfff61800526dfffa60de302dfffc4cdf0ce44e5d4e754e750000
 *   got:     9efc000c48e737341a2f00473c2f00423e2f003a246f003c266f00342a6f003070003f4000283f400024302f0028b0476c1248c02200d28137bcffff1800526f002860e670003f4000263f40002a302f002a103500001f400023b005675a302f002ab0466c523f6f00260028302f0028b0476c30122f0023b2320000662048c02200d281342f002a260252433783180042352000526f00263f4200246006526f002860c848c72007d08072ffb27308fe6606526f002a60964a6f002466063f6f002a00244a6f004a6726426f0028302f0028b0476c1a48c02200d28174ffb4731800660637af00241800526f002860de302f002a4cdf2cecdefc000c4e75
 *   summary: 254 got vs 254 ref, and the two streams run instruction for instruction. The only divergence is the frame register: the original opens LINK.W A5,#-12 and addresses every local as a negative A5 displacement, 6.51 opens SUBA.W #12,A7 and addresses the same five locals from A7. Both chained initialisations (i = last = 0, tokenIdx = pos = 0), the -1 fill, the token scan with its break, the CLR.B of the consumed source byte, the map[mapCount-1] sentinel test and the fill-missing pass all match in kind and in size.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
short SCRIPT_BuildTokenIndexMap(char *src, short *map, short mapCount,
                                char *tokens, short srcLimit,
                                char terminator, short fillMissing)
{
    char  c;
    short pos;
    short i;
    short tokenIdx;
    short last;

    i = last = 0;
    while (i < mapCount) {
        map[i] = -1;
        i++;
    }

    tokenIdx = pos = 0;
    for (;;) {
        c = src[pos];
        if (c == terminator)
            break;
        if (pos >= srcLimit)
            break;

        i = tokenIdx;
        while (i < mapCount) {
            if (c == tokens[i]) {
                map[i] = pos + 1;
                src[pos] = 0;
                tokenIdx++;
                last = pos;
                break;
            }
            i++;
        }

        if (map[mapCount - 1] != -1)
            break;
        pos++;
    }

    if (last == 0)
        last = pos;

    if (fillMissing != 0) {
        i = 0;
        while (i < mapCount) {
            if (map[i] == -1)
                map[i] = last;
            i++;
        }
    }
    return pos;
}
