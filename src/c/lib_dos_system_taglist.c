/* RESTORES: DOS_SystemTagList
 * MODULE:   modules/submodules/unknown40_dos_systemtaglist.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a thin wrapper on dos.library's SystemTagList, which runs
 * a command line through the shell.
 *
 * IT IS 2.0-ONLY. SystemTagList does not exist in Kickstart 1.3's dos.library, so
 * a caller on 1.x jumps into whatever is at that offset. The original has no
 * version guard and none is added -- ESQ_ColdReboot shows the program does check
 * the exec version where it matters, so the absence here is a decision rather
 * than an oversight.
 *
 * THE SIGNATURE IS CONFIRMED against an existing restoration:
 * `GROUP_AT_JMPTBL_DOS_SystemTagList(char *cmd, void *tags)`.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVEA.L Global_REF_DOS_LIBRARY_2,A6
 *   got:     the absolute DOSBase esq-dos.h uses -- the same variable.
 *   scope:   every library wrapper in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"

long DOS_SystemTagList(char *cmd, void *tags)
{
    return SystemTagList((STRPTR)cmd, (struct TagItem *)tags);
}
