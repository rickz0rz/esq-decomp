# Never include `<proto/*.h>` — use `esq-dos.h` / `esq-exec.h` / `esq-graphics.h`

These three headers are the stock `proto/` headers with one word added: the
library base pointer is declared **`volatile`**. That word is the difference
between a program that runs and one that resets the machine.

## What goes wrong

SAS/C assumes A6 survives a call, because its own generated code saves A6
whenever it uses it. Having loaded a library base for one call it reuses the
register for the next:

```
    MOVEA.L DOSBase,A6
    JSR     _LVOLock(A6)
    JSR     _MEMORY_AllocateMemory      <- ESQ assembly
    JSR     _LVOInfo(A6)                <- A6 is ExecBase by now
```

ESQ's hand-written assembly does not honour that convention.
`MEMORY_AllocateMemory` loads `AbsExecBase` into A6 and returns without
restoring it — its own comment lists A6 among the registers it clobbers. So the
second call enters **exec** at the dos offset. `JSR -114(ExecBase)` with
`DISKIO_QueryDiskUsagePercentAndSetBufferSize`'s arguments resets the Amiga
during startup, which is exactly what it did.

The original reloads the base before *every* call — three separate
`MOVEA.L Global_REF_DOS_LIBRARY_2,A6` in that one function. That was recorded
here as the `reload-vs-cache` byte divergence and dismissed as cosmetic. **It was
never cosmetic. It was this bug.**

Declaring the base `volatile` forces the reload and reproduces the original's
instruction sequence, in pure C, with no inline assembly.

## Why exec needs more than the other two

`proto/exec.h` reaches exec through `#pragma syscall`, which has no base
variable to qualify — it loads absolute 4 and then caches it in A6 just the
same. `esq-exec.h` switches to `pragmas/exec_sysbase_pragmas.h`, which routes
the identical calls through a `SysBase` variable that *can* be volatile.

`tools/mkabsdefs.py` defines `_SysBase` as the absolute value 4, so
`MOVEA.L _SysBase,A6` reads the longword at address 4 — `AbsExecBase`, the same
thing the original loads. It costs 2 bytes per exec call against the original's
short-absolute `MOVEA.L (4).W,A6`; correctness is worth 2 bytes.

## The check

```sh
/tmp/.capvenv/bin/python tools/a6_audit.py     # after any C build
```

It disassembles every compiled replacement and flags a `JSR d16(A6)` reached
with a call in between and no reload. It found 14 broken restorations out of 232
and exits nonzero when any remain, so this cannot silently come back.

Calls to other C functions are safe, but an object cannot say which externs are
C and which are assembly, so any intervening call counts. That bias is
deliberate: a false positive costs one base reload — which is what the original
emits anyway — and a false negative resets the machine.

## The general lesson

No byte gate can see this. `build-split.sh` compares a function's body, not the
convention its callees use, and every one of the 14 broken restorations compiled
clean and compared sanely. **Linking and running is the only thing that closes
that gap** — the same lesson as the `register-args` and interrupt-vector
families in `tools/gen_all_manifest.py`.
