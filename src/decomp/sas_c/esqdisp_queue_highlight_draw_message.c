typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;

typedef struct RastPort {
    UBYTE pad[56];
} RastPort;

typedef struct HighlightMsg {
    UBYTE raw[116];
} HighlightMsg;

typedef struct SelectionParams {
    UBYTE pad_00[8];
    LONG a;
    LONG b;
    LONG c;
} SelectionParams;

typedef struct HighlightMsgNodeFlags {
    UBYTE pad_00[53];
    UBYTE flags53;
    UBYTE pad_54;
    UBYTE flags55;
} HighlightMsgNodeFlags;

extern void *ESQ_HighlightReplyPort;
extern void *ESQ_HighlightMsgPort;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern void *AbsExecBase;

extern void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(void);
extern void ESQDISP_InitHighlightMessagePattern(void);
extern void _LVOInitRastPort(void);
extern void _LVOSetFont(void);
extern void _LVOSetDrMd(void);
extern void _LVOPutMsg(void);

void ESQDISP_QueueHighlightDrawMessage(HighlightMsg *msg, SelectionParams *params)
{
    RastPort *rp;
    HighlightMsgNodeFlags *nodeFlags;

    msg->raw[8] = 5;
    *(UWORD *)(msg->raw + 18) = 0x00A0;
    *(void **)(msg->raw + 14) = ESQ_HighlightReplyPort;

    *(LONG *)(msg->raw + 20) = params->a;
    *(LONG *)(msg->raw + 24) = params->b;
    *(LONG *)(msg->raw + 28) = params->c;

    *(UWORD *)(msg->raw + 52) = 0;
    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(msg, 0);

    *(LONG *)(msg->raw + 32) = 0;
    ESQDISP_InitHighlightMessagePattern(msg);

    rp = (RastPort *)(msg->raw + 60);
    _LVOInitRastPort(rp);

    *(void **)(msg->raw + 64) = params;
    _LVOSetFont(rp, Global_HANDLE_PREVUEC_FONT);
    _LVOSetDrMd(rp, 0);

    nodeFlags = *(HighlightMsgNodeFlags **)(msg->raw + 112);
    nodeFlags->flags55 = 1;
    nodeFlags->flags53 |= 1;

    _LVOPutMsg(ESQ_HighlightMsgPort, msg);
}
