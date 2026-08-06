/* RESTORES: LADFUNC_AllocBannerRectEntries
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc2f077e00702ebe806c362007e58041f900009fc4d1c02f3c000100014878000e4878007448790000696a2f4800144eba3e804fef0010206f00042080528760c42e1f4e5d4e75
 *   got:     594f2f077e00702ebe806c362007e58041f900000000d1c02f3c000100014878000e487800744879000000002f480014610000004fef0010206f00042080528760c42e1f584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *LADFUNC_EntryPtrTable[];
extern char *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
#define MEMF_PUBLIC 1
#define MEMF_CLEAR  65536
void LADFUNC_AllocBannerRectEntries(void)
{
    long i;

    for (i = 0; i < 46; i++)
        LADFUNC_EntryPtrTable[i] =
            MEMORY_AllocateMemory("LADFUNC.c", 116, 14,
                                                 MEMF_PUBLIC + MEMF_CLEAR);
}
