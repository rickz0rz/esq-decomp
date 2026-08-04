/* RESTORES: ESQDISP_FillProgramInfoHeaderFields
 * MODULE:   modules/groups/a/n/esqdispb_p0.s
 * STATUS:   behavioural
 *
 * Fills six header fields of a program-info record and pads a two-character
 * tag. Six parameters, and their widths are read off the stack offsets rather
 * than guessed: an argument slot is always a longword, so a MOVE.B at slot+3
 * is a char and a MOVE.W at slot+2 is a short.
 *
 *   28(A7) long   record pointer
 *   35(A7) byte   char   -> +40
 *   38(A7) word   short  -> +46
 *   43(A7) byte   char   -> +41
 *   47(A7) byte   char   -> +42
 *   48(A7) long   source pointer for the tag
 *
 * NOTE ON THE REFERENCE LENGTH. The last instruction in the extract is
 * CLR.B 45(A3) with no RTS, because the epilogue carries its own label
 * (ESQDISP_FillProgramInfoHeaderFields_Return) and refbytes.py extracts label
 * to label. So the 72 bytes EXCLUDE the MOVEM/RTS, which a C restoration always
 * emits. Add the epilogue back before judging any delta -- see AGENTS.md,
 * "A _Return label means the reference bytes stop early".
 *
 * 72 raw ref vs 84 got, so the real comparison is 78 against 84 once the
 * 6-byte epilogue (4cdf28f4 / 4e75) is added back. Both remaining items are
 * known classes and together they are exactly the 6 bytes.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     1e2f0023 3c2f0026 1a2f002b 182f002f   D7, D6, D5, D4
 *   got:     182f0033 1a2f002f 3c2f002a 1e2f0027   D4, D5, D6, D7
 *   summary: the original loads its parameters in DESCENDING register order,
 *            6.51 in ascending. Same four loads, same widths, same slots,
 *            reversed. Costs nothing; it just moves the first divergence to
 *            byte 2 and makes the region count useless.
 *   scope:   program-wide. Already recorded in docs/compiler-version.md,
 *            "Parameter and case layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: byte-store-through-d0
 *   ref:     17470028                MOVE.B D7,40(A3)                (4 bytes, x3)
 *   got:     1007 1b400028           MOVE.B D7,D0 / MOVE.B D0,40(A5) (6 bytes, x3)
 *   summary: for each of the three char fields the original stores the
 *            parameter register straight to the record; 6.51 copies it to D0
 *            first and stores from there. Three sites, 2 bytes each, which is
 *            the whole 6-byte delta. The short store (3746002e / 3b46002e) does
 *            NOT do this, so it is specific to the byte case.
 *   tried:   nothing from the source side -- the fields are already plain char
 *            assignments from char parameters.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void STRING_CopyPadNul(char *dst, char *src, long n);

struct EsqDispProgramInfo {
    char          pad0[40];
    unsigned char kind;      /* +40 */
    unsigned char flag41;    /* +41 */
    unsigned char flag42;    /* +42 */
    char          tag[2];    /* +43 */
    char          tagPad;    /* +45 */
    short         value46;   /* +46 */
};

void ESQDISP_FillProgramInfoHeaderFields(struct EsqDispProgramInfo *e, char kind,
                                         short value, char flag41, char flag42,
                                         char *src)
{
    if (e == 0)
        return;

    e->kind    = kind;
    e->value46 = value;
    e->flag41  = flag41;
    e->flag42  = flag42;
    STRING_CopyPadNul(e->tag, src, 2L);
    e->tagPad  = 0;
}
