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
    LONG src_x0,
    LONG src_y0,
    LONG src_x1,
    LONG src_y1,
    void *dst_rp,
    LONG forced_dst_y)
{
    LONG src_x = src_x0;
    LONG src_y = src_y0;
    LONG dst_x;
    LONG dst_y;
    LONG span_x;
    LONG span_y;
    LONG clip_w;
    LONG clip_h;
    LONG mode_x;
    LONG mode_y;

    if (brush == (UBYTE *)BRUSH_NULL) {
        return BRUSH_SELECT_SLOT_STATUS_FAIL;
    }

    span_x = src_x1 - src_x0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clip_w = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    if (clip_w > span_x) {
        dst_x = src_x0;
        mode_x = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
        if (mode_x == ALIGN_MODE_RIGHT_BOTTOM) {
            dst_x = clip_w - (src_x1 - src_x0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (mode_x == ALIGN_MODE_CENTER) {
            dst_x = half_toward_zero(clip_w) - half_toward_zero(span_x);
        } else {
            dst_x = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
        }
    } else {
        if (clip_w < span_x) {
            dst_x = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            mode_x = *(LONG *)(brush + BRUSH_ALIGN_X_MODE_OFFSET);
            if (mode_x == ALIGN_MODE_RIGHT_BOTTOM) {
                src_x = src_x1 - clip_w + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (mode_x == ALIGN_MODE_CENTER) {
                src_x = src_x0 + half_toward_zero(span_x) - half_toward_zero(clip_w);
            } else {
                src_x = src_x0;
            }
        } else {
            dst_x = *(LONG *)(brush + BRUSH_DST_X_OFFSET);
            src_x = src_x0;
        }
    }

    span_y = src_y1 - src_y0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    clip_h = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
    if (clip_h > span_y) {
        dst_y = src_y0;
        mode_y = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
        if (mode_y == ALIGN_MODE_RIGHT_BOTTOM) {
            dst_y = clip_h - (src_y1 - src_y0) - BRUSH_SPAN_INCLUSIVE_DELTA;
        } else if (mode_y == ALIGN_MODE_CENTER) {
            dst_y = half_toward_zero(clip_h) - half_toward_zero(span_y);
        } else {
            dst_y = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
        }
    } else {
        if (clip_h < span_y) {
            dst_y = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            mode_y = *(LONG *)(brush + BRUSH_ALIGN_Y_MODE_OFFSET);
            if (mode_y == ALIGN_MODE_RIGHT_BOTTOM) {
                src_y = src_y1 - clip_h + BRUSH_SPAN_INCLUSIVE_DELTA;
            } else if (mode_y == ALIGN_MODE_CENTER) {
                src_y = src_y0 + half_toward_zero(span_y) - half_toward_zero(clip_h);
            } else {
                src_y = src_y0;
            }
        } else {
            dst_y = *(LONG *)(brush + BRUSH_DST_Y_OFFSET);
            src_y = src_y0;
        }
    }

    clip_w = src_x1 - src_x0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clip_w > *(LONG *)(brush + BRUSH_CLIP_W_OFFSET)) {
        clip_w = *(LONG *)(brush + BRUSH_CLIP_W_OFFSET);
    }

    clip_h = src_y1 - src_y0 + BRUSH_SPAN_INCLUSIVE_DELTA;
    if (clip_h > *(LONG *)(brush + BRUSH_CLIP_H_OFFSET)) {
        clip_h = *(LONG *)(brush + BRUSH_CLIP_H_OFFSET);
    }

    if (forced_dst_y > BRUSH_FORCED_DST_Y_MIN) {
        dst_y = forced_dst_y;
    }

    return GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        brush + BRUSH_BITMAP_OFFSET,
        src_x,
        src_y,
        dst_rp,
        dst_x,
        dst_y,
        clip_w,
        clip_h,
        BLIT_MINTERM_COPY
    );
}
