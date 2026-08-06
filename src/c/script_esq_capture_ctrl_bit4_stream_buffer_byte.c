/* RESTORES: _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte
 * MODULE:   modules/groups/b/a/script2_script_esq_capturectrlbit4streambufferbyte.s
 * STATUS:   behavioural
 *
 * Sibling of script_read_next_rbf_byte.c and the same six-byte forwarder shape:
 * one PC-relative call to the group jump table, then RTS. The callee takes no
 * arguments and returns the captured byte in D0; the caller in script3b2.s
 * consumes it with MOVE.L D0,D7, so the value is a long.
 *
 * 6 bytes against 6, in ONE region, and that region is a single opcode.
 *
 * SASC-MISMATCH: call-encoding-jsr-pcrel
 *   ref:     4eba0158 4e75    JSR (d16,PC) ; RTS
 *   got:     61000000 4e75    BSR.W        ; RTS
 *   summary: identical semantics, identical size, different opcode. Same class
 *            as script_read_next_rbf_byte.c; the full write-up lives there and
 *            in docs/compiler-version.md.
 *   tried:   see script_read_next_rbf_byte.c -- no sc option reaches this.
 *   scope:   whole-program, 82 functions / 35272 bytes.
 *   retest:  a compiler emitting JSR (d16,PC) for an extern call matches with
 *            no source change.
 *
 * Together with script_read_next_rbf_byte.c this makes a matched pair of
 * 6-byte probes at two different displacements (0x0158 and 0x0164), which is
 * what rules out a displacement-dependent explanation on a single compile.
 */

extern long ESQ_CaptureCtrlBit4StreamBufferByte(void);

long SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(void)
{
    return ESQ_CaptureCtrlBit4StreamBufferByte();
}
