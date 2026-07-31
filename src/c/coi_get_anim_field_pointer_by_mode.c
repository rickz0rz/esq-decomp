/* RESTORES: _COI_GetAnimFieldPointerByMode
 * MODULE:   modules/groups/a/e/coi_p3_coi_getanimfieldpointerbymode.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: sub-record-kept-in-register
 *   ref:     4e55ffec48e70f10266d00083e2d000e3c2d001291c878002b48fff4200b67064aab0030660620086000012e2b6b0030fffc7a00206dfffcba6800246c28200548c0e580226dfffc20690026d1c022502b49fff83011b047660878012b49fff46004524560ce20060c400008640000e2d040303b00064efb000400180026004600640080000e009c00b82b6dfffcfff0600000c2206dfffc2b680004fff0600000b44a44670e206dfff42b680002fff0600000a2206dfffc2b680008fff0600000944a44670e206dfff42b680006fff060000082206dfffc2b68000cfff060744a44670c206dfff42b68000afff06064206dfffc2b680010fff060584a44670c206dfff42b68000efff06048206dfffc2b680014fff0603c4a44670c206dfff42b680012fff0602c206dfffc2b680018fff060204a44670c206dfff42b680016fff06010206dfffc2b68001cfff0600442adfff0202dfff0
 *   got:     514f48e70f343c2f00323e2f002e2a6f002842af00207800200d6706202d003066067000600000f4266d00307a00ba6b00246c2048c52005e580206b0026d1c024503012b047660878012f4a00206004524560da300648c00c8000000008640000b2d040303b00064efb0004001600200036004c0062000e0078008e2f4b001c600000942f6b0004001c6000008a206b00084a446708226f0020206900022f48001c6072206b000c4a446708226f0020206900062f48001c605c206b00104a446708226f00202069000a2f48001c6046206b00144a446708226f00202069000e2f48001c6030206b00184a446708226f0020206900122f48001c601a206b001c4a446708226f0020206900162f48001c600442af001c202f001c4cdf2cf0504f4e754e71
 *   summary: 288 got vs 344 ref, 56 bytes SHORT, and the whole deficit is one variable. The original keeps the sub-record pointer in a frame local and rebuilds MOVEA.L -4(A5),A0 / MOVE.L d16(A0),-16(A5) at each of the eight arms, ten bytes a site; 6.51 holds it in A3 and writes MOVE.L d16(A3),d16(A7), six. THE JUMP TABLE SHAPE MATCHES: entry 5 points at the FIRST body, which only happens if the case labels are written in the original's order -- 5, 0, 1, 2, 3, 4, 6, 7 -- not ascending. The key scan, the found flag, and all eight field selections with their found/not-found arms match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct AnimItem {
    short key;          /* +0 */
    char *f2;
    char *f6;
    char *f10;
    char *f14;
    char *f18;
    char *f22;
};

struct AnimSub {
    char *f0;
    char *f4;
    char *f8;
    char *f12;
    char *f16;
    char *f20;
    char *f24;
    char *f28;
    char  pad32[4];
    short count;                /* +36 */
    struct AnimItem **table;    /* +38 */
};

struct AnimEntry {
    char            pad0[48];
    struct AnimSub *sub;        /* +48 */
};

char *COI_GetAnimFieldPointerByMode(struct AnimEntry *entry, short key,
                                    short mode)
{
    struct AnimSub  *sub;
    struct AnimItem *item;
    struct AnimItem *match;
    char  *out;
    short i;
    short found;

    match = 0;
    found = 0;

    if (entry == 0 || entry->sub == 0)
        return 0;

    sub = entry->sub;
    for (i = 0; i < sub->count; i++) {
        item = sub->table[i];
        if (item->key == key) {
            found = 1;
            match = item;
            break;
        }
    }

    switch (mode) {
    case 5: out = (char *)sub; break;
    case 0: out = sub->f4; break;
    case 1: out = found ? match->f2  : sub->f8;  break;
    case 2: out = found ? match->f6  : sub->f12; break;
    case 3: out = found ? match->f10 : sub->f16; break;
    case 4: out = found ? match->f14 : sub->f20; break;
    case 6: out = found ? match->f18 : sub->f24; break;
    case 7: out = found ? match->f22 : sub->f28; break;
    default: out = 0; break;
    }
    return out;
}
