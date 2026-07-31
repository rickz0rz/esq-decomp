/* RESTORES: TLIBA1_DumpFormatStruct
 * MODULE:   modules/groups/b/a/tliba1_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: saved-register-and-arg-block
 *   ref:     2f0b266f00082f0b48790000777e4eba2e924879000077984eba2e88301348c02e8048790000779c4eba2e78302b000248c02e804879000077b04eba2e66302b000448c02e804879000077c44eba2e54302b000648c02e804879000077d84eba2e42302b000848c02e804879000077ec4eba2e304879000078004eba2e264fef0024265f4e750000
 *   got:     2f0d2a6f00082f0d487900000000610000002e8d48790000000061000000301548c02e8048790000000061000000302d000248c02e8048790000000061000000302d000448c02e8048790000000061000000302d000648c02e8048790000000061000000302d000848c02e8048790000000061000000302d000848c02e80487900000000610000004fef00242a5f4e75
 *   summary: 144 got vs 136 ref, first divergence at byte 1. The original saves A3 alone with MOVE.L A3,-(A7) and reads its argument from 8(A7); 6.51 uses a MOVEM pair and reloads the record pointer per field. This is the debug-dump block the disassembly documented but left unlabelled after TLIBA1_FormatClockFormatEntry -- giving it a name is byte-neutral, corrected that function from 524 bytes to 388, and promoted this block to its own worklist entry. The eight format calls in their original order, the five sign-extended word fields at +0 to +8, and the reuse of the last field value on the closing brace line all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct TLFormat {
    short colour;               /* +0 */
    short offset;               /* +2 */
    short fontSel;              /* +4 */
    short align;                /* +6 */
    short preGap;               /* +8 */
};

extern char TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X[];
extern char TLIBA1_STR_TLFormatStructOpenBraceLine[];
extern char TLIBA1_FMT_TLF_COLOR_PCT_D[];
extern char TLIBA1_FMT_TLF_OFFSET_PCT_D[];
extern char TLIBA1_FMT_TLF_FONTSEL_PCT_D[];
extern char TLIBA1_FMT_TLF_ALIGN_PCT_D[];
extern char TLIBA1_FMT_TLF_PREGAP_PCT_D[];
extern char TLIBA1_STR_TLFormatStructCloseBraceLine[];

extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, long value);

void TLIBA1_DumpFormatStruct(struct TLFormat *fmt)
{
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X,
                                     (long)fmt);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_STR_TLFormatStructOpenBraceLine,
                                     (long)fmt);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_TLF_COLOR_PCT_D,
                                     (long)fmt->colour);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_TLF_OFFSET_PCT_D,
                                     (long)fmt->offset);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_TLF_FONTSEL_PCT_D,
                                     (long)fmt->fontSel);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_TLF_ALIGN_PCT_D,
                                     (long)fmt->align);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_TLF_PREGAP_PCT_D,
                                     (long)fmt->preGap);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_STR_TLFormatStructCloseBraceLine,
                                     (long)fmt->preGap);
}
