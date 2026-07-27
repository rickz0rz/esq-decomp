/* RESTORES: ED_DrawDiagnosticRegisterValues
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * 382 bytes in the original, 380 emitted, and the two-byte delta is fully
 * accounted for: three sites save two bytes each on the index idiom below, while
 * the A6 save/restore pair costs four. -6 +4 = -2. Nothing is missing.
 *
 * SASC-MISMATCH: multiply-by-three-idiom
 *   ref:     e588 90b900008196           LSL.L #2,D0 / SUB.L ED_TempCopyOffset,D0
 *   got:     2200 d281 d280              MOVE.L D0,D1 / ADD.L D1,D1 / ADD.L D0,D1
 *   summary: Both compute offset*3. The original shifts left twice and subtracts
 *            the original value; SAS/C doubles and adds. Same family as the
 *            multiply-strength-reduction recorded in
 *            ed_handle_edit_attributes_menu.c, but note the direction differs --
 *            here the ORIGINAL uses the shift and SAS/C uses adds, so this is not
 *            simply "SAS/C prefers shifts". The two code generators just pick
 *            different reductions.
 *   scope:   every multiply by a small constant.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   summary: 2F0E/2C5F around the body; the original leaves A6 alone across the
 *            graphics.library calls.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for all eleven calls, all cross-unit in the
 *            original. Pre-positioned to match on the right compiler.
 */
#include <proto/graphics.h>
extern struct RastPort *Global_REF_RASTPORT_1;
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(char *buf, long value, long width);
extern char ED_EditBufferScratch[];
extern long ED_TempCopyOffset;
extern unsigned char GCOMMAND_PresetFallbackValue0[];
extern unsigned char GCOMMAND_PresetFallbackValue1[];
extern unsigned char GCOMMAND_PresetFallbackValue2[];
extern char Global_STR_REGISTER[];
extern char Global_STR_R_EQUALS[];
extern char Global_STR_G_EQUALS[];
extern char Global_STR_B_EQUALS[];

void ED_DrawDiagnosticRegisterValues(void)
{
    SetDrMd(Global_REF_RASTPORT_1, 1L);
    SetAPen(Global_REF_RASTPORT_1, 1L);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 240, Global_STR_REGISTER);
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, ED_TempCopyOffset, 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 190, 240, ED_EditBufferScratch);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 270, Global_STR_R_EQUALS);
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch,
        GCOMMAND_PresetFallbackValue0[ED_TempCopyOffset * 3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 85, 270, ED_EditBufferScratch);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 135, 270, Global_STR_G_EQUALS);
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch,
        GCOMMAND_PresetFallbackValue1[ED_TempCopyOffset * 3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 270, ED_EditBufferScratch);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 230, 270, Global_STR_B_EQUALS);
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch,
        GCOMMAND_PresetFallbackValue2[ED_TempCopyOffset * 3], 2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 275, 270, ED_EditBufferScratch);
}
