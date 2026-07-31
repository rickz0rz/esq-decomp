/* RESTORES: LOCAVAIL_ParseFilterStateFromBuffer
 * MODULE:   modules/groups/a/y/locavail_p2_locavail_parsefilterstatefrombuffer.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT (see src/c/scopts.txt)
 *
 * Parses an availability record into a filter state: a header, then a count,
 * then that many nodes, each with an id, a time, a length and that many
 * single-character availability codes.
 *
 * EVERY NUMERIC FIELD IS PARSED THE SAME WAY -- copy N characters into a shared
 * scratch buffer, terminate, and hand it to the signed-long reader. The field
 * widths differ (2, 2, 4, 2) and the buffer is reused for all four, which is
 * why the terminator is written at the loop's exit index rather than at a fixed
 * one.
 *
 * THE PARSE BUILDS INTO A LOCAL AND ONLY THEN OVERWRITES THE CALLER'S STATE.
 * On success the caller's chain is freed and the local copied over it; on
 * failure the LOCAL's chain is freed and the caller keeps what it had. So a
 * malformed record cannot corrupt a good state -- but it does allocate and free
 * along the way.
 *
 * THE FAILURE FLAG IS CHECKED AT BOTH LOOP HEADS, not at the point of failure.
 * Every error sets it and then falls through to the loop increment, so the
 * current iteration finishes its bookkeeping before the loop notices. Writing
 * the errors as `break` would skip that increment.
 *
 * A ZERO COUNT IS NOT AN ERROR. When the node allocation returns zero the code
 * only fails if the count was nonzero -- an empty record is valid and allocates
 * nothing.
 *
 * THE FOUR BOUNDS ARE ASYMMETRIC. The id is compared UNSIGNED against 0 and 100
 * (`BLS` / `BCC`), the time SIGNED against 0 and 0xe11, the length SIGNED
 * against 0 and 100. 0xe11 is 3601 -- one more than the seconds in an hour --
 * so the time field is a second count.
 *
 * THE AVAILABILITY CODES ARE SEVEN LETTERS MAPPED TO FIVE VALUES, casefolded
 * first: 'G' -> 2, 'I' -> 4, 'T' -> 3, 'V' -> 1, and '0', 'L' and 'U' all ->
 * 0. Anything else stores 0 AND fails the record. So three distinct letters
 * mean "unavailable" and every other character is a parse error even though it
 * stores the same value.
 *
 * That chain is `SUBQ #48 / SUB #23 / SUBQ #2 / SUBQ #3 / SUBQ #8 / SUBQ #1 /
 * SUBQ #1` -- seven subtractions consuming a running difference, which is the
 * chained-subtract dispatch AGENTS.md describes.
 *
 * SHORTINT IS LOAD-BEARING HERE, unlike the other four places it was tried in
 * this tranche. The reference is 690 and, correcting for the 10-byte shared
 * _Return epilogue, 700. The plain form gives 680 -- 20 under. SHORTINT gives
 * 688 -- 12 under, with the same 26 regions. Closer on the only size measure
 * available, so it is used. Fifth data point for the rule that SHORTINT has to
 * be measured per file rather than inferred from the dispatch shape.
 *
 * 690 ref vs 688 got, 26 differing regions. The header read with its casefold
 * and tag lookup, all four numeric field parses with their differing widths,
 * the zero-count exemption, all three bounds pairs with their differing
 * signedness, the per-node allocation, the seven-way code chain with its five
 * outcomes, both loop-head failure checks and both cleanup arms match in kind
 * and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffcc ... 2b48ffe4   LINK.W A5,#-52 / MOVE.L A0,-28(A5)
 *   got:     the node pointer kept in a register across the field parses
 *   summary: the frame class. The original spills the node pointer and reloads
 *            it at each of the six field stores; 6.51 keeps it live. That is
 *            the 12 bytes this comes in under.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LfNode {                         /* 10 bytes */
    unsigned char  id;                  /* +0 */
    char           pad1;
    short          time;                /* +2 */
    short          len;                 /* +4 */
    unsigned char *data;                /* +6 */
};

