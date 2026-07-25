# Runtime bisect (resolved)

## Outcome

Both `ESQ_c5` (five byte-exact C restorations) and `ESQ_canary3` (those five
plus two behavioural ones) **run correctly**. `ESQ_only_strcat` runs correctly.

The earlier reports -- `canary3` showing no diagnostics, `c5` appearing to hang
-- were **stale binaries, not code defects**.

## Cause

`ESQ_canary3` was staged with:

```sh
C_REPLACEMENTS=... ./build-split.sh >/dev/null 2>&1 && cp build/ESQ .../ESQ_canary3
```

`build-split.sh` deliberately exits nonzero when the result is not
content-identical to the reference, which is *expected* for any variant
containing a behavioural restoration. So the `&&` suppressed the copy, and a
later unconditional `cp build/ESQ ...` picked up whatever happened to be in
`build/` at that moment.

The static analysis was right and worth trusting: `ESQ_c5` differs from
`ESQ_asmonly` only by 8 inserted `4e71` NOPs and 515 PC-relative displacement
fixups, with identical relocation counts (8791 code / 261 data) and an identical
DATA hunk. It could not have behaved differently, and it does not.

## Prevention

`./stage-builds.sh` rebuilds every variant and copies each one immediately after
its own build, removes `build/ESQ` afterwards so nothing can be inherited by the
next stage, and records SHA-256s to `STAGED.txt` in the destination. Before
trusting a runtime result, confirm the binary:

```sh
shasum -a 256 ~/Downloads/Prevue/ESQ_c5
grep ESQ_c5 ~/Downloads/Prevue/STAGED.txt
```

**Never chain staging off `build-split.sh`'s exit status.** A nonzero exit means
"not content-identical", which for a C variant is the expected outcome, not a
failure.

## Current state

| binary | contents | runtime |
|---|---|---|
| `ESQ_asmonly` | pure assembly, content-identical to reference | control |
| `ESQ_c5` | five byte-exact C restorations | runs correctly |
| `ESQ_canary3` | those five + strcat + NEWGRID_GetGridModeIndex | runs correctly |
| `ESQ_only_strcat` | strcat alone | runs correctly |
| `ESQ_only_videochip` | startup restoration alone | untested |
| `ESQ_only_newgrid` | grid mode index alone | untested |
