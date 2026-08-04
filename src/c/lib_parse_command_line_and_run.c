/* RESTORES: ESQ_ParseCommandLineAndRun
 * MODULE:   modules/submodules/unknown29.s   (1 of its 2 labels)
 * STATUS:   behavioural
 *
 * SAS/C's `_main`: it splits the command line into argv, opens the three
 * standard streams, wires up the prealloc handle nodes, and calls the program's
 * entry point. Everything ESQ does happens inside the one call near the bottom.
 *
 * IT TAKES ONE ARGUMENT AND THE CALL SITE DOES NOT LOOK LIKE IT.
 * `modules/groups/_main/a/a.s` reaches it with a bare
 * `JSR GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(PC)` and pushes nothing at
 * the call. The arguments were pushed EARLIER, before the entry hook, and left
 * in place:
 *
 *     MOVE.L  A0,-(A7)                        ; saved WBStartup message
 *     PEA     Global_WBStartupCmdBuffer(A4)   ; command buffer  <- top of stack
 *     ...
 *     JSR     ...ESQ_MainEntryNoOpHook(PC)
 *     JSR     ...ESQ_ParseCommandLineAndRun(PC)
 *
 * The body confirms it. `SetOffsetForStack 5` makes `.stackOffsetBytes` 20, so
 * `UseStackLong MOVEA.L,6,A3` assembles to `MOVEA.L 44(A7),A3`; with
 * `LINK.W A5,#-16` and a five-register MOVEM that is A5+8, the first argument.
 * Read the macro, not the call site.
 *
 * THE TOKENISER. Leading spaces, tabs and newlines are skipped. A token is
 * either quoted with `"` or runs to the next space, tab or newline. Each token
 * is NUL-terminated IN PLACE and its address stored in the argv array. The loop
 * stops at 32 arguments -- `CMPI.L #' ',Global_ArgCount(A4)` compares against
 * the character constant for a space, which is 32, and the disassembly's choice
 * of a character literal there is misleading.
 *
 * AN UNTERMINATED QUOTE EXITS THE PROGRAM. If the scan for the closing quote
 * reaches the NUL, the original calls `HANDLE_CloseAllAndReturnWithCode(1)` and
 * that never returns. The `continue` after it is unreachable and is kept only
 * because the original branches back to the loop head.
 *
 * TWO STREAM SETUPS, chosen by whether any argument was parsed. With arguments
 * the program was started from a shell, so Input() and Output() are inherited
 * and `*` is opened for the third. With none it was started from Workbench, so
 * a console window is opened instead, and the task's pr_CIS is patched.
 *
 * LINKED SINCE 2026-08-04. It used to carry two reasons not to be, and both
 * are now settled:
 *
 *   1. `unknown29.s` also holds `UNKNOWN29_JMPTBL_ESQ_MainInitAndRun`, and a C
 *      file replaces a whole module. jmptbl_submodules_unknown29.c restores it
 *      and merge_module_c.py joins the two into one unit.
 *   2. THE CONSOLE NAME WOULD HAVE GROWN THE DATA HUNK. The original keeps
 *      "con.10/10/320/80/" as a PC-relative template in the CODE section and
 *      copies it with four MOVE.L and a MOVE.W. SAS/C 6.51 puts a string
 *      literal in `data`, and AGENTS.md records that a DATA hunk which grows
 *      by even four bytes shifts every symbol after it and froze the display,
 *      reproducibly. Both strings here are therefore built a character at a
 *      time into a local, which keeps them in CODE. `hunkcmp` confirms it: the
 *      DATA hunk is the same size with this module linked as without, and the
 *      six differing DATA bytes are the pre-existing relocated ones.
 *
 * MERGING IT NEEDED A FALL-THROUGH FIX IN THE TOOL, and the fall-through was
 * not real. The two `NStr` constants sit between this function's RTS and the
 * thunk's label, under local labels the scan walks past, so merge_module_c.py
 * saw NSTR as the last operation before the thunk and called it a
 * fall-through. Data is not an instruction; the RTS ended the block.
 *
 * SASC-MISMATCH: pc-relative-template-vs-data-literal
 *   ref:     LEA .loc(PC),A1 / four MOVE.L and a MOVE.W into the buffer
 *   got:     character stores, to keep the text out of the DATA hunk
 *   summary: same eighteen bytes in the same place. The original can address a
 *            constant in its own code section; SAS/C cannot, and its natural
 *            spelling would move the whole DATA section.
 *   tried:   a string literal, which is what makes this a DO-NOT-LINK risk.
 *   scope:   any restoration holding an initialised string.
 *   retest:  a compiler that places string literals in the code section.
 */
#include <exec/types.h>
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-neardata.h"

#define ARG_LIMIT   32          /* CMPI.L #' ' -- the space character, 32 */

