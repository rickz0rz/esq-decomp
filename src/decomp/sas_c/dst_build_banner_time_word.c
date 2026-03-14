#include <exec/types.h>
extern LONG DST_BuildBannerTimeEntry(WORD lane, UBYTE slot_hint, WORD *out_word, ULONG out_dt);

LONG DST_BuildBannerTimeWord(WORD lane, LONG unused, UBYTE slot_hint)
{
    WORD out_word = 0;
    DST_BuildBannerTimeEntry(lane, slot_hint, &out_word, 0);
    (void)unused;
    return (LONG)out_word;
}
