/* RESTORES: BRUSH_LoadBrushAsset
 * MODULE:   modules/groups/a/a/brush_p3.s
 * STATUS:   behavioural
 *
 * Opens an IFF brush file, decodes the ILBM into a freshly allocated 372-byte
 * brush node, and answers the node. Almost every branch in it is a failure
 * path, and the failure paths are where the behaviour lives.
 *
 * THE SUCCESS FLAG IS INVERTED AND STARTS AT FAILED. `failed` is 1 on entry and
 * is cleared ONLY when BITMAP_ProcessIlbmImage returns exactly 1. So a file
 * that opens, reads and passes the FORM check still yields no node if the
 * decoder returns anything else. The oversize check then sets it back to 1, so
 * the two rejections share one flag and the node is built only when both pass.
 *
 * THE FILE IS LEAKED WHEN THE HEADER IS SHORT. Read returning anything other
 * than 6 branches past every Close in the function. A truncated file therefore
 * costs a DOS file handle per attempt. Both other paths -- bad FORM, and the
 * full decode -- do close it. This is the original's behaviour and is
 * reproduced rather than fixed.
 *
 * THE ALERT CODES ARE THE OPPOSITE WAY ROUND FROM THE LABEL NAMES. The
 * disassembly calls the second arm `alert_depth_exceeded`, but the branch that
 * reaches it is taken when the depth is WITHIN the limit -- so code 3 means the
 * WIDTH was too large and code 2 means the depth was. The code below follows
 * the instructions, not the labels.
 *
 * The limits themselves are chosen by bit 15 of the long at +148: the wide mode
 * allows 640 pixels but only 4 planes, the default 320 and 5. Trading depth for
 * width is the whole point of that flag.
 *
 * A TYPE 11 SOURCE THROWS AWAY EVERYTHING THAT WAS JUST BUILT. The clone block
 * at the end allocates a SECOND node and overwrites the variable holding the
 * first, without freeing it, and it runs whether or not the main path built
 * anything. So a fully decoded type 11 brush leaks a 372-byte node and all its
 * rasters, and the caller receives a header-only clone. That is not a
 * transcription artifact -- the store to the node variable is unconditional in
 * the original and the only guard is on the new allocation succeeding.
 *
 * THE PLANE POINTERS ARE WALKED FORWARD AND THEN PUT BACK. The row decoder
 * advances each plane pointer by the row width as it consumes rows, so at the
 * end the BitMap would point past its own rasters. The saved copies are
 * restored from a five-element local array afterwards. Losing that restore
 * leaves a BitMap that renders garbage, and nothing else in the function would
 * notice.
 *
 * The plane loop is bounded TWICE, by the node depth and by the literal 5, and
 * both bounds are in the original at every one of the three places the planes
 * are walked. The array is five entries; a source claiming more planes would
 * otherwise run off it.
 *
 * The cleanup loop re-tests the depth on every iteration even though it cannot
 * change, which is why it is written as a `while` with both conditions rather
 * than an `if` around a `for`.
 *
 * The row-word span is `((width + 15) / 16) * 2` -- rounded up to a word and
 * then doubled to bytes -- and it is computed from the SOURCE width while the
 * row loop is bounded by the NODE height. The two come from the same 20-byte
 * block, so they agree, but the original reads them from different places.
 *
 * 1370 ref vs 1344 got, 26 differing regions. The reference emits 7
 * `LEA (d16,An),Am` address computations and this candidate emits 8, so the
 * struct layout is addressing memory the way the original does rather than
 * recomputing addresses -- which is the check AGENTS.md calls for, since
 * DATA=FAR masks a wrong offset from cdiff entirely.
 *
 * The open, the 6-byte Read, the FORM compare, the Seek to the beginning, both
 * 130000-byte allocations with their line numbers, the six-argument ILBM call,
 * both limit pairs, the Forbid/Permit bracket, the InitBitMap and InitRastPort
 * calls, the 20-byte dims copy as one MOVE.L/DBF block, the four two-long row
 * offset copies, the 96-byte palette loop, the PackBits row decoder with its
 * pointer advance, the restore loop, the raster cleanup and all four
 * MEMORY_Deallocate sites match in kind and size.
 *
 * WRITE THE 20-BYTE COPY AS A STRUCT ASSIGNMENT. `node->dims = src->dims`
 * gives the original's `MOVEQ #4 / MOVE.L (A1)+,(A0)+ / DBF` exactly, per the
 * table in AGENTS.md. It is used at both sites -- the main path and the type 11
 * clone -- which is also why the fields are grouped into `struct BrushDims`
 * rather than listed inline.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffb4 ... 2b40ffca     LINK.W A5,#-76 / MOVE.L D0,-54(A5)
 *   got:     9efc0034 ... 2f7c....0040 SUBA.W #52,A7 / MOVE.L #...,64(A7)
 *   summary: the frame class. 6.51 needs 52 bytes of stack where the original
 *            takes 76, because it keeps the file handle, the decode buffer and
 *            the loop counters in registers that the original spilled. That is
 *            most of the 26 bytes this comes in UNDER the reference.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct BrushDims {                      /* 20 bytes, copied as one unit */
    short         width;                /* +0  */
    short         height;               /* +2  */
    char          pad4[4];
    unsigned char depth;                /* +8  */
    char          pad9[11];
};

