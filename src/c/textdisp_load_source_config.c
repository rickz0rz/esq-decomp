/* RESTORES: TEXTDISP_LoadSourceConfig
 * MODULE:   modules/groups/b/a/textdisp3.s
 * STATUS:   behavioural
 *
 * 58 bytes against 58, ONE differing region, and that region is the call
 * encoding alone. Nothing else about this function differs from the original --
 * it is as close as SAS/C 6.51 can get, and it flips to exact on any compiler
 * that emits JSR (d16,PC) for a cross-unit call.
 *
 * Reproduces: the 302-entry table clear, both counter resets, and the parse of
 * the source-config INI. The loop counter is a `register long` because the
 * original keeps it in D7 and saves only D7 on entry.
 *
 * SASC-MISMATCH: cross-unit-call-width
 *   ref:     4ebab48e                   JSR (d16,PC)
 *   got:     61000000                   BSR.W
 *   summary: same size, different encoding; the class that blocks most
 *           otherwise-perfect restorations. One site.
 *   retest:  a compiler emitting 4EBA here takes this byte-exact unchanged.
 */
extern long  TEXTDISP_SourceConfigEntryTable[];
extern long  TEXTDISP_SourceConfigEntryCount;
extern char  TEXTDISP_SourceConfigFlagMask;
extern char  Global_STR_DF0_SOURCECFG_INI_2[];
extern void  PARSEINI_ParseIniBufferAndDispatch(char *path);

void TEXTDISP_LoadSourceConfig(void)
{
    register long i;

    for (i = 0; i < 302; i++)
        TEXTDISP_SourceConfigEntryTable[i] = 0;

    TEXTDISP_SourceConfigEntryCount = 0;
    TEXTDISP_SourceConfigFlagMask = 0;
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_2);
}
