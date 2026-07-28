/* RESTORES: _BRUSH_StreamFontChunk
 * MODULE:   modules/groups/a/a/brush_p0.s
 * STATUS:   behavioural
 *
 * Read `total` bytes from an open file into buf in 2048-byte chunks, recording
 * the requested size at offset 186 of the caller's context block first. Returns
 * 1 on success and -1 on a bad request or any short read.
 *
 * The chunk loop tests `> 2048` and reads a full 2048, so the tail read happens
 * once the remainder is 2048 or less -- meaning a request of exactly 2048 takes
 * the tail path, not the loop. Reproduced as written.
 *
 * LIBRARY BASE: esq-dos.h, the volatile base -- correct with nothing to weigh
 * up, because the original reloads Global_REF_DOS_LIBRARY_2 before EACH of its
 * two Read calls.
 *
 * 118 bytes against 120 (120 in the object, the last 2 being longword padding),
 * and the ONLY real divergence is how 2048 is built.
 *
 * The context store is written through a struct with the field at offset 186,
 * not as *(long *)(ctx + 186). That is load-bearing: the cast-and-add form made
 * SAS/C emit LEA 186(A3),A0 / MOVE.L D6,(A0) where the original has a single
 * MOVE.L D6,186(A2). The LEA (d16,An),Am count is now 0 against the reference's
 * 0 -- AGENTS.md rule 2, the struct-offset check that cdiff cannot do.
 *
 * SASC-MISMATCH: constant-materialisation-2048
 *   ref:     263c00000800  MOVE.L #$800,D3        (6 bytes)
 *   got:     7640 eb8b     MOVEQ #$40,D3 / LSL.L #5,D3   (4 bytes)
 *   summary: -2. The original loads 2048 as a full longword immediate; 6.51
 *            builds it as 64<<5. Note this is the OPPOSITE direction to
 *            tliba3_init_runtime_entry.c, where the original built its constant
 *            from a smaller one and SAS/C used the immediate -- so the two
 *            compilers do not simply differ by a threshold, they differ in which
 *            constants they consider worth synthesising. Worth folding into
 *            docs/compiler-version.md, "Constant materialisation".
 *   tried:   the value appears three times (two compares and the length
 *            argument); only the argument is affected.
 *   scope:   the constant class program-wide.
 *   retest:  a compiler that emits MOVE.L #$800 for a plain 2048 argument.
 */

#include "esq-dos.h"

struct BrushStreamCtx {
    unsigned char pad[186];
    long          requested;
};

long BRUSH_StreamFontChunk(long fh, long total, long limit,
                           unsigned char *buf, struct BrushStreamCtx *ctx)
{
    if (total > limit)
        return -1;

    ctx->requested = total;

    while (total > 2048) {
        if (Read(fh, buf, 2048L) != 2048)
            return -1;
        buf += 2048;
        total -= 2048;
    }

    if (Read(fh, buf, total) != total)
        return -1;

    return 1;
}
