/* RESTORES: LADFUNC_BuildEntryBuffersOrDefault
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * Fills the caller's text and attribute buffers from an entry, or with blanks
 * and a default pen pair when the entry has no text.
 *
 * Both fills and both copies run COUNT + 1 times. The loops are SUBQ.L #1 / BCC
 * -- an UNSIGNED test entered from the bottom -- so the iteration where the
 * counter reaches zero still executes and the one that borrows stops it. That
 * extra byte is the terminator slot, which is why the blank path then writes an
 * explicit CLR.B at [limit * 40]. All four are therefore memset/memcpy of
 * count + 1, and writing them that way is worth 52 bytes: hand-written
 * `do { *dst++ = c; } while (n-- != 0);` loops emit 264 bytes against the
 * original's 214, while memset/memcpy/strcpy emit 212. AGENTS.md records that
 * memcpy of a plain byte array inlines to the original's loop shape; this is
 * the same rule applied to a fill.
 *
 * The blank fill uses 32, the space character.
 *
 * ED_TextLimit * 40 is recomputed THREE times in the blank path -- once for the
 * fill, once for the terminator and once for the attribute fill -- each through
 * the 32-bit multiply helper. The C below recomputes for the same reason.
 *
 * The default attribute byte comes from ComposePackedPenByte(2, 1), and its
 * byte result is widened before being used as the fill value.
 *
 * On the copy path the ATTRIBUTE length comes from the TEXT length -- the
 * strlen is taken on the text buffer after it is copied, and the same count
 * drives the attribute copy. The two buffers are therefore always the same
 * length.
 *
 * 214 ref vs 212 got. All three limit * 40 recomputations, the MOVEQ #32 blank,
 * the CLR.B terminator, the ComposePackedPenByte(2, 1) call with its
 * ADDQ.W #8 cleanup, the inline strcpy and the closing reflow call match in
 * kind and size. The 2 bytes are the A3/A5 class.
 */
#include <string.h>
extern unsigned char LADFUNC_ComposePackedPenByte(long a, long b);
extern void LADFUNC_ReflowEntryBuffers(char *text, char *attrs);

struct LadfuncBuildEntry {
    char  pad0[6];
    char *text6;                /* +6  */
    char *attrs10;              /* +10 */
};

extern struct LadfuncBuildEntry *LADFUNC_EntryPtrTable[];
extern long ED_TextLimit;

void LADFUNC_BuildEntryBuffersOrDefault(long index, char *text, char *attrs)
{
    unsigned char fill;

    if (LADFUNC_EntryPtrTable[index]->text6 == 0) {

        memset(text, 32, ED_TextLimit * 40 + 1);
        text[ED_TextLimit * 40] = 0;

        fill = LADFUNC_ComposePackedPenByte(2L, 1L);
        memset(attrs, fill, ED_TextLimit * 40 + 1);
        return;
    }

    strcpy(text, LADFUNC_EntryPtrTable[index]->text6);
    memcpy(attrs, LADFUNC_EntryPtrTable[index]->attrs10, strlen(text) + 1);

    LADFUNC_ReflowEntryBuffers(text, attrs);
}
