typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;

typedef struct RastPort {
    UBYTE pad[56];
} RastPort;

typedef struct HighlightMsg {
    UBYTE pad_00[8];
    UBYTE type8;
    UBYTE pad_09[5];
    void *replyPort14;
    UBYTE pad_18[4];
    LONG paramA20;
    LONG paramB24;
    LONG paramC28;
    LONG paramD32;
    UBYTE pad_36[20];
    UWORD stateWord52;
    UBYTE pattern55[5];
    RastPort rastPort60;
    void *selectionParams64;
    UBYTE pad_68[48];
    void *nodePtr112;
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

extern void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(HighlightMsg *msg, LONG code);
extern void ESQDISP_InitHighlightMessagePattern(HighlightMsg *msg);
extern void _LVOInitRastPort(RastPort *rp);
extern void _LVOSetFont(RastPort *rp, void *font);
extern void _LVOSetDrMd(RastPort *rp, LONG mode);
extern void _LVOPutMsg(void *port, HighlightMsg *msg);

void ESQDISP_QueueHighlightDrawMessage(HighlightMsg *msg, SelectionParams *params)
{
    RastPort *rp;
    HighlightMsgNodeFlags *nodeFlags;

    msg->type8 = 5;
    *(UWORD *)msg->pad_18 = 0x00A0;
    msg->replyPort14 = ESQ_HighlightReplyPort;

    msg->paramA20 = params->a;
    msg->paramB24 = params->b;
    msg->paramC28 = params->c;

    msg->stateWord52 = 0;
    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(msg, 0);

    msg->paramD32 = 0;
    ESQDISP_InitHighlightMessagePattern(msg);

    rp = &msg->rastPort60;
    _LVOInitRastPort(rp);

    msg->selectionParams64 = params;
    _LVOSetFont(rp, Global_HANDLE_PREVUEC_FONT);
    _LVOSetDrMd(rp, 0);

    nodeFlags = (HighlightMsgNodeFlags *)msg->nodePtr112;
    nodeFlags->flags55 = 1;
    nodeFlags->flags53 |= 1;

    _LVOPutMsg(ESQ_HighlightMsgPort, msg);
}
