#include <exec/types.h>
typedef struct HighlightMsg {
    UBYTE pad_00[55];
    UBYTE pattern55[5];
} HighlightMsg;

void ESQDISP_InitHighlightMessagePattern(HighlightMsg *msg)
{
    LONG i;

    for (i = 0; i < 4; ++i) {
        msg->pattern55[i] = (UBYTE)(i + 4);
    }
}
