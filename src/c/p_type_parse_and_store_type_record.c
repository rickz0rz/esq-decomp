/* RESTORES: P_TYPE_ParseAndStoreTypeRecord
 * MODULE:   modules/groups/b/a/p_typebb_p0.s
 * STATUS:   behavioural
 *
 * Parses a three-character code and a two-character value out of a record,
 * decides which group list they belong to, and replaces that list's entry.
 *
 * The SAME stack buffer is reused for both fields, terminated at a different
 * offset each time -- CLR.B at buf[3] after the three-character copy and at
 * buf[2] after the two-character one. Reusing one buffer is what the original
 * does; two buffers would change the frame.
 *
 * The code is masked to a byte with MOVEQ #0 / NOT.B / AND.L, which is the ~n
 * constant rule producing 255.
 *
 * The source pointer is ADVANCED between the two parses, by 3 then by 2, so the
 * second field is read from the character after the first.
 *
 * Group selection is a two-way compare against the primary and secondary group
 * codes, defaulting to 2 -- and 2 means "neither", so the function returns 0
 * without touching any list. Only groups 0 and 1 are stored.
 *
 * The list slot address is computed TWICE, once for the free and once for the
 * store, and parked in the argument area across the allocate call.
 *
 * 198 ref vs 196 got. Both copy calls with their PEA 3 and PEA 2 lengths, both
 * terminator CLR.B at their different offsets, both parse calls, the
 * MOVEQ #0 / NOT.B / AND.L byte mask, both pointer advances, the group
 * dispatch, the ASL.L #2 slot indexing at both sites, the free, the allocate
 * and the LEA cleanups all match in kind and size.
 *
 * SASC-MISMATCH: compare-direction
 *   ref:     1039....87ba b007      MOVE.B primary,D0 / CMP.B D7,D0
 *   got:     1239.... b200          MOVE.B primary,D1 / CMP.B D0,D1
 *   summary: the two group compares use the opposite register pairing and 6.51
 *            picks a different scratch register. Same two tests, same order,
 *            same sizes.
 *   scope:   program-wide register allocation. docs/compiler-version.md,
 *            "A third divergence: register allocation order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void  P_TYPE_FreeEntry(void *entry);
extern void *P_TYPE_AllocateEntry(long code, long value, char *text);

extern char TEXTDISP_PrimaryGroupCode;
extern char TEXTDISP_SecondaryGroupCode;
extern void *P_TYPE_PrimaryGroupListPtr[];

long P_TYPE_ParseAndStoreTypeRecord(char *text)
{
    char buf[16];
    long code;
    long value;
    long group;
    long stored = 0;

    STRING_CopyPadNul(buf, text, 3L);
    buf[3] = 0;
    code = PARSE_ReadSignedLongSkipClass3_Alt(buf) & 255;
    text += 3;

    STRING_CopyPadNul(buf, text, 2L);
    buf[2] = 0;
    value = PARSE_ReadSignedLongSkipClass3_Alt(buf);
    text += 2;

    if (TEXTDISP_PrimaryGroupCode == (char)code)
        group = 0;
    else if ((char)code == TEXTDISP_SecondaryGroupCode)
        group = 1;
    else
        group = 2;

    if (group != 2) {
        P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr[group]);
        P_TYPE_PrimaryGroupListPtr[group] =
            P_TYPE_AllocateEntry((long)(unsigned char)code, value, text);
        stored = 1;
    }

    return stored;
}
