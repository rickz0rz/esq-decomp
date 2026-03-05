typedef unsigned char UBYTE;
typedef signed long LONG;

typedef struct HighlightMsg {
    UBYTE raw[60];
} HighlightMsg;

void ESQDISP_InitHighlightMessagePattern(HighlightMsg *msg)
{
    LONG i;

    for (i = 0; i < 4; ++i) {
        msg->raw[55 + i] = (UBYTE)(i + 4);
    }
}
