# Annotation Backlog (Project-Wide)

Date baseline: 2026-02-14

## Scoring Method
Priority score is driven by:
1. Count of placeholder function headers in a file (`(Routine at ...)` + static scan DESC).
2. Position in known call-tree hot paths (`main/a/a.s` -> Phase 8 fan-out).
3. Coupling to unresolved globals/state (especially `src/data/wdisp.s`).

## Global Snapshot
- `; FUNC:` headers in `src`: 1410
- Placeholder function-title headers (`Routine at`): 444
- Placeholder DESC lines (static scan text): 463
- `LAB_xxxx` globals still present: 28
- Files named `unknown*.s`: 43
- Source `??` markers: 16

## Rule: Data Sidecar Annotation (Enabled)
When a code leaf is touched, annotate related `src/data/*` symbols in the same pass where confidence permits.

Per-pass sidecar checklist:
1. Replace raw globals/offsets in touched code with existing symbols where available.
2. If a symbol is missing but usage is clear, add/rename conservatively in `src/data/*.s` and propagate.
3. If uncertain, keep `??` and log it in `CHECKPOINT_layout_coupling_population.md`.
4. Mark completed leaves in the call-tree leaf ledger to avoid re-touch churn.

## Prioritized Queue (Top Targets)

### Tier 1: Highest Impact Runtime/Core Paths
1. `src/modules/groups/a/n/esqiff.s` (102)
2. `src/modules/groups/a/n/esqfunc.s` (69)
3. `src/modules/groups/a/o/esqpars.s` (62)
4. `src/modules/groups/a/g/diskio1.s` (56)
5. `src/modules/groups/a/y/locavail.s` (46)
6. `src/modules/groups/a/g/diskio.s` (46)
7. `src/modules/groups/a/q/esqshared4.s` (44)
8. `src/modules/groups/a/h/xjump.s` (36)
9. `src/modules/groups/a/a/brush.s` (36)
10. `src/modules/groups/a/e/coi.s` (35)
11. `src/modules/groups/a/g/xjump.s` (34)
12. `src/modules/groups/b/a/wdisp.s` (26)
13. `src/modules/groups/a/n/esqdisp.s` (24)

### Tier 2: Mainline Support Branches
14. `src/modules/groups/a/y/xjump.s` (20)
15. `src/modules/groups/a/e/xjump.s` (20)
16. `src/modules/groups/a/b/xjump.s` (20)
17. `src/modules/groups/a/w/xjump.s` (18)
18. `src/modules/groups/a/w/ladfunc.s` (18)
19. `src/modules/groups/a/i/displib.s` (18)
20. `src/modules/groups/b/a/tliba3.s` (17)
21. `src/modules/groups/a/p/esqshared.s` (16)
22. `src/modules/groups/a/u/gcommand3.s` (14)
23. `src/modules/groups/b/a/parseini.s` (12)
24. `src/modules/groups/b/a/script.s` (10)
25. `src/modules/groups/a/x/ladfunc2.s` (10)
26. `src/modules/groups/a/v/xjump.s` (10)
27. `src/modules/groups/b/a/script3.s` (8)
28. `src/modules/groups/a/k/xjump2.s` (8)
29. `src/modules/groups/a/a/xjump.s` (8)
30. `src/modules/groups/_main/b/xjump.s` (8)
31. `src/modules/groups/b/a/script2.s` (6)
32. `src/modules/groups/a/z/locavail2.s` (6)

### Tier 3: Lower Volume / Cleanup Tail
33. `src/modules/groups/b/a/textdisp.s` (4)
34. `src/modules/groups/a/s/flib2.s` (4)
35. `src/modules/groups/a/r/xjump.s` (4)
36. `src/modules/groups/a/r/flib.s` (4)
37. `src/modules/groups/b/a/p_type.s` (2)
38. `src/modules/groups/a/z/xjump.s` (2)
39. `src/modules/groups/a/x/xjump.s` (2)
40. `src/modules/groups/a/k/ed1.s` (2)
41. `src/modules/groups/a/f/ctasks.s` (2)
42. `src/modules/groups/a/c/cleanup2.s` (2)
43. `src/modules/groups/a/a/app2.s` (2)

### Tier 4: Uncertain-Significance Focus (non-header-count driven)
44. `src/data/wdisp.s` unresolved symbols (`220F`, `2255/2256/225D/225E/226D/226E`)
45. `src/modules/groups/b/a/newgrid2.s` local-label clarity pass (open AGENTS item)
46. `src/modules/submodules/unknown14.s` (`Struct_PreallocHandleNode` flag semantics)
47. `src/modules/submodules/unknown16.s` (`Struct_PreallocHandleNode` flag semantics)
48. `src/modules/submodules/unknown29.s` (`OpenFlags` / mode-flag mask meaning)
49. `src/modules/submodules/unknown31.s` (`Struct_PreallocHandleNode` linked-node behavior)
50. `src/modules/submodules/unknown35.s` (`Struct_PreallocHandleNode` stream/open-state behavior)

## Execution Notes
- Use the existing `CHECKPOINT_call_tree_main_entry.md` leaf ledger to prevent rework.
- Default cadence: one branch cluster at a time, with hash validation after each pass.
- For every Tier 1/2 code pass, include targeted sidecar checks in:
  - `src/data/wdisp.s`
  - `src/data/script.s`
  - `src/data/newgrid.s` / `src/data/newgrid2.s`
  - `src/data/esq.s` / `src/data/esqfunc.s` / `src/data/esqpars2.s`

