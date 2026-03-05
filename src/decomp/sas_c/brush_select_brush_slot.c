typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

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

    if (brush == (UBYTE *)0) {
        return 0;
    }

    span_x = src_x1 - src_x0 + 1;
    clip_w = *(LONG *)(brush + 348);
    if (clip_w > span_x) {
        dst_x = src_x0;
        mode_x = *(LONG *)(brush + 356);
        if (mode_x == 2) {
            dst_x = clip_w - (src_x1 - src_x0) - 1;
        } else if (mode_x == 1) {
            dst_x = half_toward_zero(clip_w) - half_toward_zero(span_x);
        } else {
            dst_x = *(LONG *)(brush + 340);
        }
    } else {
        if (clip_w < span_x) {
            dst_x = *(LONG *)(brush + 340);
            mode_x = *(LONG *)(brush + 356);
            if (mode_x == 2) {
                src_x = src_x1 - clip_w + 1;
            } else if (mode_x == 1) {
                src_x = src_x0 + half_toward_zero(span_x) - half_toward_zero(clip_w);
            } else {
                src_x = src_x0;
            }
        } else {
            dst_x = *(LONG *)(brush + 340);
            src_x = src_x0;
        }
    }

    span_y = src_y1 - src_y0 + 1;
    clip_h = *(LONG *)(brush + 352);
    if (clip_h > span_y) {
        dst_y = src_y0;
        mode_y = *(LONG *)(brush + 360);
        if (mode_y == 2) {
            dst_y = clip_h - (src_y1 - src_y0) - 1;
        } else if (mode_y == 1) {
            dst_y = half_toward_zero(clip_h) - half_toward_zero(span_y);
        } else {
            dst_y = *(LONG *)(brush + 344);
        }
    } else {
        if (clip_h < span_y) {
            dst_y = *(LONG *)(brush + 344);
            mode_y = *(LONG *)(brush + 360);
            if (mode_y == 2) {
                src_y = src_y1 - clip_h + 1;
            } else if (mode_y == 1) {
                src_y = src_y0 + half_toward_zero(span_y) - half_toward_zero(clip_h);
            } else {
                src_y = src_y0;
            }
        } else {
            dst_y = *(LONG *)(brush + 344);
            src_y = src_y0;
        }
    }

    clip_w = src_x1 - src_x0 + 1;
    if (clip_w > *(LONG *)(brush + 348)) {
        clip_w = *(LONG *)(brush + 348);
    }

    clip_h = src_y1 - src_y0 + 1;
    if (clip_h > *(LONG *)(brush + 352)) {
        clip_h = *(LONG *)(brush + 352);
    }

    if (forced_dst_y > 0) {
        dst_y = forced_dst_y;
    }

    return GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        brush + 136, src_x, src_y, dst_rp, dst_x, dst_y, clip_w, clip_h, 192);
}
