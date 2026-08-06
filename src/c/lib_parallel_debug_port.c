/* RESTORES: PARALLEL_WriteCharStackArg,
 *           PARALLEL_WriteCharD0,
 *           PARALLEL_WriteStringStackArg,
 *           PARALLEL_WriteStringLoop,
 *           PARALLEL_WaitReady,
 *           PARALLEL_CheckReady,
 *           PARALLEL_RawDoFmtArgPtr,
 *           PARALLEL_RawDoFmtStackArgs,
 *           PARALLEL_RawDoFmtCommon,
 *           PARALLEL_JMPTBL_RawDoFmt,
 *           PARALLEL_RawDoFmtWithData,
 *           PARALLEL_WriteCharHwStackArg,
 *           PARALLEL_WriteCharHw,
 *           PARALLEL_RawDoFmt,
 *           PARALLEL_CheckReadyStub
 * MODULE:   modules/submodules/unknown42.s   (14 of its 16 labels)
 * STATUS:   behavioural
 *
 * A debug printer that bit-bangs characters out of the PARALLEL PORT, and the
 * cheapest possible one: it writes straight to the CIA-A port B data register
 * and busy-waits on the BUSY line in CIA-B port A. There is no parallel.device
 * anywhere in it. It is what a developer reaches for when the machine is too
 * broken to run a serial handler.
 *
 * The other two labels in this module are the utility.library date thunks,
 * restored in lib_clock_utility_thunks.c. They share a module and nothing else.
 *
 * ONLY ONE ENTRY IS REACHED: PARALLEL_RawDoFmtStackArgs, from
 * modules/submodules/unknown2a.s. Every other label in the family has zero
 * references anywhere in src/modules, src/data or src/c.
 *
 * FIVE STACK-ARGUMENT HEADS CARRIED NO LABEL UNTIL 2026-08-04, and they are the
 * shape of this whole module: each routine has a head that reads its argument
 * off the STACK and falls into a labelled entry that expects it in a REGISTER.
 * So the labels name the register form and the unnamed blocks are the stack
 * form. Labelling the five is byte-neutral; test-hash.sh and build-split.sh
 * both pass across the change. The names are ours.
 *
 * ONE LOCAL LABEL HAD TO BECOME GLOBAL, and this is worth knowing before
 * labelling anything in the middle of a module. `.lab_JMPTBL_PARALLEL_RawDoFmt`
 * belonged to PARALLEL_RawDoFmtCommon's scope, and inserting a global label
 * after it put the later `BSR.S` in a different scope: vasm then reports
 * `undefined symbol <_PARALLEL_RawDoFmtWithData .lab_JMPTBL_PARALLEL_RawDoFmt>`.
 * Promoting it to PARALLEL_JMPTBL_RawDoFmt is byte-neutral, because a label
 * emits nothing and the branch width was already explicit.
 *
 * THE A2 SET IN RawDoFmtCommon IS DEAD. It loads PARALLEL_WriteCharD0 as the
 * PutChProc, then calls through to PARALLEL_RawDoFmt, which loads
 * PARALLEL_WriteCharHw over it before calling exec. So every formatted write in
 * this module goes through the hardware writer directly and the D0 wrapper is
 * never the callback. The C keeps the dead assignment out rather than writing a
 * store nothing reads; the -6 bytes are recorded below.
 *
 * NEWLINE BECOMES CR THEN LF. WriteCharHw sees 0x0a, recurses once with 0x0d,
 * and then falls back into the wait-and-write for the 0x0a. The recursion goes
 * through the saved byte on the stack, which is why the byte is pushed before
 * the test and popped after.
 *
 * THE BUSY POLL IS ON CIAB_PRA BIT 0 and spins with no timeout. CIAA_DDRB is
 * set to 0xff -- all eight lines to output -- before EVERY byte, not once at
 * setup. Both hardware addresses are now exported by tools/mkabsdefs.py and
 * asserted in src/modules/c-exports.s, so the C reaches them as externs rather
 * than as pointer casts.
 *
 * PARALLEL_CheckReadyStub RETURNS -1 ALWAYS, so PARALLEL_WaitReady -- which
 * loops while the result is negative -- never terminates. It has no caller, so
 * nothing hangs. The pair is restored as written; making the loop exit would be
 * a repair, not a restoration.
 *
 * SASC-MISMATCH: fall-through-becomes-call
 *   ref:     five stack heads that run straight into their register entries
 *   got:     five calls
 *   summary: +2 bytes and one stack frame per site. It is also what lets
 *            merge_module_c.py join the module -- see ed1_enter_esc_menu.c.
 *   scope:   this module, esqshared4_p5.s and ed1_p0.s.
 *   retest:  needs a compiler that can emit a tail jump; SAS/C 6.51 cannot.
 *
 * SASC-MISMATCH: dead-store-omitted
 *   ref:     45fa xxxx   LEA PARALLEL_WriteCharD0(PC),A2 in RawDoFmtCommon
 *   got:     nothing
 *   summary: -6 bytes for a PutChProc that the callee overwrites before use.
 *   scope:   one site.
 *   retest:  nothing to retest; it is a source-level choice.
 */