struct BrushSrc {
    char             name[32];          /* +0   */
    unsigned char    palette[96];       /* +32  */
    struct BrushDims dims;              /* +128 */
    long             f148;              /* +148, bit 15 selects the wide mode */
    long             rowOffsets[8];     /* +152 */
    char             pad184[6];
    char             type;              /* +190 */
    char             label[3];          /* +191 */
    long             f194;              /* +194 */
    long             f198;
    long             f202;
    long             f206;
    long             f210;
    long             widthLimit;        /* +214 */
    long             heightLimit;       /* +218 */
    long             f222;
    long             f226;
    long             f230;
};

struct BrushNode {
    char             name[32];          /* +0   */
    char             type;              /* +32  */
    char             label[3];          /* +33  */
    struct RastPort  rastPort;          /* +36  */
    struct BitMap    bitMap;            /* +136 */
    struct BrushDims dims;              /* +176 */
    long             f196;              /* +196 */
    long             rowOffsets[8];     /* +200 */
    unsigned char    palette[96];       /* +232 */
    long             f328;              /* +328 */
    long             f332;
    long             f336;
    long             f340;
    long             f344;
    long             widthLimit;        /* +348 */
    long             heightLimit;       /* +352 */
    long             f356;
    long             f360;
    long             f364;
    long             f368;              /* +368, node is 372 bytes */
};

extern long  GROUP_AG_JMPTBL_DOS_OpenFileWithMode(char *path, long mode);
extern long  GROUP_AA_JMPTBL_STRING_CompareN(char *a, char *b, long n);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern long  BITMAP_ProcessIlbmImage(long fh, long *rowOffsets,
                                     unsigned char *palette, long size,
                                     void *buf, struct BrushSrc *src);
extern void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(char *who, long line,
                                                  long width, long height);
extern void  GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(char *who, long line, void *p,
                                                 long width, long height);
extern long __asm GROUP_AG_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void *ESQ_PackBitsDecode(void *src, void *dst, long words);

extern long BRUSH_PendingAlertCode;
extern long BRUSH_SnapshotWidth;
extern long BRUSH_SnapshotDepth;
extern char BRUSH_SnapshotHeader[];
extern char BRUSH_STR_IFF_FORM[];
extern char Global_STR_BRUSH_C_10[];
extern char Global_STR_BRUSH_C_11[];
extern char Global_STR_BRUSH_C_12[];
extern char Global_STR_BRUSH_C_13[];
extern char Global_STR_BRUSH_C_14[];
extern char Global_STR_BRUSH_C_15[];
extern char Global_STR_BRUSH_C_16[];

struct BrushNode *BRUSH_LoadBrushAsset(struct BrushSrc *src)
{
    struct BrushNode *node;
    void  *decode;
    void  *decodeBase;
    void  *planeSave[5];
    char   hdr[6];
    long   fh;
    long   failed;
    long   maxDepth;
    long   maxWidth;
    long   code;
    long   i;
    short  row;
    short  plane;
    short  rowWords;

    fh     = 0;
    failed = 1;

    maxDepth = 5;
    maxWidth = 320;

    decode = decodeBase = 0;
    node   = 0;

    fh = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(src->name, 1005L);

