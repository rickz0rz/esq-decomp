/* RESTORES: ESQFUNC_RebuildPwBrushListFromTagTable
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Throws away the current PW brush list and builds a fresh chain of six brush
 * descriptors, one per tag string, tagging the first with type 8 and the rest
 * with type 9. The head pointer is captured on the first non-null descriptor and
 * the finished chain is handed to the brush loader before being released.
 *
 * The six cases are written out separately even though five of them are the same
 * statement. That is deliberate: the original emits six distinct bodies through a
 * PC-relative jump table, so the source it came from had six case labels each
 * with its own assignment. Collapsing them to `case 1: ... case 5:` gives one
 * shared body and loses the table.
 *
 * There is no explicit range guard before the switch. The CMPI.L #6 in the
 * original is the jump table's own bound check, and adding an `if (i >= 6)` makes
 * SAS/C emit the test twice -- the rule established by ed_get_esc_menu_action_code.c.
 *
 * 216 bytes in the original, 180 emitted, and the JUMP TABLE ITSELF reproduces:
 * six entries, same order, same dispatch sequence (ADD.W D0,D0 / MOVE.W (6,PC,D0.W),D0
 * / JMP (4,PC,D0.W)). The entry offsets differ only because the case bodies are
 * shorter, which is the frame class below. That is the result worth reporting --
 * the -36 is one class applied thirteen times.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8 42adfffc / 206dfffc 117c000800be (x6) / 2e2dfff4 4e5d
 *   got:     48e70104 9bcd     / 1b7c000800be           (x6) / 4cdf2080
 *   summary: The A5-frame class. The descriptor pointer lives at -4(A5) in the
 *            original and is reloaded into A0 before every one of the six type
 *            stores; with A5 free, 6.51 stores straight through it. That is -4 at
 *            each of the six cases, or -24 of the -36, with the rest spread over
 *            the prologue, the shortened branches and the tail.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: unlk-pops-arguments
 *   ref:     (nothing after the last JSR)
 *   got:     504f                      ADDQ.W #8,A7
 *   summary: The original never cleans up the final call's argument frame because
 *            UNLK restores A7 wholesale. Same observation as
 *            esqfunc_draw_esc_menu_version.c, where it cost +10; here it is only
 *            +2 because just one call sits at the end.
 */

extern void ESQIFF_JMPTBL_BRUSH_FreeBrushList(void *listHead, long flags);
extern void *ESQIFF_JMPTBL_BRUSH_AllocBrushNode(char *tag, void *prev);
extern void ESQIFF_JMPTBL_BRUSH_PopulateBrushList(void *chain, void *listHead);

extern void *ESQFUNC_PwBrushListHead;
extern void *ESQFUNC_PwBrushDescriptorHead;
extern char *ESQFUNC_BrushDescriptorTagStrings[];

struct PwBrushDescriptor {
    char pad[190];
    char type;          /* 190 */
};

void ESQFUNC_RebuildPwBrushListFromTagTable(void)
{
    struct PwBrushDescriptor *desc;
    long i;

    desc = 0;
    ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQFUNC_PwBrushListHead, 0L);

    for (i = 0; i < 6; i++) {
        desc = (struct PwBrushDescriptor *)
               ESQIFF_JMPTBL_BRUSH_AllocBrushNode(ESQFUNC_BrushDescriptorTagStrings[i],
                                                  desc);
        switch (i) {
        case 0:
            desc->type = 8;
            break;
        case 1:
            desc->type = 9;
            break;
        case 2:
            desc->type = 9;
            break;
        case 3:
            desc->type = 9;
            break;
        case 4:
            desc->type = 9;
            break;
        case 5:
            desc->type = 9;
            break;
        }

        if (ESQFUNC_PwBrushDescriptorHead == 0)
            ESQFUNC_PwBrushDescriptorHead = desc;
    }

    ESQIFF_JMPTBL_BRUSH_PopulateBrushList(ESQFUNC_PwBrushDescriptorHead,
                                          &ESQFUNC_PwBrushListHead);
    ESQFUNC_PwBrushDescriptorHead = 0;
}
