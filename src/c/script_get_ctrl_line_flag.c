/* RESTORES: SCRIPT_GetCtrlLineFlag
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT
 *
 * Returns the CTRL line asserted flag. 14 bytes both ways; a single opcode
 * differs.
 *
 * SASC-MISMATCH: return-value-width
 *   ref:     2f07 3e39<abs> 2007 2e1f 4e75   (MOVE.L D7,D0)
 *   got:     2f07 3e39<abs> 3007 2e1f 4e75   (MOVE.W D7,D0)
 *   summary: The original loads the 16-bit global into D7 and returns the FULL
 *            32-bit register, so the upper half carries whatever the caller left
 *            there -- callers evidently use only the low word. SAS/C returns an
 *            int as MOVE.W under SHORTINT, or widens with EXT.L without it;
 *            neither reproduces an unextended MOVE.L.
 *   tried:   int/long/short return types, int/long/short locals, with and
 *            without SHORTINT, returning the global directly.
 *   retest:  needs a compiler that returns a 16-bit value in the full D0 without
 *            extending. Faithfully reproducing the stale upper half may not be
 *            expressible in C at all, in which case leave this one in assembly.
 */
extern short SCRIPT_CtrlLineAssertedFlag;

int SCRIPT_GetCtrlLineFlag(void)
{
    int flag = SCRIPT_CtrlLineAssertedFlag;

    return flag;
}
