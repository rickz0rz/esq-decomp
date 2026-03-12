typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed long LONG;

typedef struct RastPort {
    UBYTE pad[4];
} RastPort;

typedef struct SelectionParams {
    UBYTE pad_00[8];
    LONG a;
    LONG b;
    LONG c;
} SelectionParams;

typedef struct HighlightNodeFlags {
    UBYTE pad_00[53];
    UBYTE flags53;
    UBYTE pad_54;
    UBYTE flags55;
} HighlightNodeFlags;

typedef UBYTE HighlightMsg;

enum {
    HIGHLIGHTMSG_Type8 = 8,
    HIGHLIGHTMSG_ReplyPort14 = 14,
    HIGHLIGHTMSG_Length18 = 18,
    HIGHLIGHTMSG_ParamA20 = 20,
    HIGHLIGHTMSG_ParamB24 = 24,
    HIGHLIGHTMSG_ParamC28 = 28,
    HIGHLIGHTMSG_ParamD32 = 32,
    HIGHLIGHTMSG_StateWord52 = 52,
    HIGHLIGHTMSG_RastPort60 = 60,
    HIGHLIGHTMSG_SelectionParams64 = 64,
    HIGHLIGHTMSG_NodePtr112 = 112
};

enum {
    HIGHLIGHTNODE_Flags53 = 53,
    HIGHLIGHTNODE_Flags55 = 55
};

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
    HighlightNodeFlags *node;

    *(UBYTE *)(msg + HIGHLIGHTMSG_Type8) = 5;
    *(UWORD *)(msg + HIGHLIGHTMSG_Length18) = 0x00A0;
    *(void **)(msg + HIGHLIGHTMSG_ReplyPort14) = ESQ_HighlightReplyPort;

    *(LONG *)(msg + HIGHLIGHTMSG_ParamA20) = params->a;
    *(LONG *)(msg + HIGHLIGHTMSG_ParamB24) = params->b;
    *(LONG *)(msg + HIGHLIGHTMSG_ParamC28) = params->c;

    *(UWORD *)(msg + HIGHLIGHTMSG_StateWord52) = 0;
    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(msg, 0);

    *(LONG *)(msg + HIGHLIGHTMSG_ParamD32) = 0;
    ESQDISP_InitHighlightMessagePattern(msg);

    rp = (RastPort *)(msg + HIGHLIGHTMSG_RastPort60);
    _LVOInitRastPort(rp);

    *(SelectionParams **)(msg + HIGHLIGHTMSG_SelectionParams64) = params;
    _LVOSetFont(rp, Global_HANDLE_PREVUEC_FONT);
    _LVOSetDrMd(rp, 0);

    node = *(HighlightNodeFlags **)(msg + HIGHLIGHTMSG_NodePtr112);
    node->flags55 = 1;
    node->flags53 |= 1;

    _LVOPutMsg(ESQ_HighlightMsgPort, msg);
}
