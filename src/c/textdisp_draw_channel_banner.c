/* RESTORES: TEXTDISP_DrawChannelBanner
 * MODULE:   modules/groups/b/a/textdisp3_p1_p2.s
 * STATUS:   behavioural
 *
 * Builds the channel banner text and draws it, bracketed by two SetDrMd calls
 * that put the rastport into complement mode and back.
 *
 * THE RASTPORT IS CHOSEN TWICE, by the same test, in two separate if/else
 * blocks. Both are written out below rather than hoisted into a variable,
 * because that is what the original does -- and hoisting is not free here: the
 * value would have to survive four intervening calls, so 6.51 would spill it.
 *
 * drawMode 3 selects the standalone rastport at Global_REF_RASTPORT_2;
 * anything else selects the one inside the display context, at offset
 * Offset_RastPort2_FromDisplayContextBase PLUS TWO. The extra 2 is in the
 * original and is not a transcription slip -- the SetDrMd calls and the width
 * read use the same base with different displacements.
 *
 * THE HALF-WIDTH DIVIDE IS SIGNED AND THE VALUE IS NOT. The original zero-
 * extends the width with `MOVEQ #0,D5` before loading a word into it, so the
 * long can never be negative -- and then divides with the SIGNED sequence
 * `TST.L / BPL / ADDQ.L #1 / ASR.L #1`, three instructions that exist only to
 * round a negative number toward zero. The source therefore declared the width
 * as a plain long and read an UNSIGNED field into it. Writing the field as
 * signed short loses the zero-extension; writing the local as unsigned loses
 * the rounding sequence. Both halves are needed.
 *
 * The short name is copied into the label buffer with `strcpy`, and the label
 * builder is then called with the literal 1 and no reference to either buffer
 * -- it reaches them through the globals.
 *
 * WRITE THE strcpy, NOT THE LOOP, and this function is the sharpest measurement
 * of that rule so far. The original's copy is two instructions,
 * `MOVE.B (A0)+,(A1)+` and `BNE`. A hand-written `while ((*dst++ = *src++))`
 * gives 6.51 five instructions and no `12d8` at all -- it keeps the cursors in
 * two registers and stores through a third. Calling `strcpy` inlines to the
 * original's exact two-instruction form. Worth 12 bytes on this function, 276
 * against 264.
 *
 * The pen-override state word is cleared BEFORE the first SetDrMd and the
 * enable flag is set AFTER it. The two are not a pair and the order matters to
 * whatever reads them on the interrupt side.
 *
 * 270 ref vs 264 got, 12 differing regions. The group 1/2 selection, the entry
 * lookup, the short-name build, the strcpy in its two-instruction form, the
 * label build with its literal 1, both rastport selections with their +2
 * displacement, all four SetDrMd library calls, the zero-extended width load,
 * the signed half-width divide, the trim call and the frame draw all match in
 * kind and size.
 *
 * The candidate is 6 bytes UNDER the reference, and both halves of that are
 * accounted for below: the deferred cleanup costs us bytes and the dead store
 * saves us bytes we should not be saving.
 *
 * SASC-MISMATCH: deferred-stack-cleanup
 *   ref:     ... 4fef0014        one LEA 20(A7),A7 after THREE calls
 *            ... 2e80            the second call's argument slot is REUSED by
 *                                writing over (A7) rather than pushing again
 *   got:     a matching ADDQ.W/LEA after each call, and a fresh push each time
 *   summary: the original defers all three cleanups into one LEA and overwrites
 *            a live argument slot to feed the next call. 6.51 balances the
 *            stack per call. Same arguments, same order, more instructions --
 *            but NOT the dominant cost here, which an earlier draft of this
 *            header claimed without measuring. Itemised with tools/casm.py the
 *            cleanup difference is a near-wash: 6.51 spends 4 bytes on an extra
 *            LEA and saves 8 by not pushing what it does not need.
 *   tried:   nothing source-level reaches it. Argument-slot reuse across two
 *            different callees is not expressible in C -- it is a decision the
 *            code generator makes about a whole statement sequence, and 6.51
 *            does not make it anywhere in the restored set.
 *   scope:   program-wide, at every site where two calls share an argument.
 *            docs/compiler-version.md, "Parameter load order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: unreproduced-dead-store
 *   ref:     2b40fffc     MOVE.L D0,-4(A5)
 *   got:     (nothing)
 *   summary: the original stores the entry pointer into a frame slot that
 *            NOTHING reads afterwards -- the LINK reserves 8 bytes and only this
 *            one store touches them. So the source had a local that the rest of
 *            the function stopped using, and the compiler kept the store. We
 *            emit no such store, which is 4 of the 6 bytes we come in under.
 *   tried:   not attempted. AGENTS.md's zero-local trick keeps a dead TEST
 *            alive; there is no equivalent for a dead STORE, because assigning a
 *            live value to an unread local is exactly what 6.51 deletes. Forcing
 *            it would need `volatile`, which changes the type rather than the
 *            spelling and would be our artifact rather than the original's.
 *   scope:   narrow. One site.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"
#include <string.h>

struct WDispContext {
    short          pad0;                /* +0  */
    unsigned short width;               /* +2  */
    char           pad4[6];
    char           rastPort2Plus2[2];   /* +10 */
};

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long index, long group);
extern void  TEXTDISP_BuildEntryShortName(void *entry, char *out);
extern void  TEXTDISP_BuildChannelLabel(long which);
extern void  TEXTDISP_TrimTextToPixelWidth(char *text, long width);
extern void  TEXTDISP_DrawInsetRectFrame(char *text, long drawMode, long width);

extern struct WDispContext *WDISP_DisplayContextBase;
extern struct RastPort     *Global_REF_RASTPORT_2;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_LinePenOverrideEnabledFlag;
extern short TEXTDISP_LinePenOverrideStateWord;
extern char  TEXTDISP_EntryShortNameScratch[];
extern char  TEXTDISP_ChannelLabelBuffer[];

void TEXTDISP_DrawChannelBanner(short mode, short drawMode)
{
    void *entry;
    long  group;
    long  width;

    if (TEXTDISP_ActiveGroupId != 0)
        group = 1;
    else
        group = 2;

    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(
                (long)TEXTDISP_CurrentMatchIndex, group);

    TEXTDISP_BuildEntryShortName(entry, TEXTDISP_EntryShortNameScratch);

    strcpy(TEXTDISP_ChannelLabelBuffer, TEXTDISP_EntryShortNameScratch);

    TEXTDISP_BuildChannelLabel(1L);

    TEXTDISP_LinePenOverrideStateWord = 0;

    if (drawMode == 3)
        SetDrMd(Global_REF_RASTPORT_2, 0L);
    else
        SetDrMd((struct RastPort *)WDISP_DisplayContextBase->rastPort2Plus2,
                0L);

    TEXTDISP_LinePenOverrideEnabledFlag = 1;

    width = WDISP_DisplayContextBase->width;
    if (mode == 2)
        width = width / 2;

    TEXTDISP_TrimTextToPixelWidth(TEXTDISP_ChannelLabelBuffer, width);
    TEXTDISP_DrawInsetRectFrame(TEXTDISP_ChannelLabelBuffer, (long)drawMode,
                                width);

    if (drawMode == 3)
        SetDrMd(Global_REF_RASTPORT_2, 1L);
    else
        SetDrMd((struct RastPort *)WDISP_DisplayContextBase->rastPort2Plus2,
                1L);
}
