/* RESTORES: ESQDISP_QueueHighlightDrawMessage
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   behavioural
 *
 * 176 bytes in the original, 192 emitted, 14 differing regions.
 *
 * Reproduces: the message header fill (type 5 at +8, length 0xa0 at +18, the
 * reply port at +14), the three-long copy out of the source record, the
 * validate/clear/pattern-init sequence, the embedded RastPort at +60 initialised
 * then given the PrevueC font and draw mode 0, the source pointer parked at +64,
 * the context reached through +112 whose byte 55 is set and byte 53 has bit 0
 * OR-ed in, and the PutMsg.
 *
 * NOTE this function calls ESQDISP_InitHighlightMessagePattern with BSR.S -- a
 * two-byte intra-unit call, so that function shares a translation unit with this
 * one. tools/coverage.py classified this as cross-unit because it only looked for
 * BSR.W; that gap is fixed in the same commit. A restoration containing an
 * intra-unit call can never match on call encoding alone, because our
 * one-function-per-file layout makes every call external.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     (none)                     MOVEM only
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls, plus the BSR.S noted
 *            above which is a different problem entirely.
 */
#include <proto/exec.h>
#include <proto/graphics.h>

extern void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(void *msg, long code);
extern void ESQDISP_InitHighlightMessagePattern(void *msg);
extern void *ESQ_HighlightReplyPort;
extern struct MsgPort *ESQ_HighlightMsgPort;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

void ESQDISP_QueueHighlightDrawMessage(unsigned char *msg, unsigned char *src)
{
    unsigned char *ctx;

    msg[8] = 5;
    *(short *)(msg + 18) = 0xa0;
    *(void **)(msg + 14) = ESQ_HighlightReplyPort;
    *(long *)(msg + 20) = *(long *)(src + 8);
    *(long *)(msg + 24) = *(long *)(src + 12);
    *(long *)(msg + 28) = *(long *)(src + 16);
    *(short *)(msg + 52) = 0;

    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(msg, 0);
    *(long *)(msg + 32) = 0;
    ESQDISP_InitHighlightMessagePattern(msg);

    InitRastPort((struct RastPort *)(msg + 60));
    *(void **)(msg + 64) = src;
    SetFont((struct RastPort *)(msg + 60), Global_HANDLE_PREVUEC_FONT);
    SetDrMd((struct RastPort *)(msg + 60), 0L);

    ctx = *(unsigned char **)(msg + 112);
    ctx[55] = 1;
    ctx[53] |= 1;

    PutMsg(ESQ_HighlightMsgPort, (struct Message *)msg);
}
