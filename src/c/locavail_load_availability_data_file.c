/* RESTORES: LOCAVAIL_LoadAvailabilityDataFile
 * MODULE:   modules/groups/a/y/locavail_p3.s
 * STATUS:   behavioural
 *
 * Loads DF0:LOCAVAIL.DAT and rebuilds both group filter states from it. The
 * file is a sequence of records, each introduced by the token "LA_VER", and the
 * loop keeps consuming them until a token fails to match or the stream ends.
 *
 * IT IS THE FILE-BACKED TWIN OF locavail_parse_filter_state_from_buffer.c --
 * same state and node layout, same four bounds, same letter mapping. The
 * differences are worth listing because they are all in the direction of LESS
 * validation:
 *
 *   - the letters are NOT casefolded here, so a lowercase 'g' is a parse error
 *     where the buffer parser would have accepted it
 *   - '0' and 'L' are not accepted at all; only 'G', 'I', 'T', 'U' and 'V'
 *   - the fields come from a tokenising reader rather than fixed-width slices
 *
 * A MISSING FILE IS NOT A FAILURE, and the two paths differ in an important
 * way. When the load fails, each group's chain is freed ONLY IF its code does
 * not already match -- so a second failed load costs nothing. When the load
 * succeeds, both chains are freed UNCONDITIONALLY before parsing. Reading the
 * failure path as unconditional would discard good state on every poll.
 *
 * THE END-OF-STREAM SENTINEL IS -1, NOT NULL. The reader answers 0xffffffff,
 * which the original forms with `MOVEA.W #$ffff,A0` -- a word move that
 * sign-extends. It is converted to a null at the two loop-level sites and
 * treated as a hard error at the one inside a record.
 *
 * THE RECORD IS ADOPTED BY CODE, NOT BY POSITION: a record whose code matches
 * neither group is parsed in full and then FREED. So the file may contain
 * records for groups that are not currently configured, and they cost work but
 * do nothing.
 *
 * A ZERO NODE COUNT IS VALID, exactly as in the buffer parser -- the allocation
 * returning zero is only an error when the count was nonzero.
 *
 * THE FAILURE FLAG IS TESTED AT BOTH LOOP HEADS and every error falls through
 * to the loop increment rather than breaking, so a bad node still finishes its
 * iteration.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY -- the 10-byte
 * MOVE.L/MOVEM/UNLK/RTS tail has its own label, so the corrected reference is
 * 758.
 *
 * 748 ref vs 760 got, 26 differing regions -- 2 bytes over the corrected 758.
 * The load with its -1 test, both conditional frees on the failure path and
 * both unconditional ones on the success path, the LA_VER token check, the
 * three-field record header, the node loop with all three bounds pairs and
 * their differing signedness, the per-node allocation, the five-way letter
 * chain, the code-based adoption with its three arms and the closing free
 * match in kind and size.
 *
 * SHORTINT WAS MEASURED AND IS EQUIDISTANT: 756 bytes, 2 UNDER the corrected
 * reference where the plain form is 2 over, with the same 26 regions. Nothing
 * to choose between them on size, so the plain form is used and the file needs
 * no scopts.txt entry. Sixth SHORTINT measurement in this tranche and the first
 * that came out a tie.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffcc ... 2b40ffe4   LINK.W A5,#-52 / MOVE.L D0,-28(A5)
 *   got:     the node pointer kept in a register across the field parses
 *   summary: the frame class, and almost fully cancelled here -- 2 bytes. The
 *            original spills the node pointer and reloads it at each of the six
 *            field stores; 6.51 keeps it live, and the saving is offset by the
 *            tokenising reader's call overhead.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LaNode {                         /* 10 bytes */
    unsigned char  id;                  /* +0 */
    char           pad1;
    short          time;                /* +2 */
    short          len;                 /* +4 */
    unsigned char *data;                /* +6 */
};

struct LaState {                        /* 24 bytes */
    char           code;                /* +0  */
    char           pad1;
    long           count;               /* +2  */
    char           tag;                 /* +6  */
    char           pad7[13];
    struct LaNode *nodes;               /* +20 */
};

extern long  GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(char *path);
extern char *GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void);
extern long  GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void);
extern long  GROUP_AY_JMPTBL_STRING_CompareNoCaseN(char *a, char *b, long n);
extern void  LOCAVAIL_FreeResourceChain(struct LaState *st);
extern void  LOCAVAIL_ResetFilterStateStruct(struct LaState *st);
extern long  LOCAVAIL_AllocNodeArraysForState(struct LaState *st);
extern void  LOCAVAIL_CopyFilterStateStructRetainRefs(struct LaState *dst,
                                                      struct LaState *src);
