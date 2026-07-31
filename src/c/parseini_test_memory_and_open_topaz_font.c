/* RESTORES: PARSEINI_TestMemoryAndOpenTopazFont
 * MODULE:   modules/groups/b/a/parseini_p2.s
 * STATUS:   behavioural
 *
 * Closes whatever font the slot holds, probes for 8 MB of free memory, then
 * opens the requested disk font into the slot, falling back to the built-in
 * Topaz handle if the open fails.
 *
 * The memory probe is exactly that -- a probe. It allocates 0x800000 bytes and
 * frees them again inside a Forbid/Permit pair, keeping nothing. The point is
 * the answer, not the memory, and the allocation result is only tested to
 * decide whether there is anything to free.
 *
 * The font already in the slot is closed UNLESS it is the shared Topaz handle,
 * which the program does not own. Closing that would free a font other code
 * still holds.
 *
 * The result is 1 only when OpenDiskFont succeeded; the fallback path leaves it
 * 0 and installs the Topaz handle.
 *
 * A NOTE ON THE A6 COST, because this is a `no-calls` function and so is the
 * one place esq-graphics-leaf.h would normally apply. It does not help here:
 * the function talks to THREE libraries -- graphics for CloseFont, exec for
 * Forbid/AllocMem/FreeMem/Permit, and diskfont for OpenDiskFont -- and the
 * original caches each base across its own run of calls, most visibly the four
 * consecutive exec calls on one MOVEA.L AbsExecBase,A6.
 *
 * The volatile headers reload before every one of those, which costs 6 bytes a
 * site. An `esq-exec-leaf.h` would close it, and AGENTS.md deliberately does
 * NOT provide one -- its stated reason is that the DOS and exec functions
 * restored so far reload before every call in the original anyway. That reason
 * does not hold for this function, so the gap is real rather than a
 * misapplication of the rule. It is recorded here rather than acted on:
 * adding a header is a structural change to the project's A6 policy and
 * belongs to whoever owns that policy, not to one restoration.
 *
 * 124 ref vs 144 got, and the +20 is the A6 accounting described above,
 * measured rather than estimated:
 *
 *   +18  three extra base reloads. The original loads AbsExecBase ONCE and
 *        keeps it across Forbid, AllocMem, FreeMem and Permit; the volatile
 *        header reloads before each of the four. It also reloads before
 *        OpenDiskFont where the original had already loaded DiskfontBase.
 *   +2   object alignment padding.
 *
 * Everything that carries meaning matches exactly: the MOVE.L #$800000
 * probe size at both sites, the MOVEQ #1 allocation flags, all six LVO offsets
 * (ffb2 CloseFont, ff7c Forbid, ff3a AllocMem, ff2e FreeMem, ff76 Permit,
 * ffe2 OpenDiskFont), the CMPA.L against the Topaz handle and the fallback
 * store.
 *
 * SASC-MISMATCH: a6-reload-between-adjacent-library-calls
 *   ref:     2c780004 4eaeff7c ... 4eaeff3a ... 4eaeff2e 4eaeff76
 *            AbsExecBase loaded once, kept across four exec calls
 *   got:     2c79.... before each of the four
 *   summary: the volatile base is a correctness fix for calls that cross ESQ
 *            assembly, and this function makes none -- every call here is a
 *            library call, so the base is safe to cache and the original does.
 *            The cost is 6 bytes a site.
 *   tried:   nothing, deliberately. See the header note above: closing this
 *            needs an esq-exec-leaf.h that AGENTS.md explicitly declines to
 *            provide, and changing that policy is not a decision one
 *            restoration should make.
 *   scope:   every `no-calls` function that talks to exec. This is the first
 *            one in the set where the leaf argument applies to exec rather
 *            than graphics.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/memory.h>
#include "esq-exec.h"
#include "esq-graphics.h"
#include "esq-diskfont.h"

extern struct TextFont *Global_HANDLE_TOPAZ_FONT;

long PARSEINI_TestMemoryAndOpenTopazFont(struct TextFont **slot,
                                         struct TextAttr *attr)
{
    void *probe;
    long  ok = 0;

    if (*slot == 0)
        return ok;

    if (*slot != Global_HANDLE_TOPAZ_FONT)
        CloseFont(*slot);

    Forbid();
    probe = AllocMem(0x800000L, MEMF_PUBLIC);
    if (probe != 0)
        FreeMem(probe, 0x800000L);
    Permit();

    *slot = OpenDiskFont(attr);
    if (*slot == 0)
        *slot = Global_HANDLE_TOPAZ_FONT;
    else
        ok = 1;

    return ok;
}
