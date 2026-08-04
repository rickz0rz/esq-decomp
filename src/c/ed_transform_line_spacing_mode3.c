/* RESTORES: _ED_TransformLineSpacing_Mode3
 * MODULE:   modules/groups/a/l/ed3bbbb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stride-local-and-a7-frame
 *   ref:     4e55ffa448e7230020390000818472284eba4faa41f9000082f8d1c0487800282f08486dffcf4eba35804fef000c20390000818472284eba4f8441f900008460d1c0702743edffa612d851c8fffc7e007028be806c1c7020b03578cf661441f900008460d1f9000081801b9078a6528760de7c007028bc806c247027220092867420b43518cf6616908641f900008460d1f9000081801b9008a6528660d620065380be806c0000b0200690874a806a025280e2802e0020390000818472284eba4efcd08741f9000082f8d1c07028908743edffcf600210d9538064fa20390000818472284eba4ed6d08741f900008460d1c07028908743edffa6600210d9538064fa20390000818472284eba4eb041f9000082f8d1c07028908743edffcfd3c02007600210d9538064fa20390000818472284eba4e8841f900008460d1c07028908743edffa6d3c02007600210d9538064fa600000acbe866f0000a62007908652804a806a025280e2802e0020390000818472284eba4e4641f9000082f8d1c043edffcfd3c770289087600210d9538064fa20390000818472284eba4e2041f900008460d1c043edffa6d3c770289087600210d9538064fa20390000818472284eba4dfa908741f900008320d1c0200743edffcf600210d9538064fa20390000818472284eba4dd6908741f900008488d1c0200743edffa6600210d9538064fa4cdf00c44e5d4e75
 *   got:     9efc005048e72f00782820390000000022046100000041f900000000d1c0487800282f08486f0044610000004fef000c20390000000022046100000041f900000000d1c0702743ef001412d851c8fffc7e007028be806c1c7020b037783c661441f900000000d1f9000000001f907814528760de7c007028bc806c247027220092867420b437183c6616908641f900000000d1f9000000001f900814528660d620065380be806c0000b0200690874a806a025280e2802a0020390000000022046100000041f900000000d1c0d1c57028908543ef003c600210d9538064fa20390000000022046100000041f900000000d1c0d1c57028908543ef0014600210d9538064fa20390000000022046100000041f900000000d1c07028908543ef003cd3c02005600210d9538064fa20390000000022046100000041f900000000d1c07028908543ef0014d3c02005600210d9538064fa600000acbe866f0000a62007908652804a806a025280e2802a0020390000000022046100000041f900000000d1c043ef003cd3c570289085600210d9538064fa20390000000022046100000041f900000000d1c043ef0014d3c570289085600210d9538064fa20390000000022046100000041f900000000d1c091c5200543ef003c600210d9538064fa20390000000022046100000041f900000000d1c091c5200543ef0014600210d9538064fa4cdf00f4defc00504e75
 *   summary: 524 got vs 520 ref, four bytes over -- the closest of the three line-spacing transforms. The 40-byte stride is held in a local so all nine ED_ViewportOffset scalings call the 32x32 helper as the original does. Mode 3 centres rather than rotates one way: when the leading run is shorter than the trailing run by more than one it rotates right by half the difference, exactly as mode 2 does; otherwise, when leading exceeds trailing, it rotates left by half the difference plus one into the suffix and tail scratch buffers, exactly as mode 1 does. Both space scans, both halving divides and all eight variable-length byte copies match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern long ED_ViewportOffset;
extern long ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern char ED_EditBufferLive[];
extern char ED_LineTransformSuffixScratchBuffer[];
extern char ED_LineTransformTailScratchBuffer[];

extern void STRING_CopyPadNul(char *dst, char *src, long n);

void ED_TransformLineSpacing_Mode3(void)
{
    char text[40];
    char attr[40];
    long lead;
    long trail;
    long shift;
    long stride;

    stride = 40;

    STRING_CopyPadNul(text,
        ED_EditBufferScratch + ED_ViewportOffset * stride, 40);
    memcpy(attr, ED_EditBufferLive + ED_ViewportOffset * stride, 40);

    lead = 0;
    while (lead < 40 && text[lead] == ' ') {
        attr[lead] = ED_EditBufferLive[ED_EditCursorOffset];
        lead++;
    }

    trail = 0;
    while (trail < 40 && text[39 - trail] == ' ') {
        attr[39 - trail] = ED_EditBufferLive[ED_EditCursorOffset];
        trail++;
    }

    if (lead < trail - 1) {
        shift = (trail - lead) / 2;
        memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride + shift, text,
               40 - shift);
        memcpy(ED_EditBufferLive + ED_ViewportOffset * stride + shift, attr,
               40 - shift);
        memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride,
               text + (40 - shift), shift);
        memcpy(ED_EditBufferLive + ED_ViewportOffset * stride,
               attr + (40 - shift), shift);
        return;
    }

    if (lead <= trail)
        return;

    shift = (lead - trail + 1) / 2;
    memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride, text + shift,
           40 - shift);
    memcpy(ED_EditBufferLive + ED_ViewportOffset * stride, attr + shift,
           40 - shift);
    memcpy(ED_LineTransformSuffixScratchBuffer + ED_ViewportOffset * stride
           - shift, text, shift);
    memcpy(ED_LineTransformTailScratchBuffer + ED_ViewportOffset * stride
           - shift, attr, shift);
}
