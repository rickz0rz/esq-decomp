typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_SELECT_SLOT_STATUS_FAIL = 0,
    BRUSH_SPAN_INCLUSIVE_DELTA = 1,
    BRUSH_FORCED_DST_Y_MIN = 0,
    BRUSH_BITMAP_OFFSET = 136,
    BRUSH_DST_X_OFFSET = 340,
    BRUSH_DST_Y_OFFSET = 344,
    BRUSH_CLIP_W_OFFSET = 348,
    BRUSH_CLIP_H_OFFSET = 352,
    BRUSH_ALIGN_X_MODE_OFFSET = 356,
    BRUSH_ALIGN_Y_MODE_OFFSET = 360,
    ALIGN_MODE_CENTER = 1,
    ALIGN_MODE_RIGHT_BOTTOM = 2,
    BLIT_MINTERM_COPY = 192
};

LONG GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
    void *src_bm, LONG src_x, LONG src_y, void *dst_rp, LONG dst_x, LONG dst_y, LONG w, LONG h, LONG minterm);

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
    void *dstRp,
    LONG forcedDstY)
{
    LONG srcX = srcX0;
    LONG srcY = srcY0;
    LONG dstX;
    LONG dstY;
    LONG spanX;
    LONG spanY;
    LONG clip_w;
    LONG clip_h;
    LONG alignModeX;
    LONG alignModeY;

    if (brush == (UBYTE *)BRUSH_NULL) {
        return BRUSH_SELECT_SLOT_STATUS_FAIL;
    }

    spanX = srcX1 - srcX0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clip_w = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    if (clip_w > spanX) {
        dstX = srcX0;
        alignModeX = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
        if (alignModeX == ALIGN_MODE_RIGHT_BOTTOM) {
            dstX = clip_w - (srcX1 - srcX0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (alignModeX == ALIGN_MODE_CENTER) {
            dstX = half_toward_zero(clip_w) - half_toward_zero(spanX);
        } else {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
        }
    } else {
        if (clip_w < spanX) {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            alignModeX = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
            if (alignModeX == ALIGN_MODE_RIGHT_BOTTOM) {
                srcX = srcX1 - clip_w + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (alignModeX == ALIGN_MODE_CENTER) {
                srcX = srcX0 + half_toward_zero(spanX) - half_toward_zero(clip_w);
            } else {
                srcX = srcX0;
            }
        } else {
            dstX = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            srcX = srcX0;
        }
    }

    spanY = srcY1 - srcY0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clip_h = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
    if (clip_h > spanY) {
        dstY = srcY0;
        alignModeY = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
        if (alignModeY == ALIGN_MODE_RIGHT_BOTTOM) {
            dstY = clip_h - (srcY1 - srcY0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (alignModeY == ALIGN_MODE_CENTER) {
            dstY = half_toward_zero(clip_h) - half_toward_zero(spanY);
        } else {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
        }
    } else {
        if (clip_h < spanY) {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            alignModeY = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
            if (alignModeY == ALIGN_MODE_RIGHT_BOTTOM) {
                srcY = srcY1 - clip_h + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (alignModeY == ALIGN_MODE_CENTER) {
                srcY = srcY0 + half_toward_zero(spanY) - half_toward_zero(clip_h);
            } else {
                srcY = srcY0;
            }
        } else {
            dstY = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            srcY = srcY0;
        }
    }

    clip_w = srcX1 - srcX0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clip_w > *(LONG *)(brush + BRUSH_CLIP_W_OFFSET)) {
        clip_w = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    }

    clip_h = srcY1 - srcY0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clip_h > *(LONG *)(brush + BRUSH_CLIP_H_OFFSET)) {
        clip_h = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
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
        clip_w,
        clip_h,
        BLIT_MINTERM_COPY
    );
}
