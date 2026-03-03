#include "esq_types.h"

/*
 * Target 705 GCC trial function.
 * Compute source/destination slot rectangles and blit brush slice.
 */
s32 GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
    void *src_bm, s32 src_x, s32 src_y, void *dst_rp, s32 dst_x, s32 dst_y, s32 w, s32 h, s32 minterm)
    __attribute__((noinline));

static s32 half_toward_zero(s32 v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

s32 BRUSH_SelectBrushSlot(
    u8 *brush,
    s32 src_x0,
    s32 src_y0,
    s32 src_x1,
    s32 src_y1,
    void *dst_rp,
    s32 forced_dst_y)
    __attribute__((noinline, used));

s32 BRUSH_SelectBrushSlot(
    u8 *brush,
    s32 src_x0,
    s32 src_y0,
    s32 src_x1,
    s32 src_y1,
    void *dst_rp,
    s32 forced_dst_y)
{
    s32 src_x = src_x0;
    s32 src_y = src_y0;
    s32 dst_x;
    s32 dst_y;
    s32 span_x;
    s32 span_y;
    s32 clip_w;
    s32 clip_h;
    s32 mode_x;
    s32 mode_y;

    if (brush == 0) {
        return 0;
    }

    span_x = src_x1 - src_x0 + 1;
    clip_w = *(s32 *)(brush + 348);
    if (clip_w > span_x) {
        dst_x = src_x0;
        mode_x = *(s32 *)(brush + 356);
        if (mode_x == 2) {
            dst_x = clip_w - (src_x1 - src_x0) - 1;
        } else if (mode_x == 1) {
            dst_x = half_toward_zero(clip_w) - half_toward_zero(span_x);
        } else {
            dst_x = *(s32 *)(brush + 340);
        }
    } else {
        if (clip_w < span_x) {
            dst_x = *(s32 *)(brush + 340);
            mode_x = *(s32 *)(brush + 356);
            if (mode_x == 2) {
                src_x = src_x1 - clip_w + 1;
            } else if (mode_x == 1) {
                src_x = src_x0 + half_toward_zero(span_x) - half_toward_zero(clip_w);
            } else {
                src_x = src_x0;
            }
        } else {
            dst_x = *(s32 *)(brush + 340);
            src_x = src_x0;
        }
    }

    span_y = src_y1 - src_y0 + 1;
    clip_h = *(s32 *)(brush + 352);
    if (clip_h > span_y) {
        dst_y = src_y0;
        mode_y = *(s32 *)(brush + 360);
        if (mode_y == 2) {
            dst_y = clip_h - (src_y1 - src_y0) - 1;
        } else if (mode_y == 1) {
            dst_y = half_toward_zero(clip_h) - half_toward_zero(span_y);
        } else {
            dst_y = *(s32 *)(brush + 344);
        }
    } else {
        if (clip_h < span_y) {
            dst_y = *(s32 *)(brush + 344);
            mode_y = *(s32 *)(brush + 360);
            if (mode_y == 2) {
                src_y = src_y1 - clip_h + 1;
            } else if (mode_y == 1) {
                src_y = src_y0 + half_toward_zero(span_y) - half_toward_zero(clip_h);
            } else {
                src_y = src_y0;
            }
        } else {
            dst_y = *(s32 *)(brush + 344);
            src_y = src_y0;
        }
    }

    clip_w = src_x1 - src_x0 + 1;
    if (clip_w > *(s32 *)(brush + 348)) {
        clip_w = *(s32 *)(brush + 348);
    }

    clip_h = src_y1 - src_y0 + 1;
    if (clip_h > *(s32 *)(brush + 352)) {
        clip_h = *(s32 *)(brush + 352);
    }

    if (forced_dst_y > 0) {
        dst_y = forced_dst_y;
    }

    return GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        brush + 136, src_x, src_y, dst_rp, dst_x, dst_y, clip_w, clip_h, 192);
}
