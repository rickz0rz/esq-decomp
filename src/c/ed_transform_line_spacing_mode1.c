/* RESTORES: _ED_TransformLineSpacing_Mode1
 * MODULE:   modules/groups/a/l/ed3bbbb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stride-local-and-a7-frame
 *   ref:     4e55ffa448e7230020390000818472284eba523241f9000082f8d1c0487800282f08486dffcf4eba38084fef000c20390000818472284eba520c41f900008460d1c0702743edffa612d851c8fffc7e007028be806c1c7020b03578cf661441f900008460d1f9000081801b9078a6528760de7c007028bc806c247027220092867420b43518cf6616908641f900008460d1f9000081801b9008a6528660d67028be806c0000942239000081844eba519641f9000082f8d1c043edffcfd3c770289087600210d9538064fa20390000818472284eba517041f900008460d1c043edffa6d3c770289087600210d9538064fa20390000818472284eba514a908741f900008320d1c0200743edffcf600210d9538064fa20390000818472284eba5126908741f900008488d1c0200743edffa6600210d9538064fa4cdf00c44e5d4e75
 *   got:     9efc005048e727007a2820390000000022056100000041f900000000d1c0487800282f08486f0040610000004fef000c20390000000022056100000041f900000000d1c0702743ef001012d851c8fffc7e007028be806c1c7020b0377838661441f900000000d1f9000000001f907810528760de7c007028bc806c247027220092867420b43718386616908641f900000000d1f9000000001f900810528660d67028be806c00009620390000000022056100000041f900000000d1c043ef0038d3c770289087600210d9538064fa20390000000022056100000041f900000000d1c043ef0010d3c770289087600210d9538064fa20390000000022056100000041f900000000d1c091c7200743ef0038600210d9538064fa20390000000022056100000041f900000000d1c091c7200743ef0010600210d9538064fa4cdf00e4defc00504e754e71
 *   summary: 328 got vs 320 ref, eight bytes over. The 40-byte line stride is held in a local so all five ED_ViewportOffset scalings call the 32x32 helper as the original does; written against the literal, 6.51 strength-reduces every one of them. The residue is the frame register (SUBA.W #80,A7 with A7 displacements against LINK.W A5,#-92) and one address form: the last two copies compute base + offset - lead as SUBA.L A7-relative where the original folds the subtraction into the multiply result. The CopyPadNul call, the 40-byte DBF copy, both space scans and all four variable-length byte copies match in kind and order.
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

void ED_TransformLineSpacing_Mode1(void)
{
    char text[40];
    char attr[40];
    long lead;
    long trail;
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

    if (lead >= 40)
        return;

    memcpy(ED_EditBufferScratch + ED_ViewportOffset * stride, text + lead,
           40 - lead);
    memcpy(ED_EditBufferLive + ED_ViewportOffset * stride, attr + lead,
           40 - lead);
    memcpy(ED_LineTransformSuffixScratchBuffer + ED_ViewportOffset * stride - lead,
           text, lead);
    memcpy(ED_LineTransformTailScratchBuffer + ED_ViewportOffset * stride - lead,
           attr, lead);
}