extern long __asm NEWGRID_JMPTBL_MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);

extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern void *Global_PTR_WORK_BUFFER;
extern char  LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load[];
extern char  LOCAVAIL_STR_LA_VER[];
extern char  Global_STR_LOCAVAIL_C_7[];
extern char  Global_STR_LOCAVAIL_C_8[];

long LOCAVAIL_LoadAvailabilityDataFile(struct LaState *group1,
                                       struct LaState *group2)
{
    struct LaState  st;
    struct LaNode  *node;
    char *tok;
    void *buf;
    long  ok;
    long  len;
    long  i;
    long  j;
    short c;

    ok  = 1;
    buf = 0;
    len = 0;

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(
            LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load) == -1) {

        if (group1->code != TEXTDISP_PrimaryGroupCode) {
            LOCAVAIL_FreeResourceChain(group1);
            group1->code = TEXTDISP_PrimaryGroupCode;
        }

        if (group2->code != TEXTDISP_SecondaryGroupCode) {
            LOCAVAIL_FreeResourceChain(group2);
            group2->code = TEXTDISP_SecondaryGroupCode;
        }

        return 0;
    }

    LOCAVAIL_FreeResourceChain(group1);
    group1->code = TEXTDISP_PrimaryGroupCode;

    LOCAVAIL_FreeResourceChain(group2);
    group2->code = TEXTDISP_SecondaryGroupCode;

    len = Global_REF_LONG_FILE_SCRATCH;
    buf = Global_PTR_WORK_BUFFER;

    tok = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
    if (tok == (char *)-1)
        tok = 0;

    while (ok && tok != 0) {

        if (GROUP_AY_JMPTBL_STRING_CompareNoCaseN(tok, LOCAVAIL_STR_LA_VER,
                                                  6L) != 0)
            break;

        LOCAVAIL_ResetFilterStateStruct(&st);

        st.code  = (char)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
        st.count = GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();

        tok    = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
        st.tag = *tok;

        if (LOCAVAIL_AllocNodeArraysForState(&st) == 0) {

            if (st.count != 0)
                ok = 0;

        } else {

            for (i = 0; ok && i < st.count; i++) {

                node = &st.nodes[i];

                node->id = (unsigned char)
                    GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();

                if (node->id == 0 || node->id >= 100) {
                    ok = 0;
                    continue;
                }

                node->time = (short)
                    GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();

                if (node->time <= 0 || node->time >= 0xe11) {
                    ok = 0;
                    continue;
                }

                node->len = (short)
                    GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();

                if (node->len <= 0 || node->len >= 100) {
                    ok = 0;
                    continue;
                }

                node->data = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                                 Global_STR_LOCAVAIL_C_7, 786L,
                                 (long)node->len,
                                 MEMF_PUBLIC | MEMF_CLEAR);

                if (node->data == 0) {
                    ok = 0;
                    continue;
                }

                tok = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();

                if (tok == (char *)-1) {
                    ok = 0;
                    continue;
                }

                for (j = 0; ok && j < (long)node->len; j++) {

                    c = (short)*tok++;

                    switch (c) {

                    case 71:
                        node->data[j] = 2;
                        break;

                    case 73:
                        node->data[j] = 4;
                        break;

                    case 84:
                        node->data[j] = 3;
                        break;

                    case 85:
                        node->data[j] = 0;
                        break;

                    case 86:
                        node->data[j] = 1;
                        break;

                    default:
                        node->data[j] = 0;
                        ok = 0;
                        break;
                    }
                }
            }
        }

        if (ok) {
            if (st.code == TEXTDISP_PrimaryGroupCode)
                LOCAVAIL_CopyFilterStateStructRetainRefs(group1, &st);
            else if (st.code == TEXTDISP_SecondaryGroupCode)
                LOCAVAIL_CopyFilterStateStructRetainRefs(group2, &st);
            else
                LOCAVAIL_FreeResourceChain(&st);
        } else {
            LOCAVAIL_FreeResourceChain(&st);
        }

        tok = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
        if (tok == (char *)-1)
            tok = 0;
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LOCAVAIL_C_8, 897L, buf,
                                           len + 1);

    return ok;
}
