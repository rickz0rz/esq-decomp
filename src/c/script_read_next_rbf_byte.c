/* RESTORES: _SCRIPT_ReadNextRbfByte
 * MODULE:   modules/groups/b/a/script2_script_readnextrbfbyte.s
 * STATUS:   behavioural
 *
 * A six-byte forwarder: one PC-relative call to the group jump table, then RTS.
 * The callee takes no arguments and leaves the byte it read in D0, so the
 * wrapper's return value is simply the callee's -- the original neither
 * adjusts the stack nor touches D0 between the call and the RTS.
 *
 * 6 bytes against 6, in ONE region, and that region is a single opcode. This
 * is the smallest possible instance of the call-encoding class, which is the
 * only thing standing between this file and `exact`. See the probe note below.
 *
 * SASC-MISMATCH: call-encoding-jsr-pcrel
 *   ref:     4eba0164 4e75    JSR (d16,PC) ; RTS
 *   got:     61000000 4e75    BSR.W        ; RTS
 *   summary: both are 4-byte PC-relative calls with a 16-bit displacement and
 *            identical semantics; only the opcode differs. 6.51 emits BSR.W for
 *            every call, 6.00 emits JSR (d16,PC) for every call, and the
 *            original picks per callee -- see docs/compiler-version.md,
 *            "Call encoding depends on the callee's translation unit".
 *   tried:   nothing to try. `strings sc | grep -E '^[A-Z][A-Za-z]{3,24}$'`
 *            offers no branch-encoding option; the OPT* family is the only
 *            thing nearby and peephole optimisation runs toward BSR, not away
 *            from it. CODE=FAR gives 4EB9 (absolute, 6 bytes), which is worse.
 *   scope:   whole-program. 82 functions / 35272 bytes are in the `4EBA`
 *            bucket, and every one is capped at `behavioural` under 6.51.
 *            Find them with tools/coverage.py, kind == 'cross-unit'.
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern takes
 *            this file byte-exact on the first compile with no source change.
 *
 * PROBE: this is the sharpest available test for the call-encoding class --
 * sharper than esqiff_handle_brush_ini_reload_hotkey.c, which is 128 bytes and
 * nine regions. Here there is exactly one instruction in question and nothing
 * else in the function at all: no LINK, no frame, no register variable, no
 * constant to materialise, no library call, no A6. Run it first on any newly
 * obtained SAS/C version. Byte 0 answers the question by itself: 4e -> match,
 * 61 -> no.
 */

extern long ESQ_ReadSerialRbfByte(void);

long SCRIPT_ReadNextRbfByte(void)
{
    return ESQ_ReadSerialRbfByte();
}
