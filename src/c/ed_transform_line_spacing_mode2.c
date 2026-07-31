/* RESTORES: _ED_TransformLineSpacing_Mode2
 * MODULE:   modules/groups/a/l/ed3bbbb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stride-local-and-a7-frame
 *   ref:     4e55ffa448e7230020390000818472284eba50f241f9000082f8d1c0487800282f08486dffcf4eba36c84fef000c20390000818472284eba50cc41f900008460d1c0702743edffa612d851c8fffc7e007028be806c247027220092877420b43518cf6616908741f900008460d1f9000081801b9008a6528760d67c007028bc806c1c7020b03568cf661441f900008460d1f9000081801b9068a6528660de7028be806c00009c2239000081844eba5056d08741f9000082f8d1c07028908743edffcf600210d9538064fa20390000818472284eba5030d08741f900008460d1c07028908743edffa6600210d9538064fa20390000818472284eba500a41f9000082f8d1c07028908743edffcfd3c02007600210d9538064fa20390000818472284eba4fe241f900008460d1c07028908743edffa6d3c02007600210d9538064fa4cdf00c44e5d4e75
 *   got:     9efc005048e727007a2820390000000022056100000041f900000000d1c0487800282f08486f0040610000004fef000c20390000000022056100000041f900000000d1c0702743ef001012d851c8fffc7e007028be806c247027220092877420b43718386616908741f900000000d1f9000000001f900810528760d67c007028bc806c1c7020b0376838661441f900000000d1f9000000001f906810528660de7028be806c00009e20390000000022056100000041f900000000d1c0d1c77028908743ef0038600210d9538064fa20390000000022056100000041f900000000d1c0d1c77028908743ef0010600210d9538064fa20390000000022056100000041f900000000d1c07028908743ef0038d3c02007600210d9538064fa20390000000022056100000041f900000000d1c07028908743ef0010d3c02007600210d9538064fa4cdf00e4defc00504e754e71
 *   summary: 336 got vs 328 ref, eight bytes over -- the same shape as ed_transform_line_spacing_mode1.c, which rotates the other way. The 40-byte line stride is held in a local so all five ED_ViewportOffset scalings call the 32x32 helper as the original does. The residue is the frame register. The trailing-space scan from index 39 down, the leading-space scan, the four variable-length byte copies that rotate the text and attribute buffers right by the trailing-space count, and the early return when the line is all spaces match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern long ED_ViewportOffset;
extern long ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern char ED_EditBufferLive[];

extern void ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);

void ED_TransformLineSpacing_Mode2(void)
{
    char text[40];
    char attr[40];
    long trail;
    long lead;
    long stride;

    stride = 40;

    ESQFUNC_JMPTBL_STRING_CopyPadNul(text,
        ED_EditBufferScratch + ED_ViewportOffset * stride, 40);
    memcpy(attr, ED_EditBufferLive + ED_ViewportOffset * stride, 40);

    trail = 0;
    while (trail < 40 && text[39 - trail] == ' ') {
        attr[39 - trail] = ED_EditBufferLive[ED_EditCursorOffset];
        trail++;
    }

    lead = 0;
    while (lead < 40 && text[lead] == ' ') {
        attr[lead] = ED_EditBufferLive[ED_EditCursorOffset];
        lead++;
    }

    if (trail >= 40)
        return;

    memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride + trail, text,
           40 - trail);
    memcpy(ED_EditBufferLive + ED_ViewportOffset * stride + trail, attr,
           40 - trail);
    memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride,
           text + (40 - trail), trail);
    memcpy(ED_EditBufferLive + ED_ViewportOffset * stride,
           attr + (40 - trail), trail);
}
