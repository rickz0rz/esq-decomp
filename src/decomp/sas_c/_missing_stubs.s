;------------------------------------------------------------------------------
; Small hand-written stubs for symbols not provided by the restored C corpus.
;  - _AddIntVector: REAL exec.library AddIntVector call (LVO -168; D0=intNumber,
;    A1=interrupt, A6=SysBase from absolute address 4). Previously a no-op, which
;    meant SETUP_INTERRUPT_INTB_VERTB never installed the VERTB server, so the
;    per-frame copper/clock tick (ESQ_TickGlobalCounters) never ran and the
;    display never came up.
;
; NOTE (2026-07-13): the former NEWGRID / ESQSHARED no-op stubs are GONE. The
; "vamos-uncompilable" failure was an artifact of passing `--cwd esq:` to the
; emulated `sc` (see compile_all_sasc_far.sh); referencing the source as
; `esq:<file>.c` without --cwd compiles every one of them clean with
; DATA=FAR IDLEN=64. All those functions now link as their real restorations.
;------------------------------------------------------------------------------
_LVOAddIntVector_OFF = -168

    SECTION text,CODE

    XDEF    _AddIntVector
;  void AddIntVector(ULONG intNumber /*4(A7)->D0*/, struct Interrupt *intr /*8(A7)->A1*/)
_AddIntVector:
    MOVE.L  4(A7),D0
    MOVEA.L 8(A7),A1
    MOVEA.L (4).W,A6                 ; SysBase (AbsExecBase) at absolute addr 4
    JSR     _LVOAddIntVector_OFF(A6)
    RTS

    END