extern void ESQ_MainInitAndRun(long argc, char **argv);
extern void HANDLE_CloseAllAndReturnWithCode(long code);
extern void BUFFER_FlushAllAndCloseWithCode(long code);
extern void STRING_AppendN(char *dst, char *src, long n);
extern void UNKNOWN36_ShowAbortRequester(void);

static short is_space(char c)
{
    return (short)(c == ' ' || c == '\t' || c == '\n');
}

/* "con.10/10/320/80/" written a character at a time. See the header: a string
 * literal here would land in the DATA hunk and move every symbol after it. */
static void console_name(char *p)
{
    *p++ = 'c'; *p++ = 'o'; *p++ = 'n'; *p++ = '.';
    *p++ = '1'; *p++ = '0'; *p++ = '/';
    *p++ = '1'; *p++ = '0'; *p++ = '/';
    *p++ = '3'; *p++ = '2'; *p++ = '0'; *p++ = '/';
    *p++ = '8'; *p++ = '0'; *p++ = '/';
    *p   = 0;
}

void ESQ_ParseCommandLineAndRun(char *cmd)
{
    char **argv;
    char  *p;
    long   flags;
    long   handle;

    p = cmd;

    while (Global_ArgCount_A4 < ARG_LIMIT) {
        while (is_space(*p))
            p++;
        if (*p == 0)
            break;

        argv = (char **)Global_ArgvStorage_A4_ADDR;
        argv += Global_ArgCount_A4;
        Global_ArgCount_A4++;

        if (*p == '"') {
            p++;
            *argv = p;
            while (*p != 0 && *p != '"')
                p++;
            if (*p == 0) {
                /* Never returns. The original branches back to the loop head
                 * anyway, so the shape is kept. */
                HANDLE_CloseAllAndReturnWithCode(1);
                continue;
            }
            *p++ = 0;
        } else {
            *argv = p;
            while (*p != 0 && !is_space(*p))
                p++;
            if (*p == 0)
                break;
            *p++ = 0;
        }
    }

    if (Global_ArgCount_A4 != 0)
        Global_ArgvPtr_A4 = (long)Global_ArgvStorage_A4_ADDR;
    else
        Global_ArgvPtr_A4 = Global_SavedMsg_A4;

    if (Global_ArgCount_A4 == 0) {
        /* Started from Workbench: open a console and adopt it. */
        struct Process *proc;
        char           *name = (char *)Global_ConsoleNameBuffer_A4_ADDR;
        char          **arglist;

        console_name(name);
        arglist = (char **)(*(long *)(Global_SavedMsg_A4 + 36));
        STRING_AppendN(name, (char *)arglist[1], 40L);

        handle = (long)Open(name, MODE_NEWFILE);
        Global_HandleEntry0_Ptr_A4 = handle;
        Global_HandleEntry1_Ptr_A4 = handle;
        Global_HandleEntry1_Flags_A4 = 16;
        Global_HandleEntry2_Ptr_A4 = handle;
        Global_HandleEntry2_Flags_A4 = 16;

        proc = (struct Process *)FindTask(0L);
        *(long *)((char *)proc + 164) = *(long *)((handle << 2) + 8);

        flags = 0;
    } else {
        /* Started from a shell: inherit the standard streams.
         *
         * `star` is built rather than written as "*" for the same reason as the
         * console name: a string literal, even a one-character one, emits a
         * DATA hunk. Measured -- the literal form produced a 4-byte DATA hunk,
         * and AGENTS.md records that four bytes of DATA growth shifts every
         * symbol after it and freezes the display. */
        char star[2];

        star[0] = '*';
        star[1] = 0;

        Global_HandleEntry0_Ptr_A4 = (long)Input();
        Global_HandleEntry1_Ptr_A4 = (long)Output();
        Global_HandleEntry2_Ptr_A4 = (long)Open(star, MODE_OLDFILE);
        flags = 16;
    }

    Global_HandleEntry0_Flags_A4 |= (flags | 0x8001);
    Global_HandleEntry1_Flags_A4 |= (flags | 0x8002);
    Global_HandleEntry2_Flags_A4 |= 0x8003;

    flags = Global_DefaultHandleFlags_A4 ? 0 : 0x8000;

    Global_PreallocHandleNode0_HandleIndex_A4 = 0;
    Global_PreallocHandleNode0_OpenFlags_A4   = flags | 1;
    Global_PreallocHandleNode1_HandleIndex_A4 = 1;
    Global_PreallocHandleNode1_OpenFlags_A4   = flags | 2;
    Global_PreallocHandleNode2_HandleIndex_A4 = 2;
    Global_PreallocHandleNode2_OpenFlags_A4   = flags | 0x80;

    Global_SignalCallbackPtr_A4 = (long)UNKNOWN36_ShowAbortRequester;

    ESQ_MainInitAndRun(Global_ArgCount_A4, (char **)Global_ArgvPtr_A4);

    BUFFER_FlushAllAndCloseWithCode(0L);
}
