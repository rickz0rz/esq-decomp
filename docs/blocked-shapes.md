# What is still blocked, and what each class would take

After the `_Return` correction (see below) **4,368 bytes in 35 functions** cannot
be restored today. That is 2.3% of the program. The ceiling is 97.7%.

| class | fns | bytes | what actually stops us |
|---|---:|---:|---|
| register-args | 7 | 2,440 | the calling convention is a contract with assembly callers |
| falls-through (real) | 14 | 506 | not a function; belongs to its neighbour |
| interior-label | 3 | 848 | not a function; uses the parent's A5 frame |
| live-register-on-entry | 8 | 300 | same contract problem as register-args |
| rotate / predecrement / tail-jump | 3 | 274 | nothing, for a behavioural build |

The classes are not equally hard, and only one of them is a real wall.

## Nothing stops the last row (274 bytes)

`rotate-instruction`, `predecrement-store` and `tail-jump` block a BYTE-EXACT
match, not a working restoration.

- A rotate is `(x << n) | (x >> (32 - n))` in C. SAS/C 6.51 emits shifts and an
  OR instead of `ROL`, which is more bytes and the same result.
- `*--p = c` compiles to a separate `SUBQ` and a plain store, 2 bytes more per
  write than `MOVE.x src,-(An)`.
- A tail `JMP` becomes `JSR` then `RTS`. Same call, same arguments, one extra
  return.

These three are screened out because the screening was written when byte
equality was the goal. For `replacements-all.txt`, where behavioural
restorations are the norm, they are ordinary targets. There are only three of
them, so the prize is small, but the reasoning matters: **`coverage.py` answers
"can this be byte-exact", and that is not the same question as "can this be
linked and run".**

## The middle rows are a unit-of-work problem (1,354 bytes)

A `falls-through` block has no return because control runs off its end into the
next block. An `interior-label` block has no prologue because it uses the
enclosing function's A5 frame. Neither is a function, so neither can be a C
function on its own.

Both are restorable as part of a LARGER restoration. Restore the whole chain --
the entry block, the interior labels, and everything it falls into -- as one C
function, and the problem disappears. The cost is that the unit of work is now
the chain rather than the block, and any other caller that jumps directly to an
interior label needs its own entry point. Where the fall-through only carries
control (not live registers), splitting it into two C functions with an explicit
call is equivalent and simpler.

Check before starting: does register state cross the boundary? If block A leaves
a value in D4 that block B reads, then B needs it as a parameter, and every
other caller of B must supply it.

## The first and fourth rows are a real wall (2,740 bytes)

A `register-args` function takes its arguments in D0/D1/A0/A1 **and preserves
them**, because its assembly callers rely on those registers surviving the call.
`live-register-on-entry` is the same contract seen from the other end: the
function is entered with a register the caller already set.

SAS/C does have register parameters:

```c
void __asm f(register __a0 char *p, register __d0 long n);
```

That gets the arguments into the right registers. It does NOT solve the problem,
because SAS/C then copies them into its own callee-saved registers and works
there, while the original works in the argument registers in place and hands
them back. Verified against `ESQSHARED4_CopyBannerRowsWithByteOffset` and its
two siblings.

So restoring one means changing its CALLERS to a normal stack call. The callers
are assembly, and editing them changes the pure-assembly build -- which is what
`test-hash.sh` protects. That is the wall: not "C cannot express it", but "the
fix is outside the function, in code the byte gate covers".

It is not permanent. A caller that is itself restored to C stops being assembly,
and once every caller of one of these helpers is C, the helper can move too. That
makes these the LAST functions to restore, not impossible ones.

**Fifteen restorations of this class already exist as analysis** and are marked
`DO-NOT-LINK:`. They compile and document the logic; linking them silently
breaks the program, because the compiled C reads a stack frame that holds none of
its arguments.

## The 89.8% ceiling was wrong

An earlier version of this analysis put the ceiling at 89.8% and the blocked pool
at 19,756 bytes. That was a bug in `coverage.py`, not a property of the program.

The `falls-through` test asked whether the body contains any `RTS`, `RTE` or
`RTR`. When a function's epilogue is branched to from inside, the disassembly
gives that epilogue its own `<name>_Return` label, and the extract for the
function stops there -- so the body legitimately holds no return instruction
while the function returns perfectly well. **30 ordinary functions and 15,388
bytes, about 8% of the whole program, were being reported as unrestorable.**
`ESQSHARED_UpdateMatchingEntriesByTitle` at 1,360 bytes was the largest.

`coverage.py` now checks for a `_Return` label before believing the body. The
comment it replaced already described this exact case and then concluded that
"having no return instruction at all is unambiguous", which is the one situation
where it is not.

The lesson generalizes past this bug: **a screening rule that removes work is
worth auditing as carefully as the work it removes.** Nothing fails when a
filter is too aggressive. The targets simply never appear, and the ceiling looks
like a fact about the program.

## A seventh class, found on 2026-07-31: the process exit stub

`ESQ_ShutdownAndReturn` (76 bytes, `modules/groups/_main/a/a.s`) appears in
`worklist.py` as an ordinary cross-unit target. It is not one, and no C compiler
can emit it. Its last three instructions are:

```
2E6CFDA8    MOVEA.L Global_SavedStackPointer(A4),A7
4CDF7F7E    MOVEM.L (A7)+,D1-D6/A0-A6
4E75        RTS
```

Three things there are outside the language at once. The function **replaces the
stack pointer** with a value a different function saved. It then **pops thirteen
registers it never pushed** -- they were pushed by the startup code, not by this
routine, so the MOVEM is one half of a save/restore pair whose other half lives
in another function. And the `RTS` therefore returns to the startup code's
caller, not to this function's caller. A C function must balance its own stack
and return to whoever called it; this one is written to do neither.

It reads its globals through `A4` as well, and calls `_LVOexecPrivate1`, but
those are not what blocks it. The stack discipline is.

**Scope: exactly one function.** Every unrestored function was scanned for a
load of A7 from memory (`MOVEA.L <ea>,A7`, opcodes `2e6c`/`2e78`/`2e79`):

```sh
python3 - <<'PY'
import sys, subprocess, re
sys.path.insert(0, 'tools'); import coverage
for f in coverage.survey():
    if f['status'] is not None: continue
    out = subprocess.run([sys.executable, 'tools/refbytes.py', f['name']],
                         capture_output=True, text=True).stdout
    m = re.search(r'^bytes: (\S+)', out, re.M)
    if m and any(op in m.group(1) for op in ('2e6c', '2e78', '2e79')):
        print(f['size'], f['name'])
PY
```

That returns three names. Two are false positives -- `TLIBA1_FormatClockFormatEntry`
and `LOCAVAIL_ComputeFilterOffsetForEntry` contain the byte pair inside a longer
instruction and only ever adjust A7 with `LEA`/`ADDQ`. Check the disassembly, not
the byte string. `ESQ_ShutdownAndReturn` is the only real one.

So this class costs 76 bytes and moves the ceiling by 0.04%. It is recorded
because the alternative is that the next reader spends an afternoon on it, which
is the same reason every other row here exists. It is **not** yet screened by
`coverage.py`; it is small enough that a detector would risk more false
positives than it saves work.
