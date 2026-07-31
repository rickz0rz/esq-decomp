/* RESTORES: NEWGRID_FindNextEntryWithMarkers
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: reserved-a5-frame
 *   ref:     4e55fff448e70f002e2d00082c2d000c3a2d0012780020074a8067065980670660087c0060065286600278014a84660000cc4a3900009afb670000c24a84660000b670003039000087bcbc806c0000a8200548c02f062f00486dfff8486dfffc6100db7c4fef00104aadfffc670000824aadfff8677a206dfffc3028002e08000001676c1028002808000007676243e8001c200548c02f002f094eba3088504f5280664c2f2dfffc4ebacd6a584f4a80663e206dfff82248d2c5082900010007660e226dfffc1029001b0800000467202248d2c50829000700076614200548c0e580d1c04aa80038670678016000ff4e52866000ff484a8466027cff20064cdf00f04e5d4e75
 *   got:     514f48e70f003a2f00262c2f00202e2f001c780020074a8067065980670660087c0060065286600278014a8467062006600000d61039000000004a0066062006600000c64a84660000b87000303900000000bc806c0000aa300548c02f062f00486f0018486f0020610000004fef00104aaf0014670000844aaf0010677c206f00143028002e08000001676e1028002808000007676443e8001c300548c02f002f0961000000504f5280664e2f2f001461000000584f4a806640206f00102248d2c5082900010007660e226f00141029001b0800000467222248d2c5082900070007661648c52005e580d1c043e800384a91670678016000ff3252866000ff2c4a8466027cff20064cdf00f0504f4e75
 *   summary: 272 got vs 262 ref. The sibling of newgrid_find_next_entry_with_alt_markers.c: same opcode chain (0 restart, 4 advance, anything else sets the found flag), same out-parameter call, but a two-arm opcode chain instead of three and one extra guard -- NEWGRID_ShouldOpenEditor must answer 0, and the entry flags byte at +27 bit 4 is only required when selector-flags bit 1 is clear. Both out-pointers are spilled in the original too, so the frame register is the whole divergence: LINK.W A5,#-12 with negative A5 displacements against SUBQ.W #8,A7 with A7 displacements. All seven guards match in kind, in order and in size.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct NewGridEntry {
    char          pad0[27];
    unsigned char editorFlags;      /* +27 */
    char          bitset[12];       /* +28 */
    unsigned char marker;           /* +40 */
    char          pad41[5];
    short         state;            /* +46 */
};

struct NewGridAux {
    char          pad0[7];
    unsigned char selectorFlags[49];    /* +7 */
};

extern short NEWGRID_UpdatePresetEntry(struct NewGridEntry **entry,
                                       struct NewGridAux **aux,
                                       long selector, long index);
extern long  NEWGRID2_JMPTBL_ESQ_TestBit1Based(char *bits, long slot);
extern long  NEWGRID_ShouldOpenEditor(struct NewGridEntry *entry);

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned char  TEXTDISP_PrimaryGroupPresentFlag;

long NEWGRID_FindNextEntryWithMarkers(long op, long index, short selector)
{
    struct NewGridEntry *entry;
    struct NewGridAux   *aux;
    long found = 0;

    switch (op) {
    case 0:  index = 0;  break;
    case 4:  index++;    break;
    default: found = 1;  break;
    }

    for (;;) {
        if (found)
            return index;
        if (TEXTDISP_PrimaryGroupPresentFlag == 0)
            return index;
        if (found || index >= (long)TEXTDISP_PrimaryGroupEntryCount)
            break;

        NEWGRID_UpdatePresetEntry(&entry, &aux, (long)selector, index);

        if (entry != 0 && aux != 0
            && (entry->state & 2)
            && (entry->marker & 0x80)
            && NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry->bitset, (long)selector) == -1
            && NEWGRID_ShouldOpenEditor(entry) == 0
            && ((aux->selectorFlags[selector] & 2)
                || (entry->editorFlags & 0x10))
            && !(aux->selectorFlags[selector] & 0x80)
            && *(long *)((char *)aux + selector * 4 + 56) != 0)
            found = 1;
        else
            index++;
    }

    if (!found)
        index = -1;
    return index;
}
