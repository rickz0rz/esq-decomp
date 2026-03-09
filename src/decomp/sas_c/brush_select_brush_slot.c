typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

#define BRUSH_NULL 0
#define BRUSH_SELECT_SLOT_STATUS_FAIL 0
#define BRUSH_SPAN_INCLUSIVE_DELTA 1
#define BRUSH_FORCED_DST_Y_MIN 0
#define BRUSH_BITMAP_OFFSET 136
#define BRUSH_DST_X_OFFSET 340
#define BRUSH_DST_Y_OFFSET 344
#define BRUSH_CLIP_W_OFFSET 348
#define BRUSH_CLIP_H_OFFSET 352
#define BRUSH_ALIGN_X_MODE_OFFSET 356
#define BRUSH_ALIGN_Y_MODE_OFFSET 360
#define ALIGN_MODE_CENTER 1
#define ALIGN_MODE_RIGHT_BOTTOM 2
#define BLIT_MINTERM_COPY 192

LONG GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
    void *src_bm, LONG src_x, LONG src_y, char *dst_rp, LONG dst_x, LONG dst_y, LONG w, LONG h, LONG minterm);

static LONG half_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRp,
    LONG forcedDstY)
{
    LONG srcX = srcX0;
    LONG srcY = srcY0;
    LONG dstX;
    LONG dstY;
    LONG spanX;
    LONG spanY;
    LONG clipW;
    LONG clipH;
    LONG alignModeX;
    LONG alignModeY;

    if (brush == (UBYTE *)BRUSH_NULL) {
        return BRUSH_SELECT_SLOT_STATUS_FAIL;
    }

    spanX = srcX1 - srcX0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clipW = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    if (clipW > spanX) {
        dstX = srcX0;
        alignModeX = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
        if (alignModeX == ALIGN_MODE_RIGHT_BOTTOM) {
            dstX = clipW - (srcX1 - srcX0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (alignModeX == ALIGN_MODE_CENTER) {
            dstX = half_toward_zero(clipW) - half_toward_zero(spanX);
        } else {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
        }
    } else {
        if (clipW < spanX) {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            alignModeX = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
            if (alignModeX == ALIGN_MODE_RIGHT_BOTTOM) {
                srcX = srcX1 - clipW + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (alignModeX == ALIGN_MODE_CENTER) {
                srcX = srcX0 + half_toward_zero(spanX) - half_toward_zero(clipW);
            } else {
                srcX = srcX0;
            }
        } else {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            srcX = srcX0;
        }
    }

    spanY = srcY1 - srcY0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clipH = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
    if (clipH > spanY) {
        dstY = srcY0;
        alignModeY = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
        if (alignModeY == ALIGN_MODE_RIGHT_BOTTOM) {
            dstY = clipH - (srcY1 - srcY0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (alignModeY == ALIGN_MODE_CENTER) {
            dstY = half_toward_zero(clipH) - half_toward_zero(spanY);
        } else {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
        }
    } else {
        if (clipH < spanY) {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            alignModeY = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
            if (alignModeY == ALIGN_MODE_RIGHT_BOTTOM) {
                srcY = srcY1 - clipH + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (alignModeY == ALIGN_MODE_CENTER) {
                srcY = srcY0 + half_toward_zero(spanY) - half_toward_zero(clipH);
            } else {
                srcY = srcY0;
            }
        } else {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            srcY = srcY0;
        }
    }

    clipW = srcX1 - srcX0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clipW > *(LONG *)(brush + BRUSH_CLIP_W_OFFSET)) {
        clipW = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    }

    clipH = srcY1 - srcY0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clipH > *(LONG *)(brush + BRUSH_CLIP_H_OFFSET)) {
        clipH = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
    }

    if (forcedDstY > BRUSH_FORCED_DST_Y_MIN) {
        dstY = forcedDstY;
    }

    return GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        brush + BRUSH_BITMAP_OFFSET,
        srcX,
        srcY,
        dstRp,
        dstX,
        dstY,
        clipW,
        clipH,
        BLIT_MINTERM_COPY
    );
}
