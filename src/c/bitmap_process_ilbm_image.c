/* RESTORES: _BITMAP_ProcessIlbmImage
 * MODULE:   modules/groups/a/a/bitmap_bitmap_processilbmimage.s
 * STATUS:   behavioural
 *
 * The IFF/ILBM chunk loop: read a 4-byte tag, read its 4-byte size, dispatch on
 * the tag, and keep going until something sets the stop flag. Returns 1 only if a
 * BODY chunk streamed successfully, -1 otherwise -- so the result is initialised
 * to -1 and only BODY ever sets it.
 *
 * FORM and ILBM are containers and carry no size of their own, which is why they
 * jump straight back to the tag read without consuming a size field.
 *
 * THE STOP FLAG IS NOT AN EARLY RETURN. Several arms set it and then CONTINUE
 * doing work -- a BMHD whose size is not 20 still gets read, and a failed read
 * still falls into the fixups after it. Writing those as `if (bad) return` would
 * be tidier and wrong; the flag is only tested at the bottom of the loop.
 *
 * Screen-mode fixups are derived from the BMHD, not read from CAMG: HIRES
 * (0x8000) when width > 320, LACE (0x4) when height > 200 -- the latter written
 * as BSET #2 on byte 151, the low byte of the longword at 148. Height is then
 * clamped to 220 or 110 depending on the aspect code at +190, and CAMG failing
 * to read re-derives the same two flags rather than leaving the mode unset.
 *
 * Comparisons on width and height are BLS/BCS (unsigned), hence `unsigned short`.
 *
 * STRUCT OFFSETS ARE THE RISK HERE, not the control flow -- AGENTS.md is explicit
 * that a wrong offset produces byte-identical output under DATA=FAR because cdiff
 * masks relocated fields. They are written as a struct so they are at least
 * stated once and checkable: BMHD lands at +128 (so w=+128, h=+130), CAMG at
 * +148, four 8-byte CRNG entries at +152, their count at +184 (152 + 4*8 = 184,
 * which is what fixes the entry count at 4), and the aspect code at +190.
 *
 * LIBRARY BASE: esq-dos.h, the VOLATILE base, and it is required rather than
 * merely safe -- the original reloads Global_REF_DOS_LIBRARY_2 after the BSR.W
 * calls to BRUSH_LoadColorTextFont and BRUSH_StreamFontChunk, which are ESQ
 * assembly and clobber A6. This is the exact hazard esq-libbase.md describes, so
 * the graphics-leaf treatment must NOT be applied here.
 *
 * SAS/C rejects four-character constants ('ILBM' is a syntax error, not just a
 * warning), so the tags are written as hex longs with the ASCII in a comment.
 * vasm accepts them, which is why the assembly reads more clearly than this.
 *
 * Six parameters and THE SECOND IS UNUSED -- the original reads 8/16/20/24/28(A5)
 * and never touches 12(A5). It has to stay or every later argument shifts.
 *
 * SASC-MISMATCH: chunk-dispatch-layout
 *   summary: 852 against 794. SHORTINT makes no difference here (852 either way),
 *            which is itself informative -- the widths are already all long. The
 *            residual is the A5 frame class plus the ordering of the seven
 *            tag-dispatch arms, and it is NOT itemised: like
 *            newgrid_process_schedule_state.c the dispatch region defeats
 *            casm.py's instruction alignment, so a per-arm attribution would be
 *            invention.
 *   tried:   with and without SHORTINT (852 / 852). The tag tests are an if/else
 *            chain in the original's order, which is what its CMPI.L chain shows;
 *            a switch on the tags would be sparse and no better.
 *   scope:   this function.
 *   retest:  a compiler that reserves A5, then re-measure before theorising.
 */

#include "esq-dos.h"

struct CrngEntry {          /* 8 bytes each, four of them at +152 */
    unsigned short pad;     /* +0 */
    short          rate;    /* +2  (0x9a at index 0) */
    short          active;  /* +4  (0x9c) */
    unsigned char  low;     /* +6  (0x9e) */
    unsigned char  high;    /* +7  (0x9f) */
};

