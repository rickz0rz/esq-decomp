/* RESTORES: ED1_DrawStatusLine1
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd4303900005e8448c02f00487900001f16486dffd74eba3e362079000086fe41e8000a487800d2486dffd72f084eba5f524e5d4e75
 *   got:     9efc002c30390000000048c02f00487900000000486f000b61000000207900000000d0fc000a487800d2486f00132f08610000004fef0018defc002c4e754e71
 *   summary: The original builds a stack frame for the 41-byte local buffer
 *            (LINK.W A5,#-44 ... UNLK A5) and addresses it as -41(A5). SAS/C 6.51
 *            builds no frame: it adjusts A7 directly (SUBA.W #44,A7 / ADDA.W
 *            #44,A7) and addresses the buffer as 11(A7), which also forces an
 *            extra 4FEF0018 argument cleanup. 56 bytes vs 64.
 *   scope:   Every function with a local array. LINK.W A5 appears 364 times in
 *            the original against exactly one MOVE.L A5,-(A7), i.e. the original
 *            compiler reserves A5 as a dedicated frame pointer and never
 *            allocates it as a register variable. That is the same root cause as
 *            the A3-vs-A5 register-allocation divergence.
 *   tried:   DEBUG=FULL, DEBUG=LINE, DEBUG=SYMBOL, STKEXT, PROFILE, OPTIMIZE --
 *            none make 6.51 reserve A5.
 *   retest:  a candidate compiler that emits LINK.W A5 here will also pass the
 *            A3 acceptance test; the two are one property.
 */
extern short ESQPARS2_StateIndex;
extern char  ED2_FMT_SCRSPD_PCT_D[];
extern void *WDISP_DisplayContextBase;
extern void  WDISP_SPrintf(char *buf, char *fmt, long v);
extern void  TLIBA3_DrawCenteredWrappedTextLines(void *rp, char *s, long y);
void ED1_DrawStatusLine1(void)
{
    char statusLine[41];
    WDISP_SPrintf(statusLine, ED2_FMT_SCRSPD_PCT_D,
                                  (long)ESQPARS2_StateIndex);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, statusLine, 210);
}
