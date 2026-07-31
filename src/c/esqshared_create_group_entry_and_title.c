/* RESTORES: ESQSHARED_CreateGroupEntryAndTitle
 * MODULE:   modules/groups/a/p/esqshared_p1.s
 * STATUS:   behavioural
 *
 * Allocates and initialises one channel entry: a 52-byte record and a 500-byte
 * title block, appended to whichever group the code selects. It is the function
 * the serial parser calls once per channel.
 *
 * THE ALLOCATION RESULT IS STORED STRAIGHT INTO THE TABLE AND THEN READ BACK,
 * rather than kept in a register. That matters because there is NO NULL CHECK
 * on either allocation -- the entry pointer is dereferenced immediately
 * afterwards. Out of memory here is a null dereference, in the original as
 * written.
 *
 * THE COUNT IS NOT INCREMENTED UNTIL THE END, so both tables are indexed by the
 * CURRENT count throughout and the entry being built is one past the last live
 * one. An early return leaves the allocation in the table but outside the
 * count, which leaks it.
 *
 * THE NAME IS COPIED WITH SPACES REMOVED, character by character, and then a
 * SINGLE SPACE and a terminator are appended -- so a name of all spaces becomes
 * exactly one space. The loop is driven by a length counted before it starts,
 * not by the terminator, so an embedded NUL is copied rather than stopping the
 * copy.
 *
 * The longest name seen so far is tracked in a global that other code uses for
 * column widths, and it is measured AFTER the space removal and the appended
 * space, so it includes that space.
 *
 * FOUR UNBOUNDED STRING COPIES. The name field is 11 bytes, the two tag fields
 * are 7 and 8, and the title name is 7 -- and all four are filled with a copy
 * that runs to the source terminator. Longer inputs overrun into the next
 * field. That is the original's behaviour; the struct below documents the
 * intended widths without enforcing them.
 *
 * THE TITLE SLOTS ARE CLEARED AND THE FLAGS SET TO 1 in ONE loop over 49
 * entries, which is why the two arrays are declared adjacent -- the original
 * indexes both from the same counter in the same pass.
 *
 * THE MUTATION STATE IS STICKY AT 2. The primary path sets it to 1 only if it
 * is not already 2; the secondary path sets it to 2 unconditionally. So once a
 * secondary entry has been created, the primary path stops signalling.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY -- 8 bytes of MOVEM/UNLK/RTS
 * sit outside it, so the corrected reference is 712.
 *
 * 704 ref vs 744 got, 26 differing regions -- 32 bytes over the corrected 712.
 * Both group arms with their four distinct line numbers, the 52 and 500 byte
 * sizes, the present flags and header codes, the defaults and anim-object
 * calls, the space-removing copy with its pre-counted length, the appended
 * space and terminator, the longest-name update, all four string copies, the
 * bit reversal, the six-byte clear, the combined flags-and-slots loop and the
 * sticky mutation state match in kind and size.
 *
 * THREE COUNTERS NEED `register`, and it is worth 12 bytes: the original keeps
 * the string length, the loop index and the measured name length all in D5,
 * reusing one register for three purposes. Declared as plain locals, 6.51
 * spills each to its own frame slot and reloads at every use (756 bytes).
 * Declaring all three `register` brings it to 744. Same lever as
 * wdisp_draw_weather_status_summary.c and
 * newgrid_find_next_entry_with_alt_markers.c.
 *
 * Hoisting the table index into a local was ALSO tried, since the original
 * computes `count * 4` once and reuses it for both tables and both read-backs.
 * It is size-NEUTRAL at 756 -- 6.51 already commons the subexpression -- so the
 * code below indexes the tables directly, which reads better.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe8 ... 2b40fffc   LINK.W A5,#-24 / MOVE.L D0,-4(A5)
 *   got:     the same slots addressed from A7
 *   summary: the frame class, and what remains after the register counters are
 *            declared. The original spills the entry and title pointers to A5
 *            slots and reads them back at each of the eleven use sites; 6.51
 *            does the same from A7, so the residual 32 bytes are in how the two
 *            re-form the table addresses rather than in the spills themselves.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct EsqNewEntry {                    /* 52 bytes */
    char          groupCode;            /* +0  */
    char          name[11];             /* +1  */
    char          f0[7];                /* +12 */
    char          f3[8];                /* +19 */
    unsigned char entryFlag;            /* +27 */
    char          bits[6];              /* +28 */
    char          tail[6];              /* +34 */
    char          pad40[12];
};

