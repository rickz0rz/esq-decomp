/* Debug hooks. In the faithful build these are no-ops. Historical use: DBGMARK
   appended a phase marker to dh1:dbg.log and DBGNUM overwrote dh1:hb.log with a
   heartbeat counter; DBGHEX/DBGLINE appended hex values. Used (2026-07) to bisect
   the AN_MemCorrupt guru to the four ESQIFF2_ShowAttentionOverlay pointer/arg bugs,
   and then the 8000 0003 address error to the arg-dropping JMPTBL wrapper
   GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult. Re-enable from git history if another
   runtime bisection is needed. DOS I/O is only legal in the MAIN task. */
void DBGMARK(const char *s) { (void)s; }
void DBGNUM(long n) { (void)n; }
void DBGHEX(long v) { (void)v; }
void DBGLINE(const char *tag, long a, long b, long c, long d)
{ (void)tag; (void)a; (void)b; (void)c; (void)d; }
void DBG_Enable(void) {}
void DBG_SerialFlush(void) {}
