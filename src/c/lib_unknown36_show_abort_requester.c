/* RESTORES: UNKNOWN36_ShowAbortRequester
 * MODULE:   modules/submodules/unknown36_p0.s   (its only label after the split)
 * STATUS:   behavioural
 *
 * SAS/C's Ctrl-C break requester -- the runtime's `_cxbrk.c`. AGENTS.md settles
 * the identification from the string block: "** User Abort Requested **",
 * "CONTINUE", "ABORT" and "*** Break: " appear in 6.51's own member at 258,
 * 286, 296 and 302, which is exactly their order and spacing here.
 *
 * IT TRIES THE CONSOLE FIRST AND THE SCREEN SECOND. It finds the current task,
 * follows pr_CLI to the CommandLineInterface and takes cli_StandardOutput,
 * falling back to pr_COS. If either is open it writes "*** Break: " and the
 * message and returns -1. Only when there is no console at all does it open
 * intuition.library and put up an AutoRequest.
 *
 * THE MESSAGE IS A BCPL-STYLE COUNTED STRING. The length is the byte BEFORE the
 * pointer -- `MOVE.B -1(A0),D7` -- not a NUL terminator, and it is clamped to
 * 79 to fit the 80-byte frame buffer. The copy is a `SUBQ.L #1 / BCC` loop,
 * which runs length+1 times, so it copies the byte at index `length` as well;
 * the CLR.B that follows puts the NUL back at `length`. Written as a `do`
 * loop of length+1 for that reason -- a plain `memcpy(dst, src, len)` would
 * copy one byte fewer and read one byte less.
 *
 * A NEWLINE IS APPENDED IN PLACE, over the NUL, and the write length becomes
 * length+1. So the buffer is never NUL-terminated on the console path; only
 * the requester path relies on the terminator, and it is written before the
 * newline overwrites it.
 *
 * THE PROCESS FIELDS ARE REACHED BY OFFSET because the original does. 172 is
 * pr_CLI, 160 is pr_COS, and 56 is cli_StandardOutput inside the BPTR-shifted
 * CommandLineInterface. The `ASL.L #2` on pr_CLI is the BPTR-to-APTR
 * conversion, written out rather than hidden behind BADDR so the shift stays
 * visible next to the offsets.
 *
 * THE REQUESTER CALL GOES THROUGH EXEC_CallVector_348, WHICH IS AutoRequest.
 * See lib_exec_call_vector_348.c: the name in the disassembly is from the wrong
 * library's offset table, and the register spec proves the identification.
 *
 * SASC-MISMATCH: near-data-addressing
 *   summary: five globals here are reached as 16-bit displacements off A4 in
 *            the original and as absolute addresses under DATA=FAR, at 2 bytes
 *            a site. esq-neardata.h resolves each to the same address --
 *            AGENTS.md, "An (A4) symbol is a NAMED ADDRESS IN OUR OWN DATA".
 *   scope:   program-wide.
 *   retest:  a DATA=NEAR build, which this project does not use.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   summary: the original loads the DOS base once and issues two Write calls
 *            on it; esq-dos.h's volatile base forces a reload before each,
 *            6 bytes a site. That is deliberate and load-bearing -- see
 *            esq-libbase.md -- because ESQ's assembly does not preserve A6.
 *   scope:   program-wide.
 *   retest:  nothing to retest; the reload is the correct behaviour here.
 */
#include <exec/types.h>
#include <dos/dosextens.h>
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-intuition.h"
#include "esq-neardata.h"

extern char DEBUG_STR_UserAbortRequested[];
extern char UNKNOWN36_STR_BreakPrefix[];
extern char UNKNOWN36_STR_IntuitionLibrary[];

extern long EXEC_CallVector_348(void *window, void *bodyText,
                                void *positiveText, void *negativeText,
                                long positiveFlags, long negativeFlags,
                                long width, long height, void *base);

long UNKNOWN36_ShowAbortRequester(void)
{
    char  text[84];
    struct Process *task;
    struct CommandLineInterface *cli;
    long  out;
    long  len;
    long  i;
    char *src;
    void *intuition;

    src = (char *)Global_UNKNOWN36_MessagePtr_A4;
    len = (unsigned char)src[-1];
    if (len > 79)
        len = 79;

    /* SUBQ/BCC runs length+1 times -- see the header. */
    i = len;
    do {
        text[len - i] = *src++;
    } while (i-- != 0);
    text[len] = 0;

    task = (struct Process *)FindTask(0L);
    out = 0;
    if (*(long *)((char *)task + 172) != 0) {
        cli = (struct CommandLineInterface *)
              (*(long *)((char *)task + 172) << 2);
        out = *(long *)((char *)cli + 56);
        if (out == 0)
            out = *(long *)((char *)task + 160);
    }

    if (out != 0) {
        Write(out, UNKNOWN36_STR_BreakPrefix, 11L);
        text[len] = '\n';
        Write(out, text, len + 1);
        return -1;
    }

    intuition = (void *)OpenLibrary(UNKNOWN36_STR_IntuitionLibrary, 0L);
    if (intuition == 0)
        return -1;

    Global_UNKNOWN36_RequesterOutPtr_A4 = (long)text;
    if (EXEC_CallVector_348(0, Global_UNKNOWN36_RequesterText0_A4_ADDR,
                            Global_UNKNOWN36_RequesterText1_A4_ADDR,
                            Global_UNKNOWN36_RequesterText2_A4_ADDR,
                            0L, 0L, 250L, 60L, intuition) == 1)
        return 0;
    return -1;
}
