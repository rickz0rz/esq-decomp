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
 * SASC-MISMATCH: struct-form-history
 *   summary: the body was written as *(long *)(msg + 20) and so on, which cost
 *            SAS/C an address computation per access: 192 bytes against 176, in
 *            14 regions. Re-expressing it as the structs it actually is -- an
 *            Exec Message with an embedded RastPort at +60 -- folds each offset
 *            into a (d16,An) displacement and brings it to 188 in 12 regions.
 *            The layout is derived, not guessed: struct Message and struct
 *            RastPort are standard, +64 is RastPort.BitMap and +112 is
 *            RastPort.Font, and both the reference and the emitted code address
 *            the latter as 112(An) -- which is the check that the offsets are
 *            right, since cdiff cannot see a wrong one.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls, plus the BSR.S noted
 *            above which is a different problem entirely.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

extern void NEWGRID_ValidateSelectionCode(void *msg, long code);
extern void ESQDISP_InitHighlightMessagePattern(void *msg);
extern void *ESQ_HighlightReplyPort;
extern struct MsgPort *ESQ_HighlightMsgPort;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

/* The message really is an Exec Message (ln_Type at +8, mn_ReplyPort at +14,
 * mn_Length at +18) with an embedded RastPort at +60 -- InitRastPort/SetFont/
 * SetDrMd prove the latter. Both are standard layouts; the fields between are
 * modelled at the offsets the assembly already pins, so this is a re-expression
 * of the same addresses rather than a guessed layout. Writing them as members is
 * what makes SAS/C fold each offset into a (d16,An) displacement instead of
 * recomputing the address -- see the source-shapes table in AGENTS.md. */
struct HiMsg {
    struct Message   mn;            /* +0   .. +19 */
    long             f20, f24, f28; /* +20, +24, +28 */
    long             f32;           /* +32 */
    char             pad36[16];     /* +36 .. +51 */
    short            f52;           /* +52 */
    char             pad54[6];      /* +54 .. +59 */
    struct RastPort  rp;            /* +60, BitMap at +64, Font at +112 */
};

struct HiSrc {
    char pad0[8];
    long f8, f12, f16;              /* +8, +12, +16 */
};

void ESQDISP_QueueHighlightDrawMessage(unsigned char *msgp, unsigned char *srcp)
{
    register struct HiMsg *m = (struct HiMsg *)msgp;
    struct HiSrc *s = (struct HiSrc *)srcp;
    unsigned char *ctx;

    m->mn.mn_Node.ln_Type = 5;
    m->mn.mn_Length       = 0xa0;
    m->mn.mn_ReplyPort    = (struct MsgPort *)ESQ_HighlightReplyPort;
    m->f20 = s->f8;
    m->f24 = s->f12;
    m->f28 = s->f16;
    m->f52 = 0;

    NEWGRID_ValidateSelectionCode(m, 0);
    m->f32 = 0;
    ESQDISP_InitHighlightMessagePattern(m);

    InitRastPort(&m->rp);
    m->rp.BitMap = (struct BitMap *)srcp;
    SetFont(&m->rp, Global_HANDLE_PREVUEC_FONT);
    SetDrMd(&m->rp, 0L);

    ctx = (unsigned char *)m->rp.Font;
    ctx[55] = 1;
    ctx[53] |= 1;

    PutMsg(ESQ_HighlightMsgPort, (struct Message *)m);
}