struct IlbmCtx {
    unsigned char    pad0[128];
    unsigned short   w;              /* +128  BMHD starts here */
    unsigned short   h;              /* +130 */
    unsigned char    bmhdRest[16];   /* +132 .. +147 */
    unsigned long    modeId;         /* +148  CAMG */
    struct CrngEntry crng[4];        /* +152 .. +183 */
    short            crngCount;      /* +184 */
    unsigned char    pad2[5];        /* +186 .. +189 */
    unsigned char    aspectCode;     /* +190 */
};

extern long BRUSH_LoadColorTextFont(long fh, long size, void *a3, struct IlbmCtx *ctx);
extern long BRUSH_StreamFontChunk(long fh, long total, long limit,
                                  unsigned char *buf, void *ctx);

long BITMAP_ProcessIlbmImage(long fh, long unused, void *colorArg, long limit,
                             unsigned char *bodyBuf, struct IlbmCtx *ctx)
{
    long tag, size;
    long result = -1;
    long i;
    short stop = 0;

    ctx->crngCount = 0;
    for (i = 0; i < 4; i++)
        ctx->crng[i].active = 0;

    do {
        if (Read(fh, &tag, 4L) != 4) {
            stop = 1;
            break;
        }

        if (tag == 0x494C424DL /* 'ILBM' */)
            continue;

        if (Read(fh, &size, 4L) != 4) {
            stop = 1;
            break;
        }
        if (size == 0) {
            stop = 1;
            break;
        }
        if (size < 0) {
            stop = 1;
            break;
        }

        if (tag == 0x464F524DL /* 'FORM' */) {
            continue;

        } else if (tag == 0x424D4844L /* 'BMHD' */) {
            if (size != 20)
                stop = 1;
            if (Read(fh, &ctx->w, 20L) != 20)
                stop = 1;

            ctx->modeId = 0;
            if (ctx->w > 320)
                ctx->modeId = 0x8000;

            if (ctx->h > 200) {
                ctx->modeId |= 4;
                if (ctx->h > 220
                    && (ctx->aspectCode == 5 || ctx->aspectCode == 4))
                    ctx->h = 220;
            } else if (ctx->h > 110
                       && (ctx->aspectCode == 5 || ctx->aspectCode == 4)) {
                ctx->h = 110;
            }

        } else if (tag == 0x434D4150L /* 'CMAP' */) {
            if (BRUSH_LoadColorTextFont(fh, size, colorArg, ctx) != 1)
                stop = 1;

        } else if (tag == 0x424F4459L /* 'BODY' */) {
            if (BRUSH_StreamFontChunk(fh, size, limit, bodyBuf, ctx) == 1)
                result = 1;
            stop = 1;

        } else if (tag == 0x43414D47L /* 'CAMG' */) {
            ctx->modeId = 0;
            if (size != 4)
                stop = 1;
            if (Read(fh, &ctx->modeId, 4L) != 4) {
                stop = 1;
                ctx->modeId = 0;
                if (ctx->w > 320)
                    ctx->modeId = 0x8000;
                if (ctx->h > 200)
                    ctx->modeId |= 4;
            }

        } else if (tag == 0x43524E47L /* 'CRNG' */) {
            if (ctx->crngCount < 4) {
                if (size != 8) {
                    stop = 1;
                } else {
                    if (Read(fh, &ctx->crng[ctx->crngCount], 8L) != 8)
                        stop = 1;

                    if (ctx->crng[ctx->crngCount].low > 0x1f)
                        ctx->crng[ctx->crngCount].low = 0;
                    if (ctx->crng[ctx->crngCount].high > 0x1f)
                        ctx->crng[ctx->crngCount].high = 0;

                    if (ctx->crng[ctx->crngCount].rate <= 0
                        || ctx->crng[ctx->crngCount].rate == 36
                        || ctx->crng[ctx->crngCount].low
                             >= ctx->crng[ctx->crngCount].high)
                        ctx->crng[ctx->crngCount].active = 0;

                    ctx->crngCount++;
                }
            } else {
                Seek(fh, size, 0L);
            }

        } else {
            Seek(fh, size, 0L);
        }
    } while (!stop);

    return result;
}
