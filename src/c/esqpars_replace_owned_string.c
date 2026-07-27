/* RESTORES: ESQPARS_ReplaceOwnedString
 * MODULE:   modules/groups/a/n/esqpars.s
 * STATUS:   behavioural
 *
 * 148 bytes in the original, 156 emitted, 19 differing regions.
 *
 * This is the ownership primitive fifteen other restorations in this directory
 * call, so its semantics are worth stating precisely:
 *
 *   - It ALWAYS frees the old string when one is given, before doing anything
 *     with the new one. Callers pass 0 as the new string purely to free.
 *   - A null new string returns 0 after that free.
 *   - An EMPTY new string also returns 0 -- the length-plus-NUL comes to 1 and
 *     that is rejected. So replacing with "" is the same as replacing with null,
 *     and no one-byte allocation is ever made.
 *   - Under 10000 bytes free it silently returns 0 without attempting the
 *     allocation, having already freed the old string. The caller's pointer is
 *     therefore cleared rather than left dangling, which is why every caller can
 *     safely write the result straight back over its own field.
 *
 * That last property is what makes the ubiquitous
 * `x = ReplaceOwnedString(new, x)` idiom safe under memory pressure, and is worth
 * knowing before anyone "improves" the low-memory path to return the old pointer.
 *
 * SASC-MISMATCH: availmem-signedness
 *   summary: The comparison is forced signed with a cast, as in
 *            disptext_append_to_buffer.c -- AvailMem returns ULONG so the natural
 *            expression emits BLS where the original has BLE.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls. Most of the 19
 *            regions are register allocation around the two inlined strlens.
 */
#include <exec/memory.h>
#include <proto/exec.h>
#include <string.h>

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  ESQIFF_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern char Global_STR_ESQPARS_C_5[];
extern char Global_STR_ESQPARS_C_6[];

char *ESQPARS_ReplaceOwnedString(char *newstr, char *old)
{
    register long newLen;
    register long oldLen;
    char *p;

    if (old) {
        oldLen = (long)strlen(old) + 1;
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_5, 1081, old,
                                              oldLen);
    }

    if (newstr == 0)
        return 0;

    newLen = (long)strlen(newstr) + 1;
    if (newLen == 1)
        return 0;

    p = 0;
    if ((long)AvailMem(MEMF_PUBLIC) > 0x2710)
        p = ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQPARS_C_6, 1100,
                                                newLen, MEMF_PUBLIC);
    if (p)
        strcpy(p, newstr);

    return p;
}
