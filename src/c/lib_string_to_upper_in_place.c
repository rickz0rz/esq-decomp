/* RESTORES: STRING_ToUpperInPlace
 * MODULE:   modules/submodules/unknown4.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Uppercases a string in place and returns the pointer it
 * was given.
 *
 * IT IS A FAITHFUL RESTORATION, NOT AN ANALOGUE, AND THE FIRST VERSION OF THIS
 * FILE WAS WRONG TO SAY OTHERWISE. That version claimed SAS/C's character-class
 * table was unreachable from C and tested `c >= 'a' && c <= 'z'` instead. The
 * table is reachable. `Global_CharClassTable` is the equate -1007, an offset
 * from A4, and A4 is `_Global_REF_LONG_FILE_SCRATCH` -- an ordinary DATA label,
 * loaded by ESQ_StartupEntry, sitting at DATA offset 32768. Resolving the offset
 * against the data map lands exactly on `_WDISP_CharClassTable`, which is in
 * src/data/wdisp_p1.s and which `cleanup_build_aligned_status_line.c` was
 * already indexing directly.
 *
 * The lesson is worth more than the function: **an A4-relative symbol in this
 * program is not runtime state hidden in a library, it is a named address in our
 * own DATA section.** Before writing an analogue for one, resolve
 * `_Global_REF_LONG_FILE_SCRATCH + <equate>` against the data map and look for
 * the label.
 *
 * BIT 1 IS THE LOWERCASE FLAG and the original tests it with `BTST #1`. The
 * table is indexed straight from the label with no adjustment, which is what the
 * original's `0(A0,D0.L)` does and what the other C reader of this table does.
 *
 * THE SUBTRACTION IS DONE ON A ZERO-EXTENDED LONG in the original
 * (`MOVEQ #0,D1 / MOVE.B D0,D1 / SUB.L D2,D1`) and stored back as a byte, which
 * is what `(unsigned char)(*p - 32)` does.
 *
 * IT RETURNS THE ORIGINAL POINTER, held in A3 across the whole loop, not the end
 * of the string.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_CharClassTable(A4),A0   16-bit displacement off A4
 *   got:     an absolute reference to _WDISP_CharClassTable
 *   summary: the original addresses the table through the near-data base; a
 *            DATA=FAR build addresses every global absolutely. Same table, same
 *            byte, 2 bytes more per reference.
 *   scope:   program-wide, and the reason DATA=FAR is set at all.
 *   retest:  a build using SAS/C near data, which this project does not use.
 */
extern unsigned char WDISP_CharClassTable[];

char *STRING_ToUpperInPlace(char *s)
{
    unsigned char *p = (unsigned char *)s;

    while (*p != 0) {
        if (WDISP_CharClassTable[*p] & 2)
            *p = (unsigned char)(*p - 32);
        p++;
    }

    return s;
}
