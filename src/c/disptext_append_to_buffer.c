/* RESTORES: DISPTEXT_AppendToBuffer
 * MODULE:   modules/groups/a/h/disptext.s
 * STATUS:   behavioural
 *
 * 210 bytes in the original, 184 emitted, only FIVE differing regions.
 *
 * Reproduces: the empty-buffer path that simply hands the string to
 * ReplaceOwnedString, the grow path that measures both strings with inlined
 * strlen and allocates their sum plus one, the AvailMem guard that skips the
 * allocation entirely below 10000 bytes free, the copy-then-append into the new
 * buffer, the release of the old buffer through ReplaceOwnedString(0, ...), and
 * the booleanised return (SNE / NEG.B / EXT.W / EXT.L).
 *
 * NOTE the AvailMem comparison must be forced signed. AvailMem() is declared
 * returning ULONG, so `AvailMem(...) > 0x2710` emits BLS (unsigned); the original
 * emits BLE (signed). Casting to long reproduces it:
 *
 *     if ((long)AvailMem(MEMF_PUBLIC) > 0x2710)
 *
 * The two differ only for values above 2GB free, which no Amiga of this era had
 * -- but the emitted byte differs, and matching it costs nothing.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. The single new-buffer pointer stays in a
 *            register, which is most of the -26.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include <exec/memory.h>
#include "esq-exec.h"
#include <string.h>

extern void *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern char *DISPTEXT_TextBufferPtr;
extern char Global_STR_DISPTEXT_C_1[];

long DISPTEXT_AppendToBuffer(char *src)
{
    char *newBuf;
    register long total;

    newBuf = 0;

    if (DISPTEXT_TextBufferPtr) {
        total = (long)strlen(DISPTEXT_TextBufferPtr) + (long)strlen(src) + 1;
        if ((long)AvailMem(MEMF_PUBLIC) > 0x2710)
            newBuf = MEMORY_AllocateMemory(Global_STR_DISPTEXT_C_1,
                                                           127, total, MEMF_PUBLIC);
        if (newBuf) {
            strcpy(newBuf, DISPTEXT_TextBufferPtr);
            STRING_AppendAtNull(newBuf, src);
            ESQPARS_ReplaceOwnedString(0, DISPTEXT_TextBufferPtr);
            DISPTEXT_TextBufferPtr = newBuf;
        }
    } else {
        DISPTEXT_TextBufferPtr =
            ESQPARS_ReplaceOwnedString(src, DISPTEXT_TextBufferPtr);
    }

    return DISPTEXT_TextBufferPtr != 0;
}
