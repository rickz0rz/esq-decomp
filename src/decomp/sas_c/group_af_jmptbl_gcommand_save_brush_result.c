/* JMPTBL passthrough for GCOMMAND_SaveBrushResult.
   The original ASM is `JMP GCOMMAND_SaveBrushResult` — a tail-call that preserves
   the caller's stack argument. GCOMMAND_SaveBrushResult takes a pointer (workPtr),
   so the C wrapper MUST forward that argument; a `(void)` wrapper would drop it and
   the callee would read a stale return address as workPtr (wild-pointer crash). */
extern void GCOMMAND_SaveBrushResult(void *workPtr);

void GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(void *workPtr)
{
    GCOMMAND_SaveBrushResult(workPtr);
}