#include <exec/types.h>
#include "esq-exec.h"

extern volatile unsigned char CIAB_PRA;
extern volatile unsigned char CIAA_PRB;
extern volatile unsigned char CIAA_DDRB;

/* Every register entry point in this module. The stack heads above each one
 * call these; RawDoFmt calls the two character writers as PutChProcs. */
void __asm PARALLEL_WriteCharD0(register __d0 unsigned char ch);
void __asm PARALLEL_WriteCharHw(register __d0 unsigned char ch);
void __asm PARALLEL_WriteStringLoop(register __a0 char *s);
void __asm PARALLEL_RawDoFmtCommon(register __a0 char *fmt,
                                   register __a1 void *args);
void __asm PARALLEL_RawDoFmt(register __a0 char *fmt, register __a1 void *args,
                             register __a3 void *data);
void __asm PARALLEL_RawDoFmt(register __a0 char *fmt,
                                    register __a1 void *args,
                                    register __a3 void *data);
long PARALLEL_CheckReadyStub(void);
long PARALLEL_CheckReady(void);

/* ---- the hardware writer, and the only thing that touches a CIA ---- */

void __asm PARALLEL_WriteCharHw(register __d0 unsigned char ch)
{
    if (ch == '\n')
        PARALLEL_WriteCharHw('\r');

    while (CIAB_PRA & 1)        /* BUSY -- spin with no timeout */
        ;
    CIAA_DDRB = 0xff;           /* all eight lines to output, per byte */
    CIAA_PRB  = ch;
}

void PARALLEL_WriteCharHwStackArg(long ch)
{
    PARALLEL_WriteCharHw((unsigned char)ch);
}

/* ---- the D0 wrapper, which nothing reaches ---- */

void __asm PARALLEL_WriteCharD0(register __d0 unsigned char ch)
{
    PARALLEL_WriteCharHw(ch);
}

void PARALLEL_WriteCharStackArg(long ch)
{
    PARALLEL_WriteCharD0((unsigned char)ch);
}

void __asm PARALLEL_WriteStringLoop(register __a0 char *s)
{
    char c;

    for (;;) {
        c = *s++;
        if (c == 0)
            return;
        PARALLEL_WriteCharD0((unsigned char)c);
    }
}

void PARALLEL_WriteStringStackArg(char *s)
{
    PARALLEL_WriteStringLoop(s);
}

/* ---- the ready poll, which can never succeed ---- */

long PARALLEL_CheckReadyStub(void)
{
    return -1;
}

long PARALLEL_CheckReady(void)
{
    return PARALLEL_CheckReadyStub();
}

void PARALLEL_WaitReady(void)
{
    while (PARALLEL_CheckReady() < 0)
        ;
}

/* ---- formatted output ---- */

void __asm PARALLEL_RawDoFmt(register __a0 char *fmt, register __a1 void *args,
                             register __a3 void *data)
{
    RawDoFmt((UBYTE *)fmt, args, (void (*)())PARALLEL_WriteCharHw, data);
}

void __asm PARALLEL_RawDoFmtCommon(register __a0 char *fmt,
                                   register __a1 void *args)
{
    /* The original loads PARALLEL_WriteCharD0 into A2 here and the callee
     * overwrites it. See the header. */
    PARALLEL_RawDoFmt(fmt, args, 0);
}

void PARALLEL_RawDoFmtArgPtr(char *fmt, void *args)
{
    PARALLEL_RawDoFmtCommon(fmt, args);
}

void PARALLEL_RawDoFmtStackArgs(char *fmt, ...)
{
    PARALLEL_RawDoFmtCommon(fmt, (void *)((char *)&fmt + sizeof(char *)));
}

void PARALLEL_RawDoFmtWithData(char *fmt, void *args, void *putChProc,
                               void *data)
{
    PARALLEL_RawDoFmt(fmt, args, data);
}