    if (fh != 0) {

        if (Read(fh, hdr, 6L) == 6) {

            if (GROUP_AA_JMPTBL_STRING_CompareN(hdr, BRUSH_STR_IFF_FORM,
                                                4L) == 0) {

                Seek(fh, 0L, -1L);

                decode = decodeBase = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                             Global_STR_BRUSH_C_10, 977L, 130000L,
                             MEMF_PUBLIC | MEMF_CLEAR);

                if (decode != 0) {
                    if (BITMAP_ProcessIlbmImage(fh, src->rowOffsets,
                                                src->palette, 130000L, decode,
                                                src) == 1)
                        failed = 0;
                }

                Close(fh);

            } else {
                Close(fh);
            }
        }
    }

    if (src->f148 & 0x8000) {
        maxDepth = 4;
        maxWidth = 640;
    }

    if ((long)src->dims.depth > maxDepth
        || (long)src->dims.width > maxWidth) {

        Forbid();

        if ((long)src->dims.depth > maxDepth)
            code = 2;
        else
            code = 3;

        BRUSH_PendingAlertCode = code;
        BRUSH_SnapshotWidth    = (long)src->dims.width;
        BRUSH_SnapshotDepth    = (long)src->dims.depth;
        strcpy(BRUSH_SnapshotHeader, src->name);

        Permit();

        failed = 1;
    }

    if (failed == 0) {

        node = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                   Global_STR_BRUSH_C_11, 1064L, 372L,
                   MEMF_PUBLIC | MEMF_CLEAR);

        if (node != 0) {

            strcpy(node->name, src->name);

            node->dims = src->dims;
            node->f196 = src->f148;
            node->f368 = 0;

            InitBitMap(&node->bitMap, (long)node->dims.depth,
                       (long)node->dims.width, (long)node->dims.height);

            node->type  = src->type;
            node->f328  = src->f194;
            node->f332  = src->f198;
            node->f336  = src->f202;
            node->f340  = src->f206;
            node->f344  = src->f210;
            node->f356  = src->f222;
            node->f360  = src->f226;

            for (i = 0; i < 4; i++) {
                node->rowOffsets[i * 2]     = src->rowOffsets[i * 2];
                node->rowOffsets[i * 2 + 1] = src->rowOffsets[i * 2 + 1];
            }

            strcpy(node->label, src->label);

            node->f364 = src->f230;

            if (src->widthLimit != 0)
                node->widthLimit = src->widthLimit;
            else
                node->widthLimit = (long)node->dims.width;

            if (src->heightLimit != 0)
                node->heightLimit = src->heightLimit;
            else
                node->heightLimit = (long)node->dims.height;

            for (i = 0; i < (long)node->dims.depth && i < 5; i++) {

                node->bitMap.Planes[i] = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
                    Global_STR_BRUSH_C_12, 1134L, (long)node->dims.width,
                    (long)node->dims.height);
                planeSave[i] = node->bitMap.Planes[i];

                if (node->bitMap.Planes[i] == 0) {

                    Forbid();

                    if (BRUSH_PendingAlertCode == 0) {
                        BRUSH_PendingAlertCode = 1;
                        strcpy(BRUSH_SnapshotHeader, node->name);
                    }

                    Permit();
                    break;
                }
            }

            if (i == (long)node->dims.depth) {

                InitRastPort(&node->rastPort);
                node->rastPort.BitMap = &node->bitMap;

                for (i = 0; i < 96; i++)
                    node->palette[i] = src->palette[i];

                rowWords = (short)(GROUP_AG_JMPTBL_MATH_DivS32(
                                       (long)src->dims.width + 15, 16L) * 2);

                for (row = 0; row < node->dims.height; row++) {
                    for (plane = 0; plane < (short)src->dims.depth; plane++) {
                        decode = ESQ_PackBitsDecode(decode,
                                                    node->bitMap.Planes[plane],
                                                    (long)rowWords);
                        node->bitMap.Planes[plane] =
                            (PLANEPTR)((char *)node->bitMap.Planes[plane]
                                       + rowWords);
                    }
                }

                for (i = 0; i < (long)node->dims.depth && i < 5; i++)
                    node->bitMap.Planes[i] = planeSave[i];

            } else {

                while (node->dims.depth != 0 && i < 5) {
                    if (node->bitMap.Planes[i] != 0)
                        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
                            Global_STR_BRUSH_C_13, 1202L,
                            node->bitMap.Planes[i], (long)node->dims.width,
                            (long)node->dims.height);
                    i++;
                }

                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_14,
                                                        1205L, node, 372L);
                node = 0;
            }
        }
    }

    if (src->type == 11) {

        node = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                   Global_STR_BRUSH_C_15, 1220L, 372L,
                   MEMF_PUBLIC | MEMF_CLEAR);

        if (node != 0) {
            strcpy(node->name, src->name);
            node->type = src->type;
            node->dims = src->dims;
            node->f196 = src->f148;
            node->f368 = 0;
        }
    }

    if (decodeBase != 0)
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_16, 1236L,
                                                decodeBase, 130000L);

    return node;
}