struct LfState {                        /* 24 bytes */
    char            code;               /* +0  */
    char            pad1;
    long            count;              /* +2  */
    char            tag;                /* +6  */
    char            pad7[13];
    struct LfNode  *nodes;              /* +20 */
};

extern void  LOCAVAIL_ResetFilterStateStruct(struct LfState *st);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern long  NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  LOCAVAIL_AllocNodeArraysForState(struct LfState *st);
extern long __asm NEWGRID_JMPTBL_MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  LOCAVAIL_FreeResourceChain(struct LfState *st);
extern void  LOCAVAIL_CopyFilterStateStructRetainRefs(struct LfState *dst,
                                                      struct LfState *src);

extern unsigned char WDISP_CharClassTable[];
extern char LOCAVAIL_TAG_FV[];
extern char Global_STR_LOCAVAIL_C_6[];

long LOCAVAIL_ParseFilterStateFromBuffer(char *buf, struct LfState *dest)
{
    struct LfState  st;
    struct LfNode  *node;
    char  scratch[27];
    long  ok;
    long  c;
    long  v;
    long  i;
    long  j;

    ok = 1;

    LOCAVAIL_ResetFilterStateStruct(&st);

    st.code = *buf++;

    scratch[0] = *buf++;
    c = (long)scratch[0];

    if (WDISP_CharClassTable[c] & 2)
        c = c - 32;

    scratch[0] = (char)c;

    if (GROUP_AS_JMPTBL_STR_FindCharPtr(LOCAVAIL_TAG_FV,
                                        (long)scratch[0]) == 0) {
        ok = 0;
        goto finish;
    }

    st.tag = scratch[0];

    for (i = 0; i < 2; i++)
        scratch[i] = *buf++;
    scratch[i] = 0;

    st.count = NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);

    if (LOCAVAIL_AllocNodeArraysForState(&st) == 0) {
        if (st.count != 0)
            ok = 0;
        goto finish;
    }

    for (i = 0; ok && i < st.count; i++) {

        if (*buf++ != 18) {
            ok = 0;
            continue;
        }

        node = &st.nodes[i];

        for (j = 0; j < 2; j++)
            scratch[j] = *buf++;
        scratch[j] = 0;

        v = NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        node->id = (unsigned char)v;

        if (node->id == 0 || node->id >= 100) {
            ok = 0;
            continue;
        }

        for (j = 0; j < 4; j++)
            scratch[j] = *buf++;
        scratch[j] = 0;

        v = NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        node->time = (short)v;

        if (node->time <= 0 || node->time >= 0xe11) {
            ok = 0;
            continue;
        }

        for (j = 0; j < 2; j++)
            scratch[j] = *buf++;
        scratch[j] = 0;

        v = NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        node->len = (short)v;

        if (node->len <= 0 || node->len >= 100) {
            ok = 0;
            continue;
        }

        node->data = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                         Global_STR_LOCAVAIL_C_6, 341L, (long)node->len,
                         MEMF_PUBLIC | MEMF_CLEAR);

        if (node->data == 0) {
            ok = 0;
            continue;
        }

        for (j = 0; ok && j < (long)node->len; j++) {

            scratch[0] = *buf++;
            c = (long)scratch[0];

            if (WDISP_CharClassTable[c] & 2)
                c = (long)scratch[0] - 32;

            switch ((short)c) {

            case 71:
                node->data[j] = 2;
                break;

            case 73:
                node->data[j] = 4;
                break;

            case 84:
                node->data[j] = 3;
                break;

            case 86:
                node->data[j] = 1;
                break;

            case 48:
            case 76:
            case 85:
                node->data[j] = 0;
                break;

            default:
                node->data[j] = 0;
                ok = 0;
                break;
            }
        }
    }

finish:
    if (ok) {
        LOCAVAIL_FreeResourceChain(dest);
        LOCAVAIL_CopyFilterStateStructRetainRefs(dest, &st);
    } else {
        LOCAVAIL_FreeResourceChain(&st);
    }

    return ok;
}
