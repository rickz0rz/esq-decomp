/* RESTORES: TEXTDISP_SetEntryTextFields
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * Publishes the entry-text width for the current LRBN mode and then fills the
 * two name fields of an entry record: a 9-character short name at offset 0 and a
 * 199-character long name at offset 10, each blank-padded and explicitly
 * terminated one byte past its field.
 *
 * The second field is guarded by the SHORT name pointer, not the long one -- see
 * `if (shortName)` before the second copy, which then copies from `longName`. That
 * is what the original does (`MOVE.L A2,D0` a second time, with the argument
 * pushed from 16(A5)), and it is preserved deliberately: passing a null short name
 * with a non-null long name clears both fields rather than writing the long one.
 * It looks like a bug in the original and it is reproduced as a bug.
 *
 * 154 bytes in the original, 152 emitted (150 plus one alignment NOP), and the
 * itemised deltas are -2, -2, -2, +2. Ten differing regions, but seven of them are
 * a single byte -- the A3/A5 and A2/A3 register renaming that follows from the
 * frame class.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc ... 4e5d       LINK.W A5,#-4 / UNLK A5
 *   got:     594f ... 584f           SUBQ.W #4,A7 / ADDQ.W #4,A7
 *   summary: The A5-frame class, -2 in the prologue. Note the local pointer still
 *            reaches memory in both -- only the base register differs.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: zero-store-via-register
 *   ref:     7000 206dfffc 11400009  MOVEQ #0,D0 / MOVEA.L -4(A5),A0
 *                                    / MOVE.B D0,9(A0)
 *   got:     206f000c 42280009       MOVEA.L 12(A7),A0 / CLR.B 9(A0)
 *   summary: The original materialises the zero in a register and stores it, where
 *            6.51 emits CLR.B on the displaced operand. Both terminator writes, so
 *            -2 twice. What makes this worth recording rather than filing under
 *            the constant rule is that the SAME function emits CLR.B (A0) in the
 *            else branch: the original does have the CLR peephole, and declines to
 *            apply it when the operand carries a displacement.
 *   scope:   unknown -- first sighting. Worth counting the ratio of `4228xxxx` to
 *            `7000`+`1140xxxx` program-wide if it recurs.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2f2d0010                MOVE.L 16(A5),-(A7)
 *   got:     246f001c ... 2f0a       MOVEA.L 28(A7),A2 / MOVE.L A2,-(A7)
 *   summary: The long-name argument is pushed straight from the frame by the
 *            original and cached in a register by 6.51, which costs +2 here since
 *            it is used once. Same class as the two entries in
 *            gcommand_load_mplex_file.c, opposite sign.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */

extern void STRING_CopyPadNul(char *dst, char *src, long n);

extern char CONFIG_LRBN_FlagChar;
extern unsigned short TEXTDISP_LrbnEntryWidthPx;
extern unsigned short CONFIG_BannerCopperHeadByte;
extern long TEXTDISP_EntryTextBaseWidthPx;

void TEXTDISP_SetEntryTextFields(char *entry, char *shortName, char *longName)
{
    char *field;

    if (CONFIG_LRBN_FlagChar == 'Y')
        TEXTDISP_EntryTextBaseWidthPx = TEXTDISP_LrbnEntryWidthPx;
    else
        TEXTDISP_EntryTextBaseWidthPx = CONFIG_BannerCopperHeadByte;

    if (entry == 0)
        return;

    field = entry;
    if (shortName) {
        STRING_CopyPadNul(field, shortName, 9L);
        field[9] = 0;
    } else {
        *field = 0;
    }

    field = entry + 10;
    if (shortName) {
        STRING_CopyPadNul(field, longName, 199L);
        field[199] = 0;
    } else {
        *field = 0;
    }
}
