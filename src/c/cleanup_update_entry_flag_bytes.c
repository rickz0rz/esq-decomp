/* RESTORES: CLEANUP_UpdateEntryFlagBytes
 * MODULE:   modules/groups/a/e/cleanup4.s
 * STATUS:   behavioural
 *
 * Reads two hex-digit flag characters out of an entry's animation field and
 * stores their values, falling back to a default string when the entry has no
 * field.
 *
 * The fallback is a COPY into a stack buffer, and the pointer is then
 * redirected at it -- so both branches leave one pointer to read the two
 * characters through. The copy is an inline strcpy.
 *
 * The hex test is bit 7 of WDISP_CharClassTable indexed by the character, which
 * AGENTS.md records as the hex-digit bit of that table. A non-hex character
 * gives 255, reached as MOVEQ #0 / NOT.B -- the ~n constant rule.
 *
 * Both characters are SIGN-extended before indexing (EXT.W then EXT.L), so the
 * field is signed char and a high-bit character indexes below the table. That
 * is what the original does.
 *
 * The two halves are independent: the second is read through a FRESH load of
 * the pointer from its frame slot, not from the register the first left behind.
 *
 * 190 ref vs 176 got. Both BTST #7 class-table tests, both hex-digit calls with
 * their ADDQ.W #4 cleanups, both EXT.W / EXT.L character widenings, the inline
 * strcpy of the fallback and the PEA 7 field selector all match in kind and
 * size.
 *
 * SASC-MISMATCH: set-byte-vs-not
 *   ref:     7200 4601 13c1....    MOVEQ #0,D1 / NOT.B D1 / MOVE.B D1,global
 *   got:     50f9....              ST global
 *   summary: for the 255 fallback the original builds the value in a register
 *            with the ~n rule and stores it; 6.51 emits ST, which sets the byte
 *            to 0xFF directly. Same stored value, 4 bytes cheaper, at both
 *            sites. This is the reverse direction from the usual constant
 *            class -- here 6.51 has an instruction the original did not reach
 *            for.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff0 ... 2b40fffc ... 206dfffc (twice) ... 4e5d
 *   got:     9efc0010 ... 2640 ... 47ef000d
 *   summary: the original parks the field pointer in a frame slot and reloads
 *            it before each of the two halves; 6.51 keeps it in an address
 *            register. The frame plus the two reloads is the rest.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern char *COI_GetAnimFieldPointerByMode(void *entry, long mode, long which);
extern unsigned char LADFUNC_ParseHexDigit(long ch);

extern unsigned char WDISP_CharClassTable[];
extern char CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY[];
extern unsigned char DISPTEXT_InsetNibblePrimary;
extern unsigned char DISPTEXT_InsetNibbleSecondary;

void CLEANUP_UpdateEntryFlagBytes(void *entry, short mode)
{
    char  fallback[15];
    char *field;

    field = COI_GetAnimFieldPointerByMode(entry, (long)mode, 7L);

    if (field == 0) {
        strcpy(fallback, CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY);
        field = fallback;
    }

    if (WDISP_CharClassTable[(long)field[6]] & 0x80)
        DISPTEXT_InsetNibblePrimary =
            LADFUNC_ParseHexDigit((long)field[6]);
    else
        DISPTEXT_InsetNibblePrimary = 255;

    if (WDISP_CharClassTable[(long)field[7]] & 0x80)
        DISPTEXT_InsetNibbleSecondary =
            LADFUNC_ParseHexDigit((long)field[7]);
    else
        DISPTEXT_InsetNibbleSecondary = 255;
}