struct EsqNewTitle {                    /* 500 bytes */
    char          name[7];              /* +0  */
    unsigned char flags[49];            /* +7  */
    char         *slots[49];            /* +56 */
    char          pad252[246];
    char          groupCode;            /* +498 */
    char          pad499;
};

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                 long size, long flags);
extern void  ESQSHARED_InitEntryDefaults(struct EsqNewEntry *e);
extern void  ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(
                 struct EsqNewEntry *e);
extern void  ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(char *dst, char *src);

extern struct EsqNewEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct EsqNewTitle *TEXTDISP_PrimaryTitlePtrTable[];
extern struct EsqNewEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct EsqNewTitle *TEXTDISP_SecondaryTitlePtrTable[];

extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern char  TEXTDISP_PrimaryGroupHeaderCode;
extern char  TEXTDISP_SecondaryGroupHeaderCode;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern short TEXTDISP_MaxEntryTitleLength;
extern short TEXTDISP_GroupMutationState;

extern char Global_ESQPARS2_C_1[];
extern char Global_ESQPARS2_C_2[];
extern char Global_ESQPARS2_C_3[];
extern char Global_ESQPARS2_C_4[];

long ESQSHARED_CreateGroupEntryAndTitle(char groupCode, char entryFlag,
                                        char *f0, char *f1, char *f2,
                                        char *f3)
{
    struct EsqNewEntry *entry;
    struct EsqNewTitle *title;
    char *src;
    char *dst;
    register short n;
    register short len;
    register short i;

    if (groupCode == TEXTDISP_SecondaryGroupCode) {

        TEXTDISP_SecondaryEntryPtrTable[TEXTDISP_SecondaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_1, 299L,
                                                52L,
                                                MEMF_PUBLIC | MEMF_CLEAR);

        TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_SecondaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_2, 301L,
                                                500L,
                                                MEMF_PUBLIC | MEMF_CLEAR);

        TEXTDISP_SecondaryGroupPresentFlag = 1;
        TEXTDISP_SecondaryGroupHeaderCode  = groupCode;

        entry =
            TEXTDISP_SecondaryEntryPtrTable[TEXTDISP_SecondaryGroupEntryCount];
        title =
            TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_SecondaryGroupEntryCount];

    } else if (groupCode == TEXTDISP_PrimaryGroupCode) {

        TEXTDISP_PrimaryEntryPtrTable[TEXTDISP_PrimaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_3, 314L,
                                                52L,
                                                MEMF_PUBLIC | MEMF_CLEAR);

        TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_PrimaryGroupEntryCount] =
            ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_ESQPARS2_C_4, 315L,
                                                500L,
                                                MEMF_PUBLIC | MEMF_CLEAR);

        TEXTDISP_PrimaryGroupPresentFlag = 1;
        TEXTDISP_PrimaryGroupHeaderCode  = groupCode;

        entry = TEXTDISP_PrimaryEntryPtrTable[TEXTDISP_PrimaryGroupEntryCount];
        title = TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_PrimaryGroupEntryCount];

    } else {
        return 0;
    }

    ESQSHARED_InitEntryDefaults(entry);
    ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(entry);

    entry->groupCode = groupCode;

    src = f1;
    dst = entry->name;
    n   = (short)strlen(f1);

    while (n != 0) {
        if (*src != 32)
            *dst++ = *src;
        src++;
        n--;
    }

    *dst++ = 32;
    *dst   = 0;

    len = (short)strlen(entry->name);
    if (len > TEXTDISP_MaxEntryTitleLength)
        TEXTDISP_MaxEntryTitleLength = len;

    strcpy(entry->f0, f0);
    strcpy(entry->f3, f3);

    entry->entryFlag = entryFlag;

    ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(entry->bits, f2);

    for (i = 0; i < 6; i++)
        entry->tail[i] = 0;

    strcpy(title->name, f0);
    title->groupCode = groupCode;

    for (i = 0; i < 49; i++) {
        title->flags[i] = 1;
        title->slots[i] = 0;
    }

    if (TEXTDISP_PrimaryGroupCode == groupCode) {

        TEXTDISP_PrimaryGroupEntryCount++;

        if (TEXTDISP_GroupMutationState != 2)
            TEXTDISP_GroupMutationState = 1;

    } else if (groupCode == TEXTDISP_SecondaryGroupCode) {

        TEXTDISP_SecondaryGroupEntryCount++;
        TEXTDISP_GroupMutationState = 2;
    }

    return 0;
}
