/* RESTORES: ESQ_SupervisorColdReboot
 * MODULE:   modules/groups/a/a/app3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: supervisor-reset-instruction
 *   ref:     41f90100000091e8ffec2068000455884e704ed0203c00fbfffc2040321030bc55aa30100c4055aa6600001630bcaa5530100c40aa5566000008308170004e75
 *   got:     70004e75
 *   summary: Not expressible in C at all -- see the comment in the file. Documented so the label is accounted for; it must stay in assembly.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Supervisor-mode cold reboot: reads the ROM reset vector, executes the 68000
 * RESET instruction and jumps to it. RESET has no C equivalent, so this must
 * stay in assembly; documented for reference only. */
long ESQ_SupervisorColdReboot(void)
{
    return 0;
}
