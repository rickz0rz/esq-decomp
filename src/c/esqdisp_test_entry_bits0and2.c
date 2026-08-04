/* RESTORES: _ESQDISP_TestEntryBits0And2
 * MODULE:   modules/groups/a/n/esqdispb_p0_esqdisp_testentrybits0and2_core_esqdisp_testentrybits0and2.s
 * STATUS:   behavioural
 *
 * THIS IS AN ALIAS, NOT A SECOND FUNCTION. The module carries two labels on
 * ONE address:
 *
 *     _ESQDISP_TestEntryBits0And2:
 *     _ESQDISP_TestEntryBits0And2_Core:
 *         MOVEM.L D7/A3,-(A7)
 *
 * So the original spends no bytes on the alias. C cannot give one function two
 * external names, so this file forwards to the definition of record in
 * `esqdisp_test_entry_bits0and2_core.c`.
 *
 * WHICH NAME IS LIVE IS THE OPPOSITE OF WHAT THE FILE NAMES SUGGEST.
 * `_ESQDISP_TestEntryBits0And2` is the one callers reach --
 * `_NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2` jumps to it. The `_Core` name
 * appears in a `; FUNC:` comment and nowhere else in the program. The `_Core`
 * file was written first, so the live name became the forwarder rather than the
 * other way round. Both symbols must exist either way.
 *
 * SASC-MISMATCH: alias-costs-a-forwarder
 *   ref:     (nothing -- a second label on the same address)
 *   got:     a forwarding function: argument re-pushed, BSR.W, RTS
 *   summary: two names for one entry point. The original gets this free from
 *            the assembler.
 *   tried:   nothing in C reaches it. SAS/C 6.51 has no alias pragma.
 *   scope:   two modules in the program carry an alias pair. The other is
 *            `COI_SelectAnimFieldPointer`.
 *   retest:  a toolchain with an alias directive.
 */
#ifndef ESQDISPENTRY_DEFINED
struct EsqDispEntry;
#endif

extern long ESQDISP_TestEntryBits0And2_Core(struct EsqDispEntry *e);

long ESQDISP_TestEntryBits0And2(struct EsqDispEntry *e)
{
    return ESQDISP_TestEntryBits0And2_Core(e);
}
