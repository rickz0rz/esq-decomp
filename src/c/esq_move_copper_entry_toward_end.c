/* RESTORES: ESQ_MoveCopperEntryTowardEnd
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * DO-NOT-LINK: takes its arguments in REGISTERS, so the compiled C reads the
 *   stack and gets garbage. Proven: esq_dec_color_step.c linked alone over a
 *   clean 356-entry build paints a green panel over the grid area, and
 *   ESQ_SetCopperEffect_Custom compiles to 610000004e75 -- a call and a
 *   return, doing none of the work. Kept for the analysis, never linked.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     222f0004202f000848e7380024000242001f0241001fe549e54a43f900002d2a41f90000414a0641000006420000383c00207604d64130311000b2426a00001a33b130001000b2446a00000831b1300010005841584360e233801000b2446a000006318010004cdf001c4e75
 *   got:     594f48e72f202c2f00242e2f00202007721fc081e5802a002006c081e580280030055840320548c1e2812401d48241f900000000d1c23f5000183f40001aba446c56300548c0e2802200d28141f9000000002248d3c1302f001a48c0e2802200d2812448d5c132927020ba406c22300548c0e2802200d28143f900000000d3c1302f001a48c0e2802200d281d1c132905845586f001a60a6300548c0e2802200d28141f900000000d1c1302f001830807220ba416c14320548c1e2812401d48241f900000000d1c230804cdf04f4584f4e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the copper entry indices arrive in D0/D1. */
extern short ESQ_CopperStatusDigitsA[], ESQ_CopperStatusDigitsB[];

void ESQ_MoveCopperEntryTowardEnd(long from, long to)
{
    short src = (short)((from & 0x1f) << 2);
    short dst = (short)((to & 0x1f) << 2);
    short nxt = src + 4;
    short held = ESQ_CopperStatusDigitsA[src >> 1];

    while (src < dst) {
        ESQ_CopperStatusDigitsA[src >> 1] = ESQ_CopperStatusDigitsA[nxt >> 1];
        if (src < 0x20)
            ESQ_CopperStatusDigitsB[src >> 1] = ESQ_CopperStatusDigitsA[nxt >> 1];
        src += 4;
        nxt += 4;
    }
    ESQ_CopperStatusDigitsA[src >> 1] = held;
    if (src < 0x20)
        ESQ_CopperStatusDigitsB[src >> 1] = held;
}
