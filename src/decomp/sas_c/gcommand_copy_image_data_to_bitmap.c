#include <exec/types.h>
typedef struct GCOMMAND_Bitmap {
    UBYTE pad0[8];
    ULONG plane0Ptr;
    ULONG plane1Ptr;
    ULONG plane2Ptr;
} GCOMMAND_Bitmap;

extern ULONG WDISP_BannerWorkRasterPtr;

extern UBYTE *GCOMMAND_BuildBannerBlock(UBYTE *tablePtr, LONG count, UBYTE *srcBytePtr, UBYTE byte1, UWORD word2, UBYTE stepByte);
extern void GCOMMAND_BuildBannerRow(UBYTE *bitmapPtr, UBYTE *tablePtr, LONG rowIndex, LONG fallbackIndex, LONG baseOffset);

static UWORD hi16(ULONG v) { return (UWORD)((v >> 16) & 0xFFFF); }
static UWORD lo16(ULONG v) { return (UWORD)(v & 0xFFFF); }

UBYTE *GCOMMAND_CopyImageDataToBitmap(
    UBYTE *bitmapPtr,
    UBYTE *tablePtr,
    LONG length,
    LONG baseOffset,
    UBYTE *srcBytePtr,
    UWORD argWord0,
    UBYTE argByte0)
{
    GCOMMAND_Bitmap *bitmapView;
    UBYTE *out = tablePtr;
    ULONG p;
    UBYTE *blockBase;

    bitmapView = (GCOMMAND_Bitmap *)bitmapPtr;

    out[0] = 0x8E;
    out[1] = 0xD9;
    *(UWORD *)(out + 2) = 0xFFFE;
    *(UWORD *)(out + 4) = 0x0092;
    *(UWORD *)(out + 6) = 0x0030;
    *(UWORD *)(out + 8) = 0x0094;
    *(UWORD *)(out + 10) = 0x00D8;
    *(UWORD *)(out + 12) = 0x008E;
    *(UWORD *)(out + 14) = 0x1769;
    *(UWORD *)(out + 16) = 0x0090;
    *(UWORD *)(out + 18) = 0xFFC5;
    *(UWORD *)(out + 20) = 0x0108;
    *(UWORD *)(out + 22) = 88;
    *(UWORD *)(out + 24) = 0x010A;
    *(UWORD *)(out + 26) = 88;
    *(UWORD *)(out + 28) = 0x0100;
    *(UWORD *)(out + 30) = 0x9306;
    *(UWORD *)(out + 32) = 0x0102;
    *(UWORD *)(out + 34) = 0;
    *(UWORD *)(out + 36) = 0x0182;
    *(UWORD *)(out + 38) = 3;
    *(UWORD *)(out + 40) = 0x00E0;
    *(UWORD *)(out + 42) = hi16(WDISP_BannerWorkRasterPtr);
    *(UWORD *)(out + 44) = 0x00E2;
    *(UWORD *)(out + 46) = lo16(WDISP_BannerWorkRasterPtr);
    *(UWORD *)(out + 48) = 0x0180;
    *(UWORD *)(out + 50) = 3;
    *(UWORD *)(out + 52) = 0x0182;
    *(UWORD *)(out + 54) = 3;
    *(UWORD *)(out + 56) = 0x0184;
    *(UWORD *)(out + 58) = 0x0111;
    *(UWORD *)(out + 60) = 0x0186;
    *(UWORD *)(out + 62) = 0x0CC0;
    *(UWORD *)(out + 64) = 0x0188;
    *(UWORD *)(out + 66) = 0x0512;
    *(UWORD *)(out + 68) = 0x018A;
    *(UWORD *)(out + 70) = 0x016A;
    *(UWORD *)(out + 72) = 0x018C;
    *(UWORD *)(out + 74) = 0x0555;
    *(UWORD *)(out + 76) = 0x018E;
    *(UWORD *)(out + 78) = 3;
    out[80] = *srcBytePtr;
    *srcBytePtr = (UBYTE)(*srcBytePtr + argByte0);
    out[81] = 0xDB;
    *(UWORD *)(out + 82) = argWord0;
    *(UWORD *)(out + 84) = 0x00E0;
    p = bitmapView->plane0Ptr + (ULONG)length;
    *(UWORD *)(out + 86) = hi16(p);
    *(UWORD *)(out + 88) = 0x00E2;
    *(UWORD *)(out + 90) = lo16(p);
    *(UWORD *)(out + 92) = 0x00E4;
    p = bitmapView->plane1Ptr + (ULONG)length;
    *(UWORD *)(out + 94) = hi16(p);
    *(UWORD *)(out + 96) = 0x00E6;
    *(UWORD *)(out + 98) = lo16(p);
    *(UWORD *)(out + 100) = 0x00E8;
    p = bitmapView->plane2Ptr + (ULONG)length;
    *(UWORD *)(out + 102) = hi16(p);
    *(UWORD *)(out + 104) = 0x00EA;
    *(UWORD *)(out + 106) = lo16(p);
    *(UWORD *)(out + 108) = 0x0182;
    *(UWORD *)(out + 110) = 0x0AAA;
    *(UWORD *)(out + 112) = 0x0100;
    *(UWORD *)(out + 114) = 0xB306;
    *(UWORD *)(out + 116) = 0x0084;
    p = (ULONG)(out + 132);
    *(UWORD *)(out + 118) = hi16(p);
    *(UWORD *)(out + 120) = 0x0086;
    *(UWORD *)(out + 122) = lo16(p);
    *(UWORD *)(out + 124) = 0x008A;
    *(UWORD *)(out + 126) = 0;

    blockBase = out + 128;
    GCOMMAND_BuildBannerBlock(blockBase, 17, srcBytePtr, 221, argWord0, argByte0);

    out[672] = *srcBytePtr;
    *srcBytePtr = (UBYTE)(*srcBytePtr + argByte0);
    out[673] = 0xD9;
    *(UWORD *)(out + 674) = argWord0;
    *(UWORD *)(out + 676) = 0x0100;
    *(UWORD *)(out + 678) = 0x9306;
    *(UWORD *)(out + 680) = 0x0182;
    *(UWORD *)(out + 682) = 3;
    *(UWORD *)(out + 684) = 0x00E0;
    *(UWORD *)(out + 686) = hi16(WDISP_BannerWorkRasterPtr);
    *(UWORD *)(out + 688) = 0x00E2;
    *(UWORD *)(out + 690) = lo16(WDISP_BannerWorkRasterPtr);
    *(UWORD *)(out + 692) = 0x00E4;
    p = bitmapView->plane1Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 694) = hi16(p);
    *(UWORD *)(out + 696) = 0x00E6;
    *(UWORD *)(out + 698) = lo16(p);
    *(UWORD *)(out + 700) = 0x00E8;
    p = bitmapView->plane2Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 702) = hi16(p);
    *(UWORD *)(out + 704) = 0x00EA;
    *(UWORD *)(out + 706) = lo16(p);
    out[708] = *srcBytePtr;
    *srcBytePtr = (UBYTE)(*srcBytePtr + argByte0);
    out[709] = 0xDB;
    *(UWORD *)(out + 710) = argWord0;
    *(UWORD *)(out + 712) = 0x00E0;
    p = bitmapView->plane0Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 714) = hi16(p);
    *(UWORD *)(out + 716) = 0x00E2;
    *(UWORD *)(out + 718) = lo16(p);
    *(UWORD *)(out + 720) = 0x0182;
    *(UWORD *)(out + 722) = 0x0AAA;
    *(UWORD *)(out + 724) = 0x0100;
    *(UWORD *)(out + 726) = 0xB306;
    *(UWORD *)(out + 728) = 0x0084;
    p = (ULONG)(out + 744);
    *(UWORD *)(out + 730) = hi16(p);
    *(UWORD *)(out + 732) = 0x0086;
    *(UWORD *)(out + 734) = lo16(p);
    *(UWORD *)(out + 736) = 0x008A;
    *(UWORD *)(out + 738) = 0;

    blockBase = out + 740;
    GCOMMAND_BuildBannerBlock(blockBase, 98, srcBytePtr, 221, argWord0, argByte0);
    GCOMMAND_BuildBannerRow(bitmapPtr, tablePtr, 0, 98, baseOffset);

    out[3916] = 0x80;
    out[3917] = (UBYTE)-39;
    *(UWORD *)(out + 3918) = 0x80FE;
    *(UWORD *)(out + 3920) = 0x0100;
    *(UWORD *)(out + 3922) = 0x9306;
    *(UWORD *)(out + 3924) = 0x0182;
    *(UWORD *)(out + 3926) = 3;
    *(UWORD *)(out + 3928) = 0x00E0;
    *(UWORD *)(out + 3930) = hi16(WDISP_BannerWorkRasterPtr);
    *(UWORD *)(out + 3932) = 0x00E2;
    *(UWORD *)(out + 3934) = lo16(WDISP_BannerWorkRasterPtr);
    out[3936] = 0xFF;
    out[3937] = 0xFF;
    *(UWORD *)(out + 3938) = 0xFFFE;
    out[3876] = *srcBytePtr;
    *srcBytePtr = (UBYTE)(*srcBytePtr + argByte0);
    out[3877] = (UBYTE)-39;
    *(UWORD *)(out + 3878) = argWord0;
    *(UWORD *)(out + 3880) = 0x00E0;
    p = bitmapView->plane0Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 3882) = hi16(p);
    *(UWORD *)(out + 3884) = 0x00E2;
    *(UWORD *)(out + 3886) = lo16(p);
    *(UWORD *)(out + 3888) = 0x00E4;
    p = bitmapView->plane1Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 3890) = hi16(p);
    *(UWORD *)(out + 3892) = 0x00E6;
    *(UWORD *)(out + 3894) = lo16(p);
    *(UWORD *)(out + 3896) = 0x00E8;
    p = bitmapView->plane2Ptr + (ULONG)baseOffset;
    *(UWORD *)(out + 3898) = hi16(p);
    *(UWORD *)(out + 3900) = 0x00EA;
    *(UWORD *)(out + 3902) = lo16(p);
    *(UWORD *)(out + 3904) = 0x0084;
    p = (ULONG)(out + 744);
    *(UWORD *)(out + 3906) = hi16(p);
    *(UWORD *)(out + 3908) = 0x0086;
    *(UWORD *)(out + 3910) = lo16(p);
    *(UWORD *)(out + 3912) = 0x008A;
    *(UWORD *)(out + 3914) = 0;

    return tablePtr;
}
