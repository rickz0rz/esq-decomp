/* proto/exec.h with a VOLATILE library base.  Include this, never
 * <proto/exec.h>.  See esq-libbase.md in this directory for why.
 *
 * Stock proto/exec.h reaches exec through `#pragma syscall`, which has no base
 * variable to qualify -- it loads absolute 4 and then caches it in A6 exactly
 * like the others.  The sysbase pragmas route the same calls through a SysBase
 * variable instead, which CAN be made volatile.  _SysBase is defined as the
 * absolute value 4 by tools/mkabsdefs.py, so `MOVEA.L _SysBase,A6` reads the
 * longword at address 4 -- AbsExecBase -- which is what the original loads.
 */
#ifndef ESQ_EXEC_H
#define ESQ_EXEC_H
#include <exec/types.h>
extern struct ExecBase * volatile SysBase;
#include <clib/exec_protos.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <clib/alib_protos.h>
#endif
