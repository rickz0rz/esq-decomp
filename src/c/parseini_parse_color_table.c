/* RESTORES: PARSEINI_ParseColorTable
 * MODULE:   modules/groups/b/a/parseini.s
 * STATUS:   behavioural
 *
 * Matches an INI key against "COLOR0".."COLOR7" and, on a hit, decodes the three
 * hex digits of that entry into the selected palette table. The mode argument
 * picks the table -- 4 is the keyboard-edited palette, 5 the base palette -- and
 * mode 4 additionally kicks the copper rise transition once the row is stored, so
 * an edited colour takes effect immediately.
 *
 * Neither the table pointer nor the entry count is initialised when the mode is
 * anything other than 4 or 5, in the original as much as here: the switch has no
 * default and the loop bound is read uninitialised. Adding a default would be
 * inventing behaviour the original does not have.
 *
 * 168 bytes in the original, 164 emitted (162 plus one alignment NOP). The -4 is
 * fully itemised: -8, -8, +8, +4. The three spill decisions below are the same
 * trade made in different places -- both compilers run out of registers here, and
 * they pick different things to put on the stack.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ff88 ... 4e5d          LINK.W A5,#-120 / UNLK A5
 *   got:     9efc0074 ... defc0074      SUBA.W #116,A7 / ADDA.W #116,A7
 *   summary: The A5-frame class. Even the frame size differs: the original rounds
 *            116 bytes of locals up to 120, 6.51 does not round. +2 in the
 *            epilogue, and +2 more for the alignment NOP the object gains.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: table-pointer-in-frame
 *   ref:     2b7c00006952ff8c ... 206dff8c   the selected table address written to
 *                                            -116(A5) and reloaded before the store
 *   got:     45f900000000 (x2)               LEA of the same address into A2
 *   summary: A consequence of the frame class: with A5 free, 6.51 holds the table
 *            in an address register. 20 bytes in the original against 12, so -8.
 *
 * SASC-MISMATCH: index-sum-spilled
 *   ref:     2f41001c ... 222f0018      index*3+channel stored to 28(A7) across the
 *                                       ParseHexDigit call and reloaded after it
 *   got:     (none)                     the same value kept in D2
 *   summary: The original spills the computed element index over the call; 6.51
 *            has a caller-saved register free for it. -8.
 *
 * SASC-MISMATCH: channel-counter-spilled
 *   ref:     7a00 / 7003 ba80 / 5285         the inner counter lives in D5
 *   got:     42af001c / 202f001c 7203 b081 / 52af001c   it lives at 28(A7)
 *   summary: The same trade in the other direction, and the reason the total is
 *            only -4: having spent A2 and D2 on the two values above, 6.51 has
 *            nothing left for the channel counter. +8.
 *   retest:  a compiler that reserves A5 should reproduce all three placements at
 *            once, since they are one allocation decision.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     2206 e589 9286 d285   D1 = index<<2 - index + channel
 *   got:     2405 d482 d485 d480   D2 = index+index+index + channel
 *   summary: index*3 reduced two different ways, 8 bytes either way. No cost.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */

extern void WDISP_SPrintf(char *buf, char *fmt, long v);
extern long STRING_CompareNoCase(char *a, char *b);
extern long LADFUNC_ParseHexDigit(long ch);
extern void ESQIFF_RunCopperRiseTransition(void);

extern char KYBD_CustomPaletteTriplesRBase[];
extern char ESQFUNC_BasePaletteRgbTriples[];
extern char Global_STR_COLOR_PERCENT_D[];

void PARSEINI_ParseColorTable(char *key, char *digits, long mode)
{
    char buf[112];
    char *table;
    long count;
    long index;
    long channel;

    switch (mode) {
    case 4:
        table = KYBD_CustomPaletteTriplesRBase;
        count = 8;
        break;
    case 5:
        table = ESQFUNC_BasePaletteRgbTriples;
        count = 8;
        break;
    }

    for (index = 0; index < count; index++) {
        WDISP_SPrintf(buf, Global_STR_COLOR_PERCENT_D, index);
        if (STRING_CompareNoCase(key, buf) == 0) {
            for (channel = 0; channel < 3; channel++)
                table[index * 3 + channel] =
                    (char)LADFUNC_ParseHexDigit((long)digits[channel]);
        }
    }

    if (mode == 4)
        ESQIFF_RunCopperRiseTransition();
}
